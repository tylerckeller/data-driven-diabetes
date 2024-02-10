//
//  UserState.swift
//
//

import Foundation
import SwiftUI

class UserManager: ObservableObject {
    @ObservedObject static var shared = UserManager()
    
    private let userIDKey = "userID"
    private let accessTokenKey = "accessToken"
    private let refreshTokenKey = "refreshToken"
    private let loggedInKey = "loggedIn"
    private let colorSchemeKey = "colorScheme"
    
    let userDefaults = UserDefaults.standard
    
    var userID: String
    
    var accessToken: String
    var refreshToken: String
    
    @Published var loggedIn: Bool
    
    @Published var colorScheme: ColorScheme {
        didSet {
            userDefaults.set(colorScheme.rawValue, forKey: colorSchemeKey)
        }
    }

    private init() {
        let storedColorScheme = userDefaults.string(forKey: colorSchemeKey) ?? "dark"
        colorScheme = ColorScheme(rawValue: storedColorScheme) ?? .dark
        userDefaults.set(storedColorScheme, forKey: colorSchemeKey)
        
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
    
    func setColorScheme(_ colorScheme: ColorScheme) {
        self.colorScheme = colorScheme
        userDefaults.set(colorScheme.rawValue, forKey: colorSchemeKey)
    }
    
    func setLoggedIn(_ loggedIn: Bool) {
        self.loggedIn = loggedIn
        userDefaults.set(loggedIn, forKey: loggedInKey)
    }
    
    func saveTokens(accessToken: String, refreshToken: String) {
        self.accessToken = accessToken
        userDefaults.set(accessToken, forKey: accessTokenKey)
        
        self.refreshToken = refreshToken
        userDefaults.set(refreshToken, forKey: refreshTokenKey)
    }
    
}
