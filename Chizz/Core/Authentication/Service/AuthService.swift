//
//  AuthService.swift
//  Chizz
//
//  Created by Sen Feng on 7/17/24.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

protocol AuthenticationFormProtocol {
    var formIsValid: Bool { get }
}

class AuthService {
    @Published var userSession: FirebaseAuth.User?
    static let shared = AuthService()
    
    // Email verification state management
    @Published var isEmailVerificationPending = false
    @Published var emailVerificationError: String?
    private var verificationTask: Task<Void, Error>?
    @Published var isEmailVerified = false
    
    init () {
        self.userSession = Auth.auth().currentUser
        loadCurrentUserData()
    }
    
    @MainActor
    func login(withEmail email: String, password: String) async throws {
        do {
            try validateUserInput(email: email, password: password, fullname: nil)
            
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            
            // Check if the user's email is verified
            guard result.user.isEmailVerified else {
                throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Please verify your email before logging in."])
            }
            
            self.userSession = result.user
            loadCurrentUserData()
        } catch {
            print("DEBUG: Failed to login with error \(error.localizedDescription)")
            throw error
        }
    }
    
    @MainActor
    func createUser(withEmail email: String, password: String, fullname: String) async throws {
        do {
            try validateUserInput(email: email, password: password, fullname: nil)
            
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            
            guard let user = Auth.auth().currentUser else {
                throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to create user."])
            }
            
            try await user.sendEmailVerification()
            self.isEmailVerificationPending = true
            
            self.verificationTask = Task { [weak self] in
                do {
                    try await self?.waitForEmailVerification(user: user, timeout: 20) // 10 minute timeout
                    
                    self?.isEmailVerificationPending = false
                    self?.isEmailVerified = true // Update on success
                    self?.userSession = user
                    self?.loadCurrentUserData()
                } catch {
                    self?.isEmailVerificationPending = false
                    self?.emailVerificationError = error.localizedDescription
                    if (error as NSError).code == 1 { // Assuming code 1 is timeout
                        self?.isEmailVerified = false // Update on timeout
                    }
                }
            }
            
            try await self.uploadUserData(email: email, fullname: fullname, id: result.user.uid)
        }
        catch {
            self.isEmailVerificationPending = false
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
            throw error
        }
    }
    
    func waitForEmailVerification(user: FirebaseAuth.User, timeout: TimeInterval) async throws {
        let startTime = Date()
        
        while !user.isEmailVerified {
            if Date().timeIntervalSince(startTime) > timeout {
                throw NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Verification timeout."])
            }
            try await Task.sleep(nanoseconds: 3 * 1_000_000_000) // 3 seconds
            try await user.reload()
        }
    }

    func validateUserInput(email: String?, password: String?, fullname: String?) throws {
        if let email = email, !email.isEmpty {
            guard email.contains("@") else {
                throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Please use a valid email address."])
            }
            
            guard email.hasSuffix(".edu") else {
                throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Please use a valid university email address ending with .edu."])
            }
        }
        
        if let password = password, !password.isEmpty {
            guard password.count > 5 else {
                throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Password must be at least 6 characters long."])
            }
        }
        
        if let fullname = fullname {
            guard !fullname.isEmpty else {
                throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Full name cannot be empty."])
            }
        }
    }

    
    func resetPassword(forEmail email: String) async throws {
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
        } catch {
            print("DEBUG: Failed to send password reset email with error \(error.localizedDescription)")
            throw error
        }
    }
    
    func signOut () {
        do {
            try Auth.auth().signOut() // Signout on backend
            self.userSession = nil // Clear user session and redirect to login
            UserService.shared.currentUser = nil // Clear user data model
        } catch {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    func deleteAccount() async throws {
        guard let user = Auth.auth().currentUser else {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No user is currently signed in."])
        }
        
        do {
            // Delete user from Firebase Authentication
            try await user.delete()
            
            // Delete user data from Firestore
            try await Firestore.firestore().collection("users").document(user.uid).delete()
            
            // Clear local user session and data
            self.userSession = nil
            UserService.shared.currentUser = nil
            
            print("DEBUG: User account and data deleted successfully")
        } catch {
            print("DEBUG: Failed to delete user account with error \(error.localizedDescription)")
            throw error
        }
    }
    
    private func loadCurrentUserData() {
        Task { try await UserService.shared.fetchCurrentUser() }
    }
    
    private func uploadUserData(email: String, fullname: String, id: String) async throws {
        let user = User(fullname: fullname, email: email)
        guard let encodedUser = try? Firestore.Encoder().encode(user) else { return }
        try await Firestore.firestore().collection("users").document(id).setData(encodedUser)
    }
}
