//
//  CustomerMenuTVC.swift
//  BringMyFood
//
//  Created by elad schwartz on 17/04/2017.
//  Copyright © 2017 elad schwartz. All rights reserved.
//

import UIKit


class CustomerMenuTVC: UITableViewController {

    @IBOutlet weak var restaurantLbl: UILabel!
    @IBOutlet weak var trayLbl: UILabel!
    @IBOutlet weak var ordersLbl: UILabel!
    @IBOutlet weak var settingsLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        restaurantLbl.text = "Restaurants".localized(category: "Menu")
        trayLbl.text = "Tray".localized(category: "Menu")
        ordersLbl.text = "Orders".localized(category: "Menu")
        settingsLbl.text = "Settings".localized(category: "Menu")
    }
}
