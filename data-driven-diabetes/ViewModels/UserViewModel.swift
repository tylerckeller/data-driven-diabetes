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
        let recordType = "Glucose"
        let recordVersion = "1.0"
        
        var records: [GlucoseRecord] = []
        var lastValue = 100 // Starting value for glucose level
        
        // Calculate 3 months ago date
        let oneMonthsAgo = Calendar.current.date(byAdding: .month, value: -1, to: Date())!
        
        // Date formatter for systemTime and displayTime
        let dateFormatter = ISO8601DateFormatter()
        
        // Iterate through each day from 3 months ago to today
        var currentDate = oneMonthsAgo
        while currentDate <= Date() {
            // For each day, create records every 5 minutes
            var dayComponent = DateComponents()
            while dayComponent.hour ?? 0 < 24 {
                let recordId = UUID().uuidString
                let systemTime = dateFormatter.string(from: currentDate)
                let displayTime = systemTime // For simplicity, using systemTime. Adjust accordingly.
                let transmitterId = "Transmitter123"
                let transmitterTicks = Int64(currentDate.timeIntervalSince1970)
                
                // Adjust value by a random amount between 0 and 15, ensuring it does not go below 70 or above 180
                let change = Int.random(in: 0...15)
                lastValue += (Bool.random() ? change : -change) // Randomly increase or decrease
                if lastValue < 70 { lastValue = 70 }
                if lastValue > 180 { lastValue = 180 }
                
                let trend = "Flat" // Simplified for this example
                let trendRate = 0 // Simplified for this example
                let unit = "mg/dL"
                let rateUnit = "mg/dL/h"
                let displayDevice = "ExampleDevice"
                let transmitterGeneration = "G6"
                
                let record = GlucoseRecord(recordId: recordId, systemTime: systemTime, displayTime: displayTime, transmitterId: transmitterId, transmitterTicks: transmitterTicks, value: lastValue, trend: trend, trendRate: trendRate, unit: unit, rateUnit: rateUnit, displayDevice: displayDevice, transmitterGeneration: transmitterGeneration)
                records.append(record)
                
                // Increment current date by 5 minutes
                currentDate = Calendar.current.date(byAdding: .minute, value: 5, to: currentDate)!
                dayComponent = Calendar.current.dateComponents([.hour], from: currentDate)
            }
            // Reset currentDate to start of next day to avoid infinite loop
            currentDate = Calendar.current.startOfDay(for: currentDate)
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        DispatchQueue.main.async {
            self.glucoseRecords = EGV(recordType: recordType, recordVersion: recordVersion, userId: userId, records: records).records
        }
    }

    func connectToDexcom() {
        mDexcomService.connectToDexcomPressed()
    }
}
