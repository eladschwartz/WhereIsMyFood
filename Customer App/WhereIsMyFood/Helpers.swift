//
//  Helpers.swift
//  WhereIsMyFood
//
//  Created by elad schwartz on 30/04/2017.
//  Copyright © 2017 elad schwartz. All rights reserved.
//

import Foundation
import SwiftyJSON

class Helpers {
    
    static let viewColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0)
    static let userDefaults = UserDefaults.standard
    
    
    
    //A genric erro alert
    static func showErrorAlert(btnText: String, message: String) -> UIAlertController {
        let cancelAction = UIAlertAction(title: btnText, style: .cancel)
        let alertViewError = UIAlertController(title: "Error".localized(category: "Buttons"), message: message, preferredStyle: .alert)
        alertViewError.addAction(cancelAction)
        return alertViewError
    }
    
    //Helper function to performSegue with DispathQueue main
    static func goToScreen(name: String, sender: Any, viewController: UIViewController) {
        DispatchQueue.main.async(){ viewController.performSegue(withIdentifier: name, sender: sender) }
    }
    
    
    //Genric Activity Indicator
    static func showActivityIndicator(view: UIView) -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        DispatchQueue.main.async(){
            activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
            activityIndicator.center = view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = .whiteLarge
            activityIndicator.color = UIColor.white
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
        }
         return activityIndicator
    }
    
    static func initMenuBtn(controller: UIViewController, barBtn: UIBarButtonItem ) -> UIBarButtonItem {
        let locale = NSLocale.current.languageCode
        barBtn.target = controller.revealViewController()
        if locale == "he" {
            barBtn.action = #selector(SWRevealViewController.rightRevealToggle(_:))
        }else {
            barBtn.action = #selector(SWRevealViewController.revealToggle(_:))
        }
        
        //controller.view.addGestureRecognizer(controller.revealViewController().panGestureRecognizer())
        return barBtn
    }
    
    
}

//Covert Int to Bool
extension Bool {
    init<T: Integer>(_ num: T) {
        self.init(num != 0)
    }
}

//Covert String to Double
extension String {
    func toDouble() -> Double {
        return NSString(string: self).doubleValue
    }
}

extension UIImageView {
    func setRounded() {
        self.layer.cornerRadius = 8.0
        self.clipsToBounds = true
    }
}




