//
//  TransactionView.swift
//  PayMate
//
//  Created by Antony Bluemel on 2/6/24.
//

import SwiftUI

enum TransactionType {
    case deposit, withdraw, transfer, none
}

struct TransactionView: View {
    @EnvironmentObject var userModel: UserModel
    @Binding var account: Account?
    @State private var transactionType: TransactionType = .none
    @State private var amount: String = ""
    @State private var destinationAccount: Account?
    @State private var showingAccountPicker = false

    var body: some View {
        VStack {
            // Transaction Type Selection Buttons
            HStack(spacing: 20) {
                TransactionTypeButton(title: "Deposit", isSelected: transactionType == .deposit) {
                    transactionType = .deposit
                }
                TransactionTypeButton(title: "Withdraw", isSelected: transactionType == .withdraw) {
                    transactionType = .withdraw
                }
                TransactionTypeButton(title: "Transfer", isSelected: transactionType == .transfer) {
                    transactionType = .transfer
                }
            }
            .padding(.top, 20)

            // Amount Input Field
            TextField("Enter Amount", text: $amount)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)
                .padding()

            // Conditional UI for Transfer
            if transactionType == .transfer {
                Button(action: { showingAccountPicker = true }) {
                    HStack {
                        Text(destinationAccount?.name ?? "Select Destination Account")
                            .foregroundColor(.primary)
                        Image(systemName: "chevron.right")
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
                }
                .sheet(isPresented: $showingAccountPicker) {
                    AccountPickerView(selectedAccount: $destinationAccount, accounts: userModel.currentUser?.accounts ?? [])
                }
            }

            // Confirm Transaction Button
            Button(action: performTransaction) {
                Text("Confirm Transaction")
                    .bold()
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(transactionType != .none && !amount.isEmpty && !(transactionType == .transfer && destinationAccount == nil) ? Color.blue : Color.gray)
                    .cornerRadius(10)
                    .padding()
            }
            .disabled(transactionType == .none || amount.isEmpty || (transactionType == .transfer && destinationAccount == nil))
        }
        .navigationTitle("Perform Transaction")
        .padding()
        .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
    }
    
    func performTransaction() {
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
    }
}

struct TransactionTypeButton: View {
    let title: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(isSelected ? .white : .blue)
                .padding()
                .frame(width: 100, height: 50)
                .background(isSelected ? Color.blue : Color.clear)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.blue, lineWidth: 2)
                )
        }
    }
}

struct AccountPickerView: View {
    @Binding var selectedAccount: Account?
    let accounts: [Account]

    var body: some View {
        List(accounts, id: \.self) { account in
            Button(account.name) {
                selectedAccount = account
            }
        }
    }
}
