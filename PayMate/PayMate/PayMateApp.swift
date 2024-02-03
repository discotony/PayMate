//
//  PayMateApp.swift
//  PayMate
//
//  Created by Antony Bluemel on 1/15/24.
//

import SwiftUI

@main
struct PayMateApp: App {
    @StateObject private var viewRouter = ViewRouter()
    
    init() {
        Api.shared.appId = "QSQEo5xSmENL"
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewRouter)
        }
    }
}
