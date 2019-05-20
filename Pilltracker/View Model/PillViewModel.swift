//
//  PillViewModel.swift
//  Pilltracker
//
//  Created by Rob Baker on 18/05/2019.
//  Copyright © 2019 Rob Baker. All rights reserved.
//

import Foundation

class PillViewModel {
    private var model: Pill
    
    init(model: Pill) {
        self.model = model
    }
    
    func name() -> String {
        return model.name
    }
    
    func strength() -> String {
        return "\(model.mg) mg"
    }
    
    func frequency() -> String {
        return "\(model.frequency) times a day"
    }
    
    func frequencyCount() -> String {
        return "\(model.frequency)"
    }
    
    func mg() -> String {
        return "\(model.mg)"
    }
    
    func times() -> String {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "HH:mm"
        
        var timesString = ""
        model.doseTimes = model.doseTimes.sorted()
        
        for date in model.doseTimes {
            timesString.append("\(dateFormatter.string(from: date)), ")
        }
        
        timesString = String(timesString.dropLast(2))
        
        return timesString
    }
    
    func nextDose() -> String {
        let now = Date.init()
        let referenceDate = Date.init(year: 0, month: 0, day: 0, hour: now.hour, minute: now.minute, second: now.second)
        var referenceDoses: [Date] = []
        for dose in model.doseTimes {
            let referenceDose = Date.init(year: 0, month: 0, day: 0, hour: dose.hour, minute: dose.minute, second: dose.second)
            
            if referenceDose.isLater(than: referenceDate) {
                referenceDoses.append(referenceDose)
            }
        }
        
        if referenceDoses.isEmpty, let firstDose = model.doseTimes.first {
            return "Next dose at \(firstDose.format(with: "HH:mm"))"
        }
        
        if let closest = referenceDoses.enumerated().min( by: { $0.1.timeIntervalSince(referenceDate) > $1.1.timeIntervalSince(referenceDate) } ) {
            return "Next dose at \(closest.element.format(with: "HH:mm"))"
        }
        
        return ""
    }
}
