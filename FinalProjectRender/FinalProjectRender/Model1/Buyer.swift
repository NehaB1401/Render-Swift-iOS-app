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
    
    
   /* func createUser(withEmail email: String, password: String, username: String){
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error
            {
                print("failed to sign up")
                return
            }
            guard let uid = result?.user.uid else {return}
        }
        
    }*/
    
    let ref: DatabaseReference? = Database.database().reference().child("users")
    func saveToFirebase() {
        print(self.userName!)
        print(self.firstName!)
        print(self.lastName!)
        print(self.password!)
        print(self.role!)
        var role = self.role?.rawValue
        print(role!)
        self.createUser(withEmail: self.email!, password: self.password!, username: self.userName!)
        
    }
    
    func createUser(withEmail email: String, password: String, username: String) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            
            if let error = error {
                print("Failed to sign user up with error: ", error.localizedDescription)
                return
            }
            
            guard let uid = result?.user.uid else { return }
            
            let values = ["email": email, "username": username]
            
            Database.database().reference().child("users").child(uid).updateChildValues(values, withCompletionBlock: { (error, ref) in
                if let error = error {
                    print("Failed to update database values with error: ", error.localizedDescription)
                    return
                }
                
               
            })
            let userObject =
                ["userId":self.userId!,
                 "userName": self.userName,
                 "firstName":self.firstName!,
                 "lastName":self.lastName!,
                 "requestsRaised":self.requestsRaised!,
                 "password":self.password!,
                 "itemList":self.itemList,
                 "allRequests":self.allRequests,
                 "role":self.role!.rawValue,
                 "phone":self.phone!] as [String:Any]
            Database.database().reference().child("users").child(uid).setValue(userObject)
            
            Database.database().reference().child("users").child(uid).child("address").setValue(["addressLine1":(self.address?.addressLine1!)!, "addressLine2":(self.address?.addressLine2!)!,"city":(self.address?.city!)!,"state":(self.address?.state!)!, "postalcode":(self.address?.postalCode!)!, "latitude": (self.address?.latitude)!, "longitude":(self.address?.longitude)!])
            
            
        }
        
    }
}
