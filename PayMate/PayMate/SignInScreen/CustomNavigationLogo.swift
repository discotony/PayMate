//
//  CustomNavigationTitleView.swift
//  PayMate
//
//  Created by Antony Bluemel on 2/3/24.
//

import SwiftUI

struct CustomNavigationLogo: View {
    var body: some View {
        Image(.logoWithText)
            .customFixedResize(height: 32)
    }
}

struct customHomeNavigationTitle: View {
    var body: some View {
        Image(.yourAccounts)
            .customFixedResize(height: 32)
    }
}
