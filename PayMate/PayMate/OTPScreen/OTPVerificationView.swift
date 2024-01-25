//
//  OTPVerificationView.swift
//  PayMate
//
//  Created by Antony Bluemel on 1/24/24.
//

import SwiftUI

struct OTPVerificationView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var otpText: String = ""
    @FocusState private var isTextFieldFocused: Bool
    @State private var isOTPValid: Bool = false
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<6, id: \.self) { index in
                OTPTextBox(index)
            }
        }
        .padding(.leading, 24)
        .padding(.trailing, 24)
        .background(content: {
            TextField("", text: $otpText.limit(6))
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode)
                .opacity(0)
                .blendMode(.screen)
                .focused($isTextFieldFocused)
        })
        .onTapGesture {
            isTextFieldFocused.toggle()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.customBackground)
        .navigationBarBackButtonHidden(true)
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
        .navigationDestination(isPresented: $isOTPValid) {
            HomeView()
        }
    }
    
    @ViewBuilder
    func OTPTextBox(_ index: Int) -> some View {
        ZStack {
            if otpText.count > index {
                let startIndex = otpText.startIndex
                let charIndex = otpText.index(startIndex, offsetBy: index)
                let charToString = String(otpText[charIndex])
                Text(charToString)
                    .foregroundStyle(.white)
                    .font(.title3)
            } else {
                Text(" ")
            }
        }
        .frame(width: 50, height: 50)
        .background {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .foregroundStyle(.white.opacity(0.2))
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: Binding Extension for <String> Type
extension Binding where Value == String {
    func limit(_ length: Int) -> Self {
        if self.wrappedValue.count > length {
            DispatchQueue.main.async {
                self.wrappedValue = String(self.wrappedValue.prefix(length))
            }
        }
        return self
    }
}

#Preview {
    OTPVerificationView()
}
