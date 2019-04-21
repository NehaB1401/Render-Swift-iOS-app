//
//  ViewController.swift
//  FinalProjectRender
//
//  Created by Swift on 4/20/19.
//  Copyright © 2019 Swift. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var MenuTitle: UITextField!
    @IBOutlet weak var SideView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        MenuTitle.backgroundColor = UIColor.clear;

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

