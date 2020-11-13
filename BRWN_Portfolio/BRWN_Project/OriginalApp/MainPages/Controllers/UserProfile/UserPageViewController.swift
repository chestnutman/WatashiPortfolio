//
//  UserPageViewController.swift
//  OriginalApp
//
//  Created by 鈴木賀子 on 11/07/2020.
//  Copyright © 2020 Yoshiko. All rights reserved.
//

import UIKit
import NCMB
import Kingfisher
import SVProgressHUD
import SwiftDate

extension UIFont {
    convenience init(name: FontNames4, size: CGFloat) {
        self.init(name: name.rawValue, size: size)!
    }
}

public enum FontNames4: String {
    case yuGothicBold = "YuGo-Bold"
    case yoGothicMedium = "YuGo-Medium"
    case hiraMaru = "HiraMaruProN-W4"
    case arialBrack = "Arial-Black"
    case hiraginoW3 = "HiraginoSans-W3"
    case hiraginoW5 = "HiraginoSans-W5"
    case hiraginoW4 = "HiraginoSans-W4"
    case hiraginoW1 = "HiraginoSans-W1"
    case hiraginoW2 = "HiraginoSans-W2"
    //追加していく
}


class UserPageViewController: UIViewController, TimeLineTableViewCellDelegate {
    
    var userInfo: User?
    
    var selectedPost: Post?
    var posts = [Post]()
    //var followings = [NCMBUser]()
    
    //プロフィール画像の宣言
    @IBOutlet var userProfImageView: UIImageView!
    @IBOutlet var timeLineTableView: UITableView!
    @IBOutlet var editButton: UIButton!
    
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var userTitleLabel: UILabel!
    @IBOutlet var userBioTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //画像を丸くする
        userProfImageView.layer.cornerRadius = userProfImageView.bounds.width/2.0
        userProfImageView.clipsToBounds = true
        
        
        // ボタンの装飾
        editButton.center = self.view.center
        
        editButton.backgroundColor = #colorLiteral(red: 0.251144737, green: 0.1601424813, blue: 0.1088011637, alpha: 1) // 3
        editButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        
        //consentButton1.layer.borderWidth = 4
        //consentButton1.layer.borderColor = #colorLiteral(red: 0.930855453, green: 0.8780241609, blue: 0.8337224126, alpha: 1)
        
        editButton.layer.cornerRadius = 15
        
