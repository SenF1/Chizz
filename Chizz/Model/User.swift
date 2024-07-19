//
//  User.swift
//  Chizz
//
//  Created by Sen Feng on 7/15/24.
//

import Foundation
import FirebaseFirestoreSwift

// User model
struct User: Identifiable, Codable, Hashable {
    @DocumentID var uid: String?
    let fullname: String
    let email: String
    var profileImageUrl: String?
    
    var id: String {
        return uid ?? UUID().uuidString
    }
    
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullname) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        return "" // Will need to return image in future
    }
    
    var firstName: String {
        let formatter = PersonNameComponentsFormatter()
        let components = formatter.personNameComponents(from: fullname)
        return components?.givenName ?? fullname
    }
}

extension User {
    static let MOCK_USER = User(fullname: "Sen Feng", email: "senfeng6@gmail.com", profileImageUrl: nil)
}

