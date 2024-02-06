//
//  UserModel.swift
//  PayMate
//
//  Created by Antony Bluemel on 1/30/24.
//

import Foundation

class UserModel: ObservableObject {
    @Published var currentUser: User?
    @Published var apiError: ApiError?
    private var authToken: String?
    
    var isAuthenticated: Bool = false
    var isUserLoaded: Bool = false
    
    func loadAuthToken() {
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            isAuthenticated = false
            return
        }
        authToken = token
        isAuthenticated = true
    }
    
    func saveAuthToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: "authToken")
        UserDefaults.standard.synchronize() // Ensure any changes made to UserDefaults were saved to disk immediately.
        authToken = token
    }
    
    func loadUser() async {
        guard let token = authToken else {
            self.isUserLoaded = false
            return
        }
        do {
            let userResponse = try await Api.shared.user(authToken: token)
            DispatchQueue.main.async {
                self.currentUser = userResponse.user
                self.isUserLoaded = true
            }
        } catch let error as ApiError {
            DispatchQueue.main.async {
                self.apiError = error
                self.isUserLoaded = false
            }
        } catch {
            // Handle other errors if applicable
        }
    }
    
    func setUserName(with name: String) async {
        guard let token = authToken else { return }
        do {
            let userResponse = try await Api.shared.setUserName(authToken: token, name: name)
            DispatchQueue.main.async {
                self.currentUser = userResponse.user
            }
        } catch let error as ApiError {
            DispatchQueue.main.async {
                self.apiError = error
            }
        } catch {
            // Handle other errors if applicable
        }
    }
    
    func logout() {
        // Clear the current user data and authentication token
        currentUser = nil
        authToken = nil
        UserDefaults.standard.removeObject(forKey: "authToken")
        UserDefaults.standard.synchronize()
    }
    
    func createAccount(with name: String) async {
        guard let token = authToken, !name.isEmpty else { return }
        do {
            let userResponse = try await Api.shared.createAccount(authToken: token, name: name)
            DispatchQueue.main.async {
                self.currentUser = userResponse.user
            }
        } catch let error as ApiError {
            DispatchQueue.main.async {
                self.apiError = error
            }
        } catch {
            // Handle other errors if applicable
        }
    }

}
