//
//  PaymentChangeTVC.swift
//  BringMyFood
//
//  Created by elad schwartz on 17/07/2017.
//  Copyright © 2017 elad schwartz. All rights reserved.
//

import UIKit
import SwiftyJSON

class PaymentChangeTVC: UITableViewController {
    
    var creditCards = [CreditCard]()
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Hide empty cells
        self.tableView.tableFooterView = UIView.init()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
       activityIndicator =  Helpers.showActivityIndicator(view: self.view)
       getCreditCards()
    }
    
    //Get a list of customer's credit card
    func getCreditCards(){
        APIManager.shared.getCreditCards() { (json) in
            if (json != JSON.null) {
                if let creditCards = json.array {
                    for card in creditCards {
                        let creditCard = CreditCard(json:card)
                        self.creditCards.append(creditCard)
                    }
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        self.tableView.reloadData()
                    }
                }
            } else {
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return creditCards.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CreditCardCell", for: indexPath)
        cell.textLabel?.text = self.creditCards[indexPath.row].cardName
        cell.detailTextLabel?.text = self.creditCards[indexPath.row].last4Digits
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "unwindToTrayFromCreditCards", sender: self.creditCards[indexPath.row])
        
    }
    
    override  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    //Delete card if there is more than one
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let card = self.creditCards[indexPath.row]
            let okAction = UIAlertAction(title: "OK".localized(category: "Buttons"), style: .default, handler: { (action) in })
            let alertView = UIAlertController(title: "Delete Title".localized(category: "Payment"), message: "Delete Message".localized(category: "Payment"), preferredStyle: .alert)
            alertView.addAction(okAction)
           
            if let cardId = card.id {
                APIManager.shared.deleteCreditCard(cardId: String(cardId)) { (json) in
                    if (self.creditCards.count == 1) {
                         self.present(alertView, animated: true, completion: nil)
                    } else {
                        self.creditCards.remove(at: indexPath.row)
                        self.tableView.deleteRows(at: [indexPath], with: .automatic)
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "unwindToTrayFromCreditCards") {
            let trayTvc = segue.destination as! TrayVC
            let card = sender as! CreditCard
            if let card4Digits = card.last4Digits, let cardImageName = card.cardName {
                trayTvc.last4Digits = card4Digits
                trayTvc.cardImage = UIImage(named: cardImageName.lowercased())
            }
        }
    }
}




