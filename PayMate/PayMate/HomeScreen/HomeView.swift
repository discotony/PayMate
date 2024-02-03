//
//  HomeView.swift
//  PayMate
//
//  Created by Antony Bluemel on 1/25/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    var body: some View {
        VStack {
            Text("This is Home View")
                .font(.title).bold()
                .foregroundStyle(.white)
            Button("Back to Welcome") {
                print("Attempting to change view to .welcome")
                viewRouter.currentView = .welcome
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.customBackground)
        .navigationBarBackButtonHidden(true)
        
    }
}

#Preview {
    HomeView()
}
