//
//  TransactionType.swift
//  PayMate
//
//  Created by Antony Bluemel on 2/6/24.
//

import SwiftUI

enum TransactionType {
    case deposit, withdraw, transfer, none
    
    var title: String {
        switch self {
        case .deposit:
            return "Deposit"
        case .withdraw:
            return "Withdraw"
        case .transfer:
            return "Transfer"
        case .none:
            return "None"
        }
    }
    
    var image: Image {
        switch self {
        case .deposit:
            return Image(.deposit)
        case .withdraw:
            return Image(.withdraw)
        case .transfer:
            return Image(.transfer)
        case .none:
            return Image(systemName: "questionmark")
        }
    }
}
