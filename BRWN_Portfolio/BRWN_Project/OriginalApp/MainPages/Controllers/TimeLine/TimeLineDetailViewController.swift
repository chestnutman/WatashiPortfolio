//
//  TimeLineDetailViewController.swift
//  OriginalApp
//
//  Created by 鈴木賀子 on 10/08/2020.
//  Copyright © 2020 Yoshiko. All rights reserved.
//
import UIKit
import NCMB
import Kingfisher
import SVProgressHUD
import SwiftDate


//Update~~~~~~

class TimeLineDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TimeLineDetailTableViewCellDelegate {
  
    var delegate: TimeLineDetailTableViewCellDelegate?
    var selectedPost: Post?
//  var followings = [NCMBUser]()
    
    
    @IBOutlet var timeLineDetailTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeLineDetailTableView.dataSource = self
        timeLineDetailTableView.delegate = self
        
        let nib = UINib(nibName: "TimeLineDetailTableViewCell", bundle: Bundle.main)
        timeLineDetailTableView.register(nib, forCellReuseIdentifier: "DetailCell")
        timeLineDetailTableView.tableFooterView = UIView()
        
        // 引っ張って更新
        setRefreshControl()
        
        // self.navigationController?.navigationBar.isHidden = true
        
       //       ナビゲーションバーの背景色
                     self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
              //        ナビゲーションバーのアイテムの色　（戻る　＜　とか　読み込みゲージとか）
                      self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.251144737, green: 0.1601424813, blue: 0.1088011637, alpha: 1)
              //        ナビゲーションバーのテキストを変更する
                     self.navigationController?.navigationBar.titleTextAttributes = [
              //        文字の色
                      .foregroundColor: #colorLiteral(red: 0.251144737, green: 0.1601424813, blue: 0.1088011637, alpha: 1)
                     ]
        
        
        
        // フォロー中のユーザーを取得する。その後にフォロー中のユーザーの投稿のみ読み込み
        //loadFollowingUsers()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toComments" {
            let commentViewController = segue.destination as! CommentViewController
            commentViewController.postId = selectedPost?.objectId
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 849
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let detailCell = tableView.dequeueReusableCell(withIdentifier: "DetailCell") as! TimeLineDetailTableViewCell
        
        detailCell.delegate = self
        detailCell.tag = indexPath.row
        
        
        // 投稿写真を持ってくる
        let detailPostImage = selectedPost?.postImage
        let postImageName = selectedPost?.postImage
              let file = NCMBFile.file(withName: postImageName, data: nil) as! NCMBFile
              file.getDataInBackground { (result, error) in
                  if error != nil{
                      print(error)
                  }else{
//                      let selectedImage = UIImage.init(data: result as! Data)
//
//                      let cgImage = selectedImage?.cgImage
//
//                      let selectedImage2 = UIImage(cgImage: cgImage!, scale: 0, orientation: selectedImage!.imageOrientation)
//
//                      let resizedImage = selectedImage2.scale(byFactor: 0.3)
//                      detailCell.postImageView.image = resizedImage
                    detailCell.postImageView.image = UIImage.init(data: result as! Data)
                    
                }
        }
        
//        // image入れる
//
//    let cgImage = selectedImage?.cgImage
//                let selectedImage2 = UIImage(cgImage: cgImage!, scale: 0, orientation: selectedImage!.imageOrientation)
//                let resizedImage = selectedImage2.scale(byFactor: 0.3)
//                detailCell.postImageView.image = resizedImage
                
                
        // detailCell.userImageView
        
       detailCell.postTitleTextView.text = selectedPost?.postTitle
       detailCell.postDetailTextView.text = selectedPost?.postDetailText
       detailCell.postShopNameLabel.text = selectedPost?.postShopName
       detailCell.postShopStationLabel.text = selectedPost?.postShopStation
       detailCell.postShopAddressLabel.text = selectedPost?.postShopAddress
       detailCell.userNameLabel.text = selectedPost?.postUser.userDisplayName
       detailCell.userTitleLabel.text = selectedPost?.postUser.userTitle
        
        
        
