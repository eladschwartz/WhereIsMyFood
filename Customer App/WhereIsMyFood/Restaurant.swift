//
//  Restaurant.swift
//  WhereIsMyFood
//
//  Created by elad schwartz on 19/04/2017.
//  Copyright © 2017 elad schwartz. All rights reserved.
//

import Foundation
import SwiftyJSON



class Restaurant {
    
    var id: Int?
    var name: String?
    var address: String?
    var image: String?
    var active: Bool?
    var phoneNumber: String?
    var deliveryFee: Double?
    
    init(json: JSON) {
        self.id = Int(json["id"].string!)
        self.name = json["restaurant_name"].string
        self.address = json["restaurant_address"].string
        self.image = json["image"].string
        self.active = Bool.init(json["active"].string!)
        self.phoneNumber = json["phone_number"].string
        self.deliveryFee = Double(json["delivery_fee"].string!)
    }
    
}

extension Bool {
    init(_ number: Int) {
        self.init(number as NSNumber)
    }
}
