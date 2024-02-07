//
//  HomeView.swift
//  PayMate
//
//  Created by Antony Bluemel on 1/25/24.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @EnvironmentObject var userModel: UserModel
    @State private var isScrolled: Bool = false
    @State private var showSettingsView: Bool = false
    @State private var contentOpacity: Double = 0
    @State private var showCreateAccountAlert = false
    @State private var newAccountName = ""
    @State private var selectedAccount: Account?
    @State private var showTransactionView = false
    @State private var didCreateAccount = false
    @State private var newlyCreatedAccount: Account?
    @State private var isLoading = false
    
    var totalAssets: Double {
        userModel.currentUser?.accounts.reduce(0) { $0 + $1.balanceInUsd() } ?? 0
    }
    
    var name: String {
        userModel.currentUser?.name ?? ""
    }
    
    var body: some View {
        ScrollView {
            GeometryReader { geometry in
                Color.clear.preference(key: ViewOffsetKey.self, value: geometry.frame(in: .named("ScrollView")).minY)
            }
            .frame(height: 0)
            
            VStack() {
                ZStack {
                    Image("creditCard3")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .shadow(radius: 3)
                    Image("creditCard2")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .shadow(radius: 3)
                        .offset(CGSize(width: 0, height: 40))
                    Image("creditCard1")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .shadow(radius: 3)
                        .offset(CGSize(width: 0, height: 80))
                }
                Spacer().frame(height: 40)
                HStack {
                    Text(name)
                        .foregroundStyle(.white)
                        .font(.caption)
                        .offset(y: -16)
                    Spacer()
                }
                .padding(.horizontal, 40)
                Spacer().frame(height: 48)
                
                Text("Accounts Details")
                    .font(.title3).bold()
                    .foregroundColor(.white)
                Spacer().frame(height: 16)
                
                if let accounts = userModel.currentUser?.accounts, !accounts.isEmpty {
                    ForEach(accounts) { account in
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
                            self.selectedAccount = account
                            self.showTransactionView = true
                        }
                    }
                    .sheet(isPresented: $showTransactionView) {
                        TransactionView(account: $selectedAccount)
                    }
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .frame(maxWidth: .infinity)
                            .frame(height: 74)
                            .foregroundStyle(.white.opacity(0.2))
                            .shadow(radius: 3)
                        HStack {
                            Text("Total Assets: ")
                                .foregroundColor(.white)
                                .font(.headline)
                                .fontWeight(.medium)
                            Text("$\(totalAssets, specifier: "%.2f")")
                                .foregroundColor(.white)
                                .font(.headline)
                                .fontWeight(.regular)
                        }
                    }
                    .padding(.horizontal, 21)
                    .padding(.vertical, 6)
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .frame(maxWidth: .infinity)
                            .frame(height: 74)
                            .foregroundStyle(.white.opacity(0.2))
                            .shadow(radius: 3)
                        Text("No accounts created")
                            .foregroundColor(.white)
                            .font(.headline)
                            .fontWeight(.medium)
                    }
                    .padding(.horizontal, 21)
                    .padding(.vertical, 6)
                }
                Spacer()
            }
        }
        .opacity(contentOpacity)
        .onAppear {
            withAnimation(.easeIn(duration: 0.5)) {
                contentOpacity = 1
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.customBackground)
        .coordinateSpace(name: "ScrollView")
        .onPreferenceChange(ViewOffsetKey.self) { value in
            // Update isScrolled based on the scroll offset
            isScrolled = value < 0
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    showCreateAccountAlert = true
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }) {
                    if colorScheme == .light {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                            .foregroundStyle(isScrolled ? Color(hex: "055BFB") : .white)
                    } else {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                            .foregroundStyle(.white)
                    }
                }
            }
            ToolbarItem(placement: .principal) {
                if colorScheme == .light {
                    Image(isScrolled ? .logoWithTextDark : .logoWithText)
                        .customFixedResize(height: 32)
                } else {
                    Image(.logoWithText)
                        .customFixedResize(height: 32)
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    showSettingsView = true
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }) {
                    if colorScheme == .light {
                        Image(systemName: "person.crop.circle.fill")
                            .font(.title3)
                            .foregroundStyle(isScrolled ? Color(hex: "055BFB") : .white)
                    } else {
                        Image(systemName: "person.crop.circle.fill")
                            .font(.title3)
                            .foregroundStyle(.white)
                    }
                }
            }
        }.navigationDestination(isPresented: $showSettingsView) {
            SettingsView()
        }
        .alert("Create New Account", isPresented: $showCreateAccountAlert) {
            TextField("Account Name", text: $newAccountName)
                .textInputAutocapitalization(.never)
            Button("Cancel", role: .cancel) {
                newAccountName = ""
            }
            Button("Create") {
                isLoading = true
                Task {
                    await userModel.createAccount(with: newAccountName)
                    DispatchQueue.main.async {
                        newAccountName = ""
                        isLoading = false
                        didCreateAccount = true
                    }
                }
            }
//            .disabled(newAccountName.isEmpty)
        } message: {
            Text("Enter the name for the new account.")
        }
        .onChange(of: userModel.newAccount) { _, newAccount in
            if let newAccount = newAccount {
                self.newlyCreatedAccount = newAccount
                self.didCreateAccount = true
                self.userModel.newAccount = nil
            }
        }
        .sheet(isPresented: $didCreateAccount) {
            TransactionView(account: $newlyCreatedAccount)
        }
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
}

// Capture the scroll view's offset
struct ViewOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}

#Preview {
    HomeView()
        .environmentObject(UserModel())
}
