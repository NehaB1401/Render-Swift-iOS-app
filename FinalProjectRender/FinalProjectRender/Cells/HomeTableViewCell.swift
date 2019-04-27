//
//  HomeTableViewCell.swift
//  FinalProjectRender
//
//  Created by Swift on 4/26/19.
//  Copyright © 2019 Swift. All rights reserved.
//

import UIKit
import FirebaseStorage
import Firebase

class HomeTableViewCell: UITableViewCell {

    let imageRef = Storage.storage().reference().child("images")
    
    @IBOutlet weak var itemImage: UIImageView!
    
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemTitle: UILabel!
    func useMember(item:SaleItem) {
        // Round those corners
        
        // Fill in the data
        itemTitle.text = item.itemTitle
        itemPrice.text = String(item.price!)
        
        
        let downloadImageRef = imageRef.child(item.itemImages![0])
        
        let downloadTask = downloadImageRef.getData(maxSize: 1024 * 1024 * 12) { (data, error) in
            if let data = data {
                let image = UIImage(data: data)
                self.itemImage.image = image
            }
            print(error ?? "ERROR")
        }
        
        downloadTask.observe(.progress){ (snapshot) in
            print(snapshot.progress ?? "NO MORE PROGRESS")
        }
        // Fill the buttons and show or hide them
        
        
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
