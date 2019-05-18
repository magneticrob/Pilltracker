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
    
    func savedPills() -> [Pill] {
        return userDefaults.structArrayData(Pill.self, forKey: pillsKey)
    }
    
    func savedDoses() -> [Dose] {
        return userDefaults.structArrayData(Dose.self, forKey: dosagesKey)
    }
    
    func updatePills(_ pills: [Pill]) {
        userDefaults.setStructArray(pills, forKey: pillsKey)
    }
    
    func updateDoses(_ doses: [Dose]) {
        userDefaults.setStructArray(doses, forKey: dosagesKey)
    }
    
    func fetchPill(id: UUID) -> Pill? {
        let pills = savedPills()
        if let matchingPill = pills.first(where: {$0.id == id}) {
            return matchingPill
        }
        
        return nil
    }
    
    func fetchDose(id: UUID) -> Dose? {
        let doses = savedDoses()
        if let matchingDose = doses.first(where: {$0.id == id}) {
            return matchingDose
        }
        
        return nil
    }
    
    func saveOrUpdate(dose: Dose) {
        var doses = savedDoses()
        
        if let dose = fetchDose(id: dose.id) {
            doses.removeAll(where: {$0.id == dose.id})
            doses.append(dose)
        } else {
            doses.append(dose)
        }
        
        updateDoses(doses)
    }
    
    func saveOrUpdate(pill: Pill) {
        var pills = savedPills()
        
        if let index = pills.firstIndex(where: {$0.id == pill.id}) {
            pills.remove(at: index)
            pills.insert(pill, at: index)
        } else {
            pills.append(pill)
        }
        
        updatePills(pills)
    }
}
