//
//  UserViewModel.swift
//  data-driven-diabetes
//
//  Created by Tyler Keller on 2/10/24.
//

import Foundation
import FirebaseAnalytics
import FirebaseMessaging
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
    
    private let mDexcomService = DexcomService();
    
    init() {
        self.getAllEGVs()
    }
    
    func refresh() -> Void {
        self.getAllEGVs()
    }
    
    func clear() -> Void {
        DispatchQueue.main.async {
            self.glucoseRecords = []
        }
    }
    
    func getAllEGVs() {
        mDexcomService.fetchEGVs(startDate: "2022-02-06T09:12:35", endDate: "2022-02-06T09:12:35") { result in
            switch result {
            case .success(let egv):
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.glucoseRecords = egv.records;
                }
            case .failure(let error):
                //TODO handle error
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func connectToDexcom() {
    //        mDexcomService.connectToDexcomPressed() { result in
    //            switch result {
    //                case .success(let egv):
    //                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
    //                        self.glucoseRecords = egv.records;
    //                    }
    //                case .failure(let error):
    //                    //TODO handle error
    //                    print("Error: \(error.localizedDescription)")
    //                }
    //            }
    //        }
    }
}
