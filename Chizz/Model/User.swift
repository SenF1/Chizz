//
//  User.swift
//  Chizz
//
//  Created by Sen Feng on 7/15/24.
//

import Foundation

// User model
struct User: Identifiable, Codable {
    var id = UUID() // Unique identifier for each user
    let fullname: String
    let email: String
    
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullname) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        return "" // Will need to return image in future
    }
}

extension User {
    static var MOCK_USER = User(fullname: "Sen Feng", email: "senfeng6@gmail.com")
}

