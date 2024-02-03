//
//  cardView.swift
//  PayMate
//
//  Created by Antony Bluemel on 2/3/24.
//

import SwiftUI

struct CreditCardView: View {
        var body: some View {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text("Royale Gold Card")
                        .font(.system(size: 20, weight: .semibold, design: .monospaced))
                    Spacer()
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40)
                        .clipped()
                        .cornerRadius(4)
                }
                
                VStack(spacing: 6) {
                    HStack {
                        Spacer()
                        Text("7438  3425  7894  5465")
                            .font(.system(size: 25, weight: .semibold, design: .rounded))
                        Spacer()
                    }
                    
                    HStack {
                        Text("Valid From: 01/22")
                            .font(.system(size: 12, weight: .medium))
                                            
                        Text("Valid Upto: 08/25")
                            .font(.system(size: 12, weight: .medium))
                    }
                }
                
                HStack {
                    Text("Antony Bluemel")
                        .font(.system(size: 12, weight: .medium))
                    Spacer()
                    Image("mastercard")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40)
                        .clipped()
                        .cornerRadius(4)
                }
            }
            .foregroundColor(.white)
            .padding()
            .background(.customBackground)
            .overlay(RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.black.opacity(0.5), lineWidth: 1)
            )
            .cornerRadius(12)
            .shadow(radius: 5)
            .padding(.horizontal)
            .padding(.top, 8)
        }
}

#Preview {
    CreditCardView()
}
