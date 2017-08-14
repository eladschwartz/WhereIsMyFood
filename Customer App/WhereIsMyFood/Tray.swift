//
//  Tray.swift
//  WhereIsMyFood
//
//  Created by elad schwartz on 30/04/2017.
//  Copyright © 2017 elad schwartz. All rights reserved.
//

import Foundation

class Tray {
    static let currentTray = Tray()
    
    var restaurant: Restaurant?
    var items = [TrayItem]()
    var address : [String : String]?
    var restaurantNotes = ""
    
    //Get the total price of all the items + addons selected
    func getTotal() -> Double {
        var total: Double = 0
        var totalAddons: Double = 0
        //get total price of items
        for itemtray in self.items {
            if let price =  itemtray.item.price {
                 total = total + Double(itemtray.qty) * price
            }
           
        }
        
        //get total price of addons
        for trayitem in self.items {
            for addon in trayitem.item.addonsSelected {
                if let addonPrice = addon.price, addon.price != "" {
                    totalAddons = totalAddons + ( (addonPrice).toDouble() * Double(trayitem.qty) )
                }
            }
        }
        return total + totalAddons
    }
    
    
    func reset() {
        self.restaurant = nil
        self.items = []
        self.address = nil
    }
}
