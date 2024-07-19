//
//  SettingOptionsViewModel.swift
//  Chizz
//
//  Created by Sen Feng on 7/16/24.
//

import Foundation
import SwiftUI

enum SettingOptionsViewModel: Int, CaseIterable, Identifiable {
    case fullName
    case darkMode
    case activeStatus
    case accessibility
    case privacy
    case notifications
    
    var title: String {
        switch self {
            
        case .fullName: return "Name"
        case .darkMode: return "Dark Mode"
        case .activeStatus: return "Active Status"
        case .accessibility: return "Accessibility"
        case .privacy: return "Privacy"
        case .notifications: return "Notifications"
        }
    }
    
    var id: Int { return self.rawValue}
}
