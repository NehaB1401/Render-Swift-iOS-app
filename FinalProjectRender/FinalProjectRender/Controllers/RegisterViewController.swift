//
//  RegisterViewController.swift
//  FinalProjectRender
//
//  Created by Swift on 4/23/19.
//  Copyright © 2019 Swift. All rights reserved.
//

import UIKit
import CoreLocation

class RegisterViewController: UIViewController {

    @IBOutlet weak var firstNameTxt: UITextField!
    @IBOutlet weak var lastNameTxt: UITextField!
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
    @IBAction func UploadProfileImg(_ sender: UIButton) {
    }
    @IBOutlet weak var rolePicker: UIPickerView!
    func alert(_ message: String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert);
        let OkAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(OkAction)
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func registerBtn(_ sender: UIButton) {
        if ((firstNameTxt?.text?.isEmpty)! || (lastNameTxt?.text?.isEmpty)! || (emailTxt?.text?.isEmpty)! || (usernameTxt?.text?.isEmpty)! || (passTxt?.text?.isEmpty)! || (verPassTxt?.text?.isEmpty)! || (phoneTxt?.text?.isEmpty)! || (streetTxt?.text?.isEmpty)! || (aptTxt?.text?.isEmpty)! || (cityTxt?.text?.isEmpty)!
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
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(coor) { (placemarks, error) in
            guard let placemarks = placemarks,let location = placemarks.first?.location
                else {
                    let alert = UIAlertController(title: "ALERT", message: "PLEASE ENTER A VALID ADDRESS!!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
            }
        
    }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

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
