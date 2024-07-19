//
//  ChatView.swift
//  Chizz
//
//  Created by Sen Feng on 7/15/24.
//

import SwiftUI

struct ChatView: View {
    @State private var showNewMessageView = false
    @StateObject var viewModel = ChatViewModel()
    @State private var selectedUser: User?
    @State private var showChat = false
    
    private var user: User? {
        return viewModel.currentUser
    }
    
    var body: some View {
        NavigationStack {
            List {
                ActiveNowView()
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets())
                    .padding(.vertical)
                    .padding(.horizontal, 4)
                
                ForEach(viewModel.filteredMessages, id: \.messageID) { message in
                    // ZStack to avoid default chevron
                    ZStack {
                        NavigationLink(value: message) {
                            EmptyView()
                        }.opacity(0.0)
                        
                        ChatRowView(message: message)
                    }
                }
            }
            .searchable(text: $viewModel.searchText, prompt: "Search")
            .listStyle(PlainListStyle())
            .onChange(of: selectedUser) { _, newValue in
                showChat = newValue != nil
            }
            .navigationDestination(for: Message.self, destination: { message in
                if let user = message.user {
                    MessageView(user: user)
                }
            })
            .navigationDestination(for: Route.self, destination: { route in
                switch route {
                case .messageView(let user):
                    MessageView(user: user)
                }
            })
            .navigationDestination(isPresented: $showChat, destination: {
                if let user = selectedUser {
                    MessageView(user: user)
                }
            })
            .fullScreenCover(isPresented: $showNewMessageView, content: {
                NewMessageView(selectedUser: $selectedUser)
            })
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem (placement: .topBarLeading) {
                    HStack {
                        Text("Message")
                            .font(.title)
                            .fontWeight(.semibold)
                    }
                }
                
                ToolbarItem (placement: .topBarTrailing) {
                    Button {
                        showNewMessageView.toggle()
                        selectedUser = nil
                    } label: {
                        Image(systemName: "square.and.pencil.circle.fill")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .foregroundStyle(.black, Color(.systemGray5))
                    }
                }
            }
        }
    }
}

#Preview {
    ChatView()
}
