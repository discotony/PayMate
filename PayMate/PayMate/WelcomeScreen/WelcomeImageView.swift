//
//  WelcomeImageView.swift
//  PayMate
//
//  Created by Antony Bluemel on 1/18/24.
//

import SwiftUI

struct WelcomeImageView: View {
    
    @State private var rotationDegrees: Double = 360.0
    @State private var isMovingRight: Bool = true
    
    var body: some View {
        
        GeometryReader { geometry in
            ZStack {
                Image(.welcomeBackground)
                    .customScaleResize(widthScale: 0.8)
                
                Image(.coin)
                    .customScaleResize(widthScale: 0.08)
                    .rotationEffect(.degrees(rotationDegrees))
                    .offset(x: isMovingRight ? geometry.size.width * -0.08: geometry.size.width * -0.335, y: geometry.size.height * 0.355)
                    // Dynamically set offset values based on screen sizes
                
                    .animation(Animation.easeInOut(duration: 8).repeatForever(autoreverses: true), value: isMovingRight)
                    .onAppear {
                        rotationDegrees = 0
                        isMovingRight.toggle()
                    }
            }
        }
        .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.width * 0.8 / 3 * 2)
    }
}

#Preview {
    WelcomeImageView()
}
