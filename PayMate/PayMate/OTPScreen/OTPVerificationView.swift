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
    @Binding  var e164Number: String
    @Binding var displayNumber: String
    @State private var isOPTValid: Bool = false
    @State private var showAlert: Bool = false
    @State private var errorMessage: String = ""
    @State private var isLoading: Bool = false
    @State private var isResent: Bool = false
    @State private var shouldShake: Bool = false
    private let isSmallDevice = UIScreen.main.bounds.height <= 736
    
    var body: some View {
        ZStack {
            VStack {
                SignInAnimationImage(isTextFieldFocused: $isTextFieldFocused)
                    .fixedSize()
                Spacer().frame(height: 36)
                
                Text("OTP Verification")
                    .multilineTextAlignment(.center)
                    .font(.title.bold())
                    .foregroundStyle(.white)
                Spacer().frame(height: 8)
                
                Text(isResent ? "OTP has been resent to \(displayNumber)" : "Enter the OTP sent to \(displayNumber)")
                    .multilineTextAlignment(.center)
                    .font(.callout)
                    .foregroundStyle(isResent ? .yellow : .white)
                    .padding(.horizontal, 32)
                    .frame(height: 60)
                    .offset(x: shouldShake ? CGFloat(sin(Double(3) * .pi / 2)) : 0)
                    .animation(shouldShake ? Animation.default.repeatCount(10).speed(20) : .default, value: shouldShake)
                    .onChange(of: shouldShake) { _, newValue in
                        if newValue {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                shouldShake = false
                            }
                        }
                    }

                
                Spacer().frame(height: 24)
                
                HStack {
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
                        .onChange(of: otpText) { _, otp in
                            if otp.count == 6 {
                                isTextFieldFocused = false
                                isLoading = true
                                Task {
                                    do {
                                        let _ = try await Api.shared.checkVerificationToken(e164PhoneNumber: e164Number, code: otp)
                                        isOPTValid = true
                                    } catch let error as ApiError {
                                        errorMessage = error.message
                                        showAlert = true
                                        otpText = ""
                                    }
                                    isLoading = false
                                    isTextFieldFocused = true
                                }
                            }
                        }
                })
                Spacer().frame(height: isSmallDevice && isTextFieldFocused ? 48: 24)
                
                HStack(spacing: 8) {
                    Text("Didn't receive OTP?")
                        .font(.caption)
                        .foregroundStyle(.white).opacity(0.8)
                    
                    Button(action: {
                        shouldShake = true
                        Task {
                            do {
                                let _ = try await Api.shared.sendVerificationToken(e164PhoneNumber: e164Number)
                                otpText = ""
                                isResent = true
                            } catch let error as ApiError {
                                print(error.message)
                            }
                        }
                    }, label: {
                        Text("Resend OTP")
                            .font(.caption).bold()
                            .foregroundStyle(.white)
                    })
                }
                Spacer().frame(height: 16)
            }
            .offset(y: isSmallDevice && isTextFieldFocused ? -100 : 0)
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
            .navigationDestination(isPresented: $isOPTValid) {
                HomeView()
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    self.isTextFieldFocused = true
                }
            }
            .onTapGesture {
                isTextFieldFocused.toggle()
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text(""),
                      message: Text(errorMessage),
                      dismissButton: .default(Text("OK")))
            }
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5)
                    .tint(.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.45))
                    .edgesIgnoringSafeArea(.all)
            }
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
