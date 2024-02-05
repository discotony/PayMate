//
//  LaunchScreenAnimationView.swift
//  PayMate
//
//  Created by Antony Bluemel on 1/16/24.
//

import SwiftUI

struct LaunchScreenView: View {
    @EnvironmentObject var userModel: UserModel
    @State private var rotations: [Double] = [-24.0, -12.0, 0.0]
    @State private var isAnimating: Bool = false
    @State private var currentLoop: Int = 0
    @State private var scale: CGFloat = 1
    @State private var opacity: Double = 1
    @State private var textLogoOpacity: Double = 1
    @State private var navigateToView: Bool = false
    @EnvironmentObject var viewRouter: ViewRouter
    
    let animationDuration: Double = 0.8
    let delayDuration: Double = 0.5
    let pauseDuration: Double = 0.1
    let loopCount: Int = 1
    
    var body: some View {
        ZStack {
            ZStack {
                Color(.customBackground).ignoresSafeArea()
                ForEach(0...2, id: \.self) { index in
                    createCardView(for: index)
                }
            }
            VStack {
                Spacer()
                Image(.textLogo)
                    .customScaleResize(widthScale: 0.2)
                    .padding(.bottom, 24)
                    .opacity(textLogoOpacity)
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            userModel.loadAuthToken()
            startAnimationCycle()
        }
        .onChange(of: navigateToView) {
            if navigateToView {
                if userModel.isAuthenticated {
                    viewRouter.currentView = .loading
                } else {
                    viewRouter.currentView = .welcome
                }
            }
        }
    }
    
    // Create custom card view
    private func createCardView(for index: Int) -> some View {
        Image(getCardImageName(for: index))
            .customFixedResize(width: 78)
            .offset(x: 5, y: 12)
            .rotationEffect(Angle.degrees(rotations[index]),
                            anchor: .bottomLeading)
            .scaleEffect(scale)
            .opacity(opacity)
            .animation(isAnimating ? Animation.linear(duration: animationDuration).delay(delayDuration * Double(index) * 0.25) : .default, value: rotations[index])
    }
    
    // Get card images
    private func getCardImageName(for index: Int) -> String {
        switch index {
        case 0: return "card0"
        case 1: return "card1"
        case 2: return "card2"
        default: return ""
        }
    }
    
    // Start animaton cycle for each card
    private func startAnimationCycle() {
        guard currentLoop < loopCount else {
            // Start fading out the text logo earlier than the card images
            withAnimation(.easeInOut(duration: animationDuration * 0.5)) {
                textLogoOpacity = 0
            }
            
            // Start scaling and fading out other images
            withAnimation(.easeInOut(duration: animationDuration)) {
                scale = UIScreen.main.bounds.size.height / 4
                opacity = 0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
                self.navigateToView = true
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
    LaunchScreenView()
}
