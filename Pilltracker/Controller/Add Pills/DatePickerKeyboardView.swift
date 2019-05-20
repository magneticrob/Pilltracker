//
//  DatePickerKeyboardView.swift
//  Pilltracker
//
//  Created by Rob Baker on 18/05/2019.
//  Copyright © 2019 Rob Baker. All rights reserved.
//

import UIKit

class DatePickerKeyboardView: UIView {
    
    @IBOutlet weak var datePicker: DatePickerWithLabel!
    
    var changedBlock: (() -> Void)?
    var doneTapped: (() -> Void)?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func datePickerChanged(_ sender: Any) {
        if let changedBlock = changedBlock {
            changedBlock()
        }
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        if let doneTapped = doneTapped {
            doneTapped()
        }
    }
}
