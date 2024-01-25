//
//  getButton.swift
//  PayMate
//
//  Created by Antony Bluemel on 1/18/24.
//

import SwiftUI
import PhoneNumberKit

struct getOTPButton: View {
    @Binding var inputText: String
    @Binding var isInputValid: Bool
    @Binding var errorMessage: ErrorType
    @Binding var isNumValid: Bool
    @Binding var formattedNumber: String
    @State private var showAlert: Bool = false
    
    @FocusState.Binding var isTextFieldFocused: Bool
    
    let phoneNumberKit = PhoneNumberKit()
    
    var body: some View {
        Button(action: {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            do {
                let validatedPhoneNumber = try self.phoneNumberKit.parse(self.inputText)
                print("Validated Number: \(validatedPhoneNumber)")
                isTextFieldFocused = false
                isNumValid = true
                formattedNumber = formatToE164(phoneNumber: validatedPhoneNumber)
            }
            catch {
                isNumValid = false
                errorMessage = ErrorType.invalidNum
                showAlert = true
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
        .alert(isPresented: $showAlert) {
            Alert(title: Text(""),
                  message: Text(errorMessage.localizedDescription),
                  dismissButton: .default(Text("OK")))
        }
    }
    
    // Format number to E164 format
    private func formatToE164(phoneNumber: PhoneNumber, defaultRegion: String = "US") -> String {
        return phoneNumberKit.format(phoneNumber, toType: .e164)
    }
}
