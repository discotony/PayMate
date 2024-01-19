//
//  NumberTextFieldView.swift
//  PayMate
//
//  Created by Antony Bluemel on 1/18/24.
//

import SwiftUI
import PhoneNumberKit

struct NumberTextFieldView: View {
    
    @State private var inputText: String = ""
    @State private var isInputValid: Bool = false
    
    enum errorType: Error {
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
    
    @State private var errorMessage: errorType = errorType.numTooShortOrLong
    
    let phoneNumberKit = PhoneNumberKit()
    
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
                .font(.callout)
            
            Button(action: {
                do {
                    
                    let phoneNumber = try phoneNumberKit.parse(inputText)
                    let phoneNumberCustomDefaultRegion = try phoneNumberKit.parse(inputText, withRegion: "US", ignoreType: true)
                }
                catch {
                    errorMessage = errorType.inValidNum
                }
            }) {
                Text("Get OTP")
                    .foregroundStyle(isInputValid ? .customBackground : .white)
                    .font(.title3.bold())
                    .padding()
                    .frame(width: 200, height: 50)
                    .background(isInputValid ? .white : .gray.opacity(0.5))
                    .cornerRadius(25)
            }
            .disabled(!isInputValid)
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
            errorMessage = errorType.startsWithOne
            return false
        } else if filteredString.count != 10 {
            errorMessage = errorType.numTooShortOrLong
            return false
        }
        return true
    }
}

#Preview {
    NumberTextFieldView()
}
