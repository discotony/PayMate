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
                
                WelcomeTextView()
                
                Spacer().frame(height: 48)
                
                WelcomeImageView()
                
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
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.customBackground)
        }
    }
}

extension Image {
    func customScaleResize(widthScale: Float) -> some View {
        
        let outputWidth = Float(UIScreen .main.bounds.size.width) * widthScale
        
        return self
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: CGFloat(outputWidth))
    }
    
    func customFixedResize(width: CGFloat? = nil, height: CGFloat? = nil) -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: width, height: height)
    }
}

#Preview {
    WelcomeScreenView()
}



//                    ZStack {
//                        Image(.welcomeBackground)
//                            .customScaleResize(widthScale: 0.8)
//                        Image(.coin)
//                            .customScaleResize(widthScale: 0.08)
//                            .rotationEffect(.degrees(rotationDegrees))
//                            .offset(x: isMovingRight ? 0 : -100, y: 75) // Horizontal movement
//                            .onAppear() {
//                                withAnimation(Animation.easeInOut(duration: 8).repeatForever(autoreverses: true)) {
//                                    rotationDegrees = 0
//                                }
//                                withAnimation(Animation.easeInOut(duration: 8).repeatForever(autoreverses: true)) {
//                                    isMovingRight.toggle() // Move back and forth
//                                }
//                            }
//                    }
