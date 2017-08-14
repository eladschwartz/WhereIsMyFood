//
//  RestaurantVC.swift
//  BringMyFood
//
//  Created by elad schwartz on 17/04/2017.
//  Copyright © 2017 elad schwartz. All rights reserved.
//

import UIKit
import SwiftyJSON

class RestaurantVC: UIViewController  {
    
    @IBOutlet weak var searchRestaurantBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    @IBAction func unwindToRestaurants(segue: UIStoryboardSegue) {}
    
    var restaurants = [Restaurant]()
    var filteredResturants = [Restaurant]()
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator = Helpers.showActivityIndicator(view: self.view)
        //Get customer details and token - then load restaurants
        if let phoneNumber = Helpers.userDefaults.string(forKey: "phone_num") {
            APIManager.shared.getDetailsAndSave(phone: phoneNumber){ (json) in
                self.title = "RestaurantsTitle".localized(category: "Restaurants")
                self.searchRestaurantBar.placeholder = "Search Restaurant".localized(category: "Restaurants")
                self.hideKeyboardWhenTappedAround()
                //Show menu with swipe Gesture
                self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
                if self.revealViewController() != nil {
                    self.menuBarButton = Helpers.initMenuBtn(controller: self, barBtn: self.menuBarButton)
                }
                self.loadRestaurants()
            }
        }
    }
    
    //Get all restaurants
    func loadRestaurants() {
        APIManager.shared.getRestaurants{ (json) in
            if (json == JSON.null) {
                return
            }
            
            self.restaurants = []
            if let listRes = json.array {
                for item in listRes {
                    let restaurant = Restaurant(json:item)
                    self.restaurants.append(restaurant)
                }
                DispatchQueue.main.async(){
                    self.tableView.reloadData()
                    self.activityIndicator.stopAnimating()
                }
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FromResturantToCategories" {
            let categorytVC = segue.destination as! CategoriesVC
            categorytVC.restaurant = restaurants[(tableView.indexPathForSelectedRow?.row)!]
        }
    }
    
}


extension RestaurantVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rowsCount = searchRestaurantBar.text != "" ? self.filteredResturants.count : self.restaurants.count
        return rowsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell", for: indexPath) as! RestaurantCell
        var restaurant: Restaurant
        
        //If user search for a restaurant show filtered results
        restaurant = searchRestaurantBar.text != "" ? filteredResturants[indexPath.row] : restaurants[indexPath.row]
        
        guard let restaurantName = restaurant.name, let restaurantId = restaurant.id, let restaurantAddress = restaurant.address,
            let _ = restaurant.phoneNumber else {
                return cell
        }
        
        cell.restaurantNameLbl.text = restaurantName
        cell.restaurantAddress.text = restaurantAddress
        cell.backgroundColor = Helpers.viewColor
        
        //Load restaurant image. if there isn't none use default image
        if let imageName = restaurant.image {
            if (imageName != "UPLOAD IMAGE"){
                let url = "\(imageName)"
                if let imageUrl = URL(string: url) {
                    APIManager.shared.loadImage(itemName: restaurantName, itemId: restaurantId, imgUrl: imageUrl, { (image) in
                        cell.restaurantImage.image = image
                    })
                }
                
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "FromResturantToCategories", sender: self)
    }
}

extension RestaurantVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredResturants = self.restaurants.filter({ (res: Restaurant) -> Bool in
            return res.name?.lowercased().range(of:searchText.lowercased()) != nil
        })
        self.tableView.reloadData()
    }
}

