//
//  HomeView.swift
//  PayMate
//
//  Created by Antony Bluemel on 1/25/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            Text("This is Home View")
                .font(.title)
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.customBackground)
//        .navigationBarBackButtonHidden(true)
        
    }
}

#Preview {
    HomeView()
}