//
//  ItemListViewController.swift
//  FinalProjectRender
//
//  Created by Swift on 4/23/19.
//  Copyright © 2019 Swift. All rights reserved.
//

import UIKit
import Firebase

class ItemListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var rowIndex: Int = 0;
    
    @IBAction func signOut(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
             self.performSegue(withIdentifier: "SignOutSegue", sender: self)
            
            
        } catch let error {
            print("Failed to sign out with error..", error)
        }
    }
    
    
    @IBOutlet weak var tableView2: UITableView!
    
    @IBOutlet weak var tableView: UITableView!
    var loggedInUserId = ""
    var currentUserUID = ""
    var saleItemList = [SaleItem]()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return saleItemList.count
    }
    
    func tableView(_ tableViewCell: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(indexPath.row)
        
        print(tableViewCell)
       if ((!(indexPath.row % 2 == 0)) && ((tableViewCell == tableView2)))
        {
            let cell = tableViewCell.dequeueReusableCell(withIdentifier: "TableViewCell2") as! ItemListTableView2Cell
            //   tableView.dequeueReusableCell(withIdentifier: "TableViewCell")! as! ItemListTableViewCell
            var saleItem : SaleItem = saleItemList[indexPath.row]
            
            cell.useMember(item:saleItem)
            return cell
        }
        if ((indexPath.row % 2 == 0) && ((tableViewCell == tableView)))
        {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell1")! as! ItemListTableViewCell
        var saleItem : SaleItem = saleItemList[indexPath.row]
        //cell.aboutLabel.text = member.about!
        // cell.facebook = member.facebook!
        //cell.locationLabel.text = member.location!
        //cell.facebookImage.image = UIImage(named:member.imageName!)!
       // tableView.estimatedRowHeight = 250
        cell.useMember(item:saleItem)
            return cell
            
        }
        
        return UITableViewCell()
       
    }
    
    

    @IBOutlet weak var navBar: UINavigationBar!
    @IBAction func CreatePost(_ sender: UIButton) {
        self.performSegue(withIdentifier: "CreatePost", sender: self)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selfSignIn()
        self.tableView2.rowHeight = 100.0
        self.tableView.rowHeight = 100.0
        
        SideView.layer.shadowColor = UIColor.black.cgColor
        SideView.layer.shadowOpacity = 0.7
        SideView.layer.shadowOffset = CGSize(width:10 ,height:0)
        
        let itemsRef = Database.database().reference().child("items")
        
        itemsRef.observe(.value, with: { snapshot in
            
            print(snapshot)
            //self.tableView2.estimatedRowHeight = 20
          //  self.tableView2.rowHeight = UITableView.automaticDimension
            guard let postSaleItems = PostSaleItemList(with: snapshot) else { return}
            self.saleItemList = postSaleItems.SaleItemList
            self.tableView.reloadData()
            self.tableView2.reloadData()
            
        })
        // Do any additional setup after loading the view.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "CreatePost" {
            let controller = segue.destination as! ItemDetailViewController
            controller.loggedInUserId = self.currentUserUID
        }
        if segue.identifier == "SignOutSegue" {
            let controller = segue.destination as! LoginViewController
        }

        if (segue.identifier == "ViewItemDetailSegue")
        {
            if let itemDetVC = segue.destination as? ViewItemDetailViewController
            {
                itemDetVC.itemId = self.saleItemList[rowIndex].itemId;
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        rowIndex = indexPath.row
        self.performSegue(withIdentifier: "ViewItemDetailSegue", sender: nil)
    }
  
    @IBOutlet weak var SideView: UIView!
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
    
    func selfSignIn()
    {
        if Auth.auth().currentUser == nil {
          
            self.performSegue(withIdentifier: "SignOutSegue", sender: self)
        }else{
            currentUserUID = (Auth.auth().currentUser?.uid)!
        }
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
