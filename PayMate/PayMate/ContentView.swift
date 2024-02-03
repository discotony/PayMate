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
            case .welcome:
                WelcomeView().id(UUID())
//            case .verification:
//                <#code#>
            case .home:
                HomeView()
//            case .loading:
//                <#code#>
            }
        }
    }
}
