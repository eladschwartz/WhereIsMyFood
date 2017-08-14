//
//  Localizator.swift
//  WhereIsMyFood
//
//  Created by elad schwartz on 30/07/2017.
//  Copyright © 2017 elad schwartz. All rights reserved.
//

import Foundation

private class Localizator {
    
    static let sharedInstance = Localizator()
    
    lazy var localizableDictionary: [String:Any] = {
        if let url = Bundle.main.url(forResource:"Localizeble", withExtension: "plist") {
            do {
                let data = try Data(contentsOf:url)
                let swiftDictionary = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as! [String : Any]
                return swiftDictionary
            } catch {
                print(error)
                 return [String : Any]()
            }
        }
         return [String : Any]()
    }()
    
    func localize(category: String, string: String) -> String {
        guard let localizedString = localizableDictionary[category] else {
            return ""
        }
        return (localizedString as! [String : Any])[string] as! String
    }
}

extension String {
    func localized(category: String) -> String {
        return  Localizator.sharedInstance.localize(category: category, string: self)
    }
}
