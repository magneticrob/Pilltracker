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
    let name: String
    let mg: Int
    let frequency: Int
    let doseTimes: [Date]
}
