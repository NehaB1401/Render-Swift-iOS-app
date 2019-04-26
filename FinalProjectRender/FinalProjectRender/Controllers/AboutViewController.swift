//
//  AboutViewController.swift
//  FinalProjectRender
//
//  Created by Swift on 4/23/19.
//  Copyright © 2019 Swift. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var job: UILabel!
    @IBOutlet weak var website: UILabel!
    @IBOutlet weak var about: UILabel!
    @IBAction func websiteBtn(_ sender: UIButton) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        var neha = Member()
        name.text = "Neha Bhangale"
        website.text = "https://linkedin.com/in/neha-bhangale"
        //neha.web = "http://www.github.com/NehaB1401"
        neha.imageName = "neha"
        neha.about = ""
        neha.location = ""
        job.text = "Full Stack Developer"
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
