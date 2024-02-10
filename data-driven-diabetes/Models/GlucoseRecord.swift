//
//  GlucoseRecord.swift
//  data-driven-diabetes
//
//  Created by Tyler Keller on 2/10/24.
//

import Foundation

struct GlucoseRecord: Codable, Identifiable {
    var id: String { recordId }
    
    var recordId: String
    // datetime
    var systemTime: String
    // datetime
    var displayTime: String
    var transmitterId: String
    var transmitterTicks: Int64
    var value: Int
    var trend: String
    var trendRate: Int
    var unit: String
    var rateUnit: String
    var displayDevice: String
    var transmitterGeneration: String
}

