//
//  File.swift
//  WhereIsMyFood
//
//  Created by elad schwartz on 05/08/2017.
//  Copyright © 2017 elad schwartz. All rights reserved.
//

import Foundation
import SwiftyJSON

class Category {
    
    var id: Int?
    var name: String?
    var imageUrl: String?
    
    
    init(id: Int, name: String, imageUrl: String) {
        self.id = id
        self.name = name
        self.imageUrl = imageUrl
    }
    
}
