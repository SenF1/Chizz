//
//  ActiveNowModel.swift
//  Chizz
//
//  Created by Sen Feng on 7/18/24.
//

import Foundation
import Firebase

class ActiveNowModel : ObservableObject {
    @Published var users = [User]()
    
    init() {
        Task { try await fetchUsers() }
    }
    
    @MainActor
    private func fetchUsers() async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let users = try await UserService.fetchAllUsers(limit: 15)
        self.users = users.filter( {$0.id != currentUid }) // Filter current user
    }
}
