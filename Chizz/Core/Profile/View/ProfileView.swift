//
//  ProfileView.swift
//  Chizz
//
//  Created by Sen Feng on 7/14/24.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var profileViewModel = ProfileViewModel()

    var body: some View {
        NavigationView {
            if let user = profileViewModel.currentUser {
                List {
                    Section {
                        NavigationLink(destination: SettingView(user: user)) {
                                HStack {
                                    CircularProfileImageView(user: user, size: .large)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(user.fullname)
                                            .fontWeight(.semibold)
                                            .padding(.top, 4)
                                        
                                        Text(user.email)
                                            .font(.footnote)
                                            .foregroundColor(.gray)
                                    }
                                    
                                    Spacer()
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}
