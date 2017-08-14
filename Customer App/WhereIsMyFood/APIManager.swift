// 
//   APIManager.swift
//   WhereIsMyFood
// 
//   Created by elad schwartz on 19/04/2017.
//   Copyright © 2017 elad schwartz. All rights reserved.
// 

import Foundation
import SwiftyJSON
import Alamofire
import AlamofireImage


class APIManager {
    static let shared = APIManager()
    let baseURL = NSURL(string: Config.BASE_URL)
    let imageCache = AutoPurgingImageCache()
    var httpHeaders = [String: String]() // headers parameter for sending  token
    
    init() {}
    
    
    // Master function fore seding request
    func requestServer(_ method: HTTPMethod,_ path: String,_ params: [String: Any]?,_ encoding: ParameterEncoding,_ completionHandler: @escaping (JSON) -> Void ) {
        let url = self.baseURL?.appendingPathComponent(path)
        if let token = User.shared.token {
            if token != ""{
                httpHeaders["Authorization"] = "Bearer " + token
            }
        }
        Alamofire.request(url!, method: method, parameters: params, encoding: encoding, headers: self.httpHeaders).responseJSON{ response in
            switch response.result {
            case .success(let value):
                let jsonData = JSON(value)
                completionHandler(jsonData)
                break
            case .failure:
                print(response.error.debugDescription)
                completionHandler(JSON.null)
                break
            }
        }
    }
    
    
    // Get image from server
    func loadImage(itemName: String, itemId: Int, imgUrl: URL,_ completionHandler: @escaping (UIImage) -> Void) {
        let imageIdentfier = itemName + "-" + String(itemId)
        
        if let cachedImage = imageCache.image(withIdentifier: imageIdentfier) {
            completionHandler(cachedImage)
        } else {
            Alamofire.request(imgUrl).responseImage { response in
                switch response.result {
                case .success(let value):
                    let image = value
                    self.imageCache.add(image, withIdentifier: imageIdentfier)
                    completionHandler(image)
                    break
                case .failure(let error):
                    print(imgUrl)
                    print(error)
                    completionHandler(UIImage())
                    break
                }
            }
        }
    }
    
    // Get Settings
    func isSingleBranch(completionHandler: @escaping (JSON) -> Void){
        let path = "Api/get_is_single_branch/"
        requestServer(.get, path, nil, URLEncoding(), completionHandler)
    }
    
    func getCurrency(completionHandler: @escaping (JSON) -> Void) {
        let path = "Api/get_currency/"
        requestServer(.get, path, nil, URLEncoding(), completionHandler)
    }
    
    
    //   ---------- Customers ------- // 
    
    //  Save Customer details
    func saveUserDetailsToDB(name: String, email: String, phone: String,address: Address , completionHandler: @escaping (JSON) -> Void) {
        let path = "Api/save_user/"
        if let uid = UIDevice.current.identifierForVendor?.uuidString {
            let parameters: Parameters = [
                "uid": uid,
                "customer_name": name,
                "email": email,
                "city": address.city ?? "",
                "country": address.country ?? "",
                "state": address.state ?? "",
                "zip_code": address.zipCode ?? "",
                "address": address.address ?? "",
                "floor": address.floor ?? "",
                "apartnum": address.apartmentNumber ?? "",
                "phone": phone
            ]
            requestServer(.post, path, parameters, URLEncoding(), completionHandler)
        }
    }
    
    // Update Customer details
    func updateUserDetails(name: String, email: String, phone: String,address: Address , completionHandler: @escaping (JSON) -> Void) {
        let path = "Api/update_user/"
        let parameters: Parameters = [
                "customer_name": name,
                "email": email,
                "city": address.city ?? "",
                "country": address.country ?? "",
                "state": address.state ?? "",
                "zip_code": address.zipCode ?? "",
                "address": address.address ?? "",
                "floor": address.floor ?? "",
                "apartnum": address.apartmentNumber ?? "",
                "phone": phone,
                "customer_id": User.shared.id ?? ""
            ]
            requestServer(.post, path, parameters, URLEncoding(), completionHandler)
        
    }
    
    
    
    // Check if customer is already in DB
    func isCustomerExist(phone: String, completionHandler: @escaping (JSON) -> Void) {
        let parameters: Parameters = [
            "phone": phone
        ]
        
        let path = "Api/get_customer_uid"
        requestServer(.get, path, parameters, URLEncoding(), completionHandler)
    }
    
    // Get customer details
    func getCustomerDetails(phone: String, completionHandler: @escaping (JSON) -> Void) {
        let parameters: Parameters = [
            "phone": phone
        ]
        
        let path = "Api/get_customer_details"
        requestServer(.get, path, parameters, URLEncoding(), completionHandler)
    }
    
