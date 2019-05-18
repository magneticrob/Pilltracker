//
//  PillTableViewCell.swift
//  Pilltracker
//
//  Created by Rob Baker on 18/05/2019.
//  Copyright © 2019 Rob Baker. All rights reserved.
//

import UIKit

class PillTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var strengthLabel: UILabel!
    @IBOutlet weak var frequencyLabel: UILabel!
    @IBOutlet weak var timesLabel: UILabel!
    @IBOutlet weak var nextDoseLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func update(pill: Pill) {
        let viewModel = PillViewModel.init(model: pill)
        nameLabel.text = viewModel.name()
        strengthLabel.text = viewModel.strength()
        frequencyLabel.text = viewModel.frequency()
        timesLabel.text = viewModel.times()
        nextDoseLabel.text = viewModel.nextDose()
    }
}
