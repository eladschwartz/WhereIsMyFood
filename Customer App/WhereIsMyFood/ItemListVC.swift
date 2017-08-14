//
//  ItemListVC.swift
//  BringMyFood
//
//  Created by elad schwartz on 13/05/2017.
//  Copyright © 2017 elad schwartz. All rights reserved.
//

import UIKit
import SwiftyJSON


class ItemListVC: UIViewController {
    @IBOutlet weak var searchItemBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBAction func unwindToItemList(segue: UIStoryboardSegue) {}
    @IBOutlet weak var priceBtn: UIBarButtonItem! // Only for showing the price...dosn't do anything
    
    var activityIndicator = UIActivityIndicatorView()
    var restaurant: Restaurant?
    var items = [Item]()
    var filteredItems = [Item]()
    var indexpath = 0 // Index for row seleted
    var categoryId = 1
    var itemImage = UIImage()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchItemBar.placeholder = "Search item".localized(category: "Items")
        self.hideKeyboardWhenTappedAround()
        if let restaurantName = restaurant?.name {
            self.navigationItem.title = restaurantName
        }
        //Hide empty cells
         self.tableView.tableFooterView = UIView.init()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadItems()
        self.tableView.isHidden = true
        activityIndicator = Helpers.showActivityIndicator(view: self.view)
        self.priceBtn.title = "\(Config.CURRENCY_SIGN)\(Tray.currentTray.getTotal())"
    }
    

    
    func loadItems() {
        if let restaurantId = restaurant?.id {
            APIManager.shared.getItems(restaurant_id: restaurantId, category_id: categoryId, completionHandler: { (json) in
                if (json != JSON.null) {
                    self.items = []
                    if let listItems = json.array {
                        for item in listItems {
                            guard let itemID = item["id"].string,
                                let ItemName = item["item_name"].string,
                                let resturantId = item["restaurant_id"].string,
                                let categoryId = item["category_id"].string,
                                let description = item["description"].string,
                                let itemImage = item["image"].string,
                                let itemPrice = item["price"].string,
                                let isDiscount = item["is_discount"].string,
                                let discountRate = item["discount_rate"].string,
                                let show = item["show_menu"].string else {
                                    return
                            }
                            let menuItem = Item(id: itemID, resturantId: resturantId, categoryId: categoryId, name: ItemName, description: description, imageUrl: itemImage, price: itemPrice, isDiscount: isDiscount, discountRate: discountRate, show: show)
                            self.items.append(menuItem)
                        }
                        if (self.items.count == 0) {
                            //show text that there isn't Items
                        }
                        DispatchQueue.main.async(){
                            self.tableView.reloadData()
                            self.tableView.isHidden = false
                            self.activityIndicator.stopAnimating()
                        }
                        
                    }
                }
            })
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "fromItemsToItemDetails") {
            let controller = segue.destination as! ItemDetailsVC
            controller.item =  self.items[self.indexpath]
            controller.restaurant = restaurant
            controller.itemImage = self.itemImage
        }
    }
    
    
    @IBAction func viewTrayBtn(_ sender: Any) {
        self.performSegue(withIdentifier: "FromItemListToTray", sender: self)
    }
    
    
}


extension ItemListVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchItemBar.text != "" {
            return self.filteredItems.count
        }
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"ItemCell", for: indexPath) as! ItemCell
        let item: Item
        //If user search for a restaurant filter results
        item = searchItemBar.text != ""  ? filteredItems[indexPath.row] : items[indexPath.row]
        cell.configCell(item: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.indexpath = indexPath.row
        let clickedcell = tableView.cellForRow(at: indexPath ) as! ItemCell
        if let image = clickedcell.itemImage.image {
             self.itemImage = image
        }
       
        performSegue(withIdentifier: "fromItemsToItemDetails", sender: self)
    }
    
}

extension ItemListVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredItems = self.items.filter({ (item: Item) -> Bool in
            return item.name?.lowercased().range(of:searchText.lowercased()) != nil
        })
        self.tableView.reloadData()
    }
}
