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
        VStack {
            Spacer().frame(height: 100)

            VStack {
                Image(.logoWithText)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIScreen.main.bounds.size.width * 0.5)

                Spacer()

                Image(.welcomeBackground)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIScreen.main.bounds.size.width * 0.8)

                Spacer()

                Button(action: {
                    // Handle button tap
                }) {
                    Text("Sign In")
                        .foregroundColor(Color(.customBackground)) // Ensure this color is defined
                        .font(.title3.bold())
                        .padding()
                        .frame(width: 200, height: 50)
                        .background(Color.white)
                        .cornerRadius(25)
                }
            }
            .opacity(contentOpacity)
            .onAppear {
                withAnimation(.easeIn(duration: 1.0)) {
                    contentOpacity = 1
                }
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
