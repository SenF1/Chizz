//
//  AuthViewModel.swift
//  Chizz
//
//  Created by Sen Feng on 7/15/24.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

protocol AuthenticationFormProtocol {
    var formIsValid: Bool { get }
}

@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var isEmailVerificationPending = false
    var isUserEmailVerified: Bool {
        return userSession?.isEmailVerified ?? false
    }
    
    init () {
        self.userSession = Auth.auth().currentUser
        
        Task {
            await fetchUser()
        }
    }
    
    func login(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            
            // Check if the user's email is verified
            guard result.user.isEmailVerified else {
                throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Please verify your email before logging in."])
            }
            
            self.userSession = result.user
            await fetchUser()
            print("Logged In as \(email)")
        } catch {
            print("DEBUG: Failed to login with error \(error.localizedDescription)")
            throw error
        }
    }
    
    func createUser(withEmail email: String, password: String, fullname: String) async throws {
        guard email.hasSuffix(".edu") else {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Please use a valid university email address ending with .edu."])
        }
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            
            // Send email verification
            guard let user = Auth.auth().currentUser else {
                throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to create user."])
            }
            try await user.sendEmailVerification()
            
            self.isEmailVerificationPending = true
            
            // Add user to the database after email is verified
            let newUser = User(fullname: fullname, email: email)
            let encodedUser = try Firestore.Encoder().encode(newUser)
            try await Firestore.firestore().collection("users").document(result.user.uid).setData(encodedUser)
            
            // Wait for email verification
            await waitForEmailVerification(user: result.user)
            
            self.userSession = user
            await fetchUser()
            self.isEmailVerificationPending = false
            
        } catch {
            self.isEmailVerificationPending = false
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
            throw error
        }
    }
    
    
    func waitForEmailVerification(user: FirebaseAuth.User) async {
        do {
            // Poll every few seconds to check email verification status
            while !user.isEmailVerified {
                let nanoseconds: UInt64 = 3 * 1_000_000_000 // 3 seconds converted to nanoseconds
                try await Task.sleep(nanoseconds: nanoseconds)
                try await user.reload()
            }
        } catch {
            print("DEBUG: Failed to verify email with error \(error.localizedDescription)")
        }
    }
    
    func resetPassword(forEmail email: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                print("DEBUG: Failed to send password reset email with error \(error.localizedDescription)")
                completion(error)
            } else {
                print("Password reset email sent successfully")
                completion(nil)
            }
        }
    }
    
    func signOut () {
        do {
            try Auth.auth().signOut() // Signout on backend
            self.userSession = nil // Clear user session and redirect to login
            self.currentUser = nil // Clear user data model
        } catch {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
        
    }
    
    func deleteAccount() async throws {
        guard let user = Auth.auth().currentUser else {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No user is currently signed in."])
        }
        
        do {
            // Delete user data from Firestore
            try await Firestore.firestore().collection("users").document(user.uid).delete()
            
            // Delete user from Firebase Authentication
            try await user.delete()
            
            // Clear local user session and data
            self.userSession = nil
            self.currentUser = nil
            
            print("DEBUG: User account and data deleted successfully")
        } catch {
            print("DEBUG: Failed to delete user account with error \(error.localizedDescription)")
            throw error
        }
    }
    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
                
        self.currentUser = try? snapshot.data(as: User.self)
    }
}
