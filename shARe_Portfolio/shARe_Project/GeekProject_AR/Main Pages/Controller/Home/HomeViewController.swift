//
//  HomeViewController.swift
//  GeekProject_AR
//
//  Created by yanagimachi_riku on 2019/08/12.
//  Copyright © 2019 Riku Yanagimachi. All rights reserved.
//


import UIKit
import NCMB
import SwiftMessages
import QuartzCore


class HomeViewController: UIViewController, CLLocationManagerDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var room: Room!

    var rooms = [Room]()
    
//①
//Update~~~~~~~
    var memos = [Memo](){
        didSet{
            tableView.reloadData()
        }
    }
    var selectedMemo: Memo!
    var memoVC: MemoViewController!
    var locManager: CLLocationManager!
    
    var sectionTitles = ["ルーム一覧" ,"居住者一覧" ,"メモ一覧"]
    
    var opened: Bool = false
    var usersName = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUserNameFromUserIds()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 44
        tableView.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        tableView.separatorColor = #colorLiteral(red: 1, green: 0.9652449118, blue: 0.9989234649, alpha: 1)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "HomeTableViewCell", bundle: Bundle.main),forCellReuseIdentifier:"Cell")

        tableView.register(UINib(nibName: "HomeTableViewCell3", bundle: Bundle.main),forCellReuseIdentifier:"Cell3")
        tableView.register(UINib(nibName: "HomeTableViewCell4", bundle: Bundle.main),forCellReuseIdentifier:"Cell4")
        
        
        // UILongPressGestureRecognizer宣言
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(cellLongPressed(recognizer:)))
        // `UIGestureRecognizerDelegate`を設定するのをお忘れなく
        longPressRecognizer.delegate = self
        // tableViewにrecognizerを設定
        tableView.addGestureRecognizer(longPressRecognizer)
        
        
        locManager = CLLocationManager()
        locManager.delegate = self
        
        // 位置情報の使用の許可を得る
        locManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .authorizedWhenInUse:
                // 座標の表示
                locManager.startUpdatingLocation()
                break
            default:
                break
            }
        }
        
        loadData()
        
    }
    

    
    
    /* 長押しした際に呼ばれるメソッド */
    @objc func cellLongPressed(recognizer: UILongPressGestureRecognizer) {
        
        // 押された位置でcellのPathを取得
        let point = recognizer.location(in: tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        if indexPath == nil {
            
        } else if recognizer.state == UIGestureRecognizer.State.began  {
            // 長押しされた場合の処理
            print("長押しされたcellのindexPath:\(indexPath?.row)")
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "EditCellViewController") as! EditCellViewController
            let segue = SwiftMessagesSegue(identifier: "toEditCellSegue", source: self, destination: destinationVC)
            
            segue.configure(layout: .centered)
            segue.dimMode = .blur(style: .dark, alpha: 0.9, interactive: true)
            segue.messageView.configureNoDropShadow()
            
            
            
            // Increase the internal layout margins. With the `.background` containment option,
            // the margin additions specify the outer margins around `messageView.backgroundView`.
            segue.messageView.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
            
            // Collapse layout margin edges that encroach on non-zero safe area insets.
            segue.messageView.collapseLayoutMarginAdditions = true
            
            // Add a default drop shadow.
            segue.messageView.configureDropShadow()
            
            // Indicate that the view controller's view should be installed
            // as the `backgroundView` of `messageView`.
            segue.containment = .background
            
            //let destinationVC = segue.destination as! EditCellViewController
            destinationVC.memo = memos[indexPath!.row]
            destinationVC.delegate = self
            
            segue.perform()
        }
    }
    
    
    
    func loadData(){
        guard let room = room else { return }
        print("入ったよHome")
        let currentUser = NCMBUser.current()
        let query = NCMBQuery(className: "Memo")
        //~~~~機能しません
        
        query?.whereKey("roomId", equalTo: room.id)
        
        //        query?.whereKey("shareUsers", containedInArrayTo: [currentUser!.objectId])
        query?.findObjectsInBackground({ (results, error) in
            guard error == nil else { return }
            guard let results = results else { return }
            var memos = [Memo]()
            let dispatchGroup = DispatchGroup()
            let dispatchQueue = DispatchQueue(label: "queue", attributes: .concurrent)
            
            for result in results as! [NCMBObject] {
                dispatchGroup.enter()
                dispatchQueue.async {
                    let title = result.object(forKey: Memo.field.title.rawValue) as! String
                    let detail = result.object(forKey: Memo.field.detail.rawValue) as! String
                    let fileName = result.object(forKey: Memo.field.fileName.rawValue) as! String
                    let roomId = result.object(forKey: Memo.field.roomId.rawValue) as! String
                    //~~~shareUsersというカラムを作成し、RoomクラスのuserIds:[String]を引っ張ってくる → Memoクラスに反映、表示。
                    let shareUsers = result.object(forKey: Memo.field.shareUsers.rawValue) as! [String]
                    let createdUser = result.object(forKey: Memo.field.createdUser.rawValue) as! NCMBUser
                    let latitude = result.object(forKey: Memo.field.latitude.rawValue) as! Double
                    let longitude = result.object(forKey: Memo.field.longitude.rawValue) as! Double
                    //~~~セルの原因ここら辺の可能性もあり
                    
                    createdUser.fetchInBackground({ (error) in
                        if let error = error {
                            print(error.localizedDescription)
                            return
                        } else {
                            //~~~createduserの内容入ってるcurrenthと一致しないとダメ
                            let currentUser = NCMBUser.current()
                            for user in shareUsers{
                                if user == currentUser?.objectId{
                                    let user = User(objectId: user, userName: currentUser!.userName)
                                    let memo = Memo(id: result.objectId, title: title, detail: detail, fileName: fileName, roomId: roomId, createdUser: user, shareUsers: shareUsers, latitude: latitude , longitude: longitude)
                                    memos.append(memo)
                                }else{
                                    //print("なんかおかしいぞ")
                                }
                            }
                            
                            //if Memo.roomId contains~~ Room.objectId{
                            
                            //                        }
                            dispatchGroup.leave()
                        }
                    })
                }
            }
            dispatchGroup.notify(queue: .main, execute: {
                self.memos = memos
                self.tableView.reloadData()
            })
        })
    }
    
    
    func getUserNameFromUserIds(){
        let query = NCMBQuery(className: "user")
        query?.findObjectsInBackground({ (results, error) in
            if error != nil{
                print(error)
            }else{
                for result in results as! [NCMBObject]{
                    let id = result.objectId!
                    let userName = result.object(forKey: "userName") as! String
                    if self.room.userIds.contains(id){
                        self.usersName.append(userName)
                    }
                }
            }
        })
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMemo" {
            let controller = segue.destination as! MemoViewController
            controller.memo = selectedMemo
        }else if segue.identifier == "toEditCellSegue" {
            let controller = segue.destination as! EditCellViewController
            controller.memo = selectedMemo
            print("toEditCell")
        }
        
    }
}




extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if opened == true{
                return room.userIds.count + 1
            }
            return 1
        } else {
            return memos.count
        }
    }

    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //セクションのタイトルを設定する。
        
        var sectionTitle = String()
        //メモ一覧セクション
        if section == 1{
            let memoList = sectionTitles[2]
            sectionTitle = memoList
        }
        return sectionTitle
    }
    
    // セクションの背景とテキストの色を変更する
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        // 背景色を変更する
        view.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)

//        let header = view as! UITableViewHeaderFooterView
//        // テキスト色を変更する
//        header.textLabel?.textColor = .white
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell3", for: indexPath) as? HomeTableViewCell3
            if opened == true{
                opened = false
                cell?.arrowImage.image = UIImage.init(systemName: "arrow.down.circle")
                
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
            }else{
                opened = true
                cell?.arrowImage.image = UIImage.init(systemName: "arrow.up.circle")
                
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
            }
        } else if indexPath.section == 1{
            // メモ詳細
            self.selectedMemo = memos[indexPath.row]
            let controller = storyboard?.instantiateViewController(withIdentifier: "MemoViewController") as! MemoViewController
            controller.memo = self.selectedMemo
            //NavigationController利用してshow遷移にしたいのでsegueでを利用
            self.performSegue(withIdentifier: "toMemo", sender: nil)
        }
    }
    

    
    
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            if indexPath.row == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell3", for: indexPath) as? HomeTableViewCell3
                cell?.roomNameLabel.text = room.roomName
                return cell!
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell4", for: indexPath) as? HomeTableViewCell4
                cell?.userName.text = usersName[indexPath.row - 1]

                
                return cell!
            }
            
            
            
        } else {
            //self.selectedMemo = memos[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? HomeTableViewCell
            
            cell?.titleLabel?.text = memos[indexPath.row].title
            cell?.byWhoLabel?.text = "by \(memos[indexPath.row].createdUser.userName)"
            //日付            //cell?.createdDateLabel.text = memos[indexPath.row]
            
            return cell!
        }
    
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}



extension HomeViewController: MemoARKitViewControllerDelegate {
    func endAddition() {
        loadData()
    }
    
}

