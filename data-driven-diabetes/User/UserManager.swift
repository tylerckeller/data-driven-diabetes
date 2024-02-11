import Foundation
import SwiftUI

class UserManager: ObservableObject {
    @ObservedObject static var shared = UserManager()
    
    private let userIDKey = "userID"
    private let loggedInKey = "userLoggedIn"
    private let streakKey = "streak"
    private let percentArrayKey = "percentArray"
    
    let userDefaults = UserDefaults.standard
    
    var userID: String
    @Published var isLoggedIn: Bool
    @Published var streak: Int = 0
    @Published var percentArray: [Double] = []

    private init() {
        isLoggedIn = userDefaults.bool(forKey: loggedInKey)
        userID = userDefaults.string(forKey: userIDKey) ?? UUID().uuidString
        streak = userDefaults.integer(forKey: streakKey)
        percentArray = userDefaults.array(forKey: percentArrayKey) as? [Double] ?? []
    }
    
    func login() {
        userDefaults.set(true, forKey: loggedInKey)
        isLoggedIn = true
        print("UM: \(userDefaults.bool(forKey: loggedInKey))")
    }
    
    func saveStreak(streak: Int) {
        self.streak = streak
        userDefaults.set(streak, forKey: streakKey)
    }
    
    func savePercentArray(percentArray: [Double]) {
        self.percentArray = percentArray
        userDefaults.set(percentArray, forKey: percentArrayKey)
    }
}
