//
//  WelcomeScreenView.swift
//  PayMate
//
//  Created by Antony Bluemel on 1/15/24.
//

import SwiftUI

struct WelcomeScreenView: View {
    
    @State private var isRotating = false
    
    var body: some View {
        VStack(spacing: nil) {
            Spacer().frame(height: 100)
            
            Image(.logoWithText)
                .customResize(width: 0.5)
            Spacer()
            
            Spacer().frame(height: 20)
            VStack {
                Image(.welcomeBackground)
                    .customResize(width: 0.8)
            }
            
            Spacer()
            
            Button(action: {
                        // Handle button tap
                    }) {
                        Text("Sign In")
                            .foregroundColor(.customBackground)
                            .font(.title3.bold())
                            .padding()
                            .frame(width: 200, height: 50)
                            .background(.white)
                            .cornerRadius(25)
                    }
            
            Spacer().frame(height: 100)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.customBackground)
    }
}

extension Image {
    func customResize(width: Float, usingScreen: Bool = true) -> some View {
        
        let outputWidth = usingScreen ? Float(UIScreen.main.bounds.size.width) * width : width
        
        return self
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: CGFloat(outputWidth))
    }
}

#Preview {
    WelcomeScreenView()
}
