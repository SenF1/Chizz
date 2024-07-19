//
//  Constants.swift
//  Chizz
//
//  Created by Sen Feng on 7/17/24.
//

import Foundation
import Firebase

struct FirestoreConstants {
    static let userCollection = Firestore.firestore().collection("users")
    static let messagesCollection = Firestore.firestore().collection("messages")
}
