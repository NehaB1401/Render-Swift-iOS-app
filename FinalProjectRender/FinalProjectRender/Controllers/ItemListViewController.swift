//
//  ItemListViewController.swift
//  FinalProjectRender
//
//  Created by Swift on 4/23/19.
//  Copyright © 2019 Swift. All rights reserved.
//

import UIKit

class ItemListViewController: UIViewController {

    var loggedInUserId = ""
    @IBOutlet weak var navBar: UINavigationBar!
    @IBAction func CreatePost(_ sender: UIButton) {
        self.performSegue(withIdentifier: "CreatePost", sender: self)

    }
    override func viewDidLoad() {
        super.viewDidLoad()

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
