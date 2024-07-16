//
//  ForgotPasswordView.swift
//  Chizz
//
//  Created by Sen Feng on 7/14/24.
//

import SwiftUI

struct ForgotPasswordView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var email = ""
    @State private var showAlert = false
    @State private var alertMessage: String?
    
    var body: some View {
        VStack {
            Image("Chizz-App-Icon")
                .resizable()
                .scaledToFill()
                .frame(width: 150, height: 150)
                .padding(.top, 32)
            
            Text("Forgot Password")
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 10)
            
            Text("We'll send you a link to reset your password.")
                .font(.caption)
                .foregroundColor(Color.gray)
                .padding(.bottom, 40)
            
            InputView(text: $email,
                      title: "University Email Address",
                      placeholder: "name@example.edu").autocapitalization(.none)
            
            Spacer()
            
            Button(action: {
                guard !email.isEmpty else {
                    self.alertMessage = "Please enter your email."
                    self.showAlert = true
                    return
                }
                
                viewModel.resetPassword(forEmail: email) { error in
                    if let error = error {
                        self.alertMessage = error.localizedDescription
                    } else {
                        self.alertMessage = "Password reset email sent. Please check your email."
                    }
                    self.showAlert = true
                }
            }) {
                Text("Reset Password")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.accentColor)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        .padding(.horizontal)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage ?? "An unknown error occurred"), dismissButton: .default(Text("OK")))
        }
    }
}

#Preview {
    ForgotPasswordView()
        .environmentObject(AuthViewModel())
}