    // Get customer details and create the User object
    func getDetailsAndSave(phone: String, completionHandler: @escaping (JSON) -> Void) {
        self.getCustomerDetails(phone: phone) { (json) in
            guard let id = json[0]["id"].string,
                let name = json[0]["customer_name"].string,
                let email = json[0] ["email"].string,
                let phone = json[0] ["phone"].string,
                let customerAddress = json[0]["address"].string,
                let floor = json[0]["floor"].string,
                let apartnum = json[0]["apartnum"].string,
                let country = json[0]["country"].string,
                let city = json[0]["city"].string,
                let token = json[0]["token"].string else {
                    return completionHandler(false)
            }
            
            var zipCode: String!
            var state: String!
            
            zipCode = json[0]["zip_code"].string
            state = json[0]["state"].string
            
            if zipCode == nil {zipCode = ""}
            if state == nil {state = ""}
            
            let address = Address(city: city, state: state, country: country, zipCode: zipCode, address: customerAddress, floor: floor, apartmentNumber: apartnum)
            
            User.shared.saveUserDetails(id: id, name: name, email: email, phone: phone, token: token, address: address)
            Helpers.userDefaults.set(true, forKey: "is_login")
            Helpers.userDefaults.set(phone, forKey: "phone_num")
            completionHandler(true)
        }
    }
    
    
    // Check if customer has already entered credit card before
    func isCustomerStripe(completionHandler: @escaping (JSON) -> Void) {
        let parameters: Parameters = [
            "customer_id": User.shared.id ?? ""
        ]
        
        let path = "Api_stripe/is_stripe_customer"
        requestServer(.post, path, parameters, URLEncoding(), completionHandler)
        
    }
    
    // Get all credit cards for a customer
    func getCreditCards(completionHandler: @escaping (JSON) -> Void) {
        let parameters: Parameters = [
            "customer_id": User.shared.id ?? ""
        ]
        
        let path = "Api_stripe/get_credit_cards"
        requestServer(.post, path, parameters, URLEncoding(), completionHandler)
    }
    
    // Delete a single credit card from saved card
    func deleteCreditCard(cardId: String, completionHandler: @escaping (JSON) -> Void) {
        let parameters: Parameters = [
            "card_id": cardId,
            ]
        
        let path = "Api_stripe/delete_credit_card"
        requestServer(.post, path, parameters, URLEncoding(), completionHandler)
    }
    
    // Delete stripe cards informaion
    func deleteStripeCard(customerId: String, completionHandler: @escaping (JSON) -> Void) {
        let parameters: Parameters = [
            "customer_id":customerId,
            "uid": Config.UID
        ]
        
        let path = "Api/delete_stripe_cards"
        requestServer(.post, path, parameters, URLEncoding(), completionHandler)
        
    }
    
    func saveNewAddress(address: String, floor: String, apartNum: String, completionHandler: @escaping (JSON) -> Void) {
        let parameters: Parameters = [
            "customer_id": User.shared.id ?? "",
            "address": address,
            "floor": floor,
            "apartnum": apartNum
        ]
        
        let path = "Api/save_new_address"
        requestServer(.post, path, parameters, URLEncoding(), completionHandler)
        
    }
    
    //  ---------- END - Customers ------- // 
    
    
    
    //  ---------- Restaurants ------- // 
    
    // Get Resturant List
    func getRestaurants(completionHandler: @escaping (JSON) -> Void){
        let path = "Api/get_restaurants/"
        requestServer(.get, path, nil, URLEncoding(), completionHandler)
    }
    
    // Get a single restaurant
    func getRestaurant(completionHandler: @escaping (JSON) -> Void){
        let path = "Api/get_restaurant/"
        requestServer(.get, path, nil, URLEncoding(), completionHandler)
    }
    
    
    // Get Items List
    func getItems(restaurant_id: Int, category_id: Int, completionHandler: @escaping (JSON) -> Void){
        let parameters: Parameters = ["restaurant_id": restaurant_id, "category_id": category_id]
        let path = "Api/get_menu_items/"
        requestServer(.get, path, parameters, URLEncoding(), completionHandler)
    }
    // Get all addons for an item
    func getAddons(id: Int, completionHandler: @escaping (JSON) -> Void){
        let parameters: Parameters = ["id": id]
        let path = "Api/get_addons_by_item/"
        requestServer(.get, path, parameters, URLEncoding(), completionHandler)
    }
    // Get single section by id
    func getSection(id: Int, completionHandler: @escaping (JSON) -> Void){
        let parameters: Parameters = ["id": id]
        let path = "Api/get_section_by_id/"
        requestServer(.get, path, parameters, URLEncoding(), completionHandler)
    }
    // Get all the sections for an item
    func getSections(id: Int, completionHandler: @escaping (JSON) -> Void){
        let parameters: Parameters = ["id": id]
        let path = "Api/get_sections_by_item/"
        requestServer(.get, path, parameters, URLEncoding(), completionHandler)
    }
    
