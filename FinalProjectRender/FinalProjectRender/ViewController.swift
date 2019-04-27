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

class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource  {
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
    
    @IBOutlet weak var MenuTitle: UITextField!
    @IBOutlet weak var SideView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        MenuTitle.backgroundColor = UIColor.clear;
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

