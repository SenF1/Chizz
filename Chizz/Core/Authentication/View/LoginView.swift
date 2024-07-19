//
//  LoginView.swift
//  Chizz
//
//  Created by Sen Feng on 7/14/24.
//

import SwiftUI

struct LoginView: View {
    @StateObject var viewModel = LoginViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                // Logo
                Image("Chizz-App-Icon")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 150)
                
                Text("Hello")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom, 10)
                
                Text("Login to your account")
                    .font(.caption)
                    .foregroundColor(Color.gray)
                    .padding(.bottom, 40)
                
                // Form Fields
                VStack(spacing: 24) {
                    InputView(text: $viewModel.email,
                              title: "University Email Address",
                              placeholder: "name@example.edu").autocapitalization(.none)
                    
                    InputView(text: $viewModel.password, title: "Password", placeholder: "Enter your password", isSecureField: !viewModel.isPasswordVisible)
                        .overlay(alignment: .trailing) {
                            Button(action: {
                                withAnimation {
                                    viewModel.isPasswordVisible.toggle()
                                }
                            }) {
                                Image(systemName: viewModel.isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                    .foregroundStyle(.gray)
                                    .padding(.top, 30)
                                    .padding(14)
                                    .contentShape(Rectangle())
                            }
                        }
                }
                .padding(.top, 12)
                .alert(isPresented: $viewModel.showAlert) {
                    Alert(title: Text("Login Status"), message: Text(viewModel.message ?? ""), dismissButton: .default(Text("OK")))
                }
                
                // Forgot Password
                HStack {
                    Spacer()
                    NavigationLink(destination: ForgotPasswordView()) {
                        Text("Forgot Password?")
                            .foregroundColor(Color.accentColor)
                            .font(.system(size: 14))
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)
                
                // Sign in Link
                ButtonWithArrow(action: {
                    Task {
                        try await viewModel.login()
                    }
                }, label: "Log In")
                .padding(.top, 24)
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.5)
                
                Spacer()
                
                // Sign Up Link
                HStack {
                    Text("Don't have an account?")
                    NavigationLink(destination: SignUpView().navigationBarBackButtonHidden(true)) {
                        Text("Sign Up")
                            .foregroundColor(Color.accentColor)
                            .fontWeight(.bold)
                    }
                    .font(.system(size: 14))
                }
                .padding(.bottom, 24)
            }
            .padding()
        }
    }
}

extension LoginView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !viewModel.email.isEmpty
        && viewModel.email.contains("@")
        && !viewModel.password.isEmpty
        && viewModel.password.count > 5
    }
}

#Preview {
    LoginView()
}
