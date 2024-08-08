//
//  SettingView.swift
//  Chizz
//
//  Created by Sen Feng on 7/16/24.
//

import SwiftUI
import PhotosUI

struct SettingView: View {
    @State private var showAlert = false
    @State private var errorMessage: String?
    @StateObject var settingViewModel = SettingViewModel()
    let user: User
    
    var body: some View {
        // Header
        VStack {
            PhotosPicker(selection: $settingViewModel.selectedItem) {
                if let profileImage = settingViewModel.profileImage {
                    profileImage
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                } else {
                    CircularProfileImageView(user: user, size: .xlarge)
                }
            }
            
            Text(user.fullname)
                .font(.title2)
                .fontWeight(.semibold)
        }
        
        // List
        List {
            Section {
                ForEach(SettingOptionsViewModel.allCases, id: \.self) { option in
                    HStack {
                        Image(systemName: "bell.circle.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(Color(.accent))
                        
                        Text(option.title)
                            .font(.subheadline)
                    }
                }
            }
            
            Section {
                Button {
                    AuthService.shared.signOut()
                } label: {
                    ProfileRowView(imageName: "arrow.left.circle.fill", title: "Log Out", tintColor: Color(.red), foregroundColor: Color(.red))
                }
                
                Button {
                    showAlert = true
                } label: {
                    ProfileRowView(imageName: "xmark.circle.fill", title: "Delete Account", tintColor: Color(.red), foregroundColor: Color(.red))
                }
                .alert("Are you sure you want to delete your account?", isPresented: $showAlert) {
                    Button("Cancel", role: .cancel) {}
                    Button("Delete", role: .destructive) {
                        Task {
                            do {
                                try await AuthService.shared.deleteAccount()
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

#Preview {
    SettingView(user: User.MOCK_USER)
}

