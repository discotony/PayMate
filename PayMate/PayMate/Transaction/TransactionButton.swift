//
//  TransactionButton.swift
//  PayMate
//
//  Created by Antony Bluemel on 2/6/24.
//

import SwiftUI

struct TransactionButton: View {
    var transactionType: TransactionType
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                transactionType.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .padding(10)
                    .background(isSelected ? Color.white : Color.white.opacity(0.2))
                    .clipShape(Circle())
                
                Text(transactionType.title)
                    .foregroundStyle(.white)
                    .font(.caption)
            }
            .padding(.vertical, 4)
        }
    }
}
