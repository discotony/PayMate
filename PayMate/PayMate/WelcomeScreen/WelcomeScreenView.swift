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
                Spacer().frame(height: 100)
                
                VStack {
                    Image(.logoWithText)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: UIScreen.main.bounds.size.width * 0.5)
                    
                    Spacer()
                    
                    WelcomeTextView()
                    
                    Spacer().frame(height: 32)
                    
                    Image(.welcomeBackground)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: UIScreen.main.bounds.size.width * 0.8)
                    
                    Spacer()
                    
                    NavigationLink {
                        SignInScreenView()
                    } label: {
                        Text("Sign In")
                            .foregroundStyle(Color(.customBackground)) // Ensure this color is defined
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
