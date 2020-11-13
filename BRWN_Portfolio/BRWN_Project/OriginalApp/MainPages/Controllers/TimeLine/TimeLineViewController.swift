//
//  TimeLineViewController.swift
//  OriginalApp
//
//  Created by 鈴木賀子 on 12/07/2020.
//  Copyright © 2020 Yoshiko. All rights reserved.
//

import UIKit
import NCMB
import Kingfisher
import SVProgressHUD
import SwiftDate

//font arrange
extension UIFont {
    convenience init(name: FontNames3, size: CGFloat) {
        self.init(name: name.rawValue, size: size)!
    }
}

public enum FontNames3: String {
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

class TimeLineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TimeLineTableViewCellDelegate {
    
    
    var selectedPost: Post?

    private var posts: [Post] = [] {
        didSet {
            print("これは呼ばれてますね")
            timeLineTableView?.reloadData()
        }
    }
    
    
    //var followings = [NCMBUser]()
    
    @IBOutlet var timeLineTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeLineTableView.dataSource = self
        timeLineTableView.delegate = self
        
        let nib = UINib(nibName: "TimeLineTableViewCell", bundle: Bundle.main)
        timeLineTableView.register(nib, forCellReuseIdentifier: "Cell")
        timeLineTableView.tableFooterView = UIView()
        
        // 引っ張って更新
//        setRefreshControl()
        
        
        
        // フォロー中のユーザーを取得する。その後にフォロー中のユーザーの投稿のみ読み込み
        // loadFollowingUsers()
//①~~~~~~~
        loadTimeLine()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        // storyboardの背景色を変える
        view.backgroundColor = #colorLiteral(red: 0.2509803922, green: 0.1607843137, blue: 0.1098039216, alpha: 1)
        
        //let appearance = UINavigationBarAppearance()
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.titleTextAttributes = [
               // 文字の色
               .foregroundColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
           ]

        //       ナビゲーションバーの背景色
              self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        //        ナビゲーションバーのアイテムの色　（戻る　＜　とか　読み込みゲージとか）
                self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.2509803922, green: 0.1607843137, blue: 0.1098039216, alpha: 1)
        //        ナビゲーションバーのテキストを変更する
               self.navigationController?.navigationBar.titleTextAttributes = [
        //        文字の色
                .foregroundColor: #colorLiteral(red: 0.2509803922, green: 0.1607843137, blue: 0.1098039216, alpha: 1)
               ]
                
                
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TimeLineTableViewCell
        
        cell.delegate = self
        cell.tag = indexPath.row
        
//        //初期化
//        cell.postImageView.image = nil
        
        cell.userNameLabel.text = posts[indexPath.row].postUser.userDisplayName
        cell.userTitleLabel.text = posts[indexPath.row].postUser.userTitle
        
        //fileStoreから引っ張ってくる必要あり
        
        cell.postShopNameLabel.text = posts[indexPath.row].postShopName
        cell.postTitleTextView.text = posts[indexPath.row].postTitle
        //        cell.timeStampLabel.text = posts[indexPath.row].createDate
        
        //fontArrange
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        //また、この状態だと横幅に合わせたFontSizeで1行表示になるので改行を無限にする
        cell.textLabel?.numberOfLines = 0
        
