//
//  User.swift
//  GeekProject_AR
//
//  Created by yanagimachi_riku on 2019/08/18.
//  Copyright © 2019 Riku Yanagimachi. All rights reserved.
//

import UIKit

class User: NSObject{
    var objectId: String
    var userName: String
    var displayName: String?
    var introduction: String?
    
    init(objectId: String, userName: String) {
        self.objectId = objectId
        self.userName = userName
        
    }
}
