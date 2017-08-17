//
//  MainVC.swift
//  WhereIsMyFood-Driver
//
//  Created by elad schwartz on 25/07/2017.
//  Copyright © 2017 elad schwartz. All rights reserved.
//

import UIKit
import SwiftyJSON

class MainVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.perform(#selector(activeSegue), with: nil, afterDelay: 0.0)
    }
    
    func activeSegue() {
        //check if driver is logged in and get the his details. if not logged in go to sms screen
        let isLogin = Helpers.userDefaults.bool(forKey: "is_login")
        guard let phoneNumber = Helpers.userDefaults.string(forKey: "phone") else {
            return
        }
        
        if (isLogin){
            APIManager.shared.getDetailsAndSave(phoneNumber: phoneNumber) { (json) in
                self.performSegue(withIdentifier: "fromMainToOrders", sender: self)
            }
        }
        else {
            performSegue(withIdentifier: "goToSMS", sender: self)
        }
    }
}
