//
//  User.swift
//  BringMyFood
//
//  Created by elad schwartz on 18/04/2017.
//  Copyright © 2017 elad schwartz. All rights reserved.
//

import Foundation

final class User {
    
    private init() {}
    
    static let shared = User()
    
    var id: String?
    var name: String?
    var phone: String?
    var email: String?
    var token: String?
    var address: Address?
    
    func saveUserDetails(id: String, name: String, email: String, phone: String, token: String, address: Address) {
        self.id = id
        self.name = name
        self.email = email
        self.phone = phone
        self.token = token
        self.address = address
    }
    
    func updateUserDetails(name: String, email: String, address: Address) {
        self.name = name
        self.email = email
        self.address = address
    }
    
    func getAddress() -> String {
        if let country = self.address?.country, let address = self.address?.address, let state = self.address?.state,
           let city = self.address?.city, let zipCode = self.address?.zipCode  {
             return "\(address) \( state) \(city) \(zipCode) \(country)"
        }
        return ""
    }
}

class Address {
    
    var city: String?
    var state: String?
    var country: String?
    var zipCode: String?
    var address: String?
    var floor: String?
    var apartmentNumber: String?
    
    
    init (city: String, state: String = "", country: String, zipCode: String = "", address: String, floor: String, apartmentNumber: String) {
        self.city = city
        self.state = state
        self.country = country
        self.zipCode = zipCode
        self.address = address
        self.floor = floor
        self.apartmentNumber = apartmentNumber
    }
    
    
}
