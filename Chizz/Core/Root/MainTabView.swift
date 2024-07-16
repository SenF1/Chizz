//
//  MainTabView.swift
//  Chizz
//
//  Created by Sen Feng on 7/14/24.
//

import SwiftUI
import SwiftData

struct MainTabView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        TabView {
            ChatView()
                .tabItem {
                    Label("Chat", systemImage: "message.circle")
                }
            
            ExploreView()
                .tabItem {
                    Label("Explore", systemImage: "magnifyingglass.circle")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                }
        }
    }
}

#Preview {
    let viewModel = AuthViewModel()
    viewModel.currentUser = User(fullname: "John Doe", email: "john.doe@example.com")
    
    return MainTabView()
        .environmentObject(viewModel)
}
