//
//  LoginViewModel.swift
//  Chizz
//
//  Created by Sen Feng on 7/17/24.
//

import Foundation
import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isPasswordVisible = false
    
    @Published var message: String?
    @Published var showAlert = false
    
    func login() async throws {
        do {
            try await AuthService.shared.login(withEmail: email, password: password)
            DispatchQueue.main.async {
            }
        } catch {
            DispatchQueue.main.async {
                self.message = "Failed to login. \(error.localizedDescription)"
                self.showAlert = true
            }
        }
    }
}
