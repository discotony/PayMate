//
//  SignInView.swift
//  PayMate
//
//  Created by Antony Bluemel on 1/18/24.
//

import SwiftUI
import PhoneNumberKit

struct SignInView: View {
    
    let phoneNumberKit = PhoneNumberKit()
    @State private var phoneNumber = String()
    @State private var validationError = false
    @State private var errorMessage = Text("")
    @State private var numberField: PhoneNumberTextFieldView?
    
    var body: some View {
        
        VStack {
            
            Text("OTP Verification")
                .multilineTextAlignment(.center)
                .font(.title.bold())
                .foregroundStyle(.white)
            
            
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
            
            NumberTextFieldView()

            
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
        
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.customBackground)
        .onAppear() {
            self.numberField = PhoneNumberTextFieldView(phoneNumber: self.$phoneNumber)
        }
        .alert(isPresented: self.$validationError) {
            Alert(title: Text(""), message: self.errorMessage, dismissButton: .default(Text("OK")))
        }
    }
    
    func formatToE164(phoneNumber: String, defaultRegion: String = "US") -> String? {
        let phoneNumberKit = PhoneNumberKit()
        do {
            let parsedNumber = try phoneNumberKit.parse(phoneNumber, withRegion: defaultRegion, ignoreType: true)
            return phoneNumberKit.format(parsedNumber, toType: .e164)
        } catch {
            print("Invalid phone number")
            return nil
        }
    }

}

#Preview {
    SignInScreenView()
}
