//
//  Message.swift
//  Chizz
//
//  Created by Sen Feng on 7/17/24.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Message: Identifiable, Codable, Hashable {
    @DocumentID var messageID: String?
    let fromId: String
    let toId: String
    let messageText: String
    let timestamp: Timestamp
    
    var user: User?
    
    var id: String {
        return messageID ?? UUID().uuidString
    }
    
    var chatPartnerId: String {
        return fromId == Auth.auth().currentUser?.uid ? toId : fromId
    }
    
    var isFromCurrentUser: Bool {
        return fromId == Auth.auth().currentUser?.uid
    }
    
    var timestampString: String {
        return timestamp.dateValue().timestampString()
    }
}

extension Message {
    static let MOCK_MESSAGE = Message(
        fromId: "mockFromId",
        toId: "mockToId",
        messageText: "This is a mock message for testing purposes.",
        timestamp: Timestamp(date: Date()),
        user: User.MOCK_USER
    )
}
