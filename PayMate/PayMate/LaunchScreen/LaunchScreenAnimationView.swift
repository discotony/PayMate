//
//  LaunchScreenAnimationView.swift
//  PayMate
//
//  Created by Antony Bluemel on 1/16/24.
//

import SwiftUI

struct LaunchScreenAnimationView: View {
    @State private var rotations = [-24.0, -12.0, 0.0]
    @State private var isAnimating = false
    @State private var currentLoop = 0
    @State private var scale: CGFloat = 1
    @State private var opacity: Double = 1
    @State private var textLogoOpacity: Double = 1
    
    let animationDuration = 1.0
    let delayDuration = 0.5
    let pauseDuration = 0.5
    let loopCount = 3
    
    var onCompletion: (() -> Void)?
    
    var body: some View {
        ZStack {
            ZStack {
                Color(.customBackground).ignoresSafeArea()
                ForEach(0..<3, id: \.self) { index in
                    createCardView(for: index)
                }
            }
            .onAppear {
                startAnimationCycle()
            }

            VStack {
                Spacer()
                Image(.textLogo)
                    .customScaleResize(widthScale: 0.2)
                    .padding(.bottom, 24)
                    .opacity(textLogoOpacity)
            }
        }
    }
    
    private func createCardView(for index: Int) -> some View {
        Image(getCardImageName(for: index))
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 78)
            .offset(x: 5, y: 12)
            .rotationEffect(Angle.degrees(rotations[index]), anchor: .bottomLeading)
            .scaleEffect(scale)
            .opacity(opacity)
            .animation(isAnimating ? Animation.linear(duration: animationDuration).delay(delayDuration * Double(index) * 0.25) : .default, value: rotations[index])
    }
    
    private func getCardImageName(for index: Int) -> String {
        switch index {
        case 0: return "card3"
        case 1: return "card2"
        case 2: return "card1"
        default: return ""
        }
    }
    
    private func startAnimationCycle() {
        guard currentLoop < loopCount else {
            // Start fading out the text logo earlier
            withAnimation(.easeInOut(duration: animationDuration * 0.5)) {
                textLogoOpacity = 0
            }

            // Start scaling and fading out other images
            withAnimation(.easeInOut(duration: animationDuration)) {
                scale = UIScreen.main.bounds.size.height / 4
                opacity = 0
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
                onCompletion?()
            }
            return
        }
        
        isAnimating = true
        
        // Update rotations for continuous clockwise rotation
        for i in 0..<rotations.count {
            rotations[i] += 360.0
        }
        
        // Pause and restart the animation after one cycle
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration + delayDuration * 2 + pauseDuration) {
            self.isAnimating = false
            self.currentLoop += 1
            
            // Delay the restart to create a pause
            DispatchQueue.main.asyncAfter(deadline: .now() + pauseDuration) {
                self.startAnimationCycle()
            }
        }
    }
}

#Preview {
    LaunchScreenAnimationView()
}
