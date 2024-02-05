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
            switch viewRouter.currentView {
            case .launchScreen:
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
