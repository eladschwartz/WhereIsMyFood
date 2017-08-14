//
//  EnterCodeVC.swift
//  WhereIsMyFood
//
//  Created by elad schwartz on 27/04/2017.
//  Copyright © 2017 elad schwartz. All rights reserved.
//

import UIKit
import SinchVerification
import SkyFloatingLabelTextField

class EnterCodeVC: UIViewController, UITextFieldDelegate {
    var verification:Verification!
    var phonenumber: String!
    var customerExist: Bool?
    var user: User?
    
    @IBOutlet weak var codeText: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var verifyBtn: UIButton!
    @IBOutlet weak var resendCodeBtn: UIButton!
    @IBOutlet weak var changePhoneBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.codeText.delegate = self
    }
    
    //Verfiy the code the user got with Sinch server
    @IBAction func verify(sender: AnyObject) {
        spinner.startAnimating()
        verification.verify(
            codeText.text!, completion:
            { (success:Bool, error:Error?) -> Void in
                if (success) {
                    //If new customer go to details screen
                    if (self.customerExist == false || self.customerExist == nil) {
                        self.spinner.stopAnimating()
                        Helpers.goToScreen(name: "GoToCustomerDetails", sender: self, viewController: self)
                        return
                    }
                    
                    //if customer exist already in DB take the details and save them localy
                    APIManager.shared.getDetailsAndSave(phone: self.phonenumber){ (json) in
                        self.spinner.stopAnimating()
                        //Delete all credit cards for extra security
                        let userId = User.shared.id ?? ""
                        APIManager.shared.deleteStripeCard(customerId: userId) { (json) in }
                        Helpers.goToScreen(name: "fromPinCodeToRestaurants", sender: self, viewController: self)
                    }
                } else {
                    self.spinner.stopAnimating()
                    let errorAlert = Helpers.showErrorAlert(btnText: "OK", message: (error?.localizedDescription)!)
                    self.present(errorAlert, animated: true)
                }
        })
    }
    
    //Resend the code if the user didn't get the code
    @IBAction func resendCodeBtnTapped(_ sender: Any) {
        disableUI(true)
        verification = SMSVerification(Config.SINCH_KEY, phoneNumber: phonenumber)
        verification.initiate { (result: InitiationResult, error:Error?) -> Void in
            if (result.success){
                self.disableUI(false)
            } else {
                let errorAlert = Helpers.showErrorAlert(btnText: "OK", message: (error?.localizedDescription)!)
                self.present(errorAlert, animated: true)
            }
        }
    }
    
    //Go back to Phone screen
    @IBAction func changePhoneBtnTapped(_ sender: Any) {
        performSegue(withIdentifier: "unwindToLogin", sender: self)
    }
    
    //Disable the UI with delay after the user click on the send button so the user won't click again
    func disableUI(_ disable: Bool) {
        var alpha:CGFloat = 1.0
        if (disable) {
            alpha = 0.5
            codeText.resignFirstResponder()
            spinner.startAnimating()
            let delayTime =
                DispatchTime.now() +
                    Double(Int64(30 * Double(NSEC_PER_SEC)))
                    / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(
                deadline: delayTime, execute:
                { () -> Void in
                    self.disableUI(false)
            })
        }
        else {
            self.codeText.becomeFirstResponder()
            self.spinner.stopAnimating()
            
        }
        //Change controls visibility
        self.codeText.isEnabled = !disable
        self.verifyBtn.isEnabled = !disable
        self.verifyBtn.alpha = alpha
        self.resendCodeBtn.isEnabled = !disable
        self.resendCodeBtn.alpha = alpha
        self.changePhoneBtn.isEnabled = !disable
        self.changePhoneBtn.alpha = alpha
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "GoToCustomerDetails") {
            let customerDetailsVC = segue.destination as! CustomerDetailsVC
            customerDetailsVC.phoneNumber = self.phonenumber
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    //Move the view to show all the fields
    func textFieldDidBeginEditing(_ textField: UITextField) {
        animateViewMoving(up: true, moveValue: 100)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        animateViewMoving(up: false, moveValue: 100)
    }
}
