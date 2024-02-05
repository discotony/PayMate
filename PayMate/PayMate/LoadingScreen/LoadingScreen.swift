//
//  LoadingScreen.swift
//  PayMate
//
//  Created by Antony Bluemel on 2/3/24.
//

import SwiftUI

struct LoadingScreen: View {
    @EnvironmentObject var userModel: UserModel
    @EnvironmentObject var viewRouter: ViewRouter
    @State private var errorString: String?
    @State private var navigateToView: Bool = false
    
    var body: some View {
        ZStack {
            Rectangle()
                .ignoresSafeArea()
                .foregroundStyle(Color.customBackground)
            VStack {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5)
                    .tint(.white)
                    .onAppear {
                        self.errorString = nil
                    }
                Spacer().frame(height: 32)
            }
            .onChange(of: errorString) { _, newValue in
                if let newValue = newValue {
                    print(newValue)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.opacity(0.45))
        }
        .task {
            await userModel.loadUser()
            DispatchQueue.main.async {
                if userModel.isUserLoaded {
                } else {
                    self.errorString = "Authentication token not found."
                }
                self.navigateToView = true
            }
        }
        .onChange(of: navigateToView) {
            if navigateToView {
                viewRouter.currentView = .home
            }
        }
    }
}

#Preview {
    LoadingScreen()
        .environmentObject(UserModel())
}
