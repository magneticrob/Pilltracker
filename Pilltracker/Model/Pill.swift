//
//  Pill.swift
//  Pilltracker
//
//  Created by Rob Baker on 18/05/2019.
//  Copyright © 2019 Rob Baker. All rights reserved.
//

import Foundation

struct Pill: Codable {
    let id: UUID
    var name: String
    var mg: Int
    var frequency: Int
    var doseTimes: [Date]
}
