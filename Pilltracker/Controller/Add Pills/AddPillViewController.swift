//
//  AddPillViewController.swift
//  Pilltracker
//
//  Created by Rob Baker on 18/05/2019.
//  Copyright © 2019 Rob Baker. All rights reserved.
//

import UIKit

protocol AddPillViewControllerDelegate: class {
    func addPillViewControllerExited()
}

class AddPillViewController: UIViewController {
    
    enum AddPillViewControllerRows: Int {
        case Name
        case Mg
        case Frequency
        case DoseTimes
    }

    @IBOutlet weak var tableView: UITableView!
    weak var delegate: AddPillViewControllerDelegate?
    var pillNameField: UITextField?
    var pillMgField: UITextField?
    var pillFrequencyField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    @IBAction func tappedCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tappedSave(_ sender: Any) {
        
        guard let pillNameField = self.pillNameField, let pillMgField = self.pillMgField, let frequencyField = self.pillFrequencyField else {
            return
        }
        
        guard let pillName = pillNameField.text,
            let pillMgText = pillMgField.text,
            let pillMg = Int(pillMgText),
            let frequencyText = frequencyField.text,
            let frequency = Int(frequencyText) else {
            return
        }
        
        let pill = Pill.init(id: UUID.init(), name: pillName, mg: pillMg, frequency: frequency, doseTimes: [])
        UserDefaultsFetcher.init().saveOrUpdate(pill: pill)
        self.delegate?.addPillViewControllerExited()
        self.dismiss(animated: true, completion: nil)
    }
}

extension AddPillViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TextViewTableViewCell", for: indexPath) as? TextViewTableViewCell, let row = AddPillViewControllerRows.init(rawValue: indexPath.row) else {
            return UITableViewCell.init()
        }
        
        if row == .Name {
            cell.textView.placeholder = "Name"
            self.pillNameField = cell.textView
        } else if row == .Mg {
            cell.textView.placeholder = "mg"
            cell.textView.keyboardType = .numberPad
            self.pillMgField = cell.textView
        } else if row == .Frequency {
            cell.textView.placeholder = "Frequency (times a day)"
            cell.textView.keyboardType = .numberPad
            self.pillFrequencyField = cell.textView
        } else if row == .DoseTimes {
            cell.textView.placeholder = "Dosage Times"
        }
        
        cell.textView.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView.init()
    }
}

extension AddPillViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        guard let frequencyTextField = self.pillFrequencyField,
            frequencyTextField == textField,
            reason == .committed else { return }
        
    }
}
