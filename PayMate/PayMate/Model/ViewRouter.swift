//
//  ViewRouter.swift
//  PayMate
//
//  Created by Antony Bluemel on 2/3/24.
//

import Foundation

enum CurrentView {
    case launchScreen
    case loading
    case welcome
//    case verification
    case home
}

class ViewRouter: ObservableObject {
    @Published var currentView: CurrentView = .launchScreen
}
