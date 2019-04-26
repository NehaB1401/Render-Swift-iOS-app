//
//  LoginViewController.swift
//  FinalProjectRender
//
//  Created by Swift on 4/23/19.
//  Copyright © 2019 Swift. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    var userLoggedIn = ""
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passTxt: UITextField!
    @IBAction func loginBtn(_ sender: UIButton) {
        var userName : String = usernameTxt.text!
        let password : String = passTxt.text!
        
        userName = userName.replacingOccurrences(of: ".", with: ",")
        let ref: DatabaseReference?
        ref = Database.database().reference().child("users")
        var flag: Bool = true
        ref?.child(userName).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            
            if(!snapshot.hasChildren()){
                self.usernameTxt.shake()
                self.passTxt.shake()
                return
            }
            
            let userpassword = value?["password"] as? String
            let userrole = value?["role"] as? String
            let userId = value?["userId"] as? String
         //   self.uploadImage()
            if(userpassword == nil){
                flag = false
            }else{
                
                if(password==userpassword!){
                    self.userLoggedIn = userId!
                    self.performSegue(withIdentifier: "userHomeSegue", sender: self)

                }else{
                    flag = false;
                    self.usernameTxt.shake()
                    self.passTxt.shake()
                    return
                }
            }
        }) { (error) in
            print(error.localizedDescription)
            flag = false;
            self.usernameTxt.shake()
            self.passTxt.shake()
            return
        }
        
        if(!flag){
            usernameTxt.shake()
            passTxt.shake()
            return
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "userHomeSegue" {
            let controller = segue.destination as! ItemListViewController
            controller.loggedInUserId = self.userLoggedIn
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
    let filename = "demo.jpg"
    func uploadImage()
    {
        let imageRef = Storage.storage().reference().child("images")
        guard let image = UIImage(named: "register") else {return}
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        
        let uploadImageRef = imageRef.child(filename)
        
        let uploadTask = uploadImageRef.putData(imageData, metadata: nil) { (metadata, error) in
            print("Upload image finished")
            print(metadata ?? "NO METADATA")
            print(error ?? "ERROR")
        }
        
        uploadTask.observe(.progress) { (snapshot) in
            
            print(snapshot.progress ?? "NO MORE PROGRESS")
        }
    }
}



extension UITextField {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
}

