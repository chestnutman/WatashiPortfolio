//
//  Post.swift
//  OriginalApp
//
//  Created by 鈴木賀子 on 10/08/2020.
//  Copyright © 2020 Yoshiko. All rights reserved.
//

import UIKit
import NCMB

class Post {
    var objectId: String
    var postUser: User
    var postTitle: String
    var postDetailText: String
    var postImage: String
    var postShopName: String
    var postShopStation: String
    var postShopAddress: String
    var createDate: Date
    
    init(objectId: String, postUser: User, postTitle: String, postDetailText: String, postImage: String, postShopName: String, postShopStation: String, postShopAddress: String, createDate: Date) {
        self.objectId = objectId
        self.postUser = postUser
        self.postTitle = postTitle
        self.postDetailText = postDetailText
        self.postImage = postImage
        self.postShopName = postShopName
        self.postShopStation = postShopStation
        self.postShopAddress = postShopAddress
        self.createDate = createDate
    }
}

