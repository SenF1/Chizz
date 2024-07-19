//
//  ForgotPasswordView.swift
//  Chizz
//
//  Created by Sen Feng on 7/14/24.
//

import SwiftUI

struct ForgotPasswordView: View {
    @StateObject var viewModel = ForgotPasswordViewModel()
    
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
            
            InputView(text: $viewModel.email,
                      title: "University Email Address",
                      placeholder: "name@example.edu").autocapitalization(.none)
            
            Spacer()
            
            ButtonWithArrow(
                action: {
                    await viewModel.forgotPassword()
                }, label: "Reset Password")
            .padding(.horizontal)
            .disabled(!formIsValid)
            .opacity(formIsValid ? 1.0 : 0.5)
            .padding(.bottom, 20)
        }
        .padding(.horizontal)
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Password Reset"), message: Text(viewModel.message ?? ""), dismissButton: .default(Text("OK")))
        }
    }
}

extension ForgotPasswordView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !viewModel.email.isEmpty
        && viewModel.email.contains("@")
    }
}

#Preview {
    ForgotPasswordView()
}
