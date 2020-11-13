//
//  PostViewController.swift
//  OriginalApp
//
//  Created by 鈴木賀子 on 08/08/2020.
//  Copyright © 2020 Yoshiko. All rights reserved.
//

import UIKit
import NCMB
import NYXImagesKit
import UITextView_Placeholder
import SVProgressHUD
import Kingfisher


protocol PostReloadTimeLineDelegate {
    func postReload()
}

extension UIFont {
    convenience init(name: FontNames5, size: CGFloat) {
        self.init(name: name.rawValue, size: size)!
    }
}

public enum FontNames5: String {
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

class PostViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UINavigationControllerDelegate {
    
    let placeholderImage = UIImage(named: "photoPlaceHolder@3x")
    var resizedImage: UIImage!
    
    @IBOutlet var postImageView: UIImageView!
    
    @IBOutlet var postTitleTextView: UITextView!
    @IBOutlet var postDetailTextView: UITextView!
    @IBOutlet var postShopNameTextField: UITextField!
    @IBOutlet var postShopStationTextField: UITextField!
    @IBOutlet var postShopAddressTextField: UITextField!
    
    @IBOutlet var postButton: UIBarButtonItem!
    @IBOutlet var chosePictureButton: UIButton!
    
    var postImage = ""
    var tags = [String]()
    
    var delegate: PostReloadTimeLineDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postTitleTextView.delegate = self
        postDetailTextView.delegate = self
        postShopNameTextField.delegate = self
        postShopStationTextField.delegate = self
        postShopAddressTextField.delegate = self
        
        // ボタンの装飾
        chosePictureButton.center = self.view.center
        chosePictureButton.backgroundColor = #colorLiteral(red: 1, green: 0.4250276685, blue: 0.1568083763, alpha: 1) // 3
        chosePictureButton.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        //consentButton1.layer.borderWidth = 4
        //consentButton1.layer.borderColor = #colorLiteral(red: 0.930855453, green: 0.8780241609, blue: 0.8337224126, alpha: 1)
        chosePictureButton.layer.cornerRadius = 15
        // fontArange
        //  postTitleの枠のカラー
        //postTitleTextView.layer.borderColor = #colorLiteral(red: 0.251144737, green: 0.1601424813, blue: 0.1088011637, alpha: 1)
        // 枠の幅
        //postTitleTextView.layer.borderWidth = 2.0
        // 枠を角丸にする
        postTitleTextView.layer.cornerRadius = 5.0
        postTitleTextView.layer.masksToBounds = true
        
        //  postDetailの枠のカラー
        postDetailTextView.layer.borderColor = #colorLiteral(red: 0.251144737, green: 0.1601424813, blue: 0.1088011637, alpha: 1)
        // 枠の幅
        postDetailTextView.layer.borderWidth = 2.0
        // 枠を角丸にする
        postDetailTextView.layer.cornerRadius = 5.0
        postDetailTextView.layer.masksToBounds = true
        //  postTitleの枠のカラー
        postShopNameTextField.layer.borderColor = #colorLiteral(red: 0.251144737, green: 0.1601424813, blue: 0.1088011637, alpha: 1)
        // 枠の幅
        postShopNameTextField.layer.borderWidth = 2.0
        // 枠を角丸にする
        postShopNameTextField.layer.cornerRadius = 5.0
        postShopNameTextField.layer.masksToBounds = true
        //  postTitleの枠のカラー
        postShopStationTextField.layer.borderColor = #colorLiteral(red: 0.251144737, green: 0.1601424813, blue: 0.1088011637, alpha: 1)
        // 枠の幅
        postShopStationTextField.layer.borderWidth = 2.0
        // 枠を角丸にする
        postShopStationTextField.layer.cornerRadius = 5.0
        postShopStationTextField.layer.masksToBounds = true
        //  postTitleの枠のカラー
        postShopAddressTextField.layer.borderColor = #colorLiteral(red: 0.251144737, green: 0.1601424813, blue: 0.1088011637, alpha: 1)
        // 枠の幅
        postShopAddressTextField.layer.borderWidth = 2.0
        // 枠を角丸にする
        postShopAddressTextField.layer.cornerRadius = 5.0
        postShopAddressTextField.layer.masksToBounds = true
        
