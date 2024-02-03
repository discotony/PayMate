//
//  ContentView.swift
//  PayMate
//
//  Created by Antony Bluemel on 1/15/24.
//

import SwiftUI

enum CurrentView {
    case launchScreen
    case welcome
//    case verification
//    case home
//    case loading
}

struct ContentView: View {
    @State private var currentView: CurrentView = .launchScreen
    
    var body: some View {
        Group {
            switch currentView {
            case .launchScreen:
                LaunchScreenView {
                    currentView = .welcome
                }
            case .welcome:
                WelcomeView()
//            case .verification:
//                <#code#>
//            case .home:
//                <#code#>
//            case .loading:
//                <#code#>
            }
        }
    }
}
