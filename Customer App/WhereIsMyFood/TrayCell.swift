//
//  TrayCell.swift
//  WhereIsMyFood
//
//  Created by elad schwartz on 30/04/2017.
//  Copyright © 2017 elad schwartz. All rights reserved.
//

import Foundation

protocol TrayCellelegate {
    func deleteButtonPressed (sender: AnyObject)
    func editButtonPressed (sender: AnyObject)
}

class TrayCell: UITableViewCell {
    
    @IBOutlet weak var qtyLbl: UILabel!
    @IBOutlet weak var itemNameLbl: UILabel!
    @IBOutlet weak var subTotalItemLbl: UILabel!
    @IBOutlet weak var itemAddonsLbl: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    var delegate: TrayCellelegate!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        qtyLbl.layer.borderColor = UIColor.gray.cgColor
        qtyLbl.layer.borderWidth = 1.0
        qtyLbl.layer.cornerRadius = 7
    }
    
    @IBAction func deleteBtnTapped(_ sender: AnyObject) {
        self.delegate?.deleteButtonPressed(sender: sender)
    }
    
    @IBAction func editBtnTapped(_ sender: AnyObject) {
        self.delegate?.editButtonPressed(sender: sender)
    }
}
