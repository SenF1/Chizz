//
//  InputView.swift
//  Chizz
//
//  Created by Sen Feng on 7/14/24.
//

import SwiftUI

struct InputView: View {
    @Binding var text: String
    let title: String
    let placeholder: String
    var isSecureField: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .foregroundColor(Color(.darkGray))
                .fontWeight(.semibold)
                .font(.footnote)
            
            if isSecureField {
                SecureField(placeholder, text: $text)
                    .font(.system(size: 14))
                    .modifier(CustomTextFieldStyle())
            } else {
                TextField(placeholder, text: $text)
                    .font(.system(size: 14))
                    .modifier(CustomTextFieldStyle())
            }
        }
    }
}

// Custom TextFieldStyle for bottom border only
struct CustomTextFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.vertical, 10)
            .background(
                VStack {
                    Spacer()
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color(.systemGray3))
                }
            )
    }
}

struct InputView_Previews: PreviewProvider {
    @State static var inputText: String = ""
    
    static var previews: some View {
        Group {
            InputView(text: $inputText, title: "Username", placeholder: "Enter username")
                .previewDisplayName("Text Field")
            
            InputView(text: $inputText, title: "Password", placeholder: "Enter password", isSecureField: true)
                .previewDisplayName("Secure Field")
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
