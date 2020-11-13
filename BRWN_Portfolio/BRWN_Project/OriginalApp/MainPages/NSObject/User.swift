//
//  User.swift
//  OriginalApp
//
//  Created by 鈴木賀子 on 10/08/2020.
//  Copyright © 2020 Yoshiko. All rights reserved.
//

import UIKit

class User {
    var objectId: String
    var userId: String
    var userDisplayName: String?
    var userTitle: String?
    var userBio: String?
    var mailAddress: String?
    
    
    init(objectId: String, userId: String) {
        self.objectId = objectId
        self.userId = userId
    }

//Update~~~~~
    init(objectId: String, userId: String, userDisplayName: String, userTitle: String, userBio: String, mailAddress: String){
        self.objectId = objectId
        self.userId = userId
        self.userDisplayName = userDisplayName
        self.userTitle = userTitle
        self.mailAddress = mailAddress
    }
}

