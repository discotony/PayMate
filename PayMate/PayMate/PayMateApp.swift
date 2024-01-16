//
//  PayMateApp.swift
//  PayMate
//
//  Created by Antony Bluemel on 1/15/24.
//

import SwiftUI

@main
struct PayMateApp: App {
    
    @StateObject var launchScreenManager = LaunchScreenManager()
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()
                
                if launchScreenManager.state != .completed {
                    LaunchScreenView()
                }
            }
            .environmentObject(launchScreenManager)
        }
    }
}
