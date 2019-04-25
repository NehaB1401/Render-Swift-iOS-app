//
//  RegisterViewController.swift
//  FinalProjectRender
//
//  Created by Swift on 4/23/19.
//  Copyright © 2019 Swift. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
import Photos
import FirebaseDatabase
import Foundation

class RegisterViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let buyer = Buyer()
    let address = Address()
    
    var item = Item()
    var role = "Buyer";
    
    var ref:DatabaseReference?
    
    let roles = ["Seller", "Buyer"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return roles[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return roles.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        role = roles[row]
    }
    
    var imagePicker = UIImagePickerController();

    @IBOutlet weak var firstNameTxt: UITextField!
    
    @IBOutlet weak var lastNametxt: UITextField!
    
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passTxt: UITextField!
    @IBOutlet weak var verPassTxt: UITextField!
    @IBOutlet weak var phoneTxt: UITextField!
    @IBOutlet weak var streetTxt: UITextField!
    @IBOutlet weak var aptTxt: UITextField!
    @IBOutlet weak var cityTxt: UITextField!
    @IBOutlet weak var stateTxt: UITextField!
    @IBOutlet weak var countryTxt: UITextField!
    @IBOutlet weak var zipTxt: UITextField!
    @IBOutlet weak var image: UIImageView!
    @IBAction func uploadProfile(_ sender: UIButton) {

    }
    
    @IBAction func imagePicker(_ sender: UIButton) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        if let image: UIImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            self.image.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet var rolePicker: UIPickerView!
    func alert(_ message: String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert);
        let OkAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(OkAction)
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func registerBtn(_ sender: UIButton) {
      if ((firstNameTxt?.text?.isEmpty)! || (lastNametxt?.text?.isEmpty)! || (emailTxt?.text?.isEmpty)! || (usernameTxt?.text?.isEmpty)! || (passTxt?.text?.isEmpty)! || (verPassTxt?.text?.isEmpty)! || (phoneTxt?.text?.isEmpty)! || (streetTxt?.text?.isEmpty)! || (aptTxt?.text?.isEmpty)! || (cityTxt?.text?.isEmpty)!
            || (stateTxt?.text?.isEmpty)! || (countryTxt?.text?.isEmpty)! || (zipTxt?.text?.isEmpty)!) {
            alert("Values of the field can not be empty!")
            return
        }
        
        if (!(phoneTxt.text?.isInt)!) {
            alert("Invalid phone")
            return
        }
        
        if (!(aptTxt.text?.isInt)!) {
            alert("Invalid apartment number")
            return
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
        
        if (!(emailTxt.text?.isEmail)!) {
            alert("Invalid email address")
            return
        }
        
        if (passTxt.text != verPassTxt.text)
        {
            alert("Password doesn't match")
            return
        }
        
        if (!(passTxt.text?.isPassword)!)
        {
            alert("Invalid password")
            return
        }
        
        let coor:String = "" + streetTxt.text! + aptTxt.text! + ", " + cityTxt.text! + ", " + stateTxt.text! + " " + zipTxt.text!
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
        
        
        self.address.addressLine1 = self.streetTxt.text ;
        self.address.addressLine2 = self.aptTxt.text;
        self.address.city = self.cityTxt.text
        self.address.state = self.stateTxt.text
        self.address.postalCode = Int(self.zipTxt.text!)
        self.address.latitude = Double(location.coordinate.latitude)
        self.address.longitude = Double(location.coordinate.longitude)
        self.buyer.address = self.address
        
        self.buyer.firstName = self.firstNameTxt.text
        self.buyer.lastName = self.lastNametxt.text
        self.buyer.itemList = []
        self.buyer.allRequests = []
        let email = self.emailTxt.text?.replacingOccurrences(of: ".", with: ",")
        self.buyer.userName = self.usernameTxt.text
        self.buyer.password = self.passTxt.text
        self.buyer.phone = Int64(self.phoneTxt.text!)
        self.buyer.role = Role(rawValue: self.role);
        print(location.coordinate.latitude)
        print(location.coordinate.longitude)
        var userName : String = self.usernameTxt.text!
        userName = userName.replacingOccurrences(of: ".", with: ",")
        ref?.child(userName).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if(snapshot.hasChildren()){
                let alert = UIAlertController(title: "ALERT", message: "EMAIL ALREADY REGISTERED FOR RENDER USER!!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            if self.buyer.profileImage == nil {
                self.buyer.profileImage = "self.image.image!.pngData()! as Data";
            }
            self.buyer.saveToFirebase()
            //self.buyer.saveImagetoFirebase()
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

}
