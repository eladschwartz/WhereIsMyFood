//
//  MealCell.swift
//  BringMyFood
//
//  Created by elad schwartz on 29/04/2017.
//  Copyright © 2017 elad schwartz. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var discriptionLbl: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var discountImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.itemImage.image = UIImage.init(named: "blank_image")
    }
    
    func configCell(item: Item) {
        guard let itemName = item.name, let itemId = item.id, let itemPrice = item.price, let itemDescription = item.description else {
            return
        }
        self.layoutIfNeeded()
        
        
        //Set text for cell lables
        self.nameLbl.text = itemName
        self.priceLbl.text = "\(Config.CURRENCY_SIGN)\(itemPrice)"
        self.discriptionLbl.text = itemDescription
        if let imageUrl = item.imageUrl {
            if (imageUrl != "UPLOAD IMAGE"){
                let url = URL(string: imageUrl)!
                APIManager.shared.loadImage(itemName: itemName, itemId: itemId, imgUrl: url, { (image) in
                    DispatchQueue.main.async(){
                        self.itemImage.image = image
                        self.itemImage.setRounded()
                    }
                })
            }
        }
        
        //If item has a discount show image. else hide it.
        if let isDiscount  = item.isDiscount {
            if (isDiscount) {
                self.discountImage.isHidden = false
                self.priceLbl.text = String(itemPrice)
            } else {
                self.discountImage.isHidden = true
            }
        }
    }
    
}
