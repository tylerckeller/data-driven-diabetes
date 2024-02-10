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
    private let colorSchemeKey = "colorScheme"
    
    let userDefaults = UserDefaults.standard
    
    var userID: String
    
    @Published var isLoggedIn: Bool
    @Published var colorScheme: ColorScheme {
        didSet {
            userDefaults.set(colorScheme.rawValue, forKey: colorSchemeKey)
        }
    }

    private init() {
        isLoggedIn = userDefaults.bool(forKey: loggedInKey)
    
        let storedColorScheme = userDefaults.string(forKey: colorSchemeKey) ?? "dark"
        colorScheme = ColorScheme(rawValue: storedColorScheme) ?? .light
        userDefaults.set(storedColorScheme, forKey: colorSchemeKey)
    
        userID = userDefaults.string(forKey: userIDKey) ?? UUID().uuidString
        userDefaults.set(userID, forKey: userIDKey)
    }
    
    func checkLoginStatus() -> Bool {
        print("CLS: \(isLoggedIn)")
        return isLoggedIn
    }
    
    func setColorScheme(_ colorScheme: ColorScheme) {
        self.colorScheme = colorScheme
        userDefaults.set(colorScheme.rawValue, forKey: colorSchemeKey)
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
