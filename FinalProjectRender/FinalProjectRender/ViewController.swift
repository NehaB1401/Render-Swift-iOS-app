//
//  ViewController.swift
//  FinalProjectRender
//
//  Created by Swift on 4/20/19.
//  Copyright © 2019 Swift. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FBSDKLoginKit

class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, FBSDKLoginButtonDelegate,UISearchBarDelegate  {
    @IBOutlet weak var searchBar: UISearchBar!
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        
        print("Successfully logged in with facebook...")
        fetchProfile()
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of facebook")
    }
    
    var rowIndex: Int = 0;
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return saleItemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell") as! HomeTableViewCell
        var saleItem : SaleItem = saleItemList[indexPath.row]
        
        cell.useMember(item:saleItem)
        return cell
    
    }
    
    
    var saleItemList = [SaleItem]()
    @IBOutlet weak var itemTable: UITableView!
    
    @IBAction func signOut(_ sender: UIBarButtonItem) {
    }
    @IBOutlet weak var MenuTitle: UITextField!
    @IBOutlet weak var SideView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        SideView.layer.shadowColor = UIColor.black.cgColor
        SideView.layer.shadowOpacity = 0.7
        SideView.layer.shadowOffset = CGSize(width:15 ,height:0)
        
        let loginButton = FBSDKLoginButton()
        view.addSubview(loginButton)
        //frame's are obselete, please use constraints instead because its 2016 after all
        loginButton.frame = CGRect(x: 320, y: 65, width: view.frame.width - 345, height: 40)
        
        loginButton.delegate = self
      //  selfSignIn()
        
       /* if let token = FBSDKAccessToken.current()
        {
            fetchProfile()
        }*/
        
       // MenuTitle.backgroundColor = UIColor.clear;
        let itemsRef = Database.database().reference().child("items")
        
        self.itemTable.rowHeight = 180.0
        itemsRef.observe(.value, with: { snapshot in
            
            print(snapshot)
            //self.tableView2.estimatedRowHeight = 20
           // self.tableView2.rowHeight = UITableView.automaticDimension
            guard let postSaleItems = PostSaleItemList(with: snapshot) else { return}
            self.saleItemList = postSaleItems.SaleItemList
            self.itemTable.reloadData()
            
        })
        
      
    }
    
    func fetchProfile(){
        
        
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "ViewHomeItemDetail")
        {
            if let itemDetVC = segue.destination as? ViewItemDetailViewController
            {
                itemDetVC.itemId = self.saleItemList[rowIndex].itemId;
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        rowIndex = indexPath.row
        self.performSegue(withIdentifier: "ViewHomeItemDetail", sender: nil)
    }


    @IBAction func getSideView(_ sender: UIBarButtonItem) {
        if SideView.isHidden {
            SideView.isHidden = false
        } else {
            SideView.isHidden = true
        }
    }
    @IBAction func getHomeView(_ sender: UIButton) {
        if SideView.isHidden {
            SideView.isHidden = false
        } else {
            SideView.isHidden = true
        }
    }
}

