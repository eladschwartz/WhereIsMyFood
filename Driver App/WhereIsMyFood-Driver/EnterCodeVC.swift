//
//  EnterCodeVC.swift
//  WhereIsMyFood-Driver
//
//  Created by elad schwartz on 25/07/2017.
//  Copyright © 2017 elad schwartz. All rights reserved.
//


import UIKit
import SinchVerification
import SwiftyJSON
import SkyFloatingLabelTextField

class EnterCodeVC: UIViewController, UITextFieldDelegate {
    var verification:Verification!
    var phonenumber: String!
    @IBOutlet weak var codeText: SkyFloatingLabelTextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var verifyBtn: UIButton!
    @IBOutlet weak var resendCodeBtn: UIButton!
    @IBOutlet weak var changePhoneBtn: UIButton!
    
    override func viewDidLoad() {
        //self.hideKeyboardWhenTappedAround()
        self.codeText.delegate = self
        super.viewDidLoad()
    }
    
    @IBAction func verify(sender: AnyObject) {
        //if code text is empty return
        if (codeText.text == "" || codeText.text == nil) {
            return
        }
        
        disableUI(true)
        spinner.startAnimating()
        verification.verify(
            codeText.text!, completion:
            { (success:Bool, error:Error?) -> Void in
                if (success) {
                    APIManager.shared.getDetailsAndSave(phoneNumber: self.phonenumber) { (json) in
                            self.spinner.stopAnimating()
                            self.performSegue(withIdentifier: "FromCodeToOrders", sender: self)
                        
                    }
                } else {
                    self.disableUI(false)
                    self.spinner.stopAnimating()
                    let errorAlert = Helpers.showErrorAlert(btntext: "OK", message: (error?.localizedDescription)!)
                    self.present(errorAlert, animated: true)
                }
        })
    }
    
    @IBAction func resendCodeBtnTapped(_ sender: Any) {
        disableUI(true)
        verification = SMSVerification(Config.SINCH_KEY, phoneNumber: phonenumber)
        verification.initiate { (result: InitiationResult, error:Error?) -> Void in
            if (result.success){
                self.disableUI(false)
            } else {
                let errorAlert = Helpers.showErrorAlert(btntext: "OK", message: (error?.localizedDescription)!)
                self.present(errorAlert, animated: true)
            }
        }
    }
    
    @IBAction func changePhoneBtnTapped(_ sender: Any) {
        performSegue(withIdentifier: "unwindToLogin", sender: self)
    }
    
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
        self.codeText.isEnabled = !disable
        self.verifyBtn.isEnabled = !disable
        self.verifyBtn.alpha = alpha
        self.resendCodeBtn.isEnabled = !disable
        self.resendCodeBtn.alpha = alpha
        self.changePhoneBtn.isEnabled = !disable
        self.changePhoneBtn.alpha = alpha
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}

