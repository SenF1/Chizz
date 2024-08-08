//
//  MessageViewModel.swift
//  Chizz
//
//  Created by Sen Feng on 7/17/24.
//

import Foundation

class MessageViewModel : ObservableObject {
    @Published var messageText = ""
    @Published var messages = [Message]()
    
    let service: MessageService
    
    init (user: User){
        self.service = MessageService(chatPartner: user)
        observeMessages()
    }
    
    func observeMessages(){
        service.observeMessages() { messages in
            self.messages.append(contentsOf: messages)
        }
    }
    
    func sendMessage(){
        let trimmedMessageText = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedMessageText.isEmpty {
            service.sendMessage(trimmedMessageText)
            messageText = "" // Reset messageText after sending
        }
    }
}
