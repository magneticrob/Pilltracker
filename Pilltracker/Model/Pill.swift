//
//  Pill.swift
//  Pilltracker
//
//  Created by Rob Baker on 18/05/2019.
//  Copyright © 2019 Rob Baker. All rights reserved.
//

import Foundation

struct Pill: Codable {
    let id: String
    let name: String
    let mg: Int
    let frequency: Int
    let doseTimes: [Date]
    
    func save() {
        let userDefaults = UserDefaultsFetcher.init()
        if var array = userDefaults.savedPills() {
            array.removeAll(where: {$0.id == id})
            array.append(self)
            userDefaults.updatePills(array)
        }
    }
}
