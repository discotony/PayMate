//
//  ErrorType.swift
//  PayMate
//
//  Created by Antony Bluemel on 1/19/24.
//

enum ErrorType: Error {
    case invalidNum
    case numTooShortOrLong
    case startsWithOne
    case null
    case customError(message: String)
    
    var localizedDescription: String {
        switch self {
        case .numTooShortOrLong:
            return "Your number must be 10-digit long"
        case .invalidNum:
            return "Please enter a valid U.S. phone number"
        case .startsWithOne:
            return "Your number must not start with \"1\""
        case .null:
            return ""
        case .customError(let message):
            return message
        }
    }
}
