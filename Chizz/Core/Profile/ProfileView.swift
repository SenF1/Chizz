//
//  ProfileView.swift
//  Chizz
//
//  Created by Sen Feng on 7/14/24.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var showAlert = false
    @State private var errorMessage: String?

    var body: some View {
        if let user = viewModel.currentUser {
            List {
                Section {
                    HStack {
                        Text(user.initials)
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 72, height: 72)
                            .background(Color(.systemGray3))
                            .clipShape(Circle())
                        
                        VStack (alignment: .leading, spacing: 4) {
                            Text(user.fullname)
                                .fontWeight(.semibold)
                                .padding(.top, 4)
                            
                            Text(user.email)
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                Section("Account"){
                    Button {
                        viewModel.signOut()
                    } label: {
                        ProfileRowView(imageName: "arrow.left.circle.fill", title: "Sign Out", tintColor: Color(.red))
                    }
                    
                    Button {
                        showAlert = true
                    } label: {
                        ProfileRowView(imageName: "xmark.circle.fill", title: "Delete Account", tintColor: Color(.red))
                    }
                    .alert("Are you sure you want to delete your account?", isPresented: $showAlert) {
                        Button("Cancel", role: .cancel) {}
                        Button("Delete", role: .destructive) {
                            Task {
                                do {
                                    try await viewModel.deleteAccount()
                                } catch {
                                    errorMessage = error.localizedDescription
                                    showAlert = true
                                }
                            }
                        }
                    } message: {
                        if let errorMessage = errorMessage {
                            Text(errorMessage)
                        } else {
                            Text("This action cannot be undone.")
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    let viewModel = AuthViewModel()
    viewModel.currentUser = User.MOCK_USER
    
    return ProfileView()
        .environmentObject(viewModel)
}
