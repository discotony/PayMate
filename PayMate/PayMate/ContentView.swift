//
//  ContentView.swift
//  PayMate
//
//  Created by Antony Bluemel on 1/15/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View {
        Group {
            // Use combination of ViewRouter and NavigationStack to navigate between views.
            switch viewRouter.currentView {
            case .launchScreen:
                // Display the launch screen regardless of whether authToken is present or not.
                LaunchScreenView()
            case .loading:
                LoadingScreen()
            case .welcome:
                NavigationStack {
                    WelcomeView()
                }
            case .home:
                NavigationStack {
                    HomeView()
                }
            }
        }
    }
}
