//
//  Memo.swift
//  GeekProject_AR
//
//  Created by yanagimachi_riku on 2019/08/19.
//  Copyright © 2019 Riku Yanagimachi. All rights reserved.
//

import Foundation

class Memo: NSObject{
    var id: String
    var title: String
    var createdUser: User
    var shareUsers: [String]
    
    var roomId: String
    var detail: String
    var fileName: String
    
    var latitude: Double
    var longitude: Double
    
    init(id: String, title: String, detail: String, fileName: String, roomId: String, createdUser: User, shareUsers: [String], latitude: Double, longitude: Double) {
        self.id = id
        self.title = title
        self.detail = detail
        self.fileName = fileName
        self.roomId = roomId
        self.createdUser = createdUser
        self.shareUsers = shareUsers
        self.latitude = latitude
        self.longitude = longitude
    }
    enum field: String {
        case title = "title"
        case detail = "detail"
        case fileName = "fileName"
        case roomId = "roomId"
        case createdUser = "createdUser"
        case shareUsers = "shareUsers"
        case latitude = "latitude"
        case longitude = "longitude"
    }
}
