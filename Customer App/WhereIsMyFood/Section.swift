//
//  Section.swift
//  WhereIsMyFood
//
//  Created by elad schwartz on 24/05/2017.
//  Copyright © 2017 elad schwartz. All rights reserved.
//

import Foundation
import SwiftyJSON

class Section {
    var id: Int?
    var name: String?
    var type: SectionType!
    var isRequired = false
    var details = [Detail]()
    
    //Every section as an array of details. every section's detail represents an Addon and indicator if user chose the addon
    struct Detail {
        let addon: Addon
        var isChecked: Bool
    }
    
    //This enum set the section choosing option: multiple/single choice
    //(ex. temperature will be single - you can't choose more then one temperature)
    enum SectionType {
        case Single
        case Multi
    }

    init(name: String) {
        self.name = name
    }
    
    init(sectionId: Int,sectionType: String, sectionName:String, isRequired: Bool) {
        self.id = sectionId
        self.type = sectionType == "single" ? .Single : .Multi
        self.name = sectionName
        self.isRequired = isRequired
    }
    
    deinit {
        print("Section \(name!) deinit")
    }
    
  
    func addToDetails(addon: Addon, isChecked: Bool = false) {
        let detail = Detail(addon:addon, isChecked: false)
        self.details.append(detail)
        if self.details.count == 1 && self.isRequired {
            self.details[0].isChecked = true
        }
    }
    
    //Change the checkbox On/Off
    func changeChecked(index: Int, checked: Bool) {
        details[index].isChecked = checked
    }
    
   

}

