//
//  Dose.swift
//  Pilltracker
//
//  Created by Rob Baker on 18/05/2019.
//  Copyright © 2019 Rob Baker. All rights reserved.
//

import Foundation

struct Dose: Codable {
    let id: String
    let doseTime: Date
    let expectedDoseTime: Date
    let missedDose: Bool
    
    func save() {
        let userDefaults = UserDefaultsFetcher.init()
        if var array = userDefaults.savedDose() {
            array.removeAll(where: {$0.id == id})
            array.append(self)
            userDefaults.updateDoses(array)
        }
    }
}
