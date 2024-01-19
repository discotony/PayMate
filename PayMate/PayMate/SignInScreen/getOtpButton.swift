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
    @Binding var isNumValid: Bool
    @Binding var formattedNumber: String
    
    let phoneNumberKit = PhoneNumberKit()
    
    var body: some View {
        Button(action: {
            do {
                let validatedPhoneNumber = try self.phoneNumberKit.parse(self.inputText)
                print("Validated Number: \(validatedPhoneNumber)")
                isNumValid = true
                formattedNumber = formatToE164(phoneNumber: validatedPhoneNumber)
                // To Do for HW 2
                
            }
            catch {
                isNumValid = false
                errorMessage = ErrorType.invalidNum
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
        .alert(isPresented: self.$isNumValid) {
            Alert(title: Text(""), message: Text("OTP sent to \(self.inputText) \n E.164 Format: \(formattedNumber)"), dismissButton: .default(Text("OK")))
        }
    }
    
    private func formatToE164(phoneNumber: PhoneNumber, defaultRegion: String = "US") -> String {
        return phoneNumberKit.format(phoneNumber, toType: .e164)
    }
}

//#Preview {
//    getButton()
//}
