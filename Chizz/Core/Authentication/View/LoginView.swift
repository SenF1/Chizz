//
//  LoginView.swift
//  Chizz
//
//  Created by Sen Feng on 7/14/24.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    @State private var showAlert = false
    @State private var isPasswordVisible = false
    
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
                
                Text("Login to your acccount")
                    .font(.caption)
                    .foregroundColor(Color.gray)
                    .padding(.bottom, 40)
                
                // Form Fields
                VStack(spacing: 24) {
                    InputView(text: $email,
                              title: "University Email Address",
                              placeholder: "name@example.edu").autocapitalization(.none)
                    
                    InputView(text: $password, title: "Password", placeholder: "Enter your password", isSecureField: !isPasswordVisible)
                        .overlay(alignment: .trailing) {
                            Button(action: {
                                withAnimation {
                                    isPasswordVisible.toggle()
                                }
                            }) {
                                Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                    .foregroundStyle(.gray)
                                    .padding(.top, 30)
                                    .padding(14)
                                    .contentShape(.rect)
                            }
                        }

                }
                .padding(.horizontal)
                .padding(.top, 12)
                .alert("Error", isPresented: $showAlert) {
                        Button("OK", role: .cancel) { }
                    } message: {
                        Text(errorMessage ?? "An unknown error occurred")
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
                ButtonWithArrow(
                    action: {
                        do {
                            try await viewModel.login(withEmail: email, password: password)
                        } catch let error as NSError {
                            errorMessage = error.localizedDescription
                            showAlert = true
                        }
                    }, label: "Sign In")
                .padding(.top, 24)
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.5)
                
                Spacer()
                
                // Sign Up Link
                HStack {
                    Text("Don't have an account?")
                    NavigationLink(
                        destination:
                            SignUpView()
                                .navigationBarBackButtonHidden(true)) {
                        Text("Sign Up")
                            .foregroundColor(Color.accentColor)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    }
                    .font(.system(size: 14))
                }
                .padding(.bottom, 24)
            }
        }
    }
}

extension LoginView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
