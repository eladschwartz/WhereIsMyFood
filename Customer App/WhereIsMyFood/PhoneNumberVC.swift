//
//  ViewController.swift
//  BringMyFood
//
//  Created by elad schwartz on 16/04/2017.
//  Copyright © 2017 elad schwartz. All rights reserved.
//

import UIKit
import SinchVerification
import SwiftyJSON
import CountryPicker
import SkyFloatingLabelTextField

class PhoneNumberVC: UIViewController, UITextFieldDelegate, CountryPickerDelegate {
    
    @IBOutlet weak var countryCodeText: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var phoneText: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var smsBtn: UIButton!
    @IBOutlet weak var image: UIImageView!
    @IBAction func unwindToLogin(segue: UIStoryboardSegue) {}
    
    var verification:Verification!
    var isCustomerExist: Bool = false
    var countryPickerView: CountryPicker!
    var phoneNumber: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.phoneText.delegate = self
        //Hide Keyboard
        self.hideKeyboardWhenTappedAround()
        initControls()
      
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.2, animations: {
            self.phoneText.alpha = 1.0
            self.smsBtn.alpha = 1.0
            self.image.alpha = 1.0
            self.countryCodeText.alpha = 1.0
        })
    }
    
    @IBAction func sendSmsBtn(_ sender: Any) {
        //If customer entered didn't enter phone number don't continue
        if (self.phoneText.text == "" || self.phoneText.text == nil || self.countryCodeText.text == "" || self.countryCodeText.text == nil) {
            return
        }
        phoneNumber = self.countryCodeText.text! + self.phoneText.text!

        //------------------------------
        //For DEMO only - remove this in production
        if (phoneNumber == "+12") {
            APIManager.shared.getDetailsAndSave(phone: self.phoneNumber){ (json) in
                Helpers.goToScreen(name: "fromPhoneNumberToResturant", sender: self, viewController: self)
            }
            return
        }
        //------------------------------
        
              self.disableUI(true)
        APIManager.shared.isCustomerExist(phone: self.phoneNumber) { (json) in
            //If the customer is new send a sms and go to the pincode screen
            if (json == JSON.null) {
                //send SMS verifction to the phone
                self.verification = SMSVerification(Config.SINCH_KEY, phoneNumber: self.phoneNumber)
                self.verification.initiate { (result: InitiationResult, error:Error?) -> Void in
                    self.disableUI(false);
                    if (result.success){
                        Helpers.goToScreen(name: "fromPhoneNumberToPinCode", sender: sender, viewController: self)
                    } else {
                        let errorAlert = Helpers.showErrorAlert(btnText: "OK", message: (error?.localizedDescription)!)
                        self.present(errorAlert, animated: true)
                        return
                    }
                }
            }
            //if customer exist get uid from DB and compare to app's uid
            guard let uid = json[0]["uid"].string else {
                return
            }
            self.checkUid(uid: uid)
            
        }
        
        
    }
    
    //Check if customer use the same phone(this code try to deny other users access to the account)
    func checkUid(uid: String) {
            if (uid == Config.UID) {
                APIManager.shared.getDetailsAndSave(phone: self.phoneNumber){ (json) in
                    Helpers.goToScreen(name: "fromPhoneNumberToResturant", sender: self, viewController: self)
                }
        //2 Cases: 1. User swtich to a new phone. 2. another user try to use another customer number
        } else {
            self.isCustomerExist = true
            self.verification = SMSVerification(Config.SINCH_KEY, phoneNumber: self.phoneNumber)
            self.verification.initiate { (result: InitiationResult, error:Error?) -> Void in
                self.disableUI(false);
                if (result.success){
                    Helpers.goToScreen(name: "fromPhoneNumberToPinCode", sender: self, viewController: self)
                } else {
                    let errorAlert = Helpers.showErrorAlert(btnText: "OK", message: (error?.localizedDescription)!)
                    self.present(errorAlert, animated: true)
                }
            }
        }
    }
    
    //Disable the UI with delay after the user click on the send button so the user won't click again
    func disableUI(_ disable: Bool) {
        var alpha:CGFloat = 1.0;
        if (disable) {
            alpha = 0.5;
            phoneText.resignFirstResponder();
            spinner.startAnimating();
            let delayTime =
                DispatchTime.now() +
                    Double(Int64(30 * Double(NSEC_PER_SEC)))
                    / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(
                deadline: delayTime, execute:
                { () -> Void in
                    self.disableUI(false);
            });
        }
        else{
            self.phoneText.becomeFirstResponder();
            self.spinner.stopAnimating();
            
        }
        self.phoneText.isEnabled = !disable;
        self.smsBtn.isEnabled = !disable;
        self.smsBtn.alpha = alpha;
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "fromPhoneNumberToPinCode") {
            let enterCodeVC = segue.destination as! EnterCodeVC
            enterCodeVC.verification = self.verification
            enterCodeVC.phonenumber = self.phoneNumber
            enterCodeVC.customerExist = self.isCustomerExist
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    // a picker item was selected
    func countryPhoneCodePicker(_ picker: CountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
        //pick up anythink
        self.countryCodeText.text = phoneCode
    }
    
    func initControls() {
        //set alpha to 0 for animation
        self.phoneText.alpha = 0.0
        self.smsBtn.alpha = 0.0
        self.image.alpha = 0.0
        self.countryCodeText.alpha = 0.0
        //Get current country code for pickerview
        let locale = Locale.current
        let code = (locale as NSLocale).object(forKey: NSLocale.Key.countryCode) as! String?
        //init Picker
        countryPickerView = CountryPicker()
        countryPickerView.countryPickerDelegate = self
        countryPickerView.showPhoneNumbers = true
        countryPickerView.setCountry(code!)
        self.countryCodeText.inputView = countryPickerView
    }
}


extension UIViewController {
    //Hiding Keyboard when clicking on the screen
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}