    // Get all the catgeories for a restaurant
    func getItemsCategories(completionHandler: @escaping (JSON) -> Void){
        let path = "Api/get_menu_items_categories/"
        requestServer(.get, path, nil, URLEncoding(), completionHandler)
    }
    
    //  ---------- END - Restaurants ------- // 
    
    //  ---------- Orders ------- // 
    
    // Create and order
    func createOrder(stripeToken: String, isNewCard: Bool, last4Digits: String, completionHandler: @escaping (JSON) -> Void){
        let itemsarr = Tray.currentTray.items
        var jsonarr = [[String : Any]]()
        
        // Loop all items in tray and for each item get the addons selcted and insert to a dict
        for i in 0 ..< itemsarr.count {
            let trayItem = itemsarr[i]
            var addonsDict = [[String : String]]()
            var arr = [String : Any]()
            arr["item_id"] = trayItem.item.id
            arr["quantity"] = trayItem.qty
            arr["item_price"] = trayItem.item.price
            let addons = trayItem.item.addonsSelected
            for addon in addons {
                var dict = [String : String]()
                dict["adddon_name"] = addon.name
                dict["adddon_id"] = String(describing: addon.id!)
                dict["price"] = String(describing: addon.price!)
                dict["item_id"] = addon.itemId
                dict["addon_detail_id"] =  String(describing: addon.addonDetailId!)
                addonsDict.append(dict)
            }
            jsonarr.append(arr)
            jsonarr[i]["addons"] = addonsDict
        }
        
        // Convert the dict to a json object and send to the server
        if JSONSerialization.isValidJSONObject(jsonarr) {
            do {
                let data = try JSONSerialization.data(withJSONObject: jsonarr, options: [])
                if  let dataString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                    guard let restaurantId = Tray.currentTray.restaurant?.id,
                          let deliveryFee = Tray.currentTray.restaurant?.deliveryFee else  { return }
                    
                    let parameters: Parameters = [
                        "order_details": dataString,
                        "stripe_token": stripeToken,
                        "restaurant_id": restaurantId,
                        "address": User.shared.getAddress(),
                        "address_floor": User.shared.address?.floor ?? "" ,
                        "address_aprt": User.shared.address?.apartmentNumber ?? "",
                        "total" : Tray.currentTray.getTotal() + deliveryFee,
                        "customer_id": User.shared.id ?? "",
                        "restaurant_notes": Tray.currentTray.restaurantNotes,
                        "email": User.shared.email ?? "",
                        "customer_name": User.shared.name ?? "",
                        "is_new_card": isNewCard,
                        "last_4_digits": last4Digits
                    ]
                    
                    let path = "Api_stripe/create_order"
                    requestServer(.post, path, parameters, URLEncoding(), completionHandler)
                }
            }
            catch {
                print("JSON serialization failed: \(error)")
            }
        }
    }
    
    // Getting the latest order (Customer)
    func getLatestOrder(completionHandler: @escaping (JSON) -> Void) {
        let path = "Api/get_last_order"
        let params: [String: Any] = [
            "customer_id" : User.shared.id ?? ""
        ]
        requestServer(.get, path, params, URLEncoding(), completionHandler)
    }
    
    // Check if there is already an open order
    func ifOrderExist(completionHandler: @escaping (JSON) -> Void) {
        let path = "Api/if_order_exist"
        let params: [String: Any] = [
            "customer_id" : User.shared.id ?? ""
        ]
        requestServer(.get, path, params, URLEncoding(), completionHandler)
    }
    
    // Get driver location
    func getDriverLocation(completionHandler: @escaping (JSON) -> Void) {
        let path = "Api/get_driver_location"
        let params: [String: Any] = [
            "order_id" :Helpers.userDefaults.string(forKey: "order_id")!
        ]
        requestServer(.get, path, params, URLEncoding(), completionHandler)
    }
    
    // Check if driver chose our order for delivery
    func isActiveOrder(completionHandler: @escaping (JSON) -> Void) {
        let path = "Api/is_active_order"
        let params: [String: Any] = [
            "order_id" :Helpers.userDefaults.string(forKey: "order_id")!
        ]
        requestServer(.get, path, params, URLEncoding(), completionHandler)
    }
    
    //  ---------- END - Orders ------- // 
    
}
