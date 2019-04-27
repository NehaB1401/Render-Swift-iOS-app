//
//  ComplaintsViewController.swift
//  FinalProjectRender
//
//  Created by Swift on 4/27/19.
//  Copyright © 2019 Swift. All rights reserved.
//

import UIKit

class ComplaintsViewController: UIViewController,UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    var complaintList = ["Faulty Item", "Fake Information", "Warrentry Expired"];
    var category = "Warrenty Expired"
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return complaintList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return complaintList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        category = complaintList[row]
    }
    

    @IBOutlet weak var complaintPicker: UIPickerView!
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
