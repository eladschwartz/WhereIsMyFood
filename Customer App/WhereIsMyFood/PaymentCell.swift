//
//  PaymentCell.swift
//  BringMyFood
//
//  Created by elad schwartz on 30/05/2017.
//  Copyright © 2017 elad schwartz. All rights reserved.
//

import UIKit

class PaymentCell: UITableViewCell {
    
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var cardNumber: UILabel!
    @IBOutlet weak var changeLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
