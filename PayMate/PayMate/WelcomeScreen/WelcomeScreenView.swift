//
//  WelcomeScreenView.swift
//  PayMate
//
//  Created by Antony Bluemel on 1/15/24.
//

import SwiftUI

struct WelcomeScreenView: View {
    
    @State private var contentOpacity: Double = 0
    @State private var rotationDegrees = 0.0
    @State private var isMovingRight = true
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer().frame(height: 100)
                
                VStack {
                    Image(.logoWithText)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: UIScreen.main.bounds.size.width * 0.5)
                    
                    Spacer()
                    
                    WelcomeTextView()
                    
                    Spacer().frame(height: 32)
                    
                    ZStack {
                        Image(.welcomeBackground)
                            .customScaleResize(widthScale: 0.8)
                        Image(.coin)
                            .customScaleResize(widthScale: 0.08)
                            .rotationEffect(.degrees(rotationDegrees))
                            .offset(x: isMovingRight ? 0 : -100, y: 75) // Horizontal movement
                            .onAppear() {
                                withAnimation(Animation.easeInOut(duration: 8).repeatForever(autoreverses: true)) {
                                    rotationDegrees = 400
                                }
                                withAnimation(Animation.easeInOut(duration: 8).repeatForever(autoreverses: true)) {
                                    isMovingRight.toggle() // Move back and forth
                                }
                            }
                    }
                    
                    Spacer()
                    
                    NavigationLink {
                        SignInScreenView()
                    } label: {
                        Text("Sign In")
                            .foregroundStyle(Color(.customBackground))
                            .font(.title3.bold())
                            .padding()
                            .frame(width: 200, height: 50)
                            .background(Color.white)
                            .cornerRadius(25)
                    }
                }
                .opacity(contentOpacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 1.5)) {
                        contentOpacity = 1
                    }
                }
                
                Spacer().frame(height: 100)
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
