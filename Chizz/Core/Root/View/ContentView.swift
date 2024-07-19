//
//  ContentView.swift
//  Chizz
//
//  Created by Sen Feng on 7/14/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @StateObject var viewModel = ContentViewModel()

    var body: some View {
        Group {
            if let user = viewModel.userSession, user.isEmailVerified {
                MainTabView()
            } else {
                LoginView()
            }
        }
    }
}

#Preview {
    ContentView()
}
