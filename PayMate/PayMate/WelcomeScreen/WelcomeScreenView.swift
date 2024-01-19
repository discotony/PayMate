//
//  WelcomeScreenView.swift
//  PayMate
//
//  Created by Antony Bluemel on 1/15/24.
//

import SwiftUI

struct WelcomeScreenView: View {
    @State private var contentOpacity: Double = 0
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer(minLength: 10)
                
                Image(.logoWithText)
                    .customScaleResize(widthScale: 0.5)
                Spacer()
                
                WelcomeTextLabel()
                Spacer().frame(height: 48)
                
                WelcomeAnimationImage()
                Spacer()
                
                NavigationLink(destination: SignInScreenView()) {
                    Text("Sign In")
                        .foregroundStyle(Color(.customBackground))
                        .font(.title3.bold())
                        .padding()
                        .frame(width: 200, height: 50)
                        .background(Color.white)
                        .cornerRadius(25)
                }
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
}

#Preview {
    WelcomeScreenView()
}
