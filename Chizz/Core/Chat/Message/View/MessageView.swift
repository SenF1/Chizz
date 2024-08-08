//
//  MessageView.swift
//  Chizz
//
//  Created by Sen Feng on 7/16/24.
//

import SwiftUI

struct MessageView: View {
    @StateObject var viewModel: MessageViewModel
    let user: User
    
    init(user: User) {
        self.user = user
        self._viewModel = StateObject(wrappedValue: MessageViewModel(user: user))
    }
    
    var body: some View {
        VStack {
            ScrollView {
                ScrollViewReader { scrollView in
                    VStack {
                        // Header
                        CircularProfileImageView(user: user, size: .large)
                        
                        VStack(spacing: 4) {
                            Text(user.fullname)
                                .font(.title3)
                                .fontWeight(.semibold)
                            
                            Text("Chizz")
                                .font(.footnote)
                                .foregroundStyle(.gray)
                        }
                    }
                    
                    // Messages
                    LazyVStack {
                        ForEach(viewModel.messages) { message in
                            ChatMessageCell(message: message)
                        }
                        .onChange(of: viewModel.messages) {
                            scrollToBottom(scrollView: scrollView)
                        }
                        .onAppear {
                            scrollToBottom(scrollView: scrollView)
                        }
                    }
                }
            }
            
            // Message Input View
            Spacer()
            
            ZStack(alignment: .trailing) {
                TextField("Message...", text: $viewModel.messageText)
                    .padding(12)
                    .padding(.trailing, 48)
                    .background(Color(.systemGroupedBackground))
                    .clipShape(Capsule())
                    .font(.subheadline)
                
                Button {
                    viewModel.sendMessage()
                } label: {
                    Text("Send")
                        .fontWeight(.semibold)
                }
                .padding(.horizontal)
            }
            .padding()
        }
        .navigationTitle(user.fullname)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func scrollToBottom(scrollView: ScrollViewProxy) {
        if let lastMessage = viewModel.messages.last {
            scrollView.scrollTo(lastMessage.id, anchor: .bottom)
        }
    }
}

#Preview {
    MessageView(user: User.MOCK_USER)
}
