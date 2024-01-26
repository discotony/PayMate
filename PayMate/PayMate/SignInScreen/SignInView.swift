//
//  LogInScreenView.swift
//  PayMate
//
//  Created by Antony Bluemel on 1/16/24.
//

import SwiftUI
import PhoneNumberKit

struct SignInView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var inputText: String = ""
    @State private var isInputValid: Bool = false
    @State private var errorMessage: NumErrorType = NumErrorType.numTooShortOrLong
    @State private var isNumValid: Bool = false
    @State private var e164Number: String = ""
    
    private let instructions: [String] = ["We will send you one-time password (OTP) to your mobile number",
                                          "Please enter your U.S. phone number below"]
    @State private var instructionIndex: Int = 0
    @State private var timer: Timer?
    
    @FocusState private var isTextFieldFocused: Bool

    let phoneNumberKit = PhoneNumberKit()
    
    var body: some View {
        VStack {
            SignInAnimationImage(isTextFieldFocused: $isTextFieldFocused)
            Spacer().frame(height: 36)
            
            Text("OTP Verification")
                .multilineTextAlignment(.center)
                .font(.title.bold())
                .foregroundStyle(.white)
            Spacer().frame(height: 8)
            
            Text(instructions[instructionIndex])
                .multilineTextAlignment(.center)
                .font(.callout)
                .foregroundStyle(.white)
                .padding(.horizontal, 32)
                .frame(height: 60)
                .onAppear() {
                    timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
                        withAnimation {
                            instructionIndex = (instructionIndex + 1) % instructions.count
                        }
                    }
                }
                .onDisappear() {
                    timer?.invalidate()
                    timer = nil
                }
            Spacer().frame(height: 24)
            
            NumberTextField(inputText: $inputText,
                            isInputValid: $isInputValid,
                            errorMessage: $errorMessage,
                            isNumValid: $isNumValid,
                            e164Number: $e164Number)
            .fixedSize()
            .focused($isTextFieldFocused)
            Spacer().frame(height: 24)
            
            getOTPButton(inputText: $inputText, 
                         isInputValid: $isInputValid,
                         errorMessage: $errorMessage,
                         isNumValid: $isNumValid,
                         e164Number: $e164Number,
                         isTextFieldFocused: $isTextFieldFocused)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.customBackground)
        .navigationBarBackButtonHidden(true)
        .onTapGesture {
            isTextFieldFocused = false
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }) {
                    Image(systemName: "arrow.left.circle.fill")
                        .font(.title)
                        .foregroundStyle(.white)
                }
            }
            ToolbarItem(placement: .principal) {
                NavigationLogo()
            }
        }
        .animation(.easeInOut, value: inputText.isEmpty)
        .animation(.easeInOut, value: isInputValid)
        .navigationDestination(isPresented: $isNumValid) {
            OTPVerificationView(e164Number: $e164Number, displayNumber: $inputText)
        }
    }
    
    // Validate text field input as user types
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
        return true
    }
}

struct NavigationLogo: View {
    var body: some View {
        Image(.logoWithText)
            .customFixedResize(height: 32)
    }
}
