//
//  Room.swift
//  GeekProject_AR
//
//  Created by yanagimachi_riku on 2019/08/19.
//  Copyright © 2019 Riku Yanagimachi. All rights reserved.
//

import Foundation
import NCMB

class Room: NSObject{
    var id: String
    var roomName: String
    var userIds: [String]
    var createdUser: String?
    var invitationCode: String
    
    init(id: String, roomName: String, userIds: [String]) {
        self.id = id
        self.roomName = roomName
        self.userIds = userIds
        invitationCode = Room.randomString(length: 12)
    }
   
    // 指定した長さ（桁数）のランダムな文字列を生成するfunctionを定義
    static func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }

    enum field: String {
        case userIds = "userIds"
    }
    
    
}
