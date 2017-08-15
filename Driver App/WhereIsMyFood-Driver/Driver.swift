//
//  Driver.swift
//  WhereIsMyFood-Driver
//
//  Created by elad schwartz on 25/07/2017.
//  Copyright © 2017 elad schwartz. All rights reserved.
//

import Foundation
import CoreLocation

final class Driver {
    var id: String?
    var restaurantId: String?
    var name: String?
    var phone: String?
    var token: String?
    var location : CLLocationCoordinate2D?
    
    
    private init() {}
    
    static let shared = Driver()
    
    
    func saveDriverDetails(id: String, name: String, phone:String, token: String, restaurantId: String, lang: Double, lat: Double ) {
        self.id = id
        self.name = name
        self.phone = phone
        self.token = token
        self.restaurantId = restaurantId
        self.location?.latitude = lat
        self.location?.longitude = lang
    }
    
}
