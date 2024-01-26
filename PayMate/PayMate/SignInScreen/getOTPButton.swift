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
    @Binding var errorMessage: NumErrorType
    @Binding var isNumValid: Bool
    @Binding var e164Number: String
    @State private var showAlert: Bool = false
    @State private var isOTPSent: Bool = false
    
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
                e164Number = formatToE164(phoneNumber: validatedPhoneNumber)
                
                Task {
                    do {
                        let _ = try await Api.shared.sendVerificationToken(e164PhoneNumber: e164Number)
                        isOTPSent = true
                        print("OTP Sent!")
                    } catch let error as ApiError {
                        print(error.message)
                    }
                }
            }
            catch {
                isNumValid = false
                errorMessage = NumErrorType.invalidNum
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
