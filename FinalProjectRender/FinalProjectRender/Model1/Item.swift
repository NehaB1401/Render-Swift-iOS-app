//
//  Apartment.swift
//  FinalProjectRender
//
//  Created by Swift on 4/9/18.
//  Copyright © 2018 Swift. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage

class Item{
    var itemId : String?
    var itemTitle: String?
    var isSold : Bool?
    var itemCategory : String?
    var price: Double?
    var propertyAddress : Address?  = Address()
    var itemPayments : [Payment]?
    var itemBooked: Bool?
    var description: String?
    var sellerName : String?
    var itemImages:[String]?
    var itemList: [UIImage]?
    
    func saveToFirebase() -> Bool {
        let ref: DatabaseReference?
        ref = Database.database().reference().child("items")
        
        let aid = String(describing: self.itemId!)
        let soldis = String(describing: self.isSold!)
        //let lsigned = (String(describing: self.leaseSigned!))
        let price = self.price
        print(self.itemImages!)
        self.itemPayments = [Payment]()
        let isBooked = String(describing: false)
        ref?.child(aid).setValue(["itemTitle":self.itemTitle, "isSold":soldis, "itemCategory":self.itemCategory!, "sellerName":self.sellerName!,"price":price!,"itemImages":self.itemImages!, "itemPayments":self.itemPayments,"itemBooked":isBooked, "description": self.description])
        print((self.propertyAddress?.addressLine1)!)
            print((self.propertyAddress?.state)!)
            print((self.propertyAddress?.city)!)
            print((self.propertyAddress?.postalCode)!)
           // print((self.propertyAddress?.country)!)
            print((self.propertyAddress?.longitude)!)
            print((self.propertyAddress?.latitude)!)
        ref?.child(aid).child("propertyAddress").setValue(["addressLine1":(self.propertyAddress?.addressLine1)!, "state": (self.propertyAddress?.state)!, "city":(self.propertyAddress?.city)!, "postalcode": (self.propertyAddress?.postalCode)!, "latitude": (self.propertyAddress?.latitude)!, "longitude":(self.propertyAddress?.longitude)!])
        i = i + 1
        print("----------i-------------------")
        print(i)
        return true
        
    }
    
    var imageRef: StorageReference{
        return Storage.storage().reference().child("images");
        
    }
 
    func handleItemList(){
        
         for i in 0...((self.itemList?.count)!-1) {
        // 1. Upload the profile image to Firebase Storage
        
            self.uploadProfileImage(itemList![i]) { url in
        
                if url != nil {
                    var pathString = url?.absoluteString
                    self.itemImages?.append(pathString!)
                } else {
        // Error unable to upload profile image
        }
        
        }
        }
        
    }
    func uploadProfileImage(_ image:UIImage, completion: @escaping ((_ url:URL?)->())) {
        //   guard let uid = Auth.auth().currentUser?.uid else { return }
        let randomName = "".randomAlphaNumericString(8)
      //  let storageRef = Storage.storage().reference().child(randomName+".png")
        
        
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        
        let uploadImageRef = imageRef.child(randomName+".jpg")
        
        let uploadTask = uploadImageRef.putData(imageData, metadata: nil) { (metadata, error) in
            print("Upload image finished")
            print(metadata ?? "NO METADATA")
            print(error ?? "ERROR")
        }
        
        uploadTask.observe(.progress) { (snapshot) in
            
            print(snapshot.progress ?? "NO MORE PROGRESS")
        }
        
        /*let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        storageRef.putData(imageData, metadata: metaData) { metaData, error in
            if error == nil, metaData != nil {
                storageRef.downloadURL { (url, error) in
                    guard let error = error else {
                     //   var pathString = url?.absoluteString
                       // self.itemImages?.append(pathString!)
                        return
                    }
                    // success!
                }
                // success!
            } else {
                // failed
                completion(nil)
            }
        }*/
        self.saveToFirebase()
    }
    func saveImagetoFirebase() -> Bool{
       /* if(i>4){
            return true
        }*/
        let storage = Storage.storage()
       var status = false;
        self.itemImages = []
        for i in 0...((self.itemList?.count)!-1) {
            status = false;
            let random = arc4random_uniform(83) + 10;
            print(random)
            let image = itemList![i]
            let randomName = "".randomAlphaNumericString(8)
            let storageRef = storage.reference().child(randomName+".png")
            
            guard let uploadData = image.pngData()
            else{
                return false
        }
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpg"
           // var pathString: Data = image.pngData()! as Data
           // self.itemImages?.append(pathString)
          /*  storageRef.putData(uploadData, metadata: metaData){
                metadata,error in
                if error == nil, metaData != nil {
                    storageRef.downloadURL { (url, error) in
                        guard let error = error else {
                            var pathString = url?.absoluteString
                            self.itemImages?.append(pathString!)
                            return
                        }
                    // success!
                }
                }else {
                    // failed
                  //  completion(nil)
                    print(error.debugDescription)
                }
              /*  if(error != nil){
                    print(error!)
                    status = false
                    return
                }else{
                    storageRef.downloadURL { (url, error) in
                        guard let error = error else {
                            var pathString = url?.absoluteString
                            self.itemImages?.append(pathString!)
                            return
                        }
                    }
                    
                

            }*/
        }*/
        }
        status =  self.saveToFirebase()
        return status
    }
}

enum Category:String {
    case Electronics
    case Sports
    case Home
    case Kitchenware
    case Fashion
    case Vehicles
    case Books
    case Misc
}
