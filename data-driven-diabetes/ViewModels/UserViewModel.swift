//
//  UserViewModel.swift
//  data-driven-diabetes
//
//  Created by Tyler Keller on 2/10/24.
//

import Foundation
import SwiftUI

class UserViewModel: ObservableObject {
    @ObservedObject var userManager = UserManager.shared
    private var LOG_TAG = "LOG: ViewModel"
    @Published var glucoseRecords: [GlucoseRecord] = []
    @Published var loading: Bool = false {
        didSet {
            if oldValue == false && loading == true {
                self.clear()
                self.refresh()
                loading = false
            }
        }
    }
    
    init() {
        self.getAllEGVs()
    }
    
    private let mDexcomService = DexcomService();
    
    func refresh() -> Void {
        self.getAllEGVs()
    }
    
    func clear() -> Void {
        DispatchQueue.main.async {
            self.glucoseRecords = []
        }
    }
    

    func getAllEGVs() {
        let userId = UUID().uuidString // Generate a unique ID for the user

        var lastValue = 100 // Starting value for glucose level

        // Calculate 1 month ago date
        let oneMonthAgo = Calendar.current.date(byAdding: .month, value: -1, to: Date())!

        // Date formatter for systemTime and displayTime
        let dateFormatter = ISO8601DateFormatter()

        // Iterate through each day from 1 month ago to today
        var currentDate = oneMonthAgo
        while currentDate <= Date() {
            var dayComponent = Calendar.current.dateComponents([.hour], from: currentDate)
            while dayComponent.hour ?? 0 < 24 {
                let recordId = UUID().uuidString
                let systemTime = dateFormatter.string(from: currentDate)
                let displayTime = systemTime // For simplicity, using systemTime. Adjust accordingly.

                // Adjust value by a random amount between 0 and 15, ensuring it does not go below 70 or above 180
                let change = Int.random(in: 0...15)
                lastValue += (Bool.random() ? change : -change) // Randomly increase or decrease
                lastValue = min(max(lastValue, 70), 180) // Ensure value is within bounds

                let record = GlucoseRecord(recordId: recordId, systemTime: systemTime, displayTime: displayTime, value: lastValue)
                self.glucoseRecords.append(record)
                print(record)

                // Increment current date by 5 minutes
                currentDate = Calendar.current.date(byAdding: .minute, value: 5, to: currentDate)!
                dayComponent = Calendar.current.dateComponents([.hour], from: currentDate)
            }
            print(currentDate)
            // Reset currentDate to start of next day to avoid infinite loop
            currentDate = Calendar.current.startOfDay(for: currentDate)
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        }
        print("Finished")
    }
    
    func connectToDexcom() {
        mDexcomService.connectToDexcomPressed()
    }
}
