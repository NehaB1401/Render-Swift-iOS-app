//
//  FeedbackViewController.swift
//  FinalProjectRender
//
//  Created by Swift on 4/23/19.
//  Copyright © 2019 Swift. All rights reserved.
//

import UIKit

enum Rating: Int {
    case OneStar = 0
    case TwoStars
    case ThreeStars
    case FourStars
    case FiveStars
}

class FeedbackViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var FeedbackField: UITextField!
    var feedbacks: [FeedBack] = []
    var newFeedback1 = FeedBack()
    
    var currentFeedbackRating: Int = 0
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedbacks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "feedBackCell") as! FeedbackTableViewCell
        cell.backgroundColor = UIColor.clear
        
        let feedback = feedbacks[indexPath.row]
        
        cell.nameField?.text = feedback.name
        cell.feebackField?.text = feedback.text
        cell.updateViewForRating(rating: feedback.numberOfStars)
        return cell
    }
    
   /* func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell: FeedbackTableViewCell = tableView.dequeueReusableCell(withIdentifier: "feedBackCell") as! FeedbackTableViewCell
        
        let feedback = feedbacks[indexPath.row]
        
        cell.nameField?.text = feedback.name
        cell.feebackField?.text = feedback.text
        
        let height = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        return height
    }
    */
    @IBOutlet weak var FeedbacksTableView: UITableView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var oneStarBtn: UIButton!
    @IBOutlet weak var threeStarBtn: UIButton!
    @IBOutlet weak var twoStarBtn: UIButton!
   
    @IBOutlet weak var fiveStarBtn: UIButton!
    @IBOutlet weak var fourStarBtn: UIButton!
    @IBAction func sendFeedback(_ sender: UIButton) {
        let newFeedback = FeedBack()
        
        if let name = nameField?.text {
            newFeedback.name = name
        }
        
        if let text = FeedbackField?.text {
            newFeedback.text = text
        }
        
        newFeedback.numberOfStars = currentFeedbackRating
        feedbacks.append(newFeedback)
        
        FeedbacksTableView?.reloadData()
        
        nameField?.text = ""
        FeedbackField?.text = ""
        nameField?.resignFirstResponder()
        FeedbackField?.resignFirstResponder()
    }
    
    private func changeRatingFor(newRating: Int) {
        currentFeedbackRating = newRating
        
        let starImage = UIImage(named: "star_chosen")
        let greyStarImage = UIImage(named: "star_unchosen")
        
        let arrayOfButtons: [UIButton?] = [oneStarBtn, twoStarBtn, threeStarBtn, fourStarBtn, fiveStarBtn]
        
        for i in 0 ... newRating {
            if let btn = arrayOfButtons[i]! as UIButton! {
                btn.setImage(starImage, for: .normal)
            }
        }
        
        for i in 0 ... newRating {
            if let btn = arrayOfButtons[i]! as UIButton! {
                btn.setImage(greyStarImage, for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newFeedback1.name = "NEHA BHANGALE"
        newFeedback1.text = "THANK YOU ALL FOR USING OUR APP, PLEASE FEEL FREE TO ADD ANY COMMENTS AND FEEDBACKS ABOUT THE APP!. I'LL TRY TO MEET ALL EXPECTATIONS AS SOON AS POSSIBLE!!"
        newFeedback1.numberOfStars = 4
        feedbacks.append(newFeedback1)
       // self.FeedbacksTableView.reloadData()
        // Do any additional setup after loading the view.
        initTextFieldsUI()
    }
    
    private func initTextFieldsUI() {
        let color = UIColor(red: 130.0/255.0, green: 123.0/255.0, blue: 120.0/255.0, alpha: 1.0)
        
        if let nameField = self.nameField, let namePlaceholder = nameField.placeholder {
            nameField.attributedPlaceholder = NSAttributedString(string: namePlaceholder, attributes: [NSAttributedString.Key.foregroundColor: color])
        }
        
        if let feedbackField = self.FeedbackField, let feedbackPlaceholder = feedbackField.placeholder {
            feedbackField.attributedPlaceholder = NSAttributedString(string: feedbackPlaceholder, attributes: [NSAttributedString.Key.foregroundColor: color])
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
