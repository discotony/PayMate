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
    @EnvironmentObject var viewRouter: ViewRouter
    @State private var newName: String = ""
    @State private var isLoading: Bool = false
    @State private var showPhoneNumberAlert: Bool = false
    @State private var showLogoutAlert: Bool = false
    @State private var alertMessage: String = ""
    @FocusState private var isNameFieldFocused: Bool
    
    private var oldName: String {
        userModel.currentUser?.name ?? ""
    }
    
    var body: some View {
        ZStack {
            Color.customBackground
                .edgesIgnoringSafeArea(.all)
            VStack {
                Spacer().frame(height: 16)
                Form {
                    Section(header: Text("Name")
                        .foregroundStyle(.white)) {
                            TextField("Enter your name", text: $newName)
                                .onAppear {
                                    newName = userModel.currentUser?.name ?? ""
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
                                    showPhoneNumberAlert = true
                                }
                        }
                        .listRowBackground(Color.white.opacity(0.2))
                    
                    // Insert the button here, within its own Section
                    Section {
                        Button(action: {
                            isNameFieldFocused = false
                            isLoading = true
                            Task {
                                await userModel.setUserName(with: newName)
                                DispatchQueue.main.async {
                                    isLoading = false
                                    self.presentationMode.wrappedValue.dismiss()
                                }
                            }
                        }) {
                            Text("Save")
                                .foregroundStyle(Color.customBackground)
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity, minHeight: 44, alignment: .center)
                                .background(newName == oldName ? .white.opacity(0.5) : .white)
                                .cornerRadius(10)
                        }
                        .disabled(newName == oldName || isLoading)
                        .animation(.easeInOut, value: newName == oldName)
                        .listRowInsets(EdgeInsets())
                    }
                    .listRowBackground(Color.clear)
                    Section {
                        Button(action: {
                            showLogoutAlert = true
                        }) {
                            Text("Log Out")
                                .foregroundStyle(Color.customBackground)
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity, minHeight: 44, alignment: .center)
                                .background(.white)
                                .cornerRadius(10)
                        }
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
        .alert("Oops!", isPresented: $showPhoneNumberAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
        .alert("", isPresented: $showLogoutAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Log Out", role: .destructive) {
                userModel.logout()
                viewRouter.currentView = .welcome
            }
        } message: {
            Text("Are you sure you want to log out?")
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
                        .font(.title3)
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
