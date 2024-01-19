//
//  NumberTextFieldView.swift
//  PayMate
//
//  Created by Antony Bluemel on 1/18/24.
//

import SwiftUI
import PhoneNumberKit

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

struct NumberTextField: View {
    @Binding var inputText: String
    @Binding var isInputValid: Bool
    @Binding var errorMessage: ErrorType
    @Binding var isNumValid: Bool
    @Binding var formattedNumber: String
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Text("+1").foregroundStyle(.white)
                TextField("", text: $inputText, prompt: Text("(000) 000-0000").foregroundColor(.gray.opacity(0.5)))
                    .keyboardType(.numberPad)
                    .background(.clear)
                    .foregroundStyle(.white)
                    .font(.title3)
                    .frame(width: 150)
                    .onChange(of: inputText) {
                        isInputValid = validateInput(of: inputText)
                        inputText = PartialFormatter().formatPartial(inputText)
                        isNumValid = false
                    }
            }
            
            Spacer().frame(height: 8)
            
            Divider()
                .overlay(.white)
                .overlay(isInputValid ? .clear : .white)
                .opacity(isInputValid ? 0 : 1)
                .transition(.move(edge: .bottom))
            Spacer()
            
            if !inputText.isEmpty {
                Text(isNumValid ? inputText : errorMessage.localizedDescription)
                    .foregroundStyle(isNumValid ? .white : .yellow)
                    .font(.subheadline)
                    .transition(.move(edge: .bottom))
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
        errorMessage = ErrorType.null
        return true
    }
}
