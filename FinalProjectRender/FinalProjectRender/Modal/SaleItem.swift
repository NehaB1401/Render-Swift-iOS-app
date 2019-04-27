//
//  SaleItem.swift
//  FinalProjectRender
//
//  Created by Swift on 4/26/19.
//  Copyright © 2019 Swift. All rights reserved.
//

import Foundation
import UIKit

struct SaleItem{
    let itemId : String?
    let itemTitle: String?
    let isSold : Bool?
    let itemCategory : String?
    let price: Double?
    var propertyAddress : Address?  = Address()
    let itemPayments : Payment?
    let itemBooked: Bool?
    let description: String?
    let sellerName : String?
    let itemImages:[String]?
    
    init?(itemId: String, dict: [String: Any]){
        self.itemId = itemId
        guard let itemTitle = dict["itemTitle"] as? String,
         let isSold = dict["isSold"] as? String,
        let itemCategory = dict["itemCategory"] as? String,
         let price = dict["price"] as? Double,
         let address = dict["propertyAddress"] as? [String:Any],
         //let itemPayments = dict["itemPayments"] as? [Payment],
         let itemBooked = dict["itemBooked"] as? String,
         let description = dict["description"] as? String,
         let sellerName = dict["sellerName"] as? String,
         let itemImages = dict["itemImages"] as? [String]
        else{
            return nil
        }
        let propertyAddress = Address()
        guard let addLine1 = address["addressLine1"] as! String?,
        let city = address["city"] as? String,
        let latitude = address["latitude"] as? Double,
        let longitude = address["longitude"] as? Double
            else{
                return nil
        }
        
        propertyAddress.addressLine1 = addLine1
        propertyAddress.city = city
        propertyAddress.latitude = latitude
        propertyAddress.longitude = longitude
        let itemPayments = Payment()
        self.itemTitle = itemTitle
        self.isSold = Bool(isSold)
        self.itemCategory = itemCategory
        self.price = price
        self.propertyAddress = propertyAddress
        self.itemPayments = itemPayments
        self.itemBooked = Bool(itemBooked)
        self.description = description
        self.sellerName = sellerName
        self.itemImages = itemImages
    }
}
