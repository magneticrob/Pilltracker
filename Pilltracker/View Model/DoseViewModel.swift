//
//  DoseViewModel.swift
//  Pilltracker
//
//  Created by Robert Baker on 26/12/2019.
//  Copyright © 2019 Rob Baker. All rights reserved.
//

import Foundation

class DoseViewModel {
    
    private var pillModel: Pill
    private var doseModel: Dose
    
    init(pillModel: Pill, doseModel: Dose) {
        self.doseModel = doseModel
        self.pillModel = pillModel
    }
    
    func friendlyDoseTitle() -> String {
        var doseTitle = ""
        if doseModel.doseTime.hour < 8 {
            doseTitle = "Early morning "
        } else if doseModel.doseTime.hour < 12 {
            doseTitle = "Morning "
        } else if doseModel.doseTime.hour < 17 {
            doseTitle = "Afternoon "
        } else if doseModel.doseTime.hour < 22 {
            doseTitle = "Evening "
        } else {
            doseTitle = "Late night "
        }
        
        doseTitle.append(pillModel.name)
        doseTitle.append(" dose.")
        
        return doseTitle
    }
}
