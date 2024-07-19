//
//  CircularProfileImageView.swift
//  Chizz
//
//  Created by Sen Feng on 7/16/24.
//

import SwiftUI

enum profileImageSize {
    case xxsmall
    case xsmall
    case small
    case medium
    case large
    case xlarge
    
    var dimension: CGFloat {
        switch self {
        case .xxsmall: return 28
        case .xsmall: return 32
        case .small: return 40
        case .medium: return 56
        case .large: return 64
        case .xlarge: return 80
        }
    }
}

struct CircularProfileImageView: View {
    var user: User?
    let size: profileImageSize
    
    var body: some View {
        if let imageURL = user?.profileImageUrl {
            Image(imageURL)
                .resizable()
                .frame(width: size.dimension, height: size.dimension)
                .scaledToFill()
                .clipShape(Circle())
        } else {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: size.dimension, height: size.dimension)
                .foregroundStyle(Color(.systemGray4))
        }    }
}

#Preview {
    CircularProfileImageView(user: User.MOCK_USER, size: .medium)
}
