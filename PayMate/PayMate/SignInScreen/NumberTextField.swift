//
//  NumberTextFieldView.swift
//  PayMate
//
//  Created by Antony Bluemel on 1/18/24.
//

import SwiftUI
import PhoneNumberKit

enum ErrorType: Error {
    case inValidNum
    case numTooShortOrLong
    case startsWithOne
    case customError(message: String)
    
    var localizedDescription: String {
        switch self {
        case .numTooShortOrLong:
            return "Your number must be 10-digit long."
        case .inValidNum:
            return "Please enter a valid U.S. phone number"
        case .startsWithOne:
            return "Your number must not start with \"1\""
        case .customError(let message):
            return message
        }
    }
}

struct NumberTextField: View {
    
    @Binding var inputText: String
    @Binding var isInputValid: Bool
    @Binding var errorMessage: ErrorType
    
    var body: some View {
        VStack {
            HStack {
                Text("+1").foregroundStyle(.white)
                TextField("Enter Somethiing", text: $inputText)
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                    .onChange(of: inputText) {
                        isInputValid = validateInput(of: inputText)
                        inputText = PartialFormatter().formatPartial(inputText)
                    }
            }
            
            Text(isInputValid ? "" : errorMessage.localizedDescription)
                .foregroundStyle(.white.opacity(0.8))
                .font(.subheadline)
            
//            Spacer(minLength: 24)            
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.customBackground)
        .animation(.easeInOut, value: isInputValid)
    }
    
    private func validateInput(of input: String) -> Bool {
        let charactersToRemove: Set<Character> = ["+", "(", ")", "-", " "]
        let filteredString = input.filter { !charactersToRemove.contains($0) }
        
        if filteredString.first == "1" {
            errorMessage = ErrorType.startsWithOne
            return false
        } else if filteredString.count != 10 {
            errorMessage = ErrorType.numTooShortOrLong
            return false
        }
        return true
    }
}

//#Preview {
//    NumberTextField()
//}
