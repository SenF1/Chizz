//
//  RegistrationViewModel.swift
//  Chizz
//
//  Created by Sen Feng on 7/17/24.
//

import Foundation
import SwiftUI
import Combine

class SignUpViewModel: ObservableObject {
    @Published var email = ""
    @Published var fullname = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    
    @Published var message: String?
    @Published var showAlert = false
    @Published var isWaitingVerification = false
    @Published var isEmailVerificationPending = false
    
    @Published var shouldNavigateToMain = false
    @Published var shouldDismissToLogin = false

    private var authServiceListener: AnyCancellable?

    init() {
        authServiceListener = AuthService.shared.$isEmailVerified
            .sink { [weak self] isVerified in
                if isVerified {
                    self?.shouldNavigateToMain = true
                } else if AuthService.shared.emailVerificationError != nil {
                    self?.shouldDismissToLogin = true
                }
            }
        
        authServiceListener = AuthService.shared.$isEmailVerificationPending
            .sink { [weak self] isPending in
                self?.isEmailVerificationPending = isPending
            }
    }
    
    func createUser() async {
        do {
            try await AuthService.shared.createUser(withEmail: email, password: password, fullname: fullname)
            
            // Update UI on the main thread
            DispatchQueue.main.async {
                self.isWaitingVerification = AuthService.shared.isEmailVerificationPending
            }
            
        } catch {
            // Handle error on the main thread
            DispatchQueue.main.async {
                self.message = "Failed to create user. \(error.localizedDescription)"
                self.showAlert = true
            }
        }
    }
}
