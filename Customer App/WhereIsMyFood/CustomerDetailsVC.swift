//
//  CustomerDetailsVC.swift
//  WhereIsMyFood
//
//  Created by elad schwartz on 27/04/2017.
//  Copyright © 2017 elad schwartz. All rights reserved.
//

import UIKit
import SwiftyJSON
import SkyFloatingLabelTextField

class CustomerDetailsVC:  UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var addressText: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var floorText: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var apartNumText: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var emailText: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var nameText: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var countryText: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var cityText: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var stateText: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var zipCodeText: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var saveBtn: UIButton!
    
    
    var phoneNumber: String!
    var isEditMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTextFields()
        if (isEditMode) {
            let details = User.shared.address
            self.addressText.text = details?.address
            self.floorText.text = details?.floor
            self.apartNumText.text = details?.apartmentNumber
            self.emailText.text = User.shared.email
            self.nameText.text = User.shared.name
            self.countryText.text = details?.country
            self.cityText.text = details?.city
            self.stateText.text = details?.city
            self.zipCodeText.text = details?.zipCode
            self.phoneNumber = User.shared.phone
            self.saveBtn.setTitle("Update".localized(category: "Buttons"), for: .normal)
        }
    }
    
    //Save user details
    @IBAction func saveBtnTapped(_ sender: Any) {
        if (validateFields()) {
            guard let name = nameText.text,
                let email = emailText.text,
                let phone = phoneNumber,
                let custAddress = addressText.text,
                let floor = floorText.text,
                let apartnum = apartNumText.text,
                let country = countryText.text,
                let city = cityText.text,
                let state = stateText.text,
                let zipCode = zipCodeText.text else {
                    return
            }
            
            let address = Address.init(city: city, state: state, country: country, zipCode: zipCode, address: custAddress, floor: floor, apartmentNumber: apartnum)
            if (isEditMode) {
                 updateUser(name: name , email: email, phone: phone, address: address)
            } else {
                  saveUser(name: name , email: email, phone: phone, address: address)
            }
          
            
        } else {
            let alertViewError = Helpers.showErrorAlert(btnText: "OK", message: "Please Fille The Fields Correctly")
            self.present(alertViewError, animated: true, completion: nil)
        }
    }
    
    
    func saveUser(name: String , email: String, phone: String, address: Address) {
        APIManager.shared.saveUserDetailsToDB(name: name , email: email, phone: phone, address: address, completionHandler: {(json) in
            //If there was an error
            if json == JSON.null {
                let alertViewError = Helpers.showErrorAlert(btnText: "OK", message: "Error Saving Details - Please Try Again")
                self.present(alertViewError, animated: true, completion: nil)
                return
            }
            
            //save user object to local storage
            guard let userId = json["user_id"].int,
                let token = json["token"].string else {return}
            
            User.shared.saveUserDetails(id: String(userId), name: name, email: email, phone: phone, token: token, address: address)
            Helpers.userDefaults.set(true, forKey: "is_login")
            Helpers.userDefaults.set(phone, forKey: "phone_num")
            Helpers.goToScreen(name: "fromDetailsToRestaurants", sender: self, viewController: self)
        })
    }
    
    func updateUser(name: String , email: String, phone: String, address: Address) {
        APIManager.shared.updateUserDetails(name: name , email: email, phone: phone, address: address, completionHandler: {(json) in
            //If there was an error
            if json == JSON.null {
                let alertViewError = Helpers.showErrorAlert(btnText: "OK", message: "Error Updating Details - Please Try Again")
                self.present(alertViewError, animated: true, completion: nil)
                return
            }
            
            User.shared.updateUserDetails(name: name, email: email, address: address)
            Helpers.goToScreen(name: "unwindFromDetailsToSettings", sender: self, viewController: self)
        })
    }
    
    
    //Validate that all the fields are not empty and email is vaild
    func validateFields() -> Bool {
        guard let textemail = emailText.text, !textemail.isEmpty, isValidEmail(testStr: textemail),
            let textname = nameText.text, !textname.isEmpty,
            let textaddress = addressText.text, !textaddress.isEmpty,
            let floorText = floorText.text, !floorText.isEmpty,
            let apartNumText = apartNumText.text, !apartNumText.isEmpty,
            let countryText = countryText.text, !countryText.isEmpty else {
                return false
        }
        
        return true
    }
    
    //Validate Email
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    //Moving the view so the feilds can appear
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 1 || textField.tag == 2 {return}
        animateViewMoving(up: true, moveValue: 100)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 1 || textField.tag == 2 {return}
        animateViewMoving(up: false, moveValue: 100)
    }
    
    func initTextFields() {
        setTextStyle(textField:  self.addressText)
        setTextStyle(textField:  self.floorText)
        setTextStyle(textField:  self.emailText)
        setTextStyle(textField:  self.nameText)
        setTextStyle(textField:  self.cityText)
        setTextStyle(textField:  self.apartNumText)
        setTextStyle(textField:  self.countryText)
        setTextStyle(textField:  self.zipCodeText)
        setTextStyle(textField:  self.stateText)
        
    }
    
    func setTextStyle(textField: UITextField) {
        textField.delegate = self
        setIcons()
    }
    
    func setIcons() {
        self.apartNumText.iconFont = UIFont(name: "FontAwesome", size: 15)
        self.floorText.iconText = "\u{f015}"
        self.apartNumText.iconFont = UIFont(name: "FontAwesome", size: 15)
        self.apartNumText.iconText = "\u{f015}"
        self.countryText.iconFont = UIFont(name: "FontAwesome", size: 15)
        self.countryText.iconText = "\u{f0ac}"
        self.cityText.iconFont = UIFont(name: "FontAwesome", size: 15)
        self.cityText.iconText = "\u{f015}"
        self.stateText.iconFont = UIFont(name: "FontAwesome", size: 15)
        self.stateText.iconText = "\u{f015}"
        self.zipCodeText.iconFont = UIFont(name: "FontAwesome", size: 15)
        self.zipCodeText.iconText = "\u{f015}"
        self.addressText.iconFont = UIFont(name: "FontAwesome", size: 15)
        self.addressText.iconText = "\u{f236}"
        self.nameText.iconFont = UIFont(name: "FontAwesome", size: 15)
        self.nameText.iconText = "\u{f1ae}"
        self.emailText.iconFont = UIFont(name: "FontAwesome", size: 15)
        self.emailText.iconText = "\u{f003}"
    }
}

extension UIViewController {
    func animateViewMoving (up:Bool, moveValue :CGFloat) {
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = self.view.frame.offsetBy(dx: 0,  dy: movement)
        UIView.commitAnimations()
    }
}




