//
//  Addon.swift
//  WhereIsMyFood
//
//  Created by elad schwartz on 06/07/2017.
//  Copyright © 2017 elad schwartz. All rights reserved.
//

import Foundation
import SwiftyJSON

class Addon {
    var id: Int?
    var addonDetailId: Int?
    var name: String?
    var sectionId: Int?
    var price:String?
    var sectionName: String?
    var itemId :String?

    init(id:Int,addonDetailId: Int, name:String, itemId: String, sectionName: String, sectionId: Int, price: String) {
        self.id = id
        self.sectionId = sectionId
        self.price = price
        self.name = name
        self.sectionName = sectionName
        self.itemId = itemId
        self.addonDetailId = addonDetailId
    }
}
