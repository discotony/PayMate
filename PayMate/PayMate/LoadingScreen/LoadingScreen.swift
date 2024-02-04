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
    
    var body: some View {
        VStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(1.5)
                .tint(.white)
                .onAppear {
                    // Ensures the progress indicator is clearly visible.
                    self.errorString = nil
                }
            Spacer().frame(height: 32)
            if let errorString = errorString {
                Text(errorString)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(Color.black.opacity(0.45))
        .background(Color.customBackground)
        .navigationBarHidden(true)
        .task {
            await loadUserData()
        }
    }
    
    private func loadUserData() async {
        guard let authToken = userModel.authToken else {
            self.errorString = "Authentication token not found."
            return
        }
        
        await userModel.loadUser(with: authToken)
        
        DispatchQueue.main.async {
            if let _ = self.userModel.currentUser {
                // Successful user loading
                self.viewRouter.currentView = .home
            } else if let apiError = self.userModel.apiError {
                // Handling API errors by showing an appropriate error message
                self.errorString = apiError.message
            } else {
                // Handling other errors
                self.errorString = "An unexpected error occurred."
            }
        }
    }
}

#Preview {
    LoadingScreen()
        .environmentObject(UserModel())
}
