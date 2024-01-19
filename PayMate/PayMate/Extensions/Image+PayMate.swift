//
//  Image+PayMate.swift
//  PayMate
//
//  Created by Antony Bluemel on 1/18/24.
//

import SwiftUI

extension Image {
    func customScaleResize(widthScale: Float) -> some View {
        
        let outputWidth = Float(UIScreen .main.bounds.size.width) * widthScale
        
        return self
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: CGFloat(outputWidth))
    }
    
    func customFixedResize(width: CGFloat? = nil, height: CGFloat? = nil) -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: width, height: height)
    }
}