        // 字体の宣言
        postShopAddressTextField.font = UIFont(name: "HiraginoSans-W3", size: 16)
        postShopStationTextField.font = UIFont(name: "HiraMaruProN-W3", size: 16)
        postShopNameTextField.font = UIFont(name: "HiraginoSans-W3", size: 16)
        postDetailTextView.font = UIFont(name: "YHiraginoSans-W3", size: 15)
        postTitleTextView.font = UIFont(name: "HiraginoSans-W4", size: 18)
        
        
        let custombar = UIView(frame: CGRect(x:0, y:0,width:(UIScreen.main.bounds.size.width),height:40))
        custombar.backgroundColor = UIColor.groupTableViewBackground
        let commitBtn = UIButton(frame: CGRect(x:(UIScreen.main.bounds.size.width)-50,y:0,width:50,height:40))
        commitBtn.setTitle("完了", for: .normal)
        commitBtn.setTitleColor(UIColor.brown, for:.normal)
        commitBtn.addTarget(self, action: #selector(self.onClickCommitButton), for: .touchUpInside)
        custombar.addSubview(commitBtn)
        postTitleTextView.inputAccessoryView = custombar
        postDetailTextView.inputAccessoryView = custombar
        
        
        
//Update~~~~~~
        postShopNameTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        postShopAddressTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        postShopStationTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 背景の透過
        UITabBar.appearance().backgroundImage = UIImage()
        // 境界線の透過
        UITabBar.appearance().shadowImage = UIImage()
        
        // ナビゲーションを透明にする処理
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        
        //       ナビゲーションバーの背景色
        //       self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9763454795, green: 0.9658699632, blue: 0.9299083948, alpha: 1)
        //        ナビゲーションバーのアイテムの色　（戻る　＜　とか　読み込みゲージとか）
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        //        ナビゲーションバーのテキストを変更する
        self.navigationController?.navigationBar.titleTextAttributes = [
            //        文字の色
            .foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        ]
        // storyboardの背景色を変える
        view.backgroundColor = #colorLiteral(red: 0.2509803922, green: 0.1607843137, blue: 0.1098039216, alpha: 1)
        
        postTitleTextView.text = ""
        postDetailTextView.text = ""
        postShopAddressTextField.text = ""
        postShopNameTextField.text = ""
        postShopStationTextField.text = ""
        
    }
    
    
    
    
    // 入力後にキーボードが閉じるようにする（常にこれは書くこと）
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func onClickCommitButton () {
        if(postTitleTextView.isFirstResponder){
            postTitleTextView.resignFirstResponder()
        }else if(postDetailTextView.isFirstResponder){
            postDetailTextView.resignFirstResponder()
        }
    }
    
    
    
    
    func textViewDidChange(_ textView: UITextView) {
        confirmContent()
    }
    
//Update~~~~~~
    @objc func textFieldDidChange(_ textField: UITextField){
        confirmContent()
    }
    
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }
    
    
    
    @IBAction func sharePhoto() {
        //        SVProgressHUD.show()
        
        let obj = NCMBObject(className: "Post")
        obj?.setObject(NCMBUser.current(), forKey: "postUser")
        obj?.setObject(postTitleTextView.text, forKey: "postTitle")
        obj?.setObject(postDetailTextView.text, forKey: "postDetailText")
        obj?.setObject(self.postImage, forKey: "postImage")
        obj?.setObject(postShopNameTextField.text, forKey: "postShopName")
        obj?.setObject(postShopStationTextField.text, forKey: "postShopStation")
        obj?.setObject(postShopAddressTextField.text, forKey: "postShopAddress")
        obj?.setObject(tags, forKey: "searchTags")
        obj?.saveInBackground({ (error) in
            if error != nil{
                print(error)
            }else{
                let alert = UIAlertController(title: "シェア完了", message: "投稿が完了しました。", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    self.postTitleTextView.text = nil
                    self.postDetailTextView.text = nil
                    self.postShopNameTextField.text = nil
                    self.postShopStationTextField.text = nil
                    self.postShopAddressTextField.text = nil
                    self.postImageView.image = UIImage(named: "placeholderImage")
                    //                    self.confirmContent()
                })
                
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                
                //②~~~~~~~
                //Update2~~~~~
                self.delegate?.postReload()
            }
        })
        
    }

//③
    // 記入欄と写真が埋まってたら投稿する
    func confirmContent() {
        if postShopAddressTextField.text!.count > 0 &&
            postShopStationTextField.text!.count > 0 &&
            postShopNameTextField.text!.count > 0 &&
            postDetailTextView.text.count > 0 &&
            postTitleTextView.text.count > 0 &&
            postImageView.image != placeholderImage {
            postButton.isEnabled = true
        } else {
            postButton.isEnabled = false
        }
    }
    
    //    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    //        // 入力を反映させたテキストを取得する
    //        let resultText: String = (postTitleTextView.text! as NSString).replacingCharacters(in: range, with: text)
    //         let resultText2: String = (postDetailTextView.text! as NSString).replacingCharacters(in: range, with: text)
    //        if resultText.count <= 21 && resultText2.count <= 10 {
    //            return true
    //        }
    //        return false
    //        }
}




extension PostViewController: UIImagePickerControllerDelegate{
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //選択した画像を読み込む
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        let cgImage = selectedImage.cgImage
        
        let selectedImage2 = UIImage(cgImage: cgImage!, scale: 0, orientation: selectedImage.imageOrientation)
        
        let resizedImage = selectedImage2.scale(byFactor: 0.3)
        
        //        postImageView.image = resizedImage
        
        picker.dismiss(animated: true, completion: nil)
        
        //        confirmContent()
        
        
        //画像を保存
        let data = resizedImage!.pngData()
        let file = NCMBFile.file(with: data) as! NCMBFile
        
        file.saveInBackground({ (error) in
            if error != nil{
                
                print(error)
            }else{
                self.postImageView.image = selectedImage2
                
                self.postImage = file.name
            }
            
        }) { (progress) in
            if Int(progress) == 100{
                print("ダウンロード完了")
            }
        }
    }
    
    
    @IBAction func selectImage() {
        let alertController = UIAlertController(title: "画像選択", message: "シェアする画像を選択して下さい。", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        
        let cameraAction = UIAlertAction(title: "カメラで撮影", style: .default) { (action) in
            // カメラ起動
            if UIImagePickerController.isSourceTypeAvailable(.camera) == true {
                let picker = UIImagePickerController()
                picker.sourceType = .camera
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
            } else {
                print("この機種ではカメラが使用出来ません。")
            }
        }
        
        let photoLibraryAction = UIAlertAction(title: "フォトライブラリから選択", style: .default) { (action) in
            // アルバム起動
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) == true {
                let picker = UIImagePickerController()
                picker.sourceType = .photoLibrary
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
            } else {
                print("この機種ではフォトライブラリが使用出来ません。")
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(cameraAction)
        alertController.addAction(photoLibraryAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
