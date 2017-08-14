//
//  TrayItem
//  WhereIsMyFood
//
//  Created by elad schwartz on 18/07/2017.
//  Copyright © 2017 elad schwartz. All rights reserved.
//

import Foundation

class TrayItem {
    
    var item: Item
    var qty: Int
    
    init(item: Item, qty: Int) {
        self.item = item
        self.qty = qty
    }
}
