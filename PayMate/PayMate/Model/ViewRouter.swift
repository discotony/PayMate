//
//  ViewRouter.swift
//  PayMate
//
//  Created by Antony Bluemel on 2/3/24.
//

import Foundation

enum CurrentView {
    case launchScreen
    case welcome
//    case verification
    case home
//    case loading
}

class ViewRouter: ObservableObject {
    @Published var currentView: CurrentView = .launchScreen
}
