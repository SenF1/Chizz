//
//  ButtonView.swift
//  Chizz
//
//  Created by Sen Feng on 7/14/24.
//

import SwiftUI

struct ButtonWithArrow: View {
    var action: () async -> Void
    var label: String
    
    var body: some View {
        Button {
            Task {
                await action()
            }
        } label: {
            HStack {
                Text(label)
                    .fontWeight(.semibold)
                Image(systemName: "arrow.right")
            }
            .foregroundColor(.white)
            .frame(width: UIScreen.main.bounds.width - 32, height: 48)
        }
        .background(Color.accentColor)
        .cornerRadius(10)
    }
}

struct ButtonWithArrow_Previews: PreviewProvider {
    static var previews: some View {
        ButtonWithArrow(action: {}, label: "Button Label")
    }
}
