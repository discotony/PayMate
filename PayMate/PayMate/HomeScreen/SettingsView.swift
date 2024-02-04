//
//  SettingsView.swift
//  PayMate
//
//  Created by Antony Bluemel on 2/3/24.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userModel: UserModel
    @State private var userName: String = ""
    @State private var isLoading = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @FocusState private var isNameFieldFocused: Bool
    
    var body: some View {
        ZStack {
            Color.customBackground
                .edgesIgnoringSafeArea(.all)
            VStack {
                Spacer().frame(height: 16)
                Form {
                    Section(header: Text("Name")
                        .foregroundStyle(.white)) {
                            TextField("Enter your name", text: $userName)
                                .onAppear {
                                    userName = userModel.currentUser?.name ?? ""
                                }
                                .foregroundStyle(.white)
                                .focused($isNameFieldFocused)
                        }
                        .listRowBackground(Color.white.opacity(0.2))
                    
                    Section(header: Text("Phone Number")
                        .foregroundStyle(.white)) {
                            Text(userModel.currentUser?.e164PhoneNumber ?? "N/A")
                                .foregroundColor(.white)
                                .onTapGesture {
                                    alertMessage = "Phone number cannot be changed."
                                    showAlert = true
                                }
                        }
                        .listRowBackground(Color.white.opacity(0.2))
                    
                    // Insert the button here, within its own Section
                    Section {
                        Button(action: {
                            isNameFieldFocused = false
                            isLoading = true
                            Task {
                                await userModel.setUserName(with: userName)
                                DispatchQueue.main.async {
                                    isLoading = false
                                    self.presentationMode.wrappedValue.dismiss()
                                }
                            }
                        }) {
                            Text("SAVE")
                                .foregroundStyle(Color.customBackground)
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity, minHeight: 44, alignment: .center)
                                .background(.white)
                                .cornerRadius(10)
                        }
                        .disabled(userName.isEmpty || isLoading)
                        .listRowInsets(EdgeInsets())
                    }
                    .listRowBackground(Color.clear)
                }
            }
            
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5)
                    .tint(.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.45))
                    .edgesIgnoringSafeArea(.all)
            }
        }
        .alert("Oops!", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
        .scrollContentBackground(.hidden)
        .navigationTitle("Settings")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                // Custom back button navigation bar item
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }) {
                    Image(systemName: "arrow.left.circle.fill")
                        .font(.title)
                        .foregroundStyle(.white)
                }
            }
            ToolbarItem(placement: .principal) {
                Text("User Settings")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(UserModel())
}
