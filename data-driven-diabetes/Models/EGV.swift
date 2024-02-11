//
//  EGV.swift
//  data-driven-diabetes
//
//  Created by Tyler Keller on 2/10/24.
//

import Foundation

struct EGV: Codable, Identifiable {
    var id: String { userId }
//    var recordType: String
//    var recordVersion: String
    var userId: String
    var records: [ GlucoseRecord ]
}
