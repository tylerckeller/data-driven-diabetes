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
        
        accessToken = userDefaults.string(forKey: accessTokenKey) ?? ""
        userDefaults.set(accessToken, forKey: accessTokenKey)
        
        refreshToken = userDefaults.string(forKey: refreshTokenKey) ?? ""
        userDefaults.set(refreshToken, forKey: refreshTokenKey)
        
        loggedIn = accessToken != "" && refreshToken != accessToken ? true : false
        userDefaults.set(loggedIn, forKey: loggedInKey)
        
    }
    
    func checkLoginStatus() -> Bool {
        return loggedIn
    }
    

    func login() {
        userDefaults.set(true, forKey: loggedInKey)
        isLoggedIn = true
        print("UM: \(userDefaults.bool(forKey: loggedInKey))")
    }
    
    func saveTokens(accessToken: String, refreshToken: String) {
        self.accessToken = accessToken
        userDefaults.set(accessToken, forKey: accessTokenKey)
        
        self.refreshToken = refreshToken
        userDefaults.set(refreshToken, forKey: refreshTokenKey)
    }
    
}