//        let user = posts[indexPath.row].user
//        detailCell.userNameLabel.text = user.userName
//        let userImageUrl = "https://mb.api.cloud.nifty.com/2013-09-01/applications/DPB9UeoUPUZdQXe9/publicFiles/" + user.objectId
//        detailCell.userImageView.kf.setImage(with: URL(string: userImageUrl), placeholder: UIImage(named: "Placeholder.png"))
//
//        // Likeによってハートの表示を変える
//        if posts[indexPath.row].isLiked == true {
//            detailCell.goodButton.setImage(UIImage(named: "good-fill"), for: .normal)
//        } else {
//            detailCell.goodButton.setImage(UIImage(named: "good-outline"), for: .normal)
//        }
        
        // Date ⇔ Stringの相互変換をしてくれるすごい人
        let dateFormatter = DateFormatter()
        // フォーマット設定
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        // 端末設定によらず西暦（グレゴリオ暦）で処理するようにする
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        // ロケール設定 (意図して端末設定に合わせたい場合)
        dateFormatter.locale = Locale.current
        // 変換
        let str = dateFormatter.string(from: Date())
        // 結果表示
        print(str) // -> 2020/01/09 17:18:01
        // タイムスタンプ(投稿日時) (※フォーマットのためにSwiftDateライブラリをimport)
        detailCell.timeStampLabel.text = str
        
        return detailCell
    }
    
    
    func didTapGoodButton(tableViewCell: UITableViewCell, button: UIButton) {
//
//        guard let currentUser = NCMBUser.current() else {
//            // ログイン画面に戻る
//            let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
//            let rootViewController = storyboard.instantiateViewController(identifier: "RootNavigationController")
//            UIApplication.shared.keyWindow?.rootViewController = rootViewController
//            // ログアウトできたらログアウト情報を保持する
//            let ud = UserDefaults.standard
//            ud.set(false, forKey: "isLogin")
//            ud.synchronize()
//            return
//            }
//
//        if posts[tableViewCell.tag].isLiked == false || posts[tableViewCell.tag].isLiked == nil {
//            let query = NCMBQuery(className: "Post")
//            query?.getObjectInBackground(withId: posts[tableViewCell.tag].objectId, block: { (post, error) in
//                post?.addUniqueObject(NCMBUser.current().objectId, forKey: "likeUser")
//                post?.saveEventually({ (error) in
//                    if error != nil {
//                        SVProgressHUD.showError(withStatus: error!.localizedDescription)
//                    } else {
//                        self.loadTimeLine()
//                    }
//                })
//            })
//        } else {
//            let query = NCMBQuery(className: "Post")
//            query?.getObjectInBackground(withId: posts[tableViewCell.tag].objectId, block: { (post, error) in
//                if error != nil {
//                    SVProgressHUD.showError(withStatus: error!.localizedDescription)
//                } else {
//                    post?.removeObjects(in: [NCMBUser.current().objectId], forKey: "likeUser")
//                    post?.saveEventually({ (error) in
//                        if error != nil {
//                            SVProgressHUD.showError(withStatus: error!.localizedDescription)
//                        } else {
//                            self.loadTimeLine()
//                        }
//                    })
//                }
//            })
//        }
    }
    
    func didTapMenuButton(tableViewCell: UITableViewCell, button: UIButton) {
//        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        let deleteAction = UIAlertAction(title: "削除する", style: .destructive) { (action) in
//            SVProgressHUD.show()
//            let query = NCMBQuery(className: "Post")
//            query?.getObjectInBackground(withId: self.posts[tableViewCell.tag].objectId, block: { (post, error) in
//                if error != nil {
//                    SVProgressHUD.showError(withStatus: error!.localizedDescription)
//                } else {
//                    // 取得した投稿オブジェクトを削除
//                    post?.deleteInBackground({ (error) in
//                        if error != nil {
//                            SVProgressHUD.showError(withStatus: error!.localizedDescription)
//                        } else {
//                            // 再読込
//                            self.loadTimeLine()
//                            SVProgressHUD.dismiss()
//                        }
//                    })
//                }
//            })
//        }
//        let reportAction = UIAlertAction(title: "報告する", style: .destructive) { (action) in
//            SVProgressHUD.showSuccess(withStatus: "この投稿を報告しました。ご協力ありがとうございました。")
//        }
//        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
//            alertController.dismiss(animated: true, completion: nil)
//        }
//        if posts[tableViewCell.tag].postUser.objectId == NCMBUser.current().objectId {
//            // 自分の投稿なので、削除ボタンを出す
//            alertController.addAction(deleteAction)
//        } else {
//            // 他人の投稿なので、報告ボタンを出す
//            alertController.addAction(reportAction)
//        }
//        alertController.addAction(cancelAction)
//        self.present(alertController, animated: true, completion: nil)
    }
    
    func didTapCommentsButton(tableViewCell: UITableViewCell, button: UIButton) {
 /*       // 選ばれた投稿を一時的に格納
        selectedPost = posts[tableViewCell.tag]
        
        // 遷移させる(このとき、prepareForSegue関数で値を渡す)
        self.performSegue(withIdentifier: "toComments", sender: nil)
 */
    }
    
