//
//  User.swift
//  FinalProjectRender
//
//  Created by Swift on 4/8/18.
//  Copyright © 2018 Swift. All rights reserved.
//

import Foundation
import FirebaseDatabase

class User{
    var phone: Int64?
    var address: Address?
    var userName: String?
    var password: String?
    var name: String?
    var profileImage: String?
    var role:Role?
}

enum Role:String {
    case Buyer
    case Seller
}


