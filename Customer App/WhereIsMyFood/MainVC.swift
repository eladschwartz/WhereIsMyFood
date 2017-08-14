//
//  MainVC.swift
//  BringMyFood
//
//  Created by elad schwartz on 27/04/2017.
//  Copyright © 2017 elad schwartz. All rights reserved.
//

import UIKit
import SwiftyJSON


class MainVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrency()
    }
    
    @IBAction func enterBtnTapped(_ sender: Any) {
        self.perform(#selector(activeSegue), with: nil, afterDelay: 0.0)
    }
    
    
    //Check if user logged already and move the to the right screen
    func activeSegue() {
        let isLogin  = Helpers.userDefaults.bool(forKey: "is_login")
        if (isLogin) {
            Helpers.goToScreen(name: "fromMainToRestaurants", sender: self, viewController: self)
        } else {
            Helpers.goToScreen(name: "goToSMS", sender: self,  viewController: self)
        }
    }
    
    //Getting the currency that was set in admin panel
    func getCurrency() {
        APIManager.shared.getCurrency { (json) in
            if (json != JSON.null) {
                Config.CURRENCY_SIGN = json.string!
            }
        }
    }
    
}