//    func loadTimeLine() {
//
//        guard let currentUser = NCMBUser.current() else {
//        // ログイン画面に戻る
//        let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
//        let rootViewController = storyboard.instantiateViewController(identifier: "RootNavigationController")
//        UIApplication.shared.keyWindow?.rootViewController = rootViewController
//        // ログアウトできたらログアウト情報を保持する
//        let ud = UserDefaults.standard
//        ud.set(false, forKey: "isLogin")
//        ud.synchronize()
//        return
//        }
//
//        let query = NCMBQuery(className: "Post")
//
//        // 降順
//        query?.order(byDescending: "createDate")
//
//        // 投稿したユーザーの情報も同時取得
//        query?.includeKey("user")
//
///*        // フォロー中の人 + 自分の投稿だけ持ってくる
//        query?.whereKey("user", containedIn: followings)
// */
//
//        // オブジェクトの取得
//        query?.findObjectsInBackground({ (result, error) in
//            if error != nil {
//                SVProgressHUD.showError(withStatus: error!.localizedDescription)
//            } else {
//                // 投稿を格納しておく配列を初期化(これをしないとreload時にappendで二重に追加されてしまう)
//                self.posts = [Post]()
//
//                for postObject in result as! [NCMBObject] {
//                    // ユーザー情報をUserクラスにセット
//                    let user = postObject.object(forKey: "user") as! NCMBUser
//
//                    // 退会済みユーザーの投稿を避けるため、activeがfalse以外のモノだけを表示
//                    if user.object(forKey: "active") as? Bool != false {
//                        // 投稿したユーザーの情報をUserモデルにまとめる
//                        let userModel = User(objectId: user.objectId, userId: user.userName)
//                        userModel.userName = user.object(forKey: "displayName") as? String
//
//                        // 投稿の情報を取得
//                        let imageUrl = postObject.object(forKey: "imageUrl") as! String
//                        let text = postObject.object(forKey: "text") as! String
//
//                        // 2つのデータ(投稿情報と誰が投稿したか?)を合わせてPostクラスにセット
////                        let post = Post(objectId: postObject.objectId, user: userModel, imageUrl: imageUrl, text: text, createDate: postObject.createDate)
////
////                        // likeの状況(自分が過去にLikeしているか？)によってデータを挿入
////                        let likeUsers = postObject.object(forKey: "likeUser") as? [String]
////                        if likeUsers?.contains(currentUser.objectId) == true {
////                            post.isLiked = true
////                        } else {
////                            post.isLiked = false
////                        }
////                        // 配列に加える
////                        self.posts.append(post)
//                    }
//                }
//
//                // 投稿のデータが揃ったらTableViewをリロード
//                self.timeLineDetailTableView.reloadData()
//            }
//        })
//    }

    func setRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadTimeLine(refreshControl:)), for: .valueChanged)
        timeLineDetailTableView.addSubview(refreshControl)
    }
    
    @objc func reloadTimeLine(refreshControl: UIRefreshControl) {
        refreshControl.beginRefreshing()
        //self.loadFollowingUsers()
        // 更新が早すぎるので2秒遅延させる
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            refreshControl.endRefreshing()
        }
    }
    
/*  func loadFollowingUsers() {
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
    }
*/
    

    
}
