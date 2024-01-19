//
//  getButton.swift
//  PayMate
//
//  Created by Antony Bluemel on 1/18/24.
//

import SwiftUI
import PhoneNumberKit

struct getOtpButton: View {
    @Binding var inputText: String
    @Binding var isInputValid: Bool
    @Binding var errorMessage: ErrorType
    
    let phoneNumberKit = PhoneNumberKit()
    
    var body: some View {
        Button(action: {
            do {
                let validatedPhoneNumber = try self.phoneNumberKit.parse(self.inputText)
                print("Validated Number: \(validatedPhoneNumber)")
                isInputValid = true
                // To Do
                
            }
            catch {
                isInputValid = false
                errorMessage = ErrorType.inValidNum
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
}

//#Preview {
//    getButton()
//}
