//
//  ViewImageCollectionViewCell.swift
//  FinalProjectRender
//
//  Created by Swift on 4/26/19.
//  Copyright © 2019 Swift. All rights reserved.
//

import UIKit
import FirebaseStorage
import Firebase

class ViewImageCollectionViewCell: UICollectionViewCell {
    
    
    let imageRef = Storage.storage().reference().child("images")
    
    @IBOutlet weak var image: UIImageView!
    
    func useMemberString(item:String)
    {
        let downloadImageRef = imageRef.child(item)
        
        let downloadTask = downloadImageRef.getData(maxSize: 1024 * 1024 * 12) { (data, error) in
            if let data = data {
                let image = UIImage(data: data)
                self.image.image = image
            }
            print(error ?? "ERROR")
        }
        
        downloadTask.observe(.progress){ (snapshot) in
            print(snapshot.progress ?? "NO MORE PROGRESS")
        }
    }
    
}
