//
//  AddPillViewController.swift
//  Pilltracker
//
//  Created by Rob Baker on 18/05/2019.
//  Copyright © 2019 Rob Baker. All rights reserved.
//

import UIKit
import DateToolsSwift

protocol AddPillViewControllerDelegate: class {
    func addPillViewControllerExited()
}

class AddPillViewController: UIViewController {
    
    enum AddPillViewControllerRows: Int {
        case Name
        case Mg
        case Frequency
    }

    @IBOutlet weak var tableView: UITableView!
    weak var delegate: AddPillViewControllerDelegate?
    
    var pill: Pill? {
        didSet {
            if let pill = pill {
                pillViewModel = PillViewModel.init(model: pill)
            }
        }
    }
    var pillViewModel: PillViewModel?
    var pillNameField: UITextField?
    var pillMgField: UITextField?
    var pillFrequencyField: UITextField?
    var doseTimes: [Date] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        if let pill = pill {
            updateDoseRows(frequency: pill.frequency, pill: pill)
        }
    }
    
    @IBAction func tappedCancel(_ sender: Any) {
        self.dismiss()
    }
    
    func dismiss() {
        self.delegate?.addPillViewControllerExited()
        
        if let _ = pill {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
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
        
        var newPill: Pill?
        let pillId = pill?.id ?? UUID()
        
        var doses: [Dose] = []
        for doseTime in doseTimes {
            doses.append(Dose(id: UUID(), doseTime: doseTime, expectedDoseTime: doseTime, missedDose: false))
        }
        
        newPill = Pill.init(id: pillId, name: pillName, mg: pillMg, frequency: frequency, doses: doses)
        
        if let pill = newPill {
            PillService.init().saveOrUpdate(pill: pill)
        }
        
        self.dismiss()
    }
}

extension AddPillViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3 + doseTimes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row > 2 {
            return self.tableView(tableView, doseTimeCellForRowAt: indexPath)
        }
        
        return self.tableView(tableView, textViewCellForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, doseTimeCellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DoseTableViewCell", for: indexPath) as? DoseTableViewCell else {
            return UITableViewCell.init()
        }
        
        let adjustedIndex = indexPath.row - 3
        let dose = doseTimes[adjustedIndex]
        cell.doseTextView.text = dose.format(with: "HH:mm")
        
        
        if let datePickerView = UINib.init(nibName: "DatePickerKeyboardView", bundle: nil).instantiate(withOwner: nil, options: nil).first as? DatePickerKeyboardView {
            datePickerView.datePicker.textView = cell.doseTextView
            datePickerView.datePicker.datePickerMode = .time
            datePickerView.datePicker.date = dose
            datePickerView.tag = adjustedIndex
            datePickerView.backgroundColor = UIColor.white
            
            datePickerView.doneTapped = {
                self.refreshDoseRows(datePickerView.datePicker)
                cell.doseTextView.resignFirstResponder()
            }
            
            datePickerView.changedBlock = {
                self.refreshDoseRows(datePickerView.datePicker)
            }
            
            cell.doseTextView.inputView = datePickerView
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, textViewCellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TextViewTableViewCell", for: indexPath) as? TextViewTableViewCell, let row = AddPillViewControllerRows.init(rawValue: indexPath.row) else {
            return UITableViewCell.init()
        }
        
        if row == .Name {
            cell.textView.placeholder = "Name"
            cell.textView.text = pillViewModel?.name()
            self.pillNameField = cell.textView
        } else if row == .Mg {
            cell.textView.placeholder = "mg"
            cell.textView.keyboardType = .numberPad
            cell.textView.text = pillViewModel?.mg()
            self.pillMgField = cell.textView
        } else if row == .Frequency {
            cell.textView.placeholder = "Frequency (times a day)"
            cell.textView.keyboardType = .numberPad
            cell.textView.text = pillViewModel?.frequencyCount()
            self.pillFrequencyField = cell.textView
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
    
    @objc func refreshDoseRows(_ sender: DatePickerWithLabel) {
        let date = sender.date
        doseTimes.remove(at: sender.tag)
        doseTimes.insert(date, at: sender.tag)
        
        if let textView = sender.textView {
            textView.text = date.format(with: "HH:mm")
        }
        
        if var pill = pill {
            var doses: [Dose] = []
            for doseTime in doseTimes {
                let dose = Dose(id: UUID(), doseTime: doseTime, expectedDoseTime: doseTime, missedDose: false)
                doses.append(dose)
            }
            pill.doses = doses
        }
    }
}

extension AddPillViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        guard let frequencyTextField = self.pillFrequencyField,
            frequencyTextField == textField,
            reason == .committed,
            let frequencyText = textField.text,
            let frequency = Int(frequencyText) else { return }
        
        self.updateDoseRows(frequency: frequency)
    }
    
    func updateDoseRows(frequency: Int, pill: Pill? = nil) {
        
        if frequency == doseTimes.count {
            return
        }
        
        if frequency == 0 {
            doseTimes = []
            tableView.reloadData()
            return
        }
        
        let today = Date.init()
        var indexPaths: [IndexPath] = []
        var shouldReturn = frequency < doseTimes.count
        for (index, _) in doseTimes.enumerated() {
            if index >= frequency, doseTimes.count >= index {
                doseTimes.remove(at: index - 1)
            }
        }
        
        if var pill = self.pill {
            pill.frequency = frequency
            self.pill = pill
        }
        
        if shouldReturn {
            tableView.reloadData()
            return
        }
        
        let adjustedFrequency = frequency - doseTimes.count
        
        for index in 1...adjustedFrequency {
            let date: Date?
            
            if let pill = pill, index - 1 < pill.doses.count {
                date = pill.doses[index - 1].doseTime
            } else {
                date = Date.init(year: today.year, month: today.month, day: today.day, hour: 7, minute: 30, second: 0)
            }
            
            if let date = date {
                doseTimes.append(date)
            }
            
            let indexPath = IndexPath.init(row: index, section: 0)
            indexPaths.append(indexPath)
        }
        
        tableView.reloadData()
    }
}

class DatePickerWithLabel: UIDatePicker {
    var textView: UITextField?
}
