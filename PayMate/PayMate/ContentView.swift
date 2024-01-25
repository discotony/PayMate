//
//  ContentView.swift
//  PayMate
//
//  Created by Antony Bluemel on 1/15/24.
//

import SwiftUI

struct ContentView: View {
    @State private var showLaunchAnimation = true
    
    var body: some View {
        Group {
            
            // Diplays LaunchScreenView first before presenting WelcomeScreenView
            if showLaunchAnimation {
                LaunchScreenView {
                    showLaunchAnimation = false
                }
            } else {
                WelcomeView()
            }
//            OTPVerificationView()
        }
    }
}
