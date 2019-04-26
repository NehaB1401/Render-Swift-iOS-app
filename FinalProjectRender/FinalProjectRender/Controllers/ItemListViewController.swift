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
    
    //var sellItemList : [Item]? = []
    
    @IBOutlet weak var tableView2: UITableView!
    
    var loggedInUserId = ""
    var saleItemList = [SaleItem]()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return saleItemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell2")! as! ItemListTableView2Cell
        var saleItem : SaleItem = saleItemList[indexPath.row]
        //cell.aboutLabel.text = member.about!
        // cell.facebook = member.facebook!
        //cell.locationLabel.text = member.location!
        //cell.facebookImage.image = UIImage(named:member.imageName!)!
       // tableView.estimatedRowHeight = 250
        cell.useMember(item:saleItem)
        return cell
    }
    

    @IBOutlet weak var navBar: UINavigationBar!
    @IBAction func CreatePost(_ sender: UIButton) {
        self.performSegue(withIdentifier: "CreatePost", sender: self)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView2.rowHeight = 100.0
        let itemsRef = Database.database().reference().child("items")
        
        itemsRef.observe(.value, with: { snapshot in
            
            print(snapshot)
            
            guard let postSaleItems = PostSaleItemList(with: snapshot) else { return}
            self.saleItemList = postSaleItems.SaleItemList
            self.tableView2.reloadData()
            
        })
        // Do any additional setup after loading the view.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "CreatePost" {
            let controller = segue.destination as! ItemDetailViewController
            controller.loggedInUserId = self.loggedInUserId
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
