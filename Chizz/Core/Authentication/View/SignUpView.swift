//
//  SignUpView.swift
//  Chizz
//
//  Created by Sen Feng on 7/14/24.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = SignUpViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                // Logo
                Image("Chizz-App-Icon")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 150)
                
                Text("Create Your Account")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom, 10)
                
                Text("Join us and start connecting with your university community.")
                    .font(.caption)
                    .foregroundColor(Color.gray)
                    .padding(.bottom, 40)
            }
            
            // Form Fields
            VStack(spacing: 24) {
                InputView(text: $viewModel.email,
                          title: "University Email Address",
                          placeholder: "name@example.edu").autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                
                InputView(text: $viewModel.fullname,
                          title: "Full Name",
                          placeholder: "Enter your name")
                
                InputView(text: $viewModel.password,
                          title: "Password",
                          placeholder: "Enter your password",
                          isSecureField: true)
                
                ZStack (alignment: .trailing) {
                    InputView(text: $viewModel.confirmPassword,
                              title: "Confirm password",
                              placeholder: "Confirm your password",
                              isSecureField: true)
                    
                    if !viewModel.password.isEmpty && !viewModel.confirmPassword.isEmpty {
                        if viewModel.password == viewModel.confirmPassword {
                            Image(systemName: "checkmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundColor(Color(.systemGreen))
                        } else {
                            Image(systemName: "xmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundColor(Color(.systemRed))
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 12)
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Sign Up Status"), message: Text(viewModel.message ?? ""), dismissButton: .default(Text("OK")))
            }
            
            // Sign up button
            ButtonWithArrow(
                action: {
                    await viewModel.createUser()
                }, label: "Sign Up")
            .padding(.top, 24)
            .disabled(!formIsValid)
            .opacity(formIsValid ? 1.0 : 0.5)
        }
        .navigationDestination(isPresented: $viewModel.isEmailVerificationPending) {
            WaitingVerificationView()
        }
        .navigationDestination(isPresented: $viewModel.shouldNavigateToMain) {
            MainTabView() // Assuming this is your main app view
        }
        .onChange(of: viewModel.shouldDismissToLogin) { _, shouldDismiss in
            if shouldDismiss {
                dismiss()
            }
        }
        
        Spacer()
        
        // Login Link
        Button  {
            dismiss()
        } label: {
            HStack {
                Text("Already have an account?")
                Text("Sign In")
                    .foregroundColor(Color.accentColor)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .font(.system(size: 14))
            }
            .padding(.bottom, 24)
            .foregroundColor(Color.primary)
        }
    }
    
}

extension SignUpView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !viewModel.email.isEmpty
        && viewModel.email.contains("@")
        && !viewModel.password.isEmpty
        && viewModel.password.count > 5
        && viewModel.confirmPassword == viewModel.password
        && !viewModel.fullname.isEmpty
    }
}

#Preview {
    SignUpView()
}