        // 字体の宣言
        cell.postTitleTextView.font = UIFont(name: "HiraginoSans-W5", size: 17)
  
//フォント
        //文字変わる&色変わる
        cell.postShopNameLabel.font = UIFont(name: "HiraginoSans-W3", size: 19)
        cell.userTitleLabel.font = UIFont(name: "HiraMaruProN-W2", size: 10)
        //文字変わる
        cell.userNameLabel.font = UIFont(name: "HiraMaruProN-W4", size: 10)
        cell.timeStampLabel.font = UIFont(name: "HiraMaruProN-W1", size: 9)
        
        
        let postImageName = posts[indexPath.row].postImage
        let file = NCMBFile.file(withName: postImageName, data: nil) as! NCMBFile
        file.getDataInBackground { (result, error) in
            if error != nil{
                print(error)
            }else{
                let selectedImage = UIImage.init(data: result as! Data)

                let cgImage = selectedImage?.cgImage

                let selectedImage2 = UIImage(cgImage: cgImage!, scale: 0, orientation: selectedImage!.imageOrientation)

                let resizedImage = selectedImage2.scale(byFactor: 0.3)
                let croppedImage = resizedImage?.cropping(to: CGRect(x: cell.postImageView.bounds.width/2, y: cell.postImageView.bounds.height/2, width: cell.postImageView.frame.width, height: cell.postImageView.frame.height))
                cell.postImageView.image = resizedImage

                
                
//                let croppedImage =  UIImage.init(data: result as! Data)
//                cell.postImageView.image = croppedImage?.cropping(to: CGRect(x: 0, y: 0, width: cell.postImageView.frame.width, height: cell.postImageView.frame.height))
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
    
    
    func loadTimeLine() {
        let query = NCMBQuery(className: "Post")
        query?.order(byDescending: "createDate")
        query?.findObjectsInBackground({ (results, error) in
            if error != nil{
                print(error)
            }else{
                self.posts = []
                for result in results as! [NCMBObject]{
                    let postObjectId = result.objectId as! String
                    
                    let postUser = result.object(forKey: "postUser") as! NCMBUser
                    postUser.fetchInBackground { (error) in
                        let userName = postUser.userName
                        let userDisplayName = postUser.object(forKey: "userDisplayName") as? String
                        let userTitle = postUser.object(forKey: "userTitle") as? String
                        let userBio = postUser.object(forKey: "userBio") as? String
                        let mailAddress = postUser.object(forKey: "mailAddress") as? String
                        let postUserDetail = User(objectId: postUser.objectId, userId: userDisplayName ?? "", userDisplayName: userName ?? "", userTitle: userTitle ?? "", userBio: userBio ?? "", mailAddress: mailAddress ?? "")
                        
                            let postTitle = result.object(forKey: "postTitle") as! String
                            let postDetailText = result.object(forKey: "postDetailText") as! String
                            let postImage = result.object(forKey: "postImage") as! String
                            let postShopName = result.object(forKey: "postShopName") as! String
                            let postShopStation = result.object(forKey: "postShopStation") as! String
                            let postShopAddress = result.object(forKey: "postShopAddress") as! String
                            let createDate = result.createDate as! Date
                            
                        let post = Post(objectId: postObjectId, postUser: postUserDetail, postTitle: postTitle, postDetailText: postDetailText, postImage: postImage, postShopName: postShopName, postShopStation: postShopStation, postShopAddress: postShopAddress, createDate: createDate)
                            
                        self.posts.append(post)
                    }
                    
                    
                    
                }
//                self.timeLineTableView.reloadData()
            }
        })
    }
    
    
    func setRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadTimeLine(refreshControl:)), for: .valueChanged)
        timeLineTableView.addSubview(refreshControl)
    }
    
    @objc func reloadTimeLine(refreshControl: UIRefreshControl) {
        refreshControl.beginRefreshing()
        // self.loadFollowingUsers()
        // 更新が早すぎるので2秒遅延させる
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            refreshControl.endRefreshing()
        }
    }
    
/*   func loadFollowingUsers() {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toPostDetail", sender: nil)
        // 選択状態の解除
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //次の画面にデータを渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let timeLineDetailViewController = segue.destination as! TimeLineDetailViewController
        let seltectedIndex = timeLineTableView.indexPathForSelectedRow!
        // 選択されているcellのデータを取り出す
        timeLineDetailViewController.selectedPost = posts[seltectedIndex.row]
    }
    
    //戻る機能をつける
    @IBAction func back () {
        self.dismiss(animated: true, completion: nil)
    }
}



extension TimeLineViewController: PostReloadTimeLineDelegate{
    func postReload(){
        loadTimeLine()
    }
}
