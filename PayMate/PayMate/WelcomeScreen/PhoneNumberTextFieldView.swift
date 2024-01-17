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
        numberField.withPrefix = true
        numberField.numberPlaceholderColor = .placeholderText // NEED TO UPDATE
        numberField.countryCodePlaceholderColor = .placeholderText
        
        numberField.withExamplePlaceholder = true
//        numberField.placeholder = "Enter your U.S. Phone number"
        
        numberField.textColor = .white
        numberField.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        
//        numberField.becomeFirstResponder()
        return numberField
    }

    func getInputNumber() {
        self.phoneNumber = numberField.text!
    }
    
    func updateUIView(_ view: PhoneNumberTextField, context: Context) {
    
    }
}
