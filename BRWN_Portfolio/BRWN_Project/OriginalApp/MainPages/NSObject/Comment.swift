//
//  Comment.swift
//  OriginalApp
//
//  Created by 鈴木賀子 on 10/08/2020.
//  Copyright © 2020 Yoshiko. All rights reserved.
//

import UIKit

class Comment {
    var postId: String //postclassのobjectId
    var user: User
    var text: String
    var createDate: Date
    
    init(postId: String, user: User, text: String, createDate: Date) {
        self.postId = postId
        self.user = user
        self.text = text
        self.createDate = createDate
    }
}
