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
    @State private var contentOpacity: Double = 0
    
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
                    .opacity(contentOpacity)
                    .onAppear {
                        withAnimation(.easeIn(duration: 0.5)) {
                            contentOpacity = 1
                        }
                        self.errorString = nil
                    }
                    .onDisappear {
                        withAnimation(.easeIn(duration: 0.5)) {
                            contentOpacity = 0
                        }
                    }
                Spacer().frame(height: 32)
            }
            .onChange(of: errorString) { _, errorString in
                if let errorString = errorString {
                    print(errorString)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .task {
            await userModel.loadUser()
            DispatchQueue.main.async {
                if userModel.isUserLoaded {
                    self.navigateToView = true
                } else {
                    self.errorString = "Authentication token not found."
                }
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
