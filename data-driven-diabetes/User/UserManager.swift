//
//  UserState.swift
//
//

import Foundation
import SwiftUI

class UserManager: ObservableObject {
    @ObservedObject static var shared = UserManager()
    
    private let userIDKey = "userID"
    private let colorSchemeKey = "colorScheme"
    private let oauthTokenKey = "oauthToken"
    
    let userDefaults = UserDefaults.standard
    
    var userID: String
    @Published var oauthToken: String
    
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
        
        oauthToken = userDefaults.string(forKey: oauthTokenKey) ?? ""
        userDefaults.set(oauthToken, forKey: oauthTokenKey)
    }
    
    func checkLoginStatus() -> Bool {
        return oauthToken != ""
    }
    
    func setColorScheme(_ colorScheme: ColorScheme) {
        self.colorScheme = colorScheme
        userDefaults.set(colorScheme.rawValue, forKey: colorSchemeKey)
    }
    
    func setOAuthToken(_ oauthToken: String) {
        self.oauthToken = oauthToken
        userDefaults.set(oauthToken, forKey: oauthTokenKey)
    }
}
