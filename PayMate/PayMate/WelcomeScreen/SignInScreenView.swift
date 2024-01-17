//
//  LogInScreenView.swift
//  PayMate
//
//  Created by Antony Bluemel on 1/16/24.
//

import SwiftUI

struct SignInScreenView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @GestureState private var dragOffset = CGSize.zero
    
    var body: some View {
        
        let dragGesture = DragGesture()
            .updating($dragOffset, body: { (value, state, _) in
                state = value.translation
            })
            .onEnded {
                if $0.startLocation.x < 20 && $0.translation.width > 100 {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        
        return VStack {
            Spacer().frame(height: 100)
            
            VStack {
                
                Image(.OTP)
                    .customScaleResize(widthScale: 0.5)
                
                Spacer()
                
                Text("OTP Verification")
                    .multilineTextAlignment(.center)
                    .font(.title.bold())
                    .foregroundStyle(.white)
                
                Spacer().frame(height: 16)
                
                Text("We will send you one-time password (OTP) to your mobile number")
                    .multilineTextAlignment(.center)
                    .font(.callout)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 48)
                
                Spacer()
                
                Rectangle()
                    .fill(.white)
                    .opacity(0.3)
                    .cornerRadius(25)
                    .frame(width: 300, height: 100)
                
                Spacer()
                
                Button(action: {
                    
                }) {
                    Text("Get OTP")
                        .foregroundStyle(Color(.customBackground))
                        .font(.title3.bold())
                        .padding()
                        .frame(width: 200, height: 50)
                        .background(Color.white)
                        .cornerRadius(25)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.customBackground)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.left.circle.fill")
                        .font(.title)
                        .foregroundStyle(.white)
                }
            }
            ToolbarItem(placement: .principal) {
                NavigationLogo()
            }
        }
        .gesture(dragGesture)
    }
}


struct NavigationLogo: View {
    var body: some View {
        Image(.logoWithText)
            .customFixedResize(height: 32)
    }
}

#Preview {
    SignInScreenView()
}
