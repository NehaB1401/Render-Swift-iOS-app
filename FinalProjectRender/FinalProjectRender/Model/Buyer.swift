//
//  Tenant.swift
//  FinalProjectRender
//
//  Created by Swift on 4/8/18.
//  Copyright © 2018 Swift. All rights reserved.
//

import Foundation
import Firebase

class Buyer:User{
    var firstName: String?
    var lastName: String?
    var identityDocument: String?
    var requestsRaised: [MaintenanceRequest]? = []
    var itemId: Int64?
    
    func saveToFirebase() {
        let ref: DatabaseReference?
        ref = Database.database().reference().child("users")
        print(self.userName!)
        print(self.firstName!)
        print(self.lastName!)
        print(self.identityDocument!)
        print(self.password!)
        print(self.role!)
        var role = self.role?.rawValue
        print(role!)
        
        ref?.child(self.userName!).setValue(["firstName":self.firstName!, "lastName":self.lastName!,"identityDocuments":self.identityDocument!, "requestsRaised":self.requestsRaised!,"password":self.password!,"role":role!,"apartmentId":self.apartmentId!,"phone":self.phone!])
    }
    
    func saveImagetoFirebase(){
        let storage = Storage.storage()
        let randomName = "".randomAlphaNumericString(8)
        let storageRef = storage.reference().child("documents").child(randomName+".png")
        if self.documentImage == nil {
            self.documentImage = UIImage(named: "1")!
        }
        guard let uploadData = UIImagePNGRepresentation(self.documentImage!)
            else{
                return
        }
        storageRef.putData(uploadData,metadata: nil) {
            metadata,error in
            
            if(error != nil){
                print(error!)
                return
            }else{
                print(metadata!.downloadURL()?.absoluteString)
                self.identityDocument = (metadata!.downloadURL()?.absoluteString)!
                self.saveToFirebase()
            }
        }
    }
}
