//
//  ApiManager.swift
//  WhereIsMyFood-Driver
//
//  Created by elad schwartz on 25/07/2017.
//  Copyright © 2017 elad schwartz. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import CoreLocation


class APIManager {
    static let shared = APIManager()
    let baseURL = NSURL(string: Config.BASE_URL)
    var httpHeaders = [String: String]() //headers parameter for sending  token

    init() {}
    
    func requestServer(_ method: HTTPMethod,_ path: String,_ params: [String: Any]?,_ encoding: ParameterEncoding,_ completionHandler: @escaping (JSON) -> Void ) {
        let url = baseURL?.appendingPathComponent(path)
        //If token not empty send it with header. else headers will be empty
        if let token = Driver.shared.token {
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
    
    //Get all orders link to this driver
    func getOrders(completionHandler: @escaping (JSON) -> Void) {
        let path = "Api_drivers/get_orders/"
        let params: [String: Any] = [
            "driver_id" : Driver.shared.id ?? ""
        ]
        requestServer(.get, path, params, URLEncoding(), completionHandler)
    }
    
    //Check if driver is in the system
    func isDriverApprvoed(phone: String, completionHandler: @escaping (JSON) -> Void) {
        let path = "Api_drivers/is_driver_approved/"
        let params: [String: Any] = [
            "driver_id" : Driver.shared.id ?? "",
            "phone" : phone
        ]
        requestServer(.post, path, params, URLEncoding(), completionHandler)
    }
    
    
    //Get driver details and create the Driver object
    func getDetailsAndSave(phoneNumber: String, completionHandler: @escaping (JSON) -> Void) {
        self.getDriverDetails(phoneNumber: phoneNumber) { (json) in
            if (json != JSON.null) {
                Helpers.userDefaults.set(true, forKey: "is_login")
                guard let id = json[0]["id"].string,
                    let restaurantId = json[0]["restaurant_id"].string,
                    let phone = json[0] ["phone"].string,
                    let name = json[0] ["driver_name"].string,
                    let latitude = json[0] ["latitude"].string,
                    let longitude = json[0]["longitude"].string,
                    let token = json[0]["token"].string else { return }
                
                Driver.shared.saveDriverDetails(id: id, name: name, phone: phone, token: token, restaurantId: restaurantId, lang: longitude.toDouble(), lat: latitude.toDouble())
                 completionHandler(true)
            }
        }
    }
    
    //Get  drivers details
    func getDriverDetails(phoneNumber: String, completionHandler: @escaping (JSON) -> Void) {
        let path = "Api_drivers/get_driver_details/"
        let params: [String: Any] = [
            "phone" : phoneNumber
        ]
        requestServer(.get, path, params, URLEncoding(), completionHandler)
    }
    
    
    // API - Updating Driver's location
    func updateLocation(location: CLLocationCoordinate2D, completionHandler: @escaping (JSON) -> Void) {
        let path = "Api_drivers/update_location/"
        let params: [String: Any] = [
            "id": Driver.shared.id ?? "",
            "latitude": location.latitude,
            "longitude": location.longitude
        ]
        requestServer(.post, path, params, URLEncoding(), completionHandler)
    }
    
    //Complete Order
    func compeleteOrder(id: String, completionHandler: @escaping (JSON) -> Void) {
        let path = "Api_drivers/complete_order/"
        let params: [String: Any] = [
            "id": id
        ]
        requestServer(.post, path, params, URLEncoding(), completionHandler)
    }
    
    //Set the order id in DB for showing to customer that the driver is now handling his order
    func setActiveOrder(order_id: String, completionHandler: @escaping (JSON) -> Void) {
        let path = "Api_drivers/set_active_order/"
        let params: [String: Any] = [
            "id": order_id,
            "driver_id": Driver.shared.id ?? ""
        ]
        requestServer(.post, path, params, URLEncoding(), completionHandler)
    }
}

