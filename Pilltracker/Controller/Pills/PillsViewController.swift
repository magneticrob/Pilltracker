//
//  PillsViewController.swift
//  Pilltracker
//
//  Created by Rob Baker on 18/05/2019.
//  Copyright © 2019 Rob Baker. All rights reserved.
//

import UIKit

class PillsViewController: UITableViewController {

    var pills: [Pill] = UserDefaultsFetcher.init().savedPills() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    let userDefaults = UserDefaultsFetcher.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    
    @IBAction func tappedAdd(_ sender: Any) {
        self.performSegue(withIdentifier: "addPillSegue", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !pills.isEmpty {
            return pills.count
        }
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !pills.isEmpty, let cell = tableView.dequeueReusableCell(withIdentifier: "PillTableViewCell", for: indexPath) as? PillTableViewCell {
            let pill = pills[indexPath.row]
            cell.update(pill: pill)
            return cell
        }
        
        return tableView.dequeueReusableCell(withIdentifier: "NoPillsTableViewCell", for: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if pills.isEmpty {
            return view.frame.height
        }
        
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView.init()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let pill = pills[indexPath.row]
        self.performSegue(withIdentifier: "editPillSegue", sender: pill)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addPillSegue", let navigationController = segue.destination as? UINavigationController, let addPillController = navigationController.topViewController as? AddPillViewController {
            addPillController.delegate = self
        }
        
        if segue.identifier == "editPillSegue", let addPillController = segue.destination as? AddPillViewController, let pill = sender as? Pill {
            addPillController.delegate = self
            addPillController.pill = pill
        }
    }
}

extension PillsViewController: AddPillViewControllerDelegate {
    func addPillViewControllerExited() {
        self.pills = UserDefaultsFetcher.init().savedPills()
    }
}
