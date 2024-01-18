//
//  LogInScreenView.swift
//  PayMate
//
//  Created by Antony Bluemel on 1/16/24.
//

import SwiftUI
import PhoneNumberKit

struct SignInScreenView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @GestureState private var dragOffset = CGSize.zero
    @State private var rotationDegrees = 0.0        // NEED TO UPDATE
    @State private var rotationDegrees2 = 360.0     // NEED TO UPDATE
    @State private var swingAngle: Double = 5
    @State private var scale: CGFloat = 1.0
    
    let phoneNumberKit = PhoneNumberKit()
    @State private var phoneNumber = String()
    @State private var validationError = false
    @State private var errorMessage = Text("")
    @State private var numberField: PhoneNumberTextFieldView?
    
    var body: some View {
        
        let dragGesture = DragGesture()
            .updating($dragOffset, body: { (value, state, _) in
                state = value.translation
            })
            .onEnded {
                if $0.startLocation.x < 20 && $0.translation.width > 100 {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        
        return VStack {
            
            VStack {
                
                Spacer(minLength: 24)
                
                ZStack {
                    Image(.otpOuterCircle)
                        .customScaleResize(widthScale: 0.5)
                        .rotationEffect(.degrees(rotationDegrees))
                        .onAppear() {
                            withAnimation(Animation.linear(duration: 60).repeatForever(autoreverses: false)) {
                                rotationDegrees = 360
                            }
                        }
                    Image(.otpInnerCircle)
                        .customScaleResize(widthScale: 0.5)
                        .rotationEffect(.degrees(rotationDegrees2))
                        .onAppear() {
                            withAnimation(Animation.linear(duration: 60).repeatForever(autoreverses: false)) {
                                rotationDegrees2 = 0
                            }
                        }
                    Image(.otpHand)
                        .customScaleResize(widthScale: 0.5)
                        .rotationEffect(.degrees(swingAngle))
                        .scaleEffect(scale)
                        .onAppear() {
                            withAnimation(Animation.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                                swingAngle = -5
                                scale = 1.1
                            }
                        }
                }
                
                Spacer(minLength: 24)
                
                Text("OTP Verification")
                    .multilineTextAlignment(.center)
                    .font(.title.bold())
                    .foregroundStyle(.white)
                
                Spacer().frame(height: 8)
                
                Text("We will send you one-time password (OTP) to your mobile number")
                    .multilineTextAlignment(.center)
                    .font(.callout)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 48)
                
                Spacer()
                
                HStack {
                    Spacer()
                    self.numberField
                        .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/,
                               maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,
                               minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/,
                               maxHeight: 100,
                               alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .keyboardType(.phonePad)
                    Spacer()
                }
                .padding(.horizontal)
                .offset(x: 70)
//                    .multilineTextAlignment(.center)
//                .border(.red)
                
                Spacer()
                
                Button(action: {
                    do {
                        self.numberField?.getInputNumber()
                        print("Input Number: \(self.phoneNumber)")
                        let validatedPhoneNumber = try self.phoneNumberKit.parse(self.phoneNumber)
                        print("Validated Number: \(validatedPhoneNumber)")
                        // To Do
                    }
                    catch {
                        self.validationError = true
                        self.errorMessage = Text("Error: Please enter a valid phone number.")
                    }

                }) {
                    Text("Get OTP")
                        .foregroundStyle(Color(.customBackground))
                        .font(.title3.bold())
                        .padding()
                        .frame(width: 200, height: 50)
                        .background(Color.white)
                        .cornerRadius(25)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.customBackground)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
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
        .onAppear() {
            self.numberField = PhoneNumberTextFieldView(phoneNumber: self.$phoneNumber)
        }
        .alert(isPresented: self.$validationError) {
            Alert(title: Text(""), message: self.errorMessage, dismissButton: .default(Text("OK")))
        }
        .gesture(dragGesture)
    }
}


struct NavigationLogo: View {
    var body: some View {
        Image(.logoWithText)
            .customFixedResize(height: 32)
    }
}

#Preview {
    SignInScreenView()
}