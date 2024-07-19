//
//  ContentViewModel.swift
//  Chizz
//
//  Created by Sen Feng on 7/17/24.
//

import Firebase
import Combine

class ContentViewModel: ObservableObject {
    @Published var userSession : FirebaseAuth.User?
    
    private var cancellables = Set<AnyCancellable>()
    
    init () {
        setupSubscribers()
    }
    
    private func setupSubscribers() {
        AuthService.shared.$userSession
            .receive(on: DispatchQueue.main) // Ensure updates are received on the main thread
            .sink { [weak self] userSessionFromAuthService in
                self?.userSession = userSessionFromAuthService
            }
            .store(in: &cancellables)
    }
}
