//
//  PillViewModel.swift
//  Pilltracker
//
//  Created by Rob Baker on 18/05/2019.
//  Copyright © 2019 Rob Baker. All rights reserved.
//

import Foundation

class PillViewModel {
    private let model: Pill
    
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
    
    func times() -> String {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "HH:mm"
        var timesString = ""
        for date in model.doseTimes {
            timesString.append("\(dateFormatter.string(from: date)), ")
        }
        
        return timesString
    }
    
    func nextDose() -> String {
        return ""
    }
}
