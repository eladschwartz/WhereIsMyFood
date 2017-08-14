//
//  CreditCard.swift
//  BringMyFood
//
//  Created by elad schwartz on 17/07/2017.
//  Copyright © 2017 elad schwartz. All rights reserved.
//

import Foundation
import SwiftyJSON

class CreditCard {
    
    var id: Int?
    var cardName: String?
    var last4Digits: String?
 
    
    init(json: JSON) {
        self.id = Int(json["id"].string!)
        self.cardName = json["card"].string
        self.last4Digits = json["last4"].string
    }
    
}


