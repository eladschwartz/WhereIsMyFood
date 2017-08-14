//
//  Item.swift
//  WhereIsMyFood
//
//  Created by elad schwartz on 29/04/2017.
//  Copyright © 2017 elad schwartz. All rights reserved.
//

import Foundation
import SwiftyJSON

class Item {
    var id: Int?
    var restaurantId: Int?
    var categoryId: Int?
    var name: String?
    var description: String?
    var imageUrl: String?
    var price: Double?
    var isDiscount: Bool?
    var discountRate: Double?
    var show: Bool?
    var sections =  [Section]()
    var addons = [Addon]()
    var addonsSelected = [Addon]()
  
    init (id: String, resturantId: String, categoryId: String, name: String, description: String, imageUrl: String, price: String, isDiscount: String, discountRate: String, show: String ) {
        self.id = Int(id)
        self.restaurantId = Int(resturantId)
        self.categoryId = Int(categoryId)
        self.name = name
        self.description = description
        self.imageUrl = imageUrl
        self.isDiscount = Bool.init(Int(isDiscount)!)
        self.discountRate = Double(discountRate)
        if (self.isDiscount)! {
            self.price = Double(price)! - (Double(price)! * Double(self.discountRate!/100))
        }else {
            self.price = Double(price)
        }
       
        self.show = Bool.init(Int(show)!)
    }
    
    //Getting the total price for all the adoons the user selcted(and skip addons without price)
    func getAddonsSeletedTotal() -> Double {
        var total: Double = 0
        for addon in self.addonsSelected {
            if let price = addon.price, addon.price != "" {
                total +=  Double(price)!
            }
        }
         return total
    }
}
