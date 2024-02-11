//
//  UserViewModel.swift
//  data-driven-diabetes
//
//  Created by Tyler Keller on 2/10/24.
//

import Foundation
import SwiftUI
import GameplayKit

class UserViewModel: ObservableObject {
    @ObservedObject var userManager = UserManager.shared
    private var LOG_TAG = "LOG: ViewModel"
    @Published var glucoseRecords: [GlucoseRecord] = []
    
    private let mDexcomService = DexcomService();
    
    func clear() -> Void {
        DispatchQueue.main.async {
            self.glucoseRecords = []
        }
    }
    

    func getAllEGVs() {
        var lastValue = 100 // Starting value for glucose level

        // Calculate 3 months ago date
        guard let threeMonthAgo = Calendar.current.date(byAdding: .month, value: -3, to: Date()) else { return }

        // Date formatter for systemTime and displayTime
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.timeZone = TimeZone.current // Set the time zone to current

        // Iterate through each day from 3 months ago to today
        var currentDate = threeMonthAgo
        let endDate = Date() // Capture the end date to avoid processing beyond today.
        let random = GKRandomSource()
        let changeFunc = GKGaussianDistribution(randomSource: random, lowestValue: -15, highestValue: 15)
        while currentDate <= endDate {
            for hour in 0..<24 {
                for minute in stride(from: 0, to: 60, by: 5) {
                    let recordId = UUID().uuidString
                    let systemTime = dateFormatter.string(from: currentDate.addingTimeInterval(TimeInterval(hour * 3600 + minute * 60)))
                    let displayTime = systemTime // For simplicity, using systemTime. Adjust accordingly.

                    // Adjust value by a random amount between 0 and 15, ensuring it does not go below 70 or above 180
                    let change = changeFunc.nextInt()
                    lastValue += change
                    lastValue = min(max(lastValue, 70), 180) // Ensure value is within bounds

                    let record = GlucoseRecord(recordId: recordId, systemTime: systemTime, displayTime: displayTime, value: lastValue)
                    self.glucoseRecords.append(record)
                }
            }
            print(currentDate)
            // Increment currentDate by 1 day
            guard let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) else { break }
            currentDate = nextDay
        }
        print("Finished")
    }
    
    func connectToDexcom() {
        mDexcomService.connectToDexcomPressed()
    }
}
