//
//  ItemCategory.swift
//  WhereIsMyFood
//
//  Created by elad schwartz on 30/04/2017.
//  Copyright © 2017 elad schwartz. All rights reserved.
//

import Foundation
import SwiftyJSON

class ItemCategory {
    var id: Int?
    var name: String?
    var image: String?

    
    init(json:JSON) {
        self.id = json["id"].int
        self.name = json["item_name"].string
        self.image = json["image"].string
    }
}
