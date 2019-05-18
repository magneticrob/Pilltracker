//
//  UserDefaultsFetcher.swift
//  Pilltracker
//
//  Created by Rob Baker on 18/05/2019.
//  Copyright © 2019 Rob Baker. All rights reserved.
//

import Foundation

class UserDefaultsFetcher {
    let userDefaults = UserDefaults.standard
    let dosagesKey = "dosages"
    let pillsKey = "dosages"
    
    func savedPills() -> [Pill]? {
        guard let pills = userDefaults.structArrayData(Pill.self, forKey: pillsKey) as? [Pill] else { return nil }
        return pills
    }
    
    func savedDose() -> [Dose]? {
        guard let dosages = userDefaults.structArrayData(Dose.self, forKey: pillsKey) as? [Dose] else { return nil }
        return dosages
    }
    
    func updatePills(_ pills: [Pill]) {
        userDefaults.setStructArray(pills, forKey: pillsKey)
    }
    
    func updateDoses(_ doses: [Dose]) {
        userDefaults.setStructArray(doses, forKey: dosagesKey)
    }
    
    func fetchPill(id: String) -> Pill? {
        guard let pills = savedPills() else { return nil }
        
        if let matchingPill = pills.first(where: {$0.id == id}) {
            return matchingPill
        }
        
        return nil
    }
    
    func fetchDose(id: String) -> Dose? {
        guard let doses = savedDose() else { return nil }
        
        if let matchingDose = doses.first(where: {$0.id == id}) {
            return matchingDose
        }
        
        return nil
    }
}
