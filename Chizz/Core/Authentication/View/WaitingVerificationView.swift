//
//  WaitingVerificationView.swift
//  Chizz
//
//  Created by Sen Feng on 7/15/24.
//

import SwiftUI

struct WaitingVerificationView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            ProgressView()
                .scaleEffect(1.5)
                .progressViewStyle(CircularProgressViewStyle(tint: Color.accentColor))
            
            Text("Verifying Your Email")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.accentColor)
            
            Text("Please check your email inbox for a verification message. Click the link provided to complete your registration.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}


#Preview {
    WaitingVerificationView()
}
