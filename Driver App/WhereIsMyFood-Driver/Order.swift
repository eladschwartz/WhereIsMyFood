//
//  Order.swift
//  WhereIsMyFood-Driver
//
//  Created by elad schwartz on 25/07/2017.
//  Copyright © 2017 elad schwartz. All rights reserved.
//

import Foundation
import SwiftyJSON



class Order {
    
    var id: String?
    var customerName: String?
    var customerAddress: String?
    var floorNumber: String?
    var apartmentNumber: String?
    var phoneNumber: String?
    
    init(json: JSON) {
        self.id = json["id"].string
        self.customerName = json["customer_name"].string
        self.customerAddress = json["address"].string
        self.floorNumber = json["floor"].string
        self.apartmentNumber = json["apartnum"].string
        self.phoneNumber = json["phone"].string
    }
    
}

extension Bool {
    init(_ number: Int) {
        self.init(number as NSNumber)
    }
}

