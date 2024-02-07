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
    @State private var visuallySelectedAccount: Account? = nil
    let accounts: [Account]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                Spacer().frame(height: 36)
                Text("Select an Account for Balance Transfer")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding()
                    .multilineTextAlignment(.center)
                
                ForEach(accounts, id: \.self) { account in
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .frame(maxWidth: .infinity)
                            .frame(height: 74)
                            .foregroundStyle(account == visuallySelectedAccount ? .white : .white.opacity(0.2))
                            .shadow(radius: 3)
                        
                        HStack {
                            Text(account.name)
                                .foregroundColor(account == visuallySelectedAccount ? .customBackground : .white)
                                .font(.headline)
                                .fontWeight(.medium)
                            Spacer()
                            Text(account.balanceString())
                                .foregroundColor(account == visuallySelectedAccount ? .customBackground : .white)
                                .font(.headline)
                                .fontWeight(.regular)
                        }
                        .padding(.horizontal, 21)
                    }
                    .padding(.horizontal, 21)
                    .padding(.vertical, 6)
                    .onTapGesture {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        visuallySelectedAccount = account
                        selectedAccount = account
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .foregroundStyle(.white)
                    .shadow(radius: 3)
                
                Button {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Dimiss")
                        .foregroundStyle(Color.customBackground)
                        .fontWeight(.semibold)
                }
            }
            .foregroundColor(.customBackground)
            .padding()
            
            .padding(.top)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.customBackground)
    }
}

struct DragIndicator: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 5)
            .frame(width: 36, height: 5)
            .foregroundColor(Color.white)
            .padding(5)
    }
}
