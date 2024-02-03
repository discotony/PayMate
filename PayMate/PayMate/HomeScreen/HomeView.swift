//
//  HomeView.swift
//  PayMate
//
//  Created by Antony Bluemel on 1/25/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var userModel: UserModel
    
    var body: some View {
        VStack {
            ZStack {
                Image("creditCard3")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .shadow(radius: 3)
                Image("creditCard2")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .shadow(radius: 3)
                    .offset(CGSize(width: 0, height: 40))
                Image("creditCard1")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .shadow(radius: 3)
                    .offset(CGSize(width: 0, height: 80))
            }
            Spacer().frame(height: 40)
            HStack {
                Text("Antony Bluemel")
                    .foregroundStyle(.white)
                    .font(.caption)
                Spacer()
            }
            .padding(.horizontal, 40)
            Spacer().frame(height: 16)
            
            ZStack(alignment: .center) {
                RoundedRectangle(cornerRadius: 12)
                    .frame(maxWidth: .infinity)
                    .frame(height: 64)
                    .padding(.vertical)
                    .padding(.horizontal, 21)
                    .foregroundStyle(.white.opacity(0.2))
                    .shadow(radius: 3)
                Text("Total Assets: $1,000")
                    .foregroundStyle(.white)
                    .font(.subheadline)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.customBackground)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                CustomNavigationLogo()
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }) {
                    Image(systemName: "person.crop.circle")
                        .font(.title3)
                        .foregroundStyle(.white)
                }
            }
        }
        
    }
}

#Preview {
    HomeView()
}
