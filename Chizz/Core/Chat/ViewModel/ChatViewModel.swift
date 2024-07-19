//
//  ChatViewModel.swift
//  Chizz
//
//  Created by Sen Feng on 7/16/24.
//

import Foundation
import Combine
import Firebase

class ChatViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var recentMessages = [Message]()
    @Published var searchText = ""
    
    private var cancellables = Set<AnyCancellable>()
    private var service = ChatService()
    
    var filteredMessages: [Message] {
        if searchText.isEmpty {
            return recentMessages
        } else {
            return recentMessages.filter { message in
                message.user?.fullname.lowercased().contains(searchText.lowercased()) ?? false
            }
        }
    }
    
    init() {
        setupSubscribers()
        service.observeRecentMessages()
    }
    
    private func setupSubscribers() {
        UserService.shared.$currentUser
            .sink { [weak self] user in
                self?.currentUser = user
        }.store(in: &cancellables)
        
        service.$documentChanges
            .sink { [weak self] changes in
                self?.loadInitialMessages(fromChanges: changes)
        }.store(in: &cancellables)
    }
    
    private func loadInitialMessages(fromChanges changes: [DocumentChange]) {
        var tempRecentMessages = recentMessages // Work with a local copy

        let dispatchGroup = DispatchGroup()

        for change in changes {
            if let message = try? change.document.data(as: Message.self) {
                dispatchGroup.enter()
                UserService.fetchUser(withUid: message.chatPartnerId) { [weak self] user in
                    guard let self = self else { return }
                    var updatedMessage = message
                    updatedMessage.user = user

                    DispatchQueue.global(qos: .userInitiated).async {
                        // Check if there's an existing message from the same user
                        if let index = tempRecentMessages.firstIndex(where: { $0.chatPartnerId == updatedMessage.chatPartnerId }) {
                            // Compare timestamps and keep the more recent one
                            if tempRecentMessages[index].timestamp.seconds < updatedMessage.timestamp.seconds {
                                tempRecentMessages[index] = updatedMessage
                            }
                        } else {
                            // If no existing message, add the new one
                            tempRecentMessages.append(updatedMessage)
                        }
                        dispatchGroup.leave()
                    }
                }
            }
        }

        dispatchGroup.notify(queue: .main) { [weak self] in
            // Sort by timestamp before updating the published variable
            self?.recentMessages = tempRecentMessages.sorted(by: { $0.timestamp.seconds > $1.timestamp.seconds })
        }
    }
}
