//
//  AccountPickerView.swift
//  PayMate
//
//  Created by Antony Bluemel on 2/6/24.
//

import SwiftUI

struct AccountPickerView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedAccount: Account?
    let accounts: [Account]
    
    var body: some View {
        //        VStack {
        ScrollView {
            VStack(spacing: 8) {
                Spacer().frame(height: 36)
                Text("Please choose an account you wish to transfer the balance to")
                    .font(.title3) // Adjust font size as needed
                    .fontWeight(.semibold)
                    .foregroundColor(.white) // Adjust color to fit your theme
                    .padding()
                    .multilineTextAlignment(.center)
                
                ForEach(accounts, id: \.self) { account in
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .frame(maxWidth: .infinity)
                            .frame(height: 74)
                            .foregroundStyle(.white.opacity(0.2))
                            .shadow(radius: 3)
                        
                        HStack {
                            Text(account.name)
                                .foregroundColor(.white)
                                .font(.headline)
                                .fontWeight(.medium)
                            Spacer()
                            Text(account.balanceString())
                                .foregroundColor(.white)
                                .font(.headline)
                                .fontWeight(.regular)
                        }
                        .padding(.horizontal, 21)
                    }
                    .padding(.horizontal, 21)
                    .padding(.vertical, 6)
                    .onTapGesture {
                        selectedAccount = account
                    }
                }
            }
            
            Button("Dismiss") {
                presentationMode.wrappedValue.dismiss()
            }
            .foregroundColor(.blue) // Adjust the color to fit your design
            .padding()
            
            .padding(.top)
        }
        //        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.customBackground)
    }
}
