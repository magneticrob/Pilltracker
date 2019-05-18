//
//  TextViewTableViewCell.swift
//  Pilltracker
//
//  Created by Rob Baker on 18/05/2019.
//  Copyright © 2019 Rob Baker. All rights reserved.
//

import UIKit

class TextViewTableViewCell: UITableViewCell {

    @IBOutlet weak var textView: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
