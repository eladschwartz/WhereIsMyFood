//
//  File.swift
//  WhereIsMyFood
//
//  Created by elad schwartz on 25/05/2017.
//  Copyright © 2017 elad schwartz. All rights reserved.
//

import Foundation

class CheckBox: UIButton {
    // Images
    let checkedImage = UIImage(named: "checked")! as UIImage
    let uncheckedImage = UIImage(named: "notchecked")! as UIImage
    var indexpath: IndexPath!
    
    
    // Bool property
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                self.setImage(checkedImage, for: .normal)
            } else {
                self.setImage(uncheckedImage, for: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action: #selector(buttonClicked), for: UIControlEvents.touchUpInside)
        self.isChecked = false
    }
    
    func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
            NotificationCenter.default.post(name:Notification.Name(rawValue:"checkboxClicked"),
                    object: nil,
                    userInfo: ["indexpath": indexpath, "isChecked": isChecked])
    }
}
