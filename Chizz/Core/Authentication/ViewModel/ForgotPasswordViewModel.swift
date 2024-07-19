//
//  ForgotPasswordViewModel.swift
//  Chizz
//
//  Created by Sen Feng on 7/17/24.
//

import Foundation
import SwiftUI

class ForgotPasswordViewModel: ObservableObject {
    @Published var email = ""
    @Published var message: String?
    @Published var showAlert = false
    
    func forgotPassword() async {
        do {
            try await AuthService.shared.resetPassword(forEmail: email)
            DispatchQueue.main.async {
                self.message = "Password reset email sent successfully"
                self.showAlert = true
            }
        } catch {
            // Handle error on the main thread
            DispatchQueue.main.async {
                self.message = "Failed to reset password. \(error.localizedDescription)"
                self.showAlert = true
            }
        }
    }
}
