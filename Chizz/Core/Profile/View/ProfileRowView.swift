//
//  ProfileRowView.swift
//  Chizz
//
//  Created by Sen Feng on 7/15/24.
//

import SwiftUI

struct ProfileRowView: View {
    let imageName: String
    let title: String
    let tintColor: Color
    let foregroundColor: Color?
    
    init(imageName: String, title: String, tintColor: Color, foregroundColor: Color? = nil) {
            self.imageName = imageName
            self.title = title
            self.tintColor = tintColor
            self.foregroundColor = foregroundColor
    }
    
    var body: some View {
        HStack (spacing: 12) {
            Image(systemName: imageName)
                .imageScale(.small)
                .font(.title)
                .foregroundColor(tintColor)
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(foregroundColor ?? .black)
        }
    }
}

#Preview {
    ProfileRowView(imageName: "gear", title: "Version", tintColor: Color(.systemGray))
}
