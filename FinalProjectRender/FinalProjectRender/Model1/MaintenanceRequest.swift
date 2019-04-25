//
//  MaintenanceRequest.swift
//  FinalProjectRender
//
//  Created by Swift on 4/8/18.
//  Copyright © 2018 Swift. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseStorage

class MaintenanceRequest {
    var requestId : String?
    var requestType : String?
    var requestDescription : String?
    var requestImagePath : String?
    var requestImage : UIImage?
    var itemId : Int64?
    var status: String?
    var itemDescription : String?
    var sellerName : String?
    
    func saveToFirebase() {
        var ref = Database.database().reference().child("issues")
        let childRef = ref.childByAutoId()
        self.status = "Pending"
        print(self.requestType!)
        print(self.requestDescription!)
        print(self.requestImagePath!)
        print(self.itemId!)
       // print(self.requestType!)
        print(self.status!)
        let userObject = [
            "requestType":self.requestType!,
            "requestDescription":self.requestDescription!,
            "requestImagePath":self.requestImagePath! ,
            "itemId":self.itemId!,
            "status":self.status!,
            "SellerUserName":self.sellerName!
            ] as [String:Any]
        childRef.setValue(userObject)
       
    }
    
    func saveImagetoFirebase(){
        let storage = Storage.storage()
        let randomName = "".randomAlphaNumericString(8)
        let storageRef = storage.reference().child(randomName+".png")
        if self.requestImage == nil {
            self.requestImage = UIImage(named: "1")!
        }
        guard let uploadData = self.requestImage!.pngData()
            else{
                return
        }
        storageRef.putData(uploadData,metadata: nil) {
            metadata,error in
            
            if(error != nil){
                print(error!)
                return
            }else{
                storageRef.downloadURL { (url, error) in
                    guard let error = error else {
                        var pathString = url?.absoluteString
                        self.requestImagePath = pathString!
                        return
                    }
                }
              
                
                self.saveToFirebase()
            }
        }
    }
}
