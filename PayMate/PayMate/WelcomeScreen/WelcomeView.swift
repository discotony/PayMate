//
//  WelcomeScreenView.swift
//  PayMate
//
//  Created by Antony Bluemel on 1/15/24.
//

import SwiftUI

struct WelcomeView: View {
    @State private var contentOpacity: Double = 0
    
    var body: some View {
        VStack {
            Spacer(minLength: 10)
            
            Image(.logoWithText)
                .customScaleResize(widthScale: 0.5)
            Spacer()
            
            WelcomeText()
                .frame(height: 60)
            Spacer().frame(height: 48)
            
            WelcomeAnimationImage()
            Spacer()
            
            NavigationLink(destination: SignInView()) {
                Text("Sign In")
                    .foregroundStyle(Color(.customBackground))
                    .font(.title3.bold())
                    .padding()
                    .frame(width: 200, height: 50)
                    .background(Color.white)
                    .cornerRadius(25)
            }
            .simultaneousGesture(TapGesture().onEnded {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            })
            Spacer()
        }
        .opacity(contentOpacity)
        .onAppear {
            withAnimation(.easeIn(duration: 1.5)) {
                contentOpacity = 1
            }
        }
        .padding()
        .frame(maxWidth: .infinity,
               maxHeight: .infinity)
        .background(.customBackground)
        
    }
}

#Preview {
    WelcomeView()
}
