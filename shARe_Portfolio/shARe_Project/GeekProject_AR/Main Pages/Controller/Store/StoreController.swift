//
//  StoreController.swift
//  GeekProject_AR
//
//  Created by yanagimachi_riku on 2020/06/21.
//  Copyright © 2020 Riku Yanagimachi. All rights reserved.
//

import Foundation

class StoreController {

    struct AssetsPack: Hashable {
        let title: String
        let category: String
        let pic: String
        let identifier = UUID()
        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }
    }

    struct AssetsPackCollection: Hashable {
        let title: String
        let packs: [AssetsPack]

        let identifier = UUID()
        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }
    }
    
    struct ScrollCollection: Hashable {
        let title: String
        let packs: [AssetsPack]

        let identifier = UUID()
        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }
    }

//    var collections1: [ScrollCollection] {
//        return _collections1
//    }
    
    var collections2: [AssetsPackCollection] {
        return _collections2
    }

    init() {
        generateCollections()
    }
    //fileprivate var _collections1 = [ScrollCollection]()
    fileprivate var _collections2 = [AssetsPackCollection]()
}

extension StoreController {
    func generateCollections() {
//        _collections1 = [
//            ScrollCollection(title: "Trends", videos: [Video(title: "pic08", category: "idunno"),
//                                                       Video(title: "pic09", category: "idunno"),
//                                                       Video(title: "pic10", category: "idunno")])
//        ]
        
        _collections2 = [
            
            AssetsPackCollection(title: "アンティークセット",
                                 packs: [AssetsPack(title: "Bringing Your Apps to the New iPad Pro", category: "Tech Talks", pic: "pic01"),
                                         AssetsPack(title: "Designing for iPad Pro and Apple Pencil", category: "Tech Talks", pic: "pic02")]),

            AssetsPackCollection(title: "夢kawaiiセット",
                            packs: [AssetsPack(title: "Building Apps for iPhone XS, iPhone XS Max, and iPhone XR",
                                               category: "Tech Talks", pic: "pic03"),
                                      AssetsPack(title: "Designing for Apple Watch Series 4",
                                                 category: "Tech Talks", pic: "pic04"),
                                      AssetsPack(title: "Developing Complications for Apple Watch Series 4",
                                            category: "Tech Talks", pic: "pic05"),
                                      AssetsPack(title: "What's New in Core NFC",
                                            category: "Tech Talks", pic: "pic06")]),

            AssetsPackCollection(title: "偉大な自然セット",
                            packs: [AssetsPack(title: "App Store Connect Basics", category: "App Store Connect", pic: "pic07"),
                                      AssetsPack(title: "App Analytics Retention", category: "App Store Connect", pic: "pic08"),
                                      AssetsPack(title: "App Analytics Metrics", category: "App Store Connect", pic: "pic09"),
                                      AssetsPack(title: "App Analytics Overview", category: "App Store Connect", pic: "pic10"),
                                      AssetsPack(title: "TestFlight", category: "App Store Connect", pic: "pic05")]),

            AssetsPackCollection(title: "RPGセット",
                            packs: [AssetsPack(title: "What's new in watchOS", category: "Conference 2018", pic: "pic06"),
                                      AssetsPack(title: "Updating for Apple Watch Series 3", category: "Tech Talks", pic: "pic01"),
                                      AssetsPack(title: "Planning a Great Apple Watch Experience",
                                            category: "Conference 2017", pic: "pic02"),
                                      AssetsPack(title: "News Ways to Work with Workouts", category: "Conference 2018", pic: "pic03"),
                                      AssetsPack(title: "Siri Shortcuts on the Siri Watch Face",
                                            category: "Conference 2018", pic: "pic04"),
                                      AssetsPack(title: "Creating Audio Apps for watchOS", category: "Conference 2018", pic: "pic05"),
                                      AssetsPack(title: "Designing Notifications", category: "Conference 2018", pic: "pic06")]),

            AssetsPackCollection(title: "GeekSalonセット",
                            packs: [AssetsPack(title: "Introduction to Siri Shortcuts", category: "Conference 2018", pic: "pic07"),
                                     AssetsPack(title: "Building for Voice with Siri Shortcuts",
                                           category: "Conference 2018", pic: "pic08"),
                                     AssetsPack(title: "What's New in SiriKit", category: "Conference 2017", pic: "pic09"),
                                     AssetsPack(title: "Making Great SiriKit Experiences", category: "Conference 2017", pic: "pic10"),
                                     AssetsPack(title: "Increase Usage of You App With Proactive Suggestions",
                                           category: "Conference 2018", pic: "pic01")])
        ]
    }
}