        //       ナビゲーションバーの背景色
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        //        ナビゲーションバーのアイテムの色　（戻る　＜　とか　読み込みゲージとか）
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.251144737, green: 0.1601424813, blue: 0.1088011637, alpha: 1)
        //        ナビゲーションバーのテキストを変更する
        self.navigationController?.navigationBar.titleTextAttributes = [
            //        文字の色
            .foregroundColor: #colorLiteral(red: 0.251144737, green: 0.1601424813, blue: 0.1088011637, alpha: 1)
        ]
        
        // 字体の宣言
        userNameLabel.font = UIFont(name: "HiraginoSans-W5", size: 16)
        userTitleLabel.font = UIFont(name: "HiraginoSans-W4", size: 14)
        userBioTextView.font = UIFont(name: "HiraginoSans-W3", size: 13)
        
        
        // 枠のカラー
        // userBioTextView.layer.borderColor = UIColor.
        // 枠の幅
        // userBioTextView.layer.borderWidth = 1.0
        // 枠を角丸にする
        // userBioTextView.layer.cornerRadius = 10.0
        // userBioTextView.layer.masksToBounds = true
        
        timeLineTableView.dataSource = self
        timeLineTableView.delegate = self
        
        let nib = UINib(nibName: "TimeLineTableViewCell", bundle: Bundle.main)
        timeLineTableView.register(nib, forCellReuseIdentifier: "Cell")
        timeLineTableView.tableFooterView = UIView()
        
        // TableViewの不要な線を消す
        timeLineTableView.tableFooterView = UIView()
        
        // 引っ張って更新
        setRefreshControl()
        
        // フォロー中のユーザーを取得する。その後にフォロー中のユーザーの投稿のみ読み込み
        // loadFollowingUsers()
    }
    
    
    
    //Update~~~~~
    //     プロフィール画像を表示する
    override func viewWillAppear(_ animated: Bool) {
        noUserId()
        loadUserInfo()
        loadUserPagePosts()
    }
    
    
    
    //Update~~~~~
    func noUserId(){
        if NCMBUser.current() == nil{
            let alertController = UIAlertController(title: "ユーザ情報", message: "ログインしますか？", preferredStyle: .alert)
            // ログイン画面移動ボタン
            let loginAction = UIAlertAction(title: "ログイン", style: .default) { (action) in
                let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
                let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
                UIApplication.shared.keyWindow?.rootViewController = rootViewController
                //ログアウト状態の保持
                let ud = UserDefaults.standard
                ud.set(false, forKey: "isLogin")
                ud.synchronize()
            }
            
            // キャンセル機能
            let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
                alertController.dismiss(animated: true, completion: nil)
            }
            
            // アクション機能をつける
            alertController.addAction(loginAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    //Update~~~~~
    func loadUserInfo(){
        let query = NCMBUser.query()
        query?.findObjectsInBackground({ (results, error) in
            for result in results as! [NCMBObject]{
                if NCMBUser.current()?.objectId == result.objectId{
                    let objectId = result.objectId
                    let userDisplayName = result.object(forKey: "userDisplayName") as? String
                    let userName = result.object(forKey: "userName") as! String
                    let userTitle = result.object(forKey: "userTitle") as? String
                    let userBio = result.object(forKey: "userBio") as? String
                    let mailAddress = result.object(forKey: "mailAddress") as? String
                    
                    self.userInfo = User(objectId: objectId!, userId: userName, userDisplayName: userDisplayName ?? "", userTitle: userTitle ?? "", userBio: userBio ?? "", mailAddress: mailAddress ?? "")
                    
                    
                    self.userNameLabel.text = userName
                    self.userTitleLabel.text = userTitle
                    self.userBioTextView.text = userBio
                    
                    
                    let currentFile = NCMBFile.file(withName: NCMBUser.current()!.objectId + ".jpg", data: nil) as! NCMBFile
                    // 保存処理を実行
                    currentFile.getDataInBackground({ (Data, error) in
                        if error != nil {
                            print(error)
                        } else {
                            if Data != nil {
                                let image = UIImage(data: Data!)
                                self.userProfImageView.image = image
                            }
                        }
                    })
                    
                    
                }
            }
        })
        
    }
    
    
    
    
    //Update~~~~~
    func loadUserPagePosts() {
        let query = NCMBQuery(className: "Post")
        // 降順
        query?.order(byDescending: "createDate")
        // 投稿したユーザーの情報も同時取得
        query?.includeKey("postUser")
        //  自分の投稿だけ持ってくる
        query?.whereKey("postUser", equalTo: NCMBUser.current())
        // オブジェクトの取得
        query?.findObjectsInBackground({ (results, error) in
            if error != nil {
                SVProgressHUD.showError(withStatus: error!.localizedDescription)
            } else {
                // 投稿を格納しておく配列を初期化(これをしないとreload時にappendで二重に追加されてしまう)
                self.posts = [Post]()
                
                for result in results as! [NCMBObject] {
                    
                    let postObjectId = result.objectId as! String
                    
                    let postUser = result.object(forKey: "postUser") as! NCMBUser
                    let userDisplayName = postUser.object(forKey: "userDisplayName") as? String
                    let userTitle = postUser.object(forKey: "userTitle") as? String
                    let userBio = postUser.object(forKey: "userBio") as? String
                    let mailAddress = postUser.object(forKey: "mailAddress") as? String
                    
                    
                    let postTitle = result.object(forKey: "postTitle") as! String
                    let postDetailText = result.object(forKey: "postDetailText") as! String
                    let postImage = result.object(forKey: "postImage") as! String
                    let postShopName = result.object(forKey: "postShopName") as! String
                    let postShopStation = result.object(forKey: "postShopStation") as! String
                    let postShopAddress = result.object(forKey: "postShopAddress") as! String
                    let createDate = result.createDate as! Date
                    
                    
                    let userDetail = User(objectId: postUser.objectId, userId: postUser.userName, userDisplayName: userDisplayName ?? "", userTitle: userTitle ?? "", userBio: userBio ?? "", mailAddress: mailAddress ?? "")
                    
                    let post = Post(objectId: postObjectId, postUser: userDetail, postTitle: postTitle, postDetailText: postDetailText, postImage: postImage, postShopName: postShopName, postShopStation: postShopStation, postShopAddress: postShopAddress, createDate: createDate)
                    
                    self.posts.append(post)
                }
                
                // 投稿のデータが揃ったらTableViewをリロード
                self.timeLineTableView.reloadData()
            }
        })
    }
    
    func setRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadUserPage(refreshControl:)), for: .valueChanged)
        timeLineTableView.addSubview(refreshControl)
    }
    
    @objc func reloadUserPage(refreshControl: UIRefreshControl) {
        refreshControl.beginRefreshing()
        // self.loadFollowingUsers()
        // 更新が早すぎるので2秒遅延させる
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            refreshControl.endRefreshing()
        }
    }
    
    
    /*    func loadFollowingUsers() {
     // フォロー中の人だけ持ってくる
     let query = NCMBQuery(className: "Follow")
     query?.includeKey("user")
     query?.includeKey("following")
     query?.whereKey("user", equalTo: NCMBUser.current())
     query?.findObjectsInBackground({ (result, error) in
     if error != nil {
     SVProgressHUD.showError(withStatus: error!.localizedDescription)
     } else {
     self.followings = [NCMBUser]()
     for following in result as! [NCMBObject] {
     self.followings.append(following.object(forKey: "following") as! NCMBUser)
     }
     self.followings.append(NCMBUser.current())
     
     self.loadTimeLine()
     }
     })
     }  */
    
    
    
    //Update~~~~~
    @IBAction func editProfile () {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nc = storyboard.instantiateViewController(withIdentifier: "EditProfileNavigationController") as! UINavigationController
        let destination = nc.topViewController as! EditProfileViewController
        destination.userInfo = self.userInfo
        
        self.present(nc,animated: true,completion: nil)
    }
    
    
    @IBAction func showMenu () {
        let alertControleer = UIAlertController(title: "メニュー", message: "メニューを選択してください。", preferredStyle: .actionSheet)
        // ログアウト機能をつける
        let signOutAction = UIAlertAction(title: "ログアウト", style: .default) { (action) in NCMBUser.logOutInBackground { (error) in
            if error != nil {
                print(error)
            }else{
                // ログアウトに成功した時SignInに戻るようにする
                let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
                let rootViewController = storyboard.instantiateViewController(identifier: "RootNavigationController")
                UIApplication.shared.keyWindow?.rootViewController = rootViewController
                // ログアウトできたらログアウト情報を保持する
                let ud = UserDefaults.standard
                ud.set(false, forKey: "isLogin")
                ud.synchronize()
            }
            }
        }
        // 退会機能をつける
        let deleteAction = UIAlertAction(title: "退会", style: .default) { (action) in
            // どのユーザーを退会させるかを選別
            let user = NCMBUser.current()
            user?.deleteInBackground({ (error) in
                if error != nil {
                    print(error)
                }else{
                    //退会に成功したら、サインインに戻る
                    let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
                    let rootViewController = storyboard.instantiateViewController(identifier: "RootNavigationController")
                    UIApplication.shared.keyWindow?.rootViewController = rootViewController
                    // 退会できたら退会情報を保持する
                    let ud = UserDefaults.standard
                    ud.set(false, forKey: "isLogin")
                    ud.synchronize()
                }
            })
        }
        // キャンセル機能をつける
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            alertControleer.dismiss(animated: true, completion: nil)
        }
        
        // すべてのボタンにアクション機能をつける
        alertControleer.addAction(signOutAction)
        alertControleer.addAction(deleteAction)
        alertControleer.addAction(cancelAction)
        
        // アクションを表示する
        self.present(alertControleer, animated: true, completion: nil)
    }
    
}






