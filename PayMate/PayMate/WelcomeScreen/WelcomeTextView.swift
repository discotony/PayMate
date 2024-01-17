//
//  WelcomeTextView.swift
//  PayMate
//
//  Created by Antony Bluemel on 1/16/24.
//

import SwiftUI

struct WelcomeTextView: View {
    let textArray = ["Welcome to the Future of Payments!",
                     "Unlock a World of Convenience with PayMate",
                     "Your Money, Your Way, Your PayMate",
                     "Experience Easy, Fast, and Secure Transactions",
                     "Money Made Mobile – Welcome to PayMate"]

    // Create a @State variable to store the currently displayed text.
    @State private var displayedText = ""

    var body: some View {
        Text(displayedText)
            .font(.subheadline)
            .foregroundStyle(.white)
            .multilineTextAlignment(.center)
            .onAppear {
                self.displayedText = self.textArray.randomElement() ?? ""
                
                Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
                    withAnimation {
                        self.displayedText = self.textArray.randomElement() ?? ""
                    }
                }
            }
    }
}

#Preview {
    WelcomeTextView()
}
