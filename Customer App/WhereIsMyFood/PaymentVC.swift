//
//  PaymentVC.swift
//  BringMyFood
//
//  Created by elad schwartz on 18/04/2017.
//  Copyright © 2017 elad schwartz. All rights reserved.
//

import UIKit
import Stripe
import SwiftyJSON

class PaymentVC: UIViewController {
    @IBOutlet weak var cardTextField: STPPaymentCardTextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var cardBrand : UIImage?
    var last4Digits = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        cardTextField.textColor = UIColor.white
    }
    //Create strope token if credit card is valid
    @IBAction func doneButtonTapped(_ sender: Any) {
        activityIndicator.startAnimating()
          let card = self.cardTextField.cardParams
        STPAPIClient.shared().createToken(withCard: card, completion: { (token, error) in
            if let error = error {
                  self.activityIndicator.stopAnimating()
                let alertViewError = Helpers.showErrorAlert(btnText: "OK", message: error.localizedDescription)
                self.present(alertViewError, animated: true, completion: nil)
            } else if let stripeToken = token {
                guard let cardBrand = self.cardTextField.brandImage,
                      let last4 = card.last4() else {
                        return
                }
                self.activityIndicator.stopAnimating()
                self.cardBrand = cardBrand
                self.last4Digits = last4
                //Send notification to change button's text in container
                NotificationCenter.default.post(name:Notification.Name(rawValue:"changeOrderBtnText"),object: nil,  userInfo: ["text" : "Place Order"])
                Helpers.goToScreen(name: "unwindToTray", sender: stripeToken, viewController: self)
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "unwindToTray") {
            let destvc = segue.destination as! TrayVC
            if let token = sender as? STPToken {
                destvc.stripeToken = token
                destvc.last4Digits = self.last4Digits
                destvc.cardImage = self.cardBrand
                destvc.isNewCard = true
            }
        }
    }
}





