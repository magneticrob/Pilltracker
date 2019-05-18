//
//  Dose.swift
//  Pilltracker
//
//  Created by Rob Baker on 18/05/2019.
//  Copyright © 2019 Rob Baker. All rights reserved.
//

import Foundation

struct Dose: Codable {
    let id: UUID
    let doseTime: Date
    let expectedDoseTime: Date
    let missedDose: Bool
}
