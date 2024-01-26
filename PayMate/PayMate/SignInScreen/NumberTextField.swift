//
//  NumberTextFieldView.swift
//  PayMate
//
//  Created by Antony Bluemel on 1/18/24.
//

import SwiftUI
import PhoneNumberKit

struct NumberTextField: View {
    @Binding var inputText: String
    @Binding var isInputValid: Bool
    @Binding var errorMessage: NumErrorType
    @Binding var isNumValid: Bool
    @Binding var e164Number: String
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Text("+1").foregroundStyle(.white)
                TextField("", text: $inputText.limit(14), prompt: Text("(000) 000-0000").foregroundColor(.gray.opacity(0.5)))
                    .keyboardType(.numberPad)
                    .background(.clear)
                    .foregroundStyle(.white)
                    .font(.title3)
                    .frame(width: 150)
                    .onChange(of: inputText) {
                        isInputValid = validateInput(of: inputText)
                        inputText = PartialFormatter().formatPartial(inputText)
                    }
            }
            
            Spacer().frame(height: 8)
            
            Divider()
                .overlay(.white)
                .transition(.move(edge: .bottom))
            Spacer()
            
            if !inputText.isEmpty {
                if !isInputValid {
                    Text(errorMessage.localizedDescription)
                        .foregroundStyle(isInputValid ? .white : .yellow)
                        .font(.subheadline)
                        .transition(.move(edge: .bottom))
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // Validate input after user clicks a button
    private func validateInput(of input: String) -> Bool {
        let charactersToRemove: Set<Character> = ["+", "(", ")", "-", " "]
        let filteredString = input.filter { !charactersToRemove.contains($0) }
        
        if filteredString.first == "1" {
            errorMessage = NumErrorType.startsWithOne
            return false
        } else if filteredString.count != 10 {
            errorMessage = NumErrorType.numTooShortOrLong
            return false
        }
        errorMessage = NumErrorType.null
        return true
    }
}
