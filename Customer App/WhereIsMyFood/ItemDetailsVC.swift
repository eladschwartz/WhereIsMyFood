// 
//  ItemDetailsViewContainer.swift
// 
//  Created by elad schwartz on 28/05/2017.
//  Copyright © 2017 elad schwartz. All rights reserved.
// 

import UIKit
import SwiftyJSON

class ItemDetailsVC: UIViewController {
    
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var qtyLbl: UILabel!
    @IBOutlet weak var cartBtn: UIBarButtonItem!
    
    var activityIndicator = UIActivityIndicatorView()
    var item: Item!
    var restaurant: Restaurant?
    var isEditMode = false
    var qty = 1
    var itemIndex = 0
    var cellHeights: [IndexPath : CGFloat] = [:]
    var currentTotal: Double = 0.0
    var totalForItem = [Int : Double]()
    var itemImage: UIImage!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorColor = UIColor.clear
        //  hide table and set row height
        self.tableView.isHidden = true
        tableView.rowHeight = UITableViewAutomaticDimension
        // If we not in edit mode load all sections of the item
        if (!isEditMode) {
            guard let itemPrice = item?.price else {
                
                return
            }
            
            currentTotal = itemPrice
            self.priceLbl.text = "\(Config.CURRENCY_SIGN)\(itemPrice)"
            
            self.title = "Item Details".localized(category: "Item Details")
            activityIndicator = Helpers.showActivityIndicator(view: self.view)
            loadSections()
        } else {
            // In edit mode we already have all the item sections, just load the table
            if let price = totalForItem[itemIndex] {
                self.priceLbl.text = "\(price)"
                self.currentTotal = price
            }
            self.tableView.isHidden = false
            stopActivityIndicatior()
        }
        
        
        
        
        // If User is in edit mode, change title of button to Update
        if (isEditMode) {
            self.cartBtn.image = nil
            self.cartBtn.title = "Update"
        }
    }
    
    
    // Loading all the sections and all addons per section
    func loadSections() {
        // clear addons array
        self.item.addons = [Addon]()
        self.item.sections = [Section]()
        
        if (!isEditMode) {
            self.item.addonsSelected = [Addon]()
        }
        
        // Get all section for this item
        guard let itemId = self.item.id else {
            return
        }
        APIManager.shared.getSections(id: itemId) {  (json) in
            // Create Default sections for: item image, item name, item description
            let sec1 = Section(name: "")
            let sec2 = Section(name: "")
            let sec3 = Section(name: "")
            self.item.sections.insert(sec1, at: 0)
            self.item.sections.insert(sec2, at: 1)
            self.item.sections.insert(sec3, at: 2)
            if (json != JSON.null) {
                // Loop over all the sections and put in sections array
                for section in json.array!{
                    guard let sectionId =  Int(section["section_id"].string!),
                        let sectionName = section["section_name"].string,
                        let sectionType = section["type_name"].string else {
                            return
                    }
                    let isRequired = section["is_required"].string! == "1" ? true: false
                    let section = Section(sectionId: sectionId,sectionType: sectionType, sectionName: sectionName, isRequired: isRequired)
                    self.item.sections.append(section)
                }
                
                self.getAddon(itemId: itemId)
            
                if (self.isEditMode){self.checkSelctedAddons()}
            }
        }
    }
    
    func getAddon(itemId: Int) {
        // get all addons for this item and assign them to the correct sections
        APIManager.shared.getAddons(id: itemId) { (json) in
            if (json != JSON.null) {
                for addon in json.array!{
                    guard let addonID =  Int(addon["addon_id"].string!),
                        let addonDetailId =  Int(addon["addon_detail_id"].string!),
                        let addonName = addon["addon_name"].string,
                        let sectionName = addon["section_name"].string,
                        let sectionId = Int(addon["section_id"].string!) else {
                            return
                    }
                    
                    // some addons doesn't have a price
                    var addonPrice = addon["price"].string
                    if (addonPrice == nil) {
                        addonPrice = ""
                    }
                    
                    // Create new addon, search for the section in the array and add the addon to his section
                    let addon = Addon(id: addonID,addonDetailId:addonDetailId, name: addonName, itemId: String(itemId) ,sectionName:sectionName ,sectionId: sectionId, price: addonPrice!)
                    self.item.addons.append(addon)
                    let isSectionExist = self.item.sections.filter{ $0.id == addon.sectionId }.count > 0
                    if (isSectionExist) {
                        let sectionObj = self.item.sections.filter({ $0.id == addon.sectionId }).first
                        sectionObj?.addToDetails(addon:addon)
                    }
                }
                if (!self.isEditMode){
                    self.addRrequiredToArray()
                }
                
                DispatchQueue.main.async() {
                    self.tableView.reloadData()
                    self.tableView.isHidden = false
                    self.stopActivityIndicatior()
                    
                }
            }
        }
    }
    
    
    
    // In Edit Mode - loop over all the selcted addons and change the checkbox image to checked
    func checkSelctedAddons() {
        for section in self.item.sections {
            for i in 0 ..< section.details.count {
                for selected in self.item.addonsSelected {
                    if (selected.id == section.details[i].addon.id) {
                        section.changeChecked(index: i, checked: true)
                    }
                }
            }
        }
        DispatchQueue.main.async(){self.tableView.reloadData()}
    }
    
    
    // If section is required - add the first detail to the array as defualt
    func addRrequiredToArray() {
        let sections = self.item.sections
        for section in sections {
            if (section.isRequired) {
                let addon = section.details[0].addon
                self.item.addonsSelected.append(addon)
            }
        }
    }
    
    
    
    // Add item to the tray
    @IBAction func addToTrayTapped(_ sender: Any) {
        // Get embeded table view controller
        // If user want to change something in the item
        if (isEditMode){
            let trayItem = TrayItem(item: self.item, qty: self.qty)
            Tray.currentTray.items[self.itemIndex] = trayItem
            self.performSegue(withIdentifier: "unwindToTrayFromEdit", sender: self)
        } else {
            // Add new item to tray
            let trayItem = TrayItem(item: self.item, qty: self.qty)
            guard let trayRestaurant = Tray.currentTray.restaurant, let currentRestaurant = self.restaurant else {
                //  If those requirements are not met
                Tray.currentTray.restaurant = self.restaurant
                Tray.currentTray.items.append(trayItem)
                
                self.performSegue(withIdentifier: "unwindToItemList", sender: self)
                return
            }
            
            //  If ordering meal from the same restaurant
            if trayRestaurant.id == currentRestaurant.id {
                Tray.currentTray.items.append(trayItem)
                self.performSegue(withIdentifier: "unwindToItemList", sender: self)
            }
            else {//  If ordering meal from the another restaurant
                
                let alertView = UIAlertController(
                    title: "Start new tray?",
                    message: "You're ordering meal from another restaurant. Would you like to clear the current tray?",
                    preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "New Tray", style: .default, handler: { (action: UIAlertAction!) in
                    
                    Tray.currentTray.items = []
                    Tray.currentTray.items.append(trayItem)
                    Tray.currentTray.restaurant = self.restaurant
                })
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in })
                alertView.addAction(okAction)
                alertView.addAction(cancelAction)
                self.present(alertView, animated: true, completion: nil)
            }
        }
    }
    
    
    // Add 1 to current qty
    @IBAction func plusButtonTapped(_ sender: Any) {
        
        self.qty += 1
        calculateCurrentPrice()
        self.qtyLbl.text =  String(self.qty)
        
    }
    
    // Substract 1 from current qty
    @IBAction func minusButtonTapped(_ sender: Any) {
        if (self.qty >= 2) {
            self.qty -= 1
            calculateCurrentPrice()
            self.qtyLbl.text =  String(self.qty)
        }
    }
    
    func calculateCurrentPrice() {
        if let price = item.price {
            if (item.addonsSelected.count == 0 ) {
                currentTotal =  price * Double(self.qty)
                self.priceLbl.text = "\(Config.CURRENCY_SIGN)\(currentTotal)"
            } else {
                let totalAddons = item.getAddonsSeletedTotal()
                currentTotal =  (price + totalAddons) * Double(self.qty)
                self.priceLbl.text = "\(Config.CURRENCY_SIGN)\(currentTotal)"
            }
        }
    }
    
    func stopActivityIndicatior() {
        self.activityIndicator.stopAnimating()
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ItemDetialsEmbded") {
            let controller = segue.destination as! ItemDetailsVC
            controller.item =  item
            controller.restaurant = restaurant
            controller.qty = self.qty
            controller.isEditMode = self.isEditMode
        }
    }
}

