//
//  TrayViewContainer.swift
//  BringMyFood
//
//  Created by elad schwartz on 30/05/2017.
//  Copyright © 2017 elad schwartz. All rights reserved.
//

import UIKit
import MapKit
import Stripe
import SwiftyJSON

class TrayVC: UIViewController {
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    @IBOutlet weak var addPaymentBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    @IBAction func unwindToTrayFromItemDetails(segue: UIStoryboardSegue) {}
    @IBAction func unwindToTrayFromPayment(segue: UIStoryboardSegue) {}
    @IBAction func unwindToTrayFromCreditCards(segue: UIStoryboardSegue) {}
    
    var activityIndicator = UIActivityIndicatorView()
    var address : [String : String]?
    var stripeToken : STPToken?
    var last4Digits = ""
    var isCustomerExist = false
    var indexPathSelected: IndexPath?
    //Subtotal Cell
    var subTotalLableString: String?
    var deliveryFeeString: String?
    //Total Cell
    var totalLabelString: String?
    //Pamyment Cell
    var cardImage: UIImage?
    var isNewCard = false
    var emptyCartView: EmptyCartView?
    var totalForCell = [Int : Double]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isHidden = true
        activityIndicator = Helpers.showActivityIndicator(view: self.view)
        self.hideKeyboardWhenTappedAround()
        //Hide empty cells
        self.tableView.tableFooterView = UIView.init()
        NotificationCenter.default.addObserver(self, selector: #selector(self.changeBtnText), name: NSNotification.Name(rawValue: "changeOrderBtnText"), object: nil)
        
        //Side Menu Swipe
        if self.revealViewController() != nil {
            menuBarButton = Helpers.initMenuBtn(controller: self, barBtn: menuBarButton)
        }
        
        if Tray.currentTray.items.count != 0 {
            self.loadItems()
            checkCustomerStripe()
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "changeOrderBtnText"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setTrayEmpty()
        self.addPaymentBtn.isEnabled = true
        self.loadItems()
        self.tableView.reloadData()
    }
    
    func setTrayEmpty(){
        if Tray.currentTray.items.count == 0 {
            emptyCartView = Bundle.main.loadNibNamed("EmptyCart", owner: self, options: nil)?.first as? EmptyCartView
            if let emptyView = emptyCartView {
                emptyView.frame = self.view.frame
                self.view.addSubview(emptyView)
                self.activityIndicator.stopAnimating()
                menuBtn.isEnabled = false
            }
        } else {
            self.addPaymentBtn.isHidden = false
            self.activityIndicator.stopAnimating()
        }
    }
    
    //Check if cutomser is returning customer and entered in the past credit card
    func checkCustomerStripe() {
        APIManager.shared.isCustomerStripe { (json) in
            if json != JSON.null {
                guard let last4Digits = json[0]["last4"].string, let cardName = json[0]["card"].string  else {
                    return
                }
                self.isCustomerExist = true
                self.addPaymentBtn.setTitle("Place Order".localized(category: "Tray"), for: .normal)
                
                //change payment cell to show the credit card brand and 4 last card digits
                self.last4Digits = last4Digits
                if let image = UIImage(named: cardName.lowercased()) {
                    self.cardImage = image
                }
                
            } else if (self.stripeToken != nil) {
                if let cardimage = self.cardImage {
                    self.cardImage = cardimage
                }
                
                if self.last4Digits != "" {
                    self.addPaymentBtn.setTitle("Place Order".localized(category: "Tray"), for: .normal)
                } else {
                    self.addPaymentBtn.setTitle("Add Payment".localized(category: "Tray"), for: .normal)
                }
            }
            
            DispatchQueue.main.async {
                if Tray.currentTray.items.count == 0 {
                    self.tableView.isHidden = true
                }else {
                    self.tableView.isHidden = false
                    self.activityIndicator.stopAnimating()
                    // Display all of the UI controllers and load items
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    //Create anOrder
    @IBAction func placeOrderBtnTapped(_ sender: AnyObject) {
        self.addPaymentBtn.isEnabled = false
        activityIndicator = Helpers.showActivityIndicator(view: self.view)
        let token = self.stripeToken != nil ? self.stripeToken?.tokenId:""
        if self.stripeToken != nil || self.isCustomerExist  {
            //Check if there is already open order for this user
            APIManager.shared.ifOrderExist() { (json) in
                if json[0] ==  JSON.null || json[0]["status_name"] == "Delivered" {
                    APIManager.shared.createOrder(stripeToken: token!, isNewCard: self.isNewCard, last4Digits:self.last4Digits ) { (json) in
                        //if there was a problem with chaarging the credit card, show a message with the error
                        if (json["charge"]["status"] != "succeeded"){
                            if let message = json["message"].string {
                                self.activityIndicator.stopAnimating()
                                let alertViewError = Helpers.showErrorAlert(btnText: "OK".localized(category: "Buttons"), message: message)
                                self.present(alertViewError, animated: true, completion: nil)
                                self.addPaymentBtn.isEnabled = true
                            }
                        } else {
                            //go to order screen if charge was ok
                            self.activityIndicator.stopAnimating()
                            Helpers.userDefaults.set(String(json["order_id"].int!), forKey: "order_id")
                            Tray.currentTray.reset()
                            Helpers.goToScreen(name: "fromTrayToOrder", sender: self, viewController: self)
                        }
                    }
                }
                else {
                    // Showing an alert message if there is an open order.
                    self.activityIndicator.stopAnimating()
                    self.addPaymentBtn.isEnabled = true
                    let cancelAction = UIAlertAction(title: "OK".localized(category: "Buttons"), style: .cancel)
                    let okAction = UIAlertAction(title: "Go to order".localized(category: "Tray"), style: .default, handler: { (action) in
                        Helpers.goToScreen(name: "fromTrayToOrder", sender: self, viewController: self)
                    })
                    let alertView = UIAlertController(title: "Open Order Exist".localized(category: "Tray"), message: "Open Order Message".localized(category: "Tray"), preferredStyle: .alert)
                    alertView.addAction(okAction)
                    alertView.addAction(cancelAction)
                    self.present(alertView, animated: true, completion: nil)
                }
            }
        } else {
            //if usde didn't enter credit card
            self.activityIndicator.stopAnimating()
            self.performSegue(withIdentifier: "fromTrayToPayment", sender: self)
        }
    }
    
    func addPaymentLblTapped () {
        self.performSegue(withIdentifier: "fromTrayToPayment", sender: self)
    }
    
    func showContorls(show: Bool) {
        tableView.isHidden = show == false ? true : false
        if (show){
            // Display all of the UI controllers and load items
            loadItems()
        }
    }
    
    //Set labels text
    func loadItems() {
        let total = Tray.currentTray.getTotal()
        guard let deliveryfee = Tray.currentTray.restaurant?.deliveryFee else {
            return
        }
        self.deliveryFeeString = "\(Config.CURRENCY_SIGN)\(deliveryfee)"
        self.subTotalLableString = "\(Config.CURRENCY_SIGN)\(total)"
        self.totalLabelString = "\(Config.CURRENCY_SIGN)\(total + deliveryfee)"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromTrayToEditItem" {
            let dest = segue.destination as! ItemDetailsVC
            dest.item = (sender as! TrayItem).item
            dest.qty = (sender as! TrayItem).qty
            dest.isEditMode = true
            dest.totalForItem = self.totalForCell
            dest.restaurant = Tray.currentTray.restaurant
            if let index = self.indexPathSelected {
                dest.itemIndex = index.row
            }
        }
        
        if segue.identifier == "fromTrayToMenu" {
            let dest = segue.destination as! CategoriesVC
            dest.restaurant = Tray.currentTray.restaurant
        }
    }
    
    func changeBtnText() {
        self.addPaymentBtn.setTitle("Place Order", for: .normal)
    }
    
    
}

extension TrayVC: UITableViewDelegate, UITableViewDataSource, TrayCellelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
            //Item & Addons
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TrayCell", for: indexPath) as! TrayCell
            let trayItem = Tray.currentTray.items[indexPath.row]
            let addonsSelected = Tray.currentTray.items[indexPath.row].item.addonsSelected
            var totalForCell = 0.0
            cell.delegate = self
            cell.qtyLbl.text = "\(trayItem.qty)"
            cell.itemNameLbl.text = trayItem.item.name
            if let price = trayItem.item.price {
                totalForCell = price
            }
            
            if (addonsSelected.count != 0) {
                cell.itemAddonsLbl.isHidden = false
                cell.itemAddonsLbl.text = ""
                //loop over the selected addons for each item and set the label to show the name and the price(if the addon has price)
                for addon in addonsSelected {
                    guard let addonName = addon.name else {
                        return cell
                    }
                    
                    if let price = addon.price, price != "" {
                        let addonPrice = price.toDouble()
                        cell.itemAddonsLbl.text =  cell.itemAddonsLbl.text!  + "\(addonName) (\(Config.CURRENCY_SIGN)\(addonPrice))\n"
                        totalForCell += addonPrice
                    } else {
                        cell.itemAddonsLbl.text =  cell.itemAddonsLbl.text!  + "\(addonName)\n"
                    }
                }
            }
            self.totalForCell[indexPath.row] = totalForCell * Double(trayItem.qty)
            cell.subTotalItemLbl.text =  "\(Config.CURRENCY_SIGN)\(totalForCell * Double(trayItem.qty))"
            return cell
            
        case 1:
            //Notes
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
            cell.textLabel?.text = "Restaurants Notes".localized(category: "Tray")
            cell.textLabel?.textColor = UIColor.white
            return cell
        //Sub Total and Delivery Fee
        case 2:
            //If customer exist show the last 4 digits in the lable. if not show add payment
            let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentCell", for: indexPath) as! PaymentCell
            if (self.isCustomerExist || self.last4Digits != "") {
                cell.cardNumber.text = "****\(last4Digits)"
                cell.changeLbl.text = "Change".localized(category: "Tray")
            } else {
                cell.cardNumber.text = "Add Payment".localized(category: "Tray")
            }
            
            guard  let image = self.cardImage else {return cell}
            cell.cardImageView.image = image
            return cell
        //Total
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TotalCell", for: indexPath) as! TotalCell
            cell.subTotal.text = "\(Config.CURRENCY_SIGN)\(Tray.currentTray.getTotal())"
            let address = User.shared.getAddress() 
            if let delivery = Tray.currentTray.restaurant?.deliveryFee {
                cell.delivery.text = "\(Config.CURRENCY_SIGN)\(delivery)"
                cell.address.text = "\(address)"
                cell.total.text = "\(Config.CURRENCY_SIGN)\(Tray.currentTray.getTotal() + delivery)"
            }
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Open restaurant notes view
        if indexPath.section == 1 {
            self.performSegue(withIdentifier: "fromTrayToNotes", sender: "Restaurant")
            return
        }
        
        //Go to payments screen if customer not exist or go to change payments if he do
        if indexPath.section == 2 {
            if(self.isCustomerExist) {
                self.performSegue(withIdentifier: "fromTrayToPaymentChange", sender: self)
            } else {
                self.performSegue(withIdentifier: "fromTrayToPayment", sender: self)
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1, 2, 3:
            return 1
        default:
            return Tray.currentTray.items.count
        }
        
    }
    
  
    //Delete button for item in a cell
    func deleteButtonPressed (sender: AnyObject) {
        guard let cell = sender.superview??.superview as? TrayCell else {
            return
        }
        
        let indexPath = self.tableView.indexPath(for: cell)
        
        let alertView = UIAlertController(
            title: "Delete Item".localized(category: "Tray"),
            message: "Delete Message".localized(category: "Tray"),
            preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Delete".localized(category: "Buttons"), style: .default, handler: { (action: UIAlertAction!) in
            Tray.currentTray.items.remove(at: (indexPath?.row)!)
            self.tableView.deleteRows(at: [indexPath!], with: .fade)
            if (Tray.currentTray.items.count == 0) {self.showContorls(show: false)}
            self.setTrayEmpty()
            self.loadItems()
            self.tableView.reloadData()
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel".localized(category: "Buttons"), style: .default, handler: { (action: UIAlertAction!) in
            
        })
        alertView.addAction(okAction)
        alertView.addAction(cancelAction)
        self.present(alertView, animated: true, completion: nil)
    }
    
    //Edit item in a cell
     func editButtonPressed (sender: AnyObject) {
        guard let cell = sender.superview??.superview as? TrayCell else {
            return
        }
        
        let indexPath = self.tableView.indexPath(for: cell)
        if let index = indexPath {
            let item = Tray.currentTray.items[index.row]
            self.indexPathSelected = index
            performSegue(withIdentifier: "fromTrayToEditItem", sender: item)
        }
       

    }
}


