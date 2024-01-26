//
//  ErrorType.swift
//  PayMate
//
//  Created by Antony Bluemel on 1/19/24.
//

enum NumErrorType: Error {
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
    
    static func ==(lhs: NumErrorType, rhs: NumErrorType) -> Bool {
        switch (lhs, rhs) {
        case (.invalidNum, .invalidNum),
            (.numTooShortOrLong, .numTooShortOrLong),
            (.startsWithOne, .startsWithOne),
            (.null, .null):
            return true
        case (.customError(let a), .customError(let b)):
            return a == b
        default:
            return false
        }
    }
}
