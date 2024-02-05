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
    @State private var navigateToHome: Bool = false
    
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
                if userModel.isAuthenticated {
                    self.navigateToHome = true
                } else {
                    self.errorString = "Authentication token not found."
                    self.navigateToHome = false
                }
                self.navigateToView = true
            }
        }
        .onChange(of: navigateToView) {
            if navigateToView {
                if navigateToHome {
                    viewRouter.currentView = .home
                } else {
                    viewRouter.currentView = .welcome
                }
            }
        }
    }
}

#Preview {
    LoadingScreen()
        .environmentObject(UserModel())
}
