//
//  PeopleView.swift
//  Chizz
//
//  Created by Sen Feng on 7/16/24.
//

import SwiftUI

struct ActiveNowView: View {
    @StateObject var viewModel = ActiveNowModel()
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 32, content: {
                ForEach(viewModel.users, id: \.self) { user in
                    NavigationLink(value: Route.messageView(user)) {
                        VStack {
                            ZStack(alignment: .bottomTrailing) {
                                CircularProfileImageView(user: user, size: .medium)
                                
                                ZStack {
                                    Circle()
                                        .fill(.white)
                                        .frame(width: 18, height: 18)
                                    
                                    Circle()
                                        .fill(Color(.systemGreen))
                                        .frame(width: 12, height: 12)
                                }
                            }
                            
                            Text(user.firstName)
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                    }
                }
            })
            .padding()
        }
        .scrollIndicators(.hidden)
        .frame(height: 106)
    }
}

#Preview {
    ActiveNowView()
}
