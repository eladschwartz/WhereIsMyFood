//
//  Helpers.swift
//  WhereIsMyFood-Driver
//
//  Created by elad schwartz on 25/07/2017.
//  Copyright © 2017 elad schwartz. All rights reserved.
//

import Foundation
import UIKit

class Helpers {
    
    static let viewColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0)
    static let userDefaults = UserDefaults.standard
    
    static func loadImage(_ imageView: UIImageView,_ urlString: String) {
        if let imgURL  = URL(string: urlString) {
            URLSession.shared.dataTask(with: imgURL) { (data, response, error) in
                
                guard let data = data, error == nil else { return}
                
                DispatchQueue.main.async(execute: {
                    imageView.image = UIImage(data: data)
                })
                }.resume()
        }
    }
    
    static func showActivityIndicator(_ activityIndicator: UIActivityIndicatorView,_ view: UIView) {
        activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        activityIndicator.color = UIColor.black
        
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    // Helper method to hide activity indicator
    static func hideActivityIndicator(_ activityIndicator: UIActivityIndicatorView) {
        activityIndicator.stopAnimating()
    }
    
    static func showErrorAlert(btntext: String, message: String) -> UIAlertController {
        let cancelAction = UIAlertAction(title: btntext, style: .cancel)
        let alertViewError = UIAlertController(title: "ERROR", message: message, preferredStyle: .alert)
        alertViewError.addAction(cancelAction)
        return alertViewError
    }
    
    //Helper function to performSegue with DispathQueue main
    static func goToScreen(name: String, sender: Any, viewController: UIViewController) {
        DispatchQueue.main.async(){ viewController.performSegue(withIdentifier: name, sender: sender) }
    }
}


class HairlineView: UIView {
    override func awakeFromNib() {
        guard let backgroundColor = self.backgroundColor?.cgColor else { return }
        self.layer.borderColor = backgroundColor
        self.layer.borderWidth = (1.0 / UIScreen.main.scale) / 2
        self.backgroundColor = UIColor.clear
    }
}

extension String {
    func toDouble() -> Double {
        return NSString(string: self).doubleValue
    }
}

