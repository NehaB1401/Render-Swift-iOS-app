//
//  PostSaleItemList.swift
//  FinalProjectRender
//
//  Created by Swift on 4/26/19.
//  Copyright © 2019 Swift. All rights reserved.
//

import Foundation
import Firebase

struct PostSaleItemList {
    var SaleItemList = [SaleItem]()
    
    init?(with snapshot: DataSnapshot){
        var saleItems = [SaleItem]()
        guard let snapDict = snapshot.value as? [String: [String: Any]] else {
            return nil}
        for snap in snapDict{
            guard let item = SaleItem(itemId: snap.key, dict: snap.value) else {continue}
            saleItems.append(item)
        }
        self.SaleItemList = saleItems
    }
    
}
