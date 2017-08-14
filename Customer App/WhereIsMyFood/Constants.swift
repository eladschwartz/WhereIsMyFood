//
//  Constants.swift
//  WhereIsMyFood
//
//  Created by elad schwartz on 19/04/2017.
//  Copyright © 2017 elad schwartz. All rights reserved.
//

import Foundation

enum Config {
    static let BASE_URL: String = "http://whereismyfood.biz"
    static let STRIPE_KEY = "" //Enter the key you get from Stripe
    static let SINCH_KEY = "" //Enter the key you get from  Sinch
    static let UID = UIDevice.current.identifierForVendor!.uuidString
    static var CURRENCY_SIGN = "" //Currency is set in the admin panel by the restaurant
    static var ORDER_ACTIVE_TIMER_INTERVAL: TimeInterval = 10 //Timer that will check if the the current order is the active one(= driver took the order)
    static var DRIVER_TIMER_INTERVAL: TimeInterval = 10 // Timer that will check the location of the driver
}


