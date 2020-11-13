//
//  BaseViewController.swift
//  GeekProject_AR
//
//  Created by yanagimachi_riku on 2019/08/20.
//  Copyright © 31 Heisei Riku Yanagimachi. All rights reserved.
//



import UIKit
import Tabman
import Pageboy
import NCMB


class BaseViewController: TabmanViewController {
    
    var rooms = [Room]()

    var viewControllers = [UIViewController]()
//    {
//        didSet{
//            self.reloadData()
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Neoneon", size: 35)!]

        
        self.view.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        
        loadData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    
    
    
    private func configureTab() {
        dataSource = self
        
        let bar = TMBar.ButtonBar()
        if bars.count > 0 {
            removeBar(bars.first!)
        }
        
        if rooms.count > 5{
            bar.layout.contentMode = .intrinsic
            bar.layout.alignment = .centerDistributed
        }else{
            bar.layout.contentMode = .fit
            bar.layout.alignment = .centerDistributed
        }
        bar.backgroundView.style = .flat(color: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))
        bar.layout.transitionStyle = .snap
        bar.indicator.tintColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        addBar(bar, dataSource: self, at: .top)
        
        bar.buttons.customize { (button) in
            button.selectedTintColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            button.tintColor = .white

        }
    }

    
    func loadData(){
        let query = NCMBQuery(className: "Room")
        guard let currentUser = NCMBUser.current() else { return }
        print("入ったよBase")
        query?.includeKey("name")
        query?.whereKey("userIds", containedInArrayTo: [currentUser.objectId])
        query?.findObjectsInBackground({ (objects, error) in
            guard error == nil else { return }
            guard let objects = objects else { return }
            var rooms = [Room]()
            for object in objects as! [NCMBObject] {
                //userIdsが一致する部屋情報の取得
                let name = object.object(forKey: "name") as! String
                let userIds = object.object(forKey: "userIds") as! [String]
                let room = Room(id: object.objectId, roomName: name, userIds: userIds)
                rooms.append(room)
            }
                self.rooms = rooms
                self.configureTab()
            })
        }
    
    
    func initializeViewControllers() {
        // Add ViewControllers
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        viewControllers.removeAll()
        guard rooms.count > 0 else { return }
        for _ in 0...rooms.count-1 {
            let homeViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            viewControllers.append(homeViewController)
        }
    }
    
}

extension BaseViewController: PageboyViewControllerDataSource, TMBarDataSource {
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        initializeViewControllers()
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        let viewController = viewControllers[index] as! HomeViewController
        viewController.room = rooms[index]
        return viewController
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
    
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        var items = [TMBarItem]()
        
        for room in rooms {
            let item = TMBarItem(title: room.roomName)
            items.append(item)
        }
        return items[index]
    }
}

extension BaseViewController: MemoARKitViewControllerDelegate {
    func endAddition() {
        loadData()
    }
    
}


