//
//  PhoneNumberTextFieldView.swift
//  PayMate
//
//  Created by Antony Bluemel on 1/16/24.
//

import SwiftUI
import PhoneNumberKit

struct PhoneNumberTextFieldView: UIViewRepresentable {
    
    @Binding var phoneNumber: String
    private let numberField = PhoneNumberTextField()
 
    func makeUIView(context: Context) -> PhoneNumberTextField {
        
        numberField.withFlag = true
        numberField.withPrefix = false
        numberField.numberPlaceholderColor = .white // NEED TO UPDATE
//        numberField.countryCodePlaceholderColor = .white.withAlphaComponent(0.5)
        
        numberField.withExamplePlaceholder = true
//        numberField.numberPlaceholderColor = .white.withAlphaComponent(0.9)
//        numberField.placeholder = "Enter your U.S. Phone number"
        
        numberField.textColor = .white
        numberField.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        
        numberField.becomeFirstResponder()
        return numberField
    }

    func getInputNumber() {
        self.phoneNumber = numberField.text!
    }
    
    func updateUIView(_ view: PhoneNumberTextField, context: Context) {
    
    }
}
