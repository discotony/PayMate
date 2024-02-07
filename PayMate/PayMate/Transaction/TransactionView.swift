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
    @State private var transactionType: TransactionType = .deposit
    @State private var amount: String = ""
    @State private var destinationAccount: Account?
    @State private var showAccountPicker = false
    @State private var isLoading = false
    @State private var showAlert = false
    @State private var contentOpacity: Double = 0
    @FocusState private var isTextFieldFocused: Bool
    
    // Display the balance before the transaction
    private var initialBalance: Double {
        guard let account = account else { return 0 }
        return account.balanceInUsd()
    }
    
    @State private var projectedBalance: Double = 0
    
//    let currencyFormatter: NumberFormatter = {
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .currency
//        formatter.maximumFractionDigits = 2
//        return formatter
//    }()
    
    var body: some View {
        VStack(spacing: transactionType == .transfer ? 12 : 16) {
            if let account = account {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .frame(maxWidth: .infinity)
                        .frame(height: 80)
                        .foregroundStyle(.white.opacity(0.2))
                        .shadow(radius: 3)
                    VStack(spacing: 8) {
                        HStack {
                            Text("Current Balance:")
                                .foregroundColor(.white)
                                .font(.headline)
                                .fontWeight(.medium)
                            Text(account.balanceString())
                                .foregroundColor(.white)
                                .font(.headline)
                                .fontWeight(.regular)
                        }
                        HStack {
                            Text("Projected Balance:")
                                .foregroundColor(.white)
                                .font(.headline)
                                .fontWeight(.medium)
                            Text("$\(String(format: "%.2f", projectedBalance))")
                                .foregroundColor(.white)
                                .font(.headline)
                                .fontWeight(.regular)
                        }
                    }
                }
//                .padding()
            }
//            Spacer().frame(height: )
            
            // Transaction Type Selection Buttons
            HStack(spacing: 48) {
                TransactionButton(transactionType: .deposit, isSelected: transactionType == .deposit) {
                    transactionType = .deposit
                    updateProjectedBalance()
                }
                TransactionButton(transactionType: .withdraw, isSelected: transactionType == .withdraw) {
                    transactionType = .withdraw
                    updateProjectedBalance()
                }
                TransactionButton(transactionType: .transfer, isSelected: transactionType == .transfer) {
                    transactionType = .transfer
                    updateProjectedBalance()
                }
            }
            
            // Conditional UI for Transfer
            if transactionType == .transfer {
                Spacer().frame(height: 4)
                HStack {
                    Text("Transfer to ")
                        .font(.headline)
                        .foregroundStyle(.white)
                    Button(action: { showAccountPicker = true }) {
                        HStack {
                            Text(destinationAccount?.name ?? "Select Destination")
                                .font(.subheadline)
                                .foregroundStyle(.white)
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.white.opacity(0.8))
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 12).stroke(.white.opacity(0.8), lineWidth: 1))
                    }
                }
                .opacity(contentOpacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 0.5)) {
                        contentOpacity = 1
                    }
                }
                .sheet(isPresented: $showAccountPicker) {
                    AccountPickerView(selectedAccount: $destinationAccount, accounts: userModel.currentUser?.accounts ?? [])
                }
            }
            
            // Amount Input Field
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .foregroundStyle(.white.opacity(0.2))
                    .shadow(radius: 3)
                
//                TextField("Enter Amount", value: $amount, formatter: NumberFormatter().numberStyle = .currency)
                TextField("Enter Amount", text: $amount)
                    .onChange(of: amount) { _, enteredAmount in
                        updateProjectedBalance()
                    }
                    .background(.clear)
                    .foregroundStyle(.white)
                    .font(.headline)
                    .fontWeight(.regular)
                    .frame(height: 50)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.center)
                    .focused($isTextFieldFocused)
            }
//            .padding()
            
            // Confirm Transaction Button
            Button(action: {
                isLoading = true
                if projectedBalance >= 0 {
                    Task {
                        await performTransaction()
                        isLoading = false
                        presentationMode.wrappedValue.dismiss()
                    }
                } else {
                    showAlert = true
                    isLoading = false
                    amount = ""
                }
            }) {
                Text("Confirm Transaction")
                    .bold()
                    .foregroundStyle(.customBackground)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(!amount.isEmpty && !(transactionType == .transfer && destinationAccount == nil) ? .white : .white.opacity(0.5))
                    .cornerRadius(12)
//                    .padding()
            }
            .frame(height: 50)
            .disabled(amount.isEmpty || (transactionType == .transfer && destinationAccount == nil))
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Oops!"),
                      message: Text("You cannot withdraw more than your balance."),
                      dismissButton: .default(Text("OK")))
            }
            .onAppear {
                updateProjectedBalance()
            }
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
        .onAppear {
            isTextFieldFocused = true
        }
    }
    
    private func updateProjectedBalance() {
        guard let initialBalance = account?.balanceInUsd() else { return }
        let enteredAmount = Double(amount) ?? 0

        switch transactionType {
        case .deposit:
            projectedBalance = initialBalance + enteredAmount
        case .withdraw, .transfer:
            projectedBalance = initialBalance - enteredAmount
        }
    }
    
    private func performTransaction() async {
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
        }
        
        // After transaction completion, refresh user data if necessary
        await userModel.loadUser()
    }
}

#Preview {
    TransactionView(account: .constant(UserModel().currentUser?.accounts.first))
}
