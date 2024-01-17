//
//  LaunchScreenView.swift
//  PayMate
//
//  Created by Antony Bluemel on 1/15/24.
//

import SwiftUI

struct LaunchScreenView: View {
    
    @EnvironmentObject var launchScreenManager: LaunchScreenManager
    @State private var firstPhaseIsAnimating: Bool = false
    @State private var secondPhaseIsAnimating: Bool = false
    
    private var timer = Timer.publish(every: 0.6,
                                      on: .main,
                                      in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            ZStack {
                background
                logo
            }
            .onReceive(timer) { input in
                switch launchScreenManager.state {
                case .first:
                    // first phase with continuous scaling effect
                    withAnimation(.spring()) {
                        firstPhaseIsAnimating.toggle()
                    }
                case .second:
                    // second phase with expanding and masking effect
                    withAnimation(.easeInOut) {
                        secondPhaseIsAnimating.toggle()
                    }
                default: break
                }
            }
            VStack {
                Spacer()
                Image(.textLogo)
                    .customScaleResize(widthScale: 0.2)
                    .padding(.bottom, 24)
                    .transition(.opacity)
            }
        }.opacity(secondPhaseIsAnimating ? 0 : 1)
    }
}

private extension LaunchScreenView {
    
    var background: some View {
        Color(.customBackground)
            .edgesIgnoringSafeArea(.all)
    }
    
    var logo: some View {
        Image(.logo)
            .scaleEffect(firstPhaseIsAnimating ? 0.65 : 1)
            .scaleEffect(secondPhaseIsAnimating ? UIScreen.main.bounds.size.height / 4 : 1)
    }
}


#Preview {
    LaunchScreenView()
        .environmentObject(LaunchScreenManager())
}
