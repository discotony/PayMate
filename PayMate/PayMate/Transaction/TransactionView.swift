//
//  TransactionView.swift
//  PayMate
//
//  Created by Antony Bluemel on 2/6/24.
//

import SwiftUI

struct TransactionView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userModel: UserModel
    @Binding var account: Account?
    @State private var transactionType: TransactionType = .none
    @State private var amount: String = ""
    @State private var destinationAccount: Account?
    @State private var showingAccountPicker = false
    @State private var isLoading = false
    
    var body: some View {
        VStack {
            Text("Choose Transaction Type")
                .font(.title3).bold()
                .foregroundStyle(.white)
            Spacer().frame(height: 16)
            
            // Amount Input Field
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .frame(maxWidth: .infinity)
                    .frame(height: 74)
                    .padding()
                    .foregroundStyle(.white.opacity(0.2))
                    .shadow(radius: 3)
                
                TextField("Enter Amount", text: $amount)
                    .background(.clear)
                    .foregroundStyle(.white)
                    .font(.title3)
                    .frame(width: 250, height: 74)
                    .padding()
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.center)
            }
            
            Spacer().frame(height: 8)
            
            // Transaction Type Selection Buttons
            HStack(spacing: 48) {
                TransactionButton(transactionType: .deposit, isSelected: transactionType == .deposit) {
                    transactionType = .deposit
                }
                TransactionButton(transactionType: .withdraw, isSelected: transactionType == .withdraw) {
                    transactionType = .withdraw
                }
                TransactionButton(transactionType: .transfer, isSelected: transactionType == .transfer) {
                    transactionType = .transfer
                }
            }
            
            // Conditional UI for Transfer
            if transactionType == .transfer {
                Button(action: { showingAccountPicker = true }) {
                    HStack {
                        Text(destinationAccount?.name ?? "Select Destination Account")
                            .foregroundStyle(.primary)
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
                }
                .sheet(isPresented: $showingAccountPicker) {
                    AccountPickerView(selectedAccount: $destinationAccount, accounts: userModel.currentUser?.accounts ?? [])
                }
            }
            
            // Confirm Transaction Button
            Button(action: {
                isLoading = true
                Task {
                    await performTransaction()
                    isLoading = false
                    presentationMode.wrappedValue.dismiss()
                }
            }) {
                Text("Confirm Transaction")
                    .bold()
                    .foregroundStyle(.customBackground)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(transactionType != .none && !amount.isEmpty && !(transactionType == .transfer && destinationAccount == nil) ? .white : .white.opacity(0.5))
                    .cornerRadius(12)
                    .padding()
            }
            .disabled(transactionType == .none || amount.isEmpty || (transactionType == .transfer && destinationAccount == nil))
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.customBackground)
        .overlay {
            if isLoading {
                ZStack {
                    Color.black.opacity(0.45)
                        .edgesIgnoringSafeArea(.all)
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(1.5)
                        .tint(.white)
                        .edgesIgnoringSafeArea(.all)
                }
            }
        }
    }
    
    func performTransaction() async {
        guard let account = account, let amountInt = Int(amount), amountInt > 0 else { return }
        
        switch transactionType {
        case .deposit:
            Task {
                await userModel.deposit(to: account, amount: amountInt)
            }
        case .withdraw:
            Task {
                await userModel.withdraw(from: account, amount: amountInt)
            }
        case .transfer:
            if let destinationAccount = destinationAccount {
                Task {
                    await userModel.transfer(from: account, to: destinationAccount, amount: amountInt)
                }
            }
        default: break
        }
        
        // After transaction completion, refresh user data if necessary
        await userModel.loadUser()
    }
}
