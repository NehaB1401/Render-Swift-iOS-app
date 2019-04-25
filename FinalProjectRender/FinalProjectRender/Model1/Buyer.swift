//
//  Tenant.swift
//  FinalProjectRender
//
//  Created by Swift on 4/8/18.
//  Copyright © 2018 Swift. All rights reserved.
//

import Foundation
import Firebase

extension String {
    
    ///For placeholders
    func randomAlphaNumericString(_ length: Int) -> String {
        let charactersString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let charactersArray : [Character] = Array(charactersString.characters)
        
        var string = ""
        for _ in 0..<length {
            string.append(charactersArray[Int(arc4random()) % charactersArray.count])
        }
        
        return string
    }
}

class Buyer:User{
    var requestsRaised: [MaintenanceRequest]? = []
    var itemId: Int64?
    var itemList: [Int64]!
    var allRequests: [MaintenanceRequest]!
    var itemsForSale : [Item]!
    var pathString: String?
    
    func saveToFirebase() {
        let ref: DatabaseReference?
        ref = Database.database().reference().child("users")
        print(self.userName!)
        print(self.firstName!)
        print(self.lastName!)
        print(self.password!)
        print(self.role!)
        var role = self.role?.rawValue
        print(role!)
        let userObject =
            ["firstName":self.firstName!,
             "lastName":self.lastName!,
             "requestsRaised":self.requestsRaised!,
             "password":self.password!,
             "itemList":self.itemList,
             "allRequests":self.allRequests,
             "role":self.role!.rawValue,
             "phone":self.phone!] as [String:Any]
        ref?.child(self.userName!).setValue(userObject)
        
        ref?.child(self.userName!).child("address").setValue(["addressLine1":(self.address?.addressLine1!)!, "addressLine2":(self.address?.addressLine2!)!,"city":(self.address?.city!)!,"state":(self.address?.state!)!, "postalcode":(self.address?.postalCode!)!])
    }
    
}
