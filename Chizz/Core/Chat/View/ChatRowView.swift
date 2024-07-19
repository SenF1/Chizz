//
//  ChatRowView.swift
//  Chizz
//
//  Created by Sen Feng on 7/16/24.
//

import SwiftUI

struct ChatRowView: View {
    let message: Message
    
    var body: some View {
        HStack(alignment: .top, spacing: 12, content: {
            CircularProfileImageView(user: message.user, size: .medium)
            
            VStack(alignment: .leading, spacing: 4, content: {
                Text(message.user?.fullname ?? "")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text(message.messageText)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                    .frame(maxWidth: UIScreen.main.bounds.width - 100, alignment: .leading)
            })
            
            HStack {
                Text(message.timestampString)
                
                Image(systemName: "chevron.right")
            }
            .font(.footnote)
            .foregroundStyle(.gray)
        })
        .frame(height: 72)
    }
}


#Preview {
    ChatRowView(message: Message.MOCK_MESSAGE)
}
