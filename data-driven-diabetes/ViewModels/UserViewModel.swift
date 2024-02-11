//
//  UserViewModel.swift
//  data-driven-diabetes
//
//  Created by Tyler Keller on 2/10/24.
//

import Foundation
import SwiftUI
import GameplayKit

struct Goal {
    var inRange: Float
    var average: Int
}

class UserViewModel: ObservableObject {
    @ObservedObject var userManager = UserManager.shared
    private var LOG_TAG = "LOG: ViewModel"
    @Published var glucoseRecords: [GlucoseRecord] = []
    @Published var high = 180
    @Published var low = 70
    @Published var name = ""
    @Published var currentDate: Date = Date()
    @Published var streak = 0

    var goalDict: [String: Goal] = [:]
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
        let changeFunc = GKGaussianDistribution(randomSource: random, lowestValue: -10, highestValue: 10)
        while currentDate <= endDate {
            for hour in 0..<24 {
                for minute in stride(from: 0, to: 60, by: 5) {
                    let recordId = UUID().uuidString
                    let systemTime = dateFormatter.string(from: currentDate.addingTimeInterval(TimeInterval(hour * 3600 + minute * 60)))
                    let displayTime = systemTime // For simplicity, using systemTime. Adjust accordingly.

                    // Adjust value by a random amount between 0 and 15, ensuring it does not go below 70 or above 180
                    let change = changeFunc.nextInt()
                    lastValue += change
                    lastValue = min(max(lastValue, 50), 250) // Ensure value is within bounds

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
    
    func preprocessGoalValues() {
        let uniqueDays = Array(Set(glucoseRecords.map { $0.displayTime.prefix(10) })) // Extract unique days from glucoseRecords
        var streakBroken = false
        for day in uniqueDays.reversed() {
            let dayRecords = glucoseRecords.filter { $0.displayTime.hasPrefix(day) } // Filter records for the specific day
            let inRangeCount = dayRecords.filter { $0.value >= low && $0.value <= high }.count
            let inRangePercentage = Double(inRangeCount) / Double(dayRecords.count) * 100
            let averageValue = dayRecords.reduce(0, { $0 + $1.value }) / dayRecords.count
            if inRangePercentage >= 70 && averageValue >= 70 && averageValue <= 180 && !streakBroken {
                streak += 1
            } else {
                streakBroken = true
            }
            print("Date: \(day), In Range Percentage: \(inRangePercentage)%, Average Value: \(averageValue)")
        }
    }
    
    func getCurrentDateData() -> [GlucoseRecord] {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return glucoseRecords.filter { $0.displayTime.hasPrefix(dateFormatter.string(from: currentDate)) }
    }
    
    func getSpecificDayData(for day: Date) -> [GlucoseRecord] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dayString = dateFormatter.string(from: day)
        return glucoseRecords.filter { $0.displayTime.hasPrefix(dayString) }
    }
    
    func moveDate(by days: Int) {
        if let newDate = Calendar.current.date(byAdding: .day, value: days, to: currentDate) {
            currentDate = newDate
            // Here, you would also trigger fetching of data for the new currentDate,
            // or the view depending on this will automatically update if it observes this property.
        }
    }
    func getCurrentDateInRangePercentage() -> Double {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDayRecords = glucoseRecords.filter { $0.displayTime.hasPrefix(dateFormatter.string(from: currentDate)) }
        let inRangeCount = currentDayRecords.filter { $0.value >= low && $0.value <= high }.count
        print(inRangeCount)
        let inRangePercentage = Double(inRangeCount) / Double(currentDayRecords.count) * 100
        print(inRangePercentage)
        return inRangePercentage
    }
    
    func getCurrentDateAverageGlucoseValue() -> Double {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDayRecords = glucoseRecords.filter { $0.displayTime.hasPrefix(dateFormatter.string(from: currentDate)) }
        let sumOfValues = currentDayRecords.reduce(0.0, { $0 + Double($1.value) })
        let averageValue = sumOfValues / Double(currentDayRecords.count)
        return averageValue
    }
    
    func connectToDexcom() {
        mDexcomService.connectToDexcomPressed()
    }
    
    func getLast30DaysInRangePercentage(glucoseRecords: [GlucoseRecord]) -> [Double] {
        var percentages = [Double]()
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        for dayOffset in 0..<30 {
            guard let date = calendar.date(byAdding: .day, value: -dayOffset, to: Date()) else { continue }
            let dateString = dateFormatter.string(from: date)
            let currentDayRecords = glucoseRecords.filter { $0.displayTime.hasPrefix(dateString) }
            if currentDayRecords.count > 0 {
                let inRangeCount = currentDayRecords.filter { $0.value >= low && $0.value <= high }.count
                let inRangePercentage = Double(inRangeCount) / Double(currentDayRecords.count) * 100
                percentages.append(inRangePercentage)
            } else {
                percentages.append(0) // or skip appending if you prefer not to include days without records
            }
        }
        return percentages.reversed() // Reverse to have the oldest day first, if needed
    }

}
