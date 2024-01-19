//
//  WelcomeTextView.swift
//  PayMate
//
//  Created by Antony Bluemel on 1/16/24.
//

import SwiftUI

struct WelcomeTextLabel: View {
    let textArray: [String] = ["Welcome to the Future of Payments!",
                               "Unlock a World of Convenience with PayMate",
                               "Your Money, Your Way, Your PayMate",
                               "Experience Easy, Fast, and Secure Transactions",
                               "Money Made Mobile – Welcome to PayMate"]
    
    @State private var displayedText: String = ""
    @State private var currentIndex: Int = 0
    
    var body: some View {
        Text(displayedText)
            .font(.callout)
            .foregroundStyle(.white)
            .multilineTextAlignment(.center)
            .transition(.move(edge: .bottom))
            .onAppear {
                self.displayedText = self.textArray[currentIndex]
                
                Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
                    withAnimation {
                        self.currentIndex = (self.currentIndex + 1) % self.textArray.count
                        self.displayedText = self.textArray.randomElement() ?? ""
                    }
                }
            }
    }
}

#Preview {
    WelcomeTextLabel()
}
