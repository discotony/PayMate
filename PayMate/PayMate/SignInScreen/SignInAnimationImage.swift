//
//  SignInAnimationView.swift
//  PayMate
//
//  Created by Antony Bluemel on 1/18/24.
//

import SwiftUI

struct SignInAnimationImage: View {
    @State private var outerRotationDegrees: Double = 0.0
    @State private var InnerRotationDegrees: Double = 360.0
    @State private var swingAngle: Double = 5
    @State private var scale: CGFloat = 1.0
    
    @FocusState.Binding var isTextFieldFocused: Bool
    private let isSmallDevice = UIScreen.main.bounds.height <= 736
    
    var body: some View {
        ZStack {
            if !isTextFieldFocused || !isSmallDevice {
                Image(.otpOuterCircle)
                    .customScaleResize(widthScale: 0.4)
                    .rotationEffect(.degrees(outerRotationDegrees))
                    .onAppear() {
                        withAnimation(Animation.linear(duration: 60).repeatForever(autoreverses: false)) {
                            outerRotationDegrees = 360
                        }
                    }
                Image(.otpInnerCircle)
                    .customScaleResize(widthScale: 0.4)
                    .rotationEffect(.degrees(InnerRotationDegrees))
                    .onAppear() {
                        withAnimation(Animation.linear(duration: 60).repeatForever(autoreverses: false)) {
                            InnerRotationDegrees = 0
                        }
                    }
                Image(.otpHand)
                    .customScaleResize(widthScale: 0.4)
                    .rotationEffect(.degrees(swingAngle))
                    .scaleEffect(scale)
                    .onAppear() {
                        withAnimation(Animation.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                            swingAngle = -5
                            scale = 1.1
                        }
                    }
            }
        }
        .transition(.move(edge: .top))
        .animation(.linear(duration: 0.25), value: isTextFieldFocused)
    }
}
