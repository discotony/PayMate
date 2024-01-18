//
//  WelcomeImageView.swift
//  PayMate
//
//  Created by Antony Bluemel on 1/18/24.
//

import SwiftUI

struct WelcomeImageView: View {
    
    @State private var personRotationDegrees: Double = 0.0
    @State private var arrowRotationDegrees: Double = 4.0
    @State private var arrowScale: Double = 1.0
    @State private var coinRotationDegrees: Double = 360.0
    @State private var isMovingRight: Bool = true
    
    var body: some View {
        
        GeometryReader { geometry in
            ZStack {
                Image(.welcomeBackground)
                    .customScaleResize(widthScale: 0.8)
                
                Image(.welcomePerson)
                    .customScaleResize(widthScale: 0.8)
                    .rotationEffect(.degrees(personRotationDegrees))
                    .onAppear {
                        withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                            personRotationDegrees = 3.0
                        }
                    }
                
                Image(.welcomeCoin)
                    .customScaleResize(widthScale: 0.08)
                    .rotationEffect(.degrees(coinRotationDegrees))
                    .offset(x: isMovingRight ? geometry.size.width * -0.08: geometry.size.width * -0.335, y: geometry.size.height * 0.355)
                    // Dynamically set offset values based on screen sizes
                
                    .animation(Animation.easeInOut(duration: 8).repeatForever(autoreverses: true), value: isMovingRight)
                    .onAppear {
                        coinRotationDegrees = 0
                        isMovingRight.toggle()
                    }
                
                Image(.welcomeArrow)
                    .customScaleResize(widthScale: 0.8)
                    .rotationEffect(.degrees(arrowRotationDegrees))
                    .scaleEffect(arrowScale)
                    .onAppear {
                        withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                            arrowRotationDegrees = 0
                            arrowScale = 1.05
                        }
                    }
            }
        }
        .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.width * 0.8 / 3 * 2)
    }
}

#Preview {
    WelcomeImageView()
}
