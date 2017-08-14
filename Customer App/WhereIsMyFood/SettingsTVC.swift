//
//  SettingsTVC.swift
//  WhereIsMyFood
//
//  Created by elad schwartz on 28/07/2017.
//  Copyright © 2017 elad schwartz. All rights reserved.
//

import Foundation
import SwiftyJSON


class SettingsTVC: UITableViewController {
    
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    @IBAction func unwindFromDetailsToSettings(segue: UIStoryboardSegue) {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Show menu with swipe Gesture
        if self.revealViewController() != nil {
            menuBarButton = Helpers.initMenuBtn(controller: self, barBtn: menuBarButton)
        }
        self.tableView.tableFooterView = UIView.init()

    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddressCell", for: indexPath)
            cell.textLabel?.text = "Address".localized(category: "Settings")
             cell.detailTextLabel?.text = "Change".localized(category: "Settings")
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
                self.performSegue(withIdentifier: "FromSettingsToDetails", sender: self)
            break
        default:
            break
        }
    }
    
    override  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FromSettingsToDetails" {
            let dest = segue.destination as! CustomerDetailsVC
            dest.isEditMode = true
        }
    }
}
