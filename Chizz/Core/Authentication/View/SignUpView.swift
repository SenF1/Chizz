//
//  SignUpView.swift
//  Chizz
//
//  Created by Sen Feng on 7/14/24.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var email = ""
    @State private var fullname = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isWaitingVerification = false
    @State private var errorMessage: String?
    @State private var showAlert = false
    
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
                InputView(text: $email,
                          title: "University Email Address",
                          placeholder: "name@example.edu").autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                
                InputView(text: $fullname,
                          title: "Full Name",
                          placeholder: "Enter your name")
                
                InputView(text: $password,
                          title: "Password",
                          placeholder: "Enter your password",
                          isSecureField: true)
                
                ZStack (alignment: .trailing) {
                    InputView(text: $confirmPassword,
                              title: "Confirm password",
                              placeholder: "Confirm your password",
                              isSecureField: true)
                    
                    if !password.isEmpty && !confirmPassword.isEmpty {
                        if password == confirmPassword {
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
            .alert("Error", isPresented: $showAlert) {
                        Button("OK", role: .cancel) { }
                    } message: {
                        Text(errorMessage ?? "An unknown error occurred")
                    }
            
            ButtonWithArrow(
                action: {
                    Task {
                        do {
                            try await viewModel.createUser(withEmail: email, password: password, fullname: fullname)
                        } catch let error as NSError {
                            errorMessage = error.localizedDescription
                            showAlert = true
                        }
                    }
                }, label: "Sign Up")
            .padding(.top, 24)
            .disabled(!formIsValid)
            .opacity(formIsValid ? 1.0 : 0.5)
            
        }
        .navigationDestination(isPresented: $viewModel.isEmailVerificationPending) {
            WaitingVerificationView()
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
        return !email.isEmpty
        && email.contains("@")
        && email.hasSuffix(".edu")
        && !password.isEmpty
        && password.count > 5
        && confirmPassword == password
        && !fullname.isEmpty
    }
}

#Preview {
    SignUpView()
        .environmentObject(AuthViewModel())
}
