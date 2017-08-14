//
//  LineSeparator.swift
//  WhereIsMyFood
//
//  Created by elad schwartz on 04/08/2017.
//  Copyright © 2017 elad schwartz. All rights reserved.
//

import UIKit

class LineSeparator: UIView {
    
    override func awakeFromNib() {
        
        let sortaPixel: CGFloat = 1.0/UIScreen.main.scale
        
        let topSeparatorView = UIView()
        topSeparatorView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: sortaPixel)
        
        topSeparatorView.isUserInteractionEnabled = false
        topSeparatorView.backgroundColor = self.backgroundColor
        
        self.addSubview(topSeparatorView)
        self.backgroundColor = UIColor(red:0.25, green:0.27, blue:0.30, alpha:1.0)
        
        self.isUserInteractionEnabled = false   
    }
}
