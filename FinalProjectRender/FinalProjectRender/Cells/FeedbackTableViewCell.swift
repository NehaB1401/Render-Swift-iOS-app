//
//  FeedbackTableViewCell.swift
//  FinalProjectRender
//
//  Created by Swift on 4/27/19.
//  Copyright © 2019 Swift. All rights reserved.
//

import UIKit

class FeedbackTableViewCell: UITableViewCell {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var feebackField: UILabel!
    @IBOutlet weak var oneStarBtn: UIButton!
    @IBOutlet weak var twoStarBtn: UIButton!
    @IBOutlet weak var threeStarBtn: UIButton!
    @IBOutlet weak var fourStarBtn: UIButton!
    @IBOutlet weak var fiveStarBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateViewForRating(rating: Int) {
        let arrayOfImages: [UIButton?] = [oneStarBtn, twoStarBtn, threeStarBtn, fourStarBtn, fiveStarBtn]
        
        for i in 0 ..< rating {
            let imgView = arrayOfImages[i]!
            imgView.isHidden = false
        }
        
        for i in rating ..< arrayOfImages.count {
            let imgView = arrayOfImages[i]!
            imgView.isHidden = true
        }
    }
}
