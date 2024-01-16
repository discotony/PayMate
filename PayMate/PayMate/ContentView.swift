//
//  ContentView.swift
//  PayMate
//
//  Created by Antony Bluemel on 1/15/24.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var launchScreenManager: LaunchScreenManager
    
    var body: some View {
        VStack {
            Button("Tap Me") {
                print("Button Tapped")
            }
            Text("Hello World")
                .onAppear() {
                    DispatchQueue
                        .main
                        .asyncAfter(deadline: .now() + 3) {
                            launchScreenManager.dismiss()
                        }
                }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(LaunchScreenManager())
}
