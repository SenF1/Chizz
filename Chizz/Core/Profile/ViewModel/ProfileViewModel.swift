//
//  ProfileViewModel.swift
//  Chizz
//
//  Created by Sen Feng on 7/17/24.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var currentUser: User?
    private let userService = UserService.shared
    
    init() {
        fetchCurrentUser()
    }
    
    func fetchCurrentUser() {
        Task {
            do {
                try await userService.fetchCurrentUser()
                self.currentUser = userService.currentUser
            } catch {
                // Handle error fetching user data
                print("Error fetching user data: \(error.localizedDescription)")
            }
        }
    }
}
