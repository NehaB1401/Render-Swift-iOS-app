//
//  ItemDetailViewController.swift
//  FinalProjectRender
//
//  Created by Swift on 4/23/19.
//  Copyright © 2019 Swift. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import CoreLocation

var i = 0{
    didSet{
        
    }
}

extension String {
    func randomNumericInt() -> Int {
        let charactersString = "0123456789"
        let charactersArray : [Character] = Array(charactersString.characters)
        
        var string = ""
        for _ in 0..<4 {
            string.append(charactersArray[Int(arc4random()) % charactersArray.count])
        }
        
        return Int(string)!
    }
    
    
}

class ItemDetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UIPickerViewDataSource, UIPickerViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    let imageRef = Storage.storage().reference().child("images")
      var loggedInUserId = ""
     var itemList = [UIImage]();
    var imageNames = [String]();
    let itemDetails = Item()
    var item = Item()
    let itemAddress = Address()
    let address = Address()
    
    var imagePicker = UIImagePickerController();
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imageCollection.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as? ImageCollectionViewCell
        cell!.useMember(item:itemList[indexPath.row])
       // cell?.image.image = UIImage(named: "register")
        return cell!
    }
    var category = "Misc";
    
    var ref:DatabaseReference?
    
    let categories =  ["Electronics","Sports", "Home", "Kitchenware", "Fashion", "Vehicles", "Books", "Misc"];
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        category = categories[row]
    }
    
    func alert(_ message: String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert);
        let OkAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(OkAction)
        self.present(alert, animated: true, completion: nil)
    }
   
    func presentAlert(){
        let alert = UIAlertController(title: "SUCCESS", message: "SUCCESSFULLY POSTED LISTING!!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    @IBOutlet weak var imageCollection: UICollectionView!

    @IBOutlet weak var titleTxt: UITextField!
    @IBOutlet weak var descTxt: UITextView!

    @IBOutlet weak var priceTxt: UITextField!
    @IBAction func freeItem(_ sender: UISwitch) {
        if (sender.isOn == true)
        {
            priceTxt.text = "0"
        }
    }
    @IBOutlet weak var categoryScroll: UIPickerView!
    @IBAction func addImage(_ sender: UIButton) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        if let image: UIImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            self.itemList.append(image)
            
            self.imageCollection.reloadData()
        }
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var AddressLine1: UITextField!
    @IBOutlet weak var cityTxt: UITextField!
    @IBOutlet weak var stateTxt: UITextField!
    @IBOutlet weak var zipTxt: UITextField!
    @IBAction func postListing(_ sender: UIButton) {
        if ((AddressLine1?.text?.isEmpty)! || (cityTxt?.text?.isEmpty)!
            || (zipTxt?.text?.isEmpty)!) {
            alert("Address values can not be empty!")
            return
        }
        
        if (!(priceTxt.text?.isDouble)!) {
            alert("Invalid price")
            return
        }else if let number = Double(priceTxt.text!)
        {
            if((number < 0))
            {
                alert("Invalid price")
                return
            }
            
        }
        
        if (!(zipTxt.text?.isInt)!) {
            alert("Invalid zip")
            return
        }else if let number = Int(zipTxt.text!)
        {
            if((number < 0) || (number>Int.max))
            {
                alert("Invalid zip")
                return
            }
            
        }
        
        let coor:String = "" + AddressLine1.text! + ", " + cityTxt.text! + ", " + stateTxt.text! + " " + zipTxt.text!
        print(coor)
        
        let ref: DatabaseReference?
        ref = Database.database().reference().child("users")
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(coor) { (placemarks, error) in
            guard let placemarks = placemarks,let location = placemarks.first?.location
                else {
                    let alert = UIAlertController(title: "ALERT", message: "PLEASE ENTER A VALID ADDRESS!!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
            }
            
            
            self.address.addressLine1 = self.AddressLine1.text ;
            self.address.city = self.cityTxt.text
            self.address.state = self.stateTxt.text
            self.address.postalCode = Int(self.zipTxt.text!)
            self.address.latitude = Double(location.coordinate.latitude)
            self.address.longitude = Double(location.coordinate.longitude)
            self.itemDetails.propertyAddress = self.address
            if(!((self.titleTxt?.text?.isEmpty)!))
            {
                self.itemDetails.itemTitle = self.titleTxt.text;
            }
            if(!((self.descTxt?.text?.isEmpty)!))
            {
                self.itemDetails.description = self.descTxt.text;
            }
            if(!((self.priceTxt?.text?.isEmpty)!))
            {
                self.itemDetails.price = Double(self.priceTxt.text!);
            }
            self.itemDetails.itemCategory = Category(rawValue: self.category).map { $0.rawValue };
            self.itemDetails.isSold = false;
            self.itemDetails.itemBooked = false;
            self.itemDetails.sellerName = self.loggedInUserId
            self.itemDetails.itemId = UUID().uuidString;
            self.itemDetails.itemList = self.itemList
            self.itemDetails.description = self.descTxt.text

            print(location.coordinate.latitude)
            print(location.coordinate.longitude)
            var itemId : String = self.itemDetails.itemId!
           // userName = userName.replacingOccurrences(of: ".", with: ",")
            ref?.child(itemId).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if(snapshot.hasChildren()){
                    let alert = UIAlertController(title: "ALERT", message: "EMAIL ALREADY REGISTERED FOR RENDER USER!!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                
                self.uploadImage()
                self.itemDetails.itemImages = self.imageNames
                self.itemDetails.saveToFirebase()
                  self.presentAlert()
                self.getProperties()
               
            })
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    

    let filename = "demo1.jpg"
    func uploadImage()
    {
        
        for i in 0...((self.itemList.count)-1) {
            let image = self.itemList[i]
            guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
            let imageName = "".randomAlphaNumericString(8)+".jpg"
            let uploadImageRef = imageRef.child(imageName)
            let metaData = StorageMetadata()
            self.imageNames.append(imageName)
            let uploadTask = uploadImageRef.putData(imageData, metadata: metaData) { (metadata, error) in
                print("Upload image finished")
                print(metadata ?? "NO METADATA")
                print(error ?? "ERROR")
                
            }
            
            uploadTask.observe(.progress) { (snapshot) in
                
                print(snapshot.progress ?? "NO MORE PROGRESS")
            }
            
            //uploadTask.resume()
        }
    }
    
    
    func getProperties(){
        let session = URLSession.shared
        let postEndpoint: String = "https://search.onboard-apis.com/propertyapi/v1.0.0/property/snapshot?latitude=\(String(describing: address.latitude!))&longitude=\(String(describing: address.longitude!))&radius=1"
        print(postEndpoint)
        let url = URL(string: postEndpoint)!
        var request = URLRequest(url: url as URL)
        
        request.setValue("02a205de6f57ff300b669f187a7556e6", forHTTPHeaderField: "apikey")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                print("error calling POST on /todos/1")
                print(error!)
                return
            }
            
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            let responseString = String(data: data!, encoding: String.Encoding.utf8)
            print("responseString = \(responseString!)")
            do{
                if let data = data,
                    let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                    let propertys = json["property"] as? [Any] {
                    print(propertys.count)
                    // var i=0
                    for property in propertys {
                        self.item = Item()
                        // i = i+1
                        var property1 = property as? [String:Any]
                        if let identifier = property1!["identifier"] as? [String: Any] {
                            if let id : String? = String(describing: identifier["obPropId"]!){
                                print(id!)
                                self.item.itemId = id!
                            }
                            self.item.isSold = false
                            self.item.price = Double("".randomNumericInt())
                            self.item.itemBooked = false
                           
                            
                            if let summary:[String:Any] = property1!["description"] as? [String:Any]{
                                self.item.itemCategory = summary["proptype"] as? String
                            }
                            self.item.sellerName = self.loggedInUserId
                            print(property1!["address"]!)
                            if let address = property1!["address"]! as? [String:String]{
                                self.itemAddress.addressLine1 = address["line1"]
                                print(self.itemAddress.addressLine1!)
                                self.itemAddress.addressLine2 = ""
                                self.itemAddress.city = address["locality"]
                                self.itemAddress.country = address["country"]
                                self.itemAddress.postalCode = Int(address["postal1"]!)
                                self.itemAddress.state = address["countrySubd"]
                            }
                            if let location = property1!["location"] as? [String:Any]{
                                self.itemAddress.latitude = Double((location["latitude"] as? String)!)
                                self.itemAddress.longitude = Double((location["longitude"]as? String)!)
                            }
                            self.item.propertyAddress = self.itemAddress
                        }
                        let status = self.item.saveImagetoFirebase()
                        
                        OperationQueue.main.addOperation {
                            self.presentAlert()
                          //  self.clearTExtFields()
                        }
                    }}}catch  {
                        print("error parsing response from POST on /todos")
                        return
            }
        }
        task.resume()
    }
    

}
