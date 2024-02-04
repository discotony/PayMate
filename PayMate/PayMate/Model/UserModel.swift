//
//  UserModel.swift
//  PayMate
//
//  Created by Antony Bluemel on 1/30/24.
//

import Foundation

class UserModel: ObservableObject {
    @Published var currentUser: User?
    @Published var apiError: ApiError? // Instances of ApiError representing specific error conditions(like a missing authentication token)
    //    @Published var didLoadUser = false
    
    var authToken: String?
    
    var isLoading: Bool {
        currentUser == nil && apiError == nil
    }
    
    var isAuthenticated: Bool {
        authToken != nil && currentUser != nil
    }
    
    init() {
        loadAuthToken()
    }
    
    func loadAuthToken() {
        authToken = UserDefaults.standard.string(forKey: "authToken")
        if let token = authToken {
            Task {
                await loadUser(with: token)
            }
        }
    }
    
    func saveAuthToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: "authToken")
        UserDefaults.standard.synchronize() // Ensure any changes made to UserDefaults were saved to disk immediately.
        authToken = token
    }
    
    func loadUser(with token: String) async {
        do {
            let userResponse = try await Api.shared.user(authToken: token)
            DispatchQueue.main.async {
                self.currentUser = userResponse.user
                //                self.didLoadUser = true
            }
        } catch let error as ApiError {
            DispatchQueue.main.async {
                self.apiError = error
                //                self.didLoadUser = false
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
}
