//
//  UserState.swift
//
//

import Foundation
import SwiftUI

class UserManager: ObservableObject {
    @ObservedObject static var shared = UserManager()
    
    private let userIDKey = "userID"
    private let loggedInKey = "userLoggedIn"
    
    let userDefaults = UserDefaults.standard
    
    var userID: String
    
    @Published var isLoggedIn: Bool

    private init() {
        isLoggedIn = userDefaults.bool(forKey: loggedInKey)
        userID = userDefaults.string(forKey: userIDKey) ?? UUID().uuidString
        userDefaults.set(userID, forKey: userIDKey)
    }
    
    func checkLoginStatus() -> Bool {
        print("CLS: \(isLoggedIn)")
        return isLoggedIn
    }
    
    func login() {
        userDefaults.set(true, forKey: loggedInKey)
        isLoggedIn = true
        print("UM: \(userDefaults.bool(forKey: loggedInKey))")
    }
    
    func logout() {
        userDefaults.set(false, forKey: loggedInKey)
        isLoggedIn = false
        print("UM: \(userDefaults.bool(forKey: loggedInKey))")
    }
}
