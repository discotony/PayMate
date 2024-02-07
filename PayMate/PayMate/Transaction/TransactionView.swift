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
    @State private var inputAmount: String = ""
    @State private var destinationAccount: Account?
    @State private var showAccountPicker = false
    @State private var isLoading = false
    @State private var showNegativeBalanceAlert = false
    @State private var contentOpacity: Double = 0
    @FocusState private var isTextFieldFocused: Bool
    @State private var showDeleteAccontAlert = false
    
    private let isSmallDevice = UIScreen.main.bounds.height <= 736
    
    @State private var projectedBalance: Double = 0
    
    private var formattedInputAmount: Binding<String> {
        Binding<String>(
            get: {
                "$\(self.inputAmount)"
            },
            set: { newValue in
                let numericValue = newValue.filter("0123456789.".contains)
                self.inputAmount = numericValue
            }
        )
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing:
                    isSmallDevice ? (transactionType == .transfer ? 8 : 24) :
                                    (transactionType == .transfer ? 24 : 32)) {
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
                }
                
                HStack(spacing: 48) {
                    TransactionButton(transactionType: .deposit, isSelected: transactionType == .deposit) {
                        transactionType = .deposit
                        contentOpacity = 0
                        updateProjectedBalance()
                    }
                    TransactionButton(transactionType: .withdraw, isSelected: transactionType == .withdraw) {
                        transactionType = .withdraw
                        contentOpacity = 0
                        updateProjectedBalance()
                    }
                    TransactionButton(transactionType: .transfer, isSelected: transactionType == .transfer) {
                        transactionType = .transfer
                        updateProjectedBalance()
                    }
                }
                
                // Conditional UI for Transfer
                if transactionType == .transfer {
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
                        VStack {
                            AccountPickerView(selectedAccount: $destinationAccount, accounts: userModel.currentUser?.accounts ?? [])
                        }
                    }
                }
                
                // Amount Input Field
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .foregroundStyle(.white.opacity(0.2))
                        .shadow(radius: 3)
                    
                    TextField("Enter Amount", text: formattedInputAmount)
                        .onChange(of: inputAmount) { _, enteredAmount in
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
                        showNegativeBalanceAlert = true
                        isLoading = false
                        inputAmount = ""
                    }
                }) {
                    Text("Confirm Transaction")
                        .bold()
                        .foregroundStyle(.customBackground)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(!inputAmount.isEmpty && !(transactionType == .transfer && destinationAccount == nil) ? .white : .white.opacity(0.5))
                        .cornerRadius(12)
                }
                .frame(height: 50)
                .disabled(inputAmount.isEmpty || (transactionType == .transfer && destinationAccount == nil))
                .alert(isPresented: $showNegativeBalanceAlert) {
                    Alert(title: Text("Oops!"),
                          message: Text("You cannot withdraw more than your balance."),
                          dismissButton: .default(Text("OK")))
                }
                .onAppear {
                    updateProjectedBalance()
                }
            }
                    .padding([.horizontal, .bottom])
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
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: {
                                presentationMode.wrappedValue.dismiss()
                                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            }) {
                                Image(systemName: "chevron.down.circle.fill")
                                    .font(.title3)
                                    .foregroundStyle(.white)
                            }
                        }
                        ToolbarItem(placement: .principal) {
                            Text(account?.name ?? "")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                showDeleteAccontAlert = true
                                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            }) {
                                Image(systemName: "trash.circle.fill")
                                    .font(.title3)
                                    .foregroundStyle(.white)
                            }
                        }
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .alert("", isPresented: $showDeleteAccontAlert) {
                        Button("Cancel", role: .cancel) { }
                        Button("Delete", role: .destructive) {
                            isLoading = true
                            Task {
                                guard let account = account else { return }
                                await userModel.deleteAccount(account: account)
                                DispatchQueue.main.async {
                                    presentationMode.wrappedValue.dismiss()
                                    isLoading = false
                                }
                            }
                        }
                    } message: {
                        Text("Are you sure you want to delete \(account?.name ?? "")?")
                    }
        }
    }
    
    private func updateProjectedBalance() {
        guard let currentBalance = account?.balanceInUsd() else { return }
        let enteredAmount = Double(inputAmount) ?? 0
        
        switch transactionType {
        case .deposit:
            projectedBalance = currentBalance + enteredAmount
        case .withdraw, .transfer:
            projectedBalance = currentBalance - enteredAmount
        }
    }
    
    private func performTransaction() async {
        guard let account = account, let amountInt = Int(inputAmount), amountInt > 0 else { return }
        
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
        
        // After transaction completion, reload user data
        await userModel.loadUser()
    }
}

#Preview {
    TransactionView(account: .constant(UserModel().currentUser?.accounts.first))
}