extension ItemDetailsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.item.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0, 1, 2:
            return 1
        default:
            return (self.item.sections[section].details.count)
        }
    }
    
    // Save the cell height so that later when table reloads will not jump back to top
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section != 0 {
            cellHeights[indexPath] = cell.frame.size.height
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 314
        }
        
        guard let height = cellHeights[indexPath] else { return 20.0 }
        return height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        // Item Image
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemImageCell", for: indexPath) as! ItemImageCell
            cell.itemImage.image = self.itemImage
            return cell
        // Item Name
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemNameCell", for: indexPath)
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.text = item.name
            cell.textLabel?.font = UIFont(name:"Raleway", size: 17)
            cell.textLabel?.textColor = UIColor(red:0.97, green:0.72, blue:0.39, alpha:1.0)
            return cell
        // Item Description
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemDescriptionCell", for: indexPath)
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.lineBreakMode = .byWordWrapping
            cell.textLabel?.text = item.description
            cell.textLabel?.font = UIFont(name:"Raleway", size: 17)
            cell.textLabel?.textColor = UIColor(red:0.97, green:0.72, blue:0.39, alpha:1.0)
            return cell
        // Item Addons Information
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemDetailsCell", for: indexPath) as! ItemDetailsCell
            let section = self.item.sections[indexPath.section]
            let details = section.details[indexPath.row]
            let price = details.addon.price
            cell.selectionStyle = .none
            cell.nameLbl.text = details.addon.name
            cell.checkBoxImage.image = details.isChecked ? UIImage(named: "btn_checked") : UIImage(named: "btn_not_checked")
            
            if (price == "") {
                cell.priceLbl.text = ""
                cell.priceLbl.isHidden = true
            } else {
                cell.priceLbl.isHidden = false
                cell.priceLbl.text = "+" + Config.CURRENCY_SIGN + price!
            }
            cell.nameLbl.font = details.isChecked ? UIFont(name:"Raleway-Bold", size: 17) : UIFont(name:"Raleway", size: 17)
            cell.priceLbl.font = details.isChecked ? UIFont(name:"Raleway-Bold", size: 17) : UIFont(name:"Raleway", size: 17)
            cell.nameLbl?.textColor = UIColor(red:0.97, green:0.72, blue:0.39, alpha:1.0)
            cell.priceLbl?.textColor = UIColor(red:0.97, green:0.72, blue:0.39, alpha:1.0)
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // if user click on a addon in details section(0,1,2 are the image, name of item and the description = not clickable)
        if (indexPath.section > 2) {
            let clickedcell = tableView.cellForRow(at: indexPath ) as! ItemDetailsCell
            cellClicked(clickedcell: clickedcell, indexPath: indexPath )
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor(red:0.97, green:0.72, blue:0.39, alpha:1.0)
        let label = UILabel()
        label.frame = CGRect(x: 20, y: 3, width: 400, height: 30)
        if let sectionName = self.item.sections[section].name {
            if (self.item.sections[section].isRequired) {
                label.text = sectionName + " - " + "Required"
            } else {
                label.text = sectionName
            }
        }
        
        view.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        switch section {
        // Don't show section title for the first 3 sections
        case 0, 1, 2:
            return 0
        default:
            return 30
        }
    }
    
    // Click on a addon in addons sections
    func cellClicked(clickedcell: ItemDetailsCell, indexPath: IndexPath) {
        let isChecked = self.item.sections[indexPath.section].details[indexPath.row].isChecked
        let isRequired = self.item.sections[indexPath.section].isRequired
        let addon = self.item.sections[indexPath.section].details[indexPath.row].addon
        guard let addonPrice = self.item.sections[indexPath.section].details[indexPath.row].addon.price,
            let sectionType = self.item.sections[indexPath.section].type,
            let addonId = self.item.sections[indexPath.section].details[indexPath.row].addon.id else {
                return
        }
        
        switch sectionType {
        // In this section user can choose multiple addons
        case .Multi:
            handleMultipleSelection(indexPath: indexPath, isChecked: isChecked, isRequired: isRequired, addon: addon, addonPrice: addonPrice, addonId: addonId)
        // In this section user can chopse only single addon
        case .Single:
            handleSingleSelection(indexPath: indexPath, isChecked: isChecked, isRequired: isRequired, addon: addon, addonPrice: addonPrice, addonId: addonId)
        }
        
    }
    
    
    func handleMultipleSelection(indexPath: IndexPath, isChecked: Bool, isRequired: Bool, addon: Addon, addonPrice: String, addonId: Int) {
        // If addon is not selected and user selected it
        if (!isChecked) {
            //  if addon was selcted - insert addon to our array of selected addons
            self.item.addonsSelected.append(addon)
            self.item.sections[indexPath.section].details[indexPath.row].isChecked = true
            //  if addon has price -  send notifction to our view container to update the price lable
            if (addonPrice != "") {
                self.priceLbl.text = "\(Config.CURRENCY_SIGN)\(currentTotal + (addonPrice.toDouble() * Double(self.qty)))"
                currentTotal += addonPrice.toDouble() * Double(self.qty)
            }
            self.tableView.reloadData()
            // Else - if addon is alreay selected and uesr deselect it
        } else {
            // find the addon in array and filter it
            let newarray =  self.item.addonsSelected.filter{$0.id != addonId}
            self.item.addonsSelected = newarray
            self.item.sections[indexPath.section].details[indexPath.row].isChecked = false
            if (addonPrice != "") {
                self.priceLbl.text = "\(Config.CURRENCY_SIGN)\(currentTotal - (addonPrice.toDouble() * Double(self.qty)))"
                currentTotal -= addonPrice.toDouble() * Double(self.qty)
            }
             self.tableView.reloadData()
        }
        
    }
    
    
    func handleSingleSelection(indexPath: IndexPath, isChecked: Bool, isRequired: Bool, addon: Addon, addonPrice: String, addonId: Int) {
        let section = self.item.sections[indexPath.section]
        //  if addon is not selected and user selected it
        if (!isChecked) {
            // loop over the section addons and unchecked the other checkboxs
            let count = self.item.sections[indexPath.section].details.count
            var index = 0
            var checkedAddonId = 0
            for i in 0 ..< count {
                let detail = section.details[i]
                if detail.addon.id == addonId {index = i}
                if (detail.isChecked) {
                    guard let addonCheckedId = detail.addon.id,
                          let addonCheckedPrice = detail.addon.price else {
                            return
                    }
                    checkedAddonId = addonCheckedId
                    if let price = detail.addon.price {
                        // if one of the addon we want to remove was previously selcted, substract it's price
                        if (price != "") {
                            self.priceLbl.text = "\(Config.CURRENCY_SIGN)\(currentTotal - (addonCheckedPrice.toDouble() * Double(self.qty)))"
                            currentTotal -= addonCheckedPrice.toDouble()  * Double(self.qty)
                        }
                    }
                    // get new array with the new selected addon
                    let newarray =  self.item.addonsSelected.filter{$0.id != addonCheckedId}
                    self.item.addonsSelected = newarray
                }
                section.changeChecked(index: i, checked: false)
            }
            if (isRequired) {
                // remove defualt addon from the array
                let filteredArray =  self.item.addonsSelected.filter{$0.id != checkedAddonId}
                self.item.addonsSelected = filteredArray
            }
            section.changeChecked(index: index, checked: true)
            self.item.addonsSelected.append(addon)
            if (addonPrice != "") {
                var pricelbl =  self.priceLbl.text
                pricelbl?.remove(at: (pricelbl?.startIndex)!)
                self.priceLbl.text = "\(Config.CURRENCY_SIGN)\(currentTotal + (addonPrice.toDouble() * Double(self.qty)))"
                currentTotal += addonPrice.toDouble() * Double(self.qty)
            }
             self.tableView.reloadData()
            
        } else {
            // If the section is required don't let user unchecked a checked option
            if (isRequired) {
                return
            }
            let newarray =  self.item.addonsSelected.filter{$0.id != addonId}
            self.item.addonsSelected = newarray
            self.item.sections[indexPath.section].details[indexPath.row].isChecked = false
            if (addonPrice != "") {
                self.priceLbl.text = "\(Config.CURRENCY_SIGN)\(currentTotal - (addonPrice.toDouble() * Double(self.qty)))"
                currentTotal -= addonPrice.toDouble() * Double(self.qty)
            }
             self.tableView.reloadData()
        }
    }
}