extension UserPageViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 185
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    
    
//    func getImageDataFromNCMB(imageString: String) -> UIImage{
//        var resizedImage: UIImage?
//
//        let file = NCMBFile.file(withName: imageString, data: nil) as! NCMBFile
//        file.getDataInBackground { (result, error) in
//            if error != nil{
//                print(error)
//            }else{
//                let selectedImage = UIImage.init(data: result as! Data)
//
//                let cgImage = selectedImage?.cgImage
//
//                let selectedImage2 = UIImage(cgImage: cgImage!, scale: 0, orientation: selectedImage!.imageOrientation)
//
//                resizedImage = selectedImage2.scale(byFactor: 0.3)
//
//            }
//        }
//        return resizedImage!
//    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TimeLineTableViewCell
        
        cell.delegate = self
        cell.tag = indexPath.row
        
        
        cell.userNameLabel.text = posts[indexPath.row].postUser.userDisplayName
        cell.userTitleLabel.text = posts[indexPath.row].postUser.userTitle
        
        //fileStoreから引っ張ってくる必要あり
        
        cell.postShopNameLabel.text = posts[indexPath.row].postShopName
        cell.postTitleTextView.text = posts[indexPath.row].postTitle
        //        cell.timeStampLabel.text = posts[indexPath.row].createDate
        
        let userImageName = posts[indexPath.row].objectId + ".jpg"
        
        let postImageName = posts[indexPath.row].postImage
        
        var imageArray:[String] = [userImageName, postImageName]
        for i in 0...2{
            for j in imageArray as! [String]{
                let file = NCMBFile.file(withName: j, data: nil) as! NCMBFile
                file.getDataInBackground({ (result, error) in
                    if error != nil{
                        SVProgressHUD.showError(withStatus: error!.localizedDescription)
                    }else{
                        //                    let selectedImage = UIImage.init(data: result as! Data)
                        //
                        //                    let cgImage = selectedImage?.cgImage
                        //
                        //                    let selectedImage2 = UIImage(cgImage: cgImage!, scale: 0, orientation: selectedImage!.imageOrientation)
                        //
                        //                    let resizedImage = selectedImage2.scale(byFactor: 0.3)
                        
                        if j.contains(".jpg"){
                            cell.userImageView.image = UIImage.init(data: result!)
                        }else{
                            cell.postImageView.image = UIImage.init(data: result!)
                        }
                        
                    }
                }, progressBlock: { (progress) in
                    if Int(progress) == 100{
                        print("ダウンロード完了")
                    }
                })
            }
            
            
        }
        
        //        let user = posts[indexPath.row].postUser
        //        cell.userNameLabel.text = user.userName
        //        let userImageUrl = "https://mb.api.cloud.nifty.com/2013-09-01/applications/DPB9UeoUPUZdQXe9/publicFiles/" + user.objectId
        //        cell.userImageView.kf.setImage(with: URL(string: userImageUrl), placeholder: UIImage(named: "Placeholder.png"))
        //
        //        // Date ⇔ Stringの相互変換をしてくれるすごい人
        //        let dateFormatter = DateFormatter()
        //        // フォーマット設定
        //        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        //        // 端末設定によらず西暦（グレゴリオ暦）で処理するようにする
        //        dateFormatter.calendar = Calendar(identifier: .gregorian)
        //        // ロケール設定 (意図して端末設定に合わせたい場合)
        //        dateFormatter.locale = Locale.current
        //        // 変換
        //        let str = dateFormatter.string(from: Date())
        //        // 結果表示
        //        print(str) // -> 2020/01/09 17:18:01
        //        // タイムスタンプ(投稿日時) (※フォーマットのためにSwiftDateライブラリをimport)
        //        cell.timeStampLabel.text = str
        
        return cell
    }
    
}
