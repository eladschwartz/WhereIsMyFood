//
//  CustomerMenuTVC.swift
//  WhereIsMyFood-Driver
//
//  Created by elad schwartz on 25/07/2017.
//  Copyright © 2017 elad schwartz. All rights reserved.
//


import UIKit


class CustomerMenuTVC: UITableViewController {
    
    @IBOutlet weak var lblName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        lblName.text = Driver.shared.name
        view.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0)
    }
}
