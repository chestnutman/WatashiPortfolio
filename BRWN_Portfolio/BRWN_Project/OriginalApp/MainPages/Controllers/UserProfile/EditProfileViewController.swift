//
//  EditProfileViewController.swift
//  OriginalApp
//
//  Created by 鈴木賀子 on 05/08/2020.
//  Copyright © 2020 Yoshiko. All rights reserved.
//

import UIKit
import NCMB
import NYXImagesKit
import UITextView_Placeholder

extension UIFont {
    convenience init(name: FontNames, size: CGFloat) {
        self.init(name: name.rawValue, size: size)!
    }
}

public enum FontNames: String {
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


class EditProfileViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
     var userInfo: User?
    
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var userIdTextField: UITextField!
    @IBOutlet var userNameTextField: UITextField!
    @IBOutlet var userTitleTextField: UITextField!
    @IBOutlet var userBioTextView: UITextView!
    @IBOutlet var mailAddressTextField: UITextField!
    
    @IBOutlet var userIdLabel: UILabel!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var userTitleLabel: UILabel!
    @IBOutlet var userBioLabel: UILabel!
    @IBOutlet var mailAdressLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userIdTextField.delegate = self
        userNameTextField.delegate = self
        userTitleTextField.delegate = self
        userBioTextView.delegate = self
        mailAddressTextField.delegate = self
        
        //画像を丸くする
        userImageView.layer.cornerRadius = userImageView.bounds.width/2.0
        userImageView.clipsToBounds = true
        
        //  bioの枠のカラー
        userBioTextView.layer.borderColor = #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.9176470588, alpha: 1)
        // 枠の幅
        userBioTextView.layer.borderWidth = 2.0
        // 枠を角丸にする
        userBioTextView.layer.cornerRadius = 5.0
        userBioTextView.layer.masksToBounds = true
       
// fontArrange
        // 字体の宣言
        userIdLabel.font = UIFont(name: "HiraginoSans-W3", size: 12)
        userIdTextField.font = UIFont(name: "HiraMaruProN-W4", size: 15)
        userNameLabel.font = UIFont(name: "HiraginoSans-W3", size: 12)
        userNameTextField.font = UIFont(name: "HiraginoSans-W4", size: 15)
        userBioLabel.font = UIFont(name: "HiraginoSans-W3", size: 12)
        userBioTextView.font = UIFont(name: "HiraginoSans-W4", size: 14)
        mailAdressLabel.font = UIFont(name: "HiraginoSans-W3", size: 12)
        mailAddressTextField.font = UIFont(name: "HiraginoSans-W4", size: 15)
        mailAddressTextField.keyboardType = UIKeyboardType.emailAddress //メールアドレス
        
        // ユーザーIDTextFieldにユーザーIDガ入力されるようにする
        let userId = NCMBUser.current()?.userName
        userIdTextField.text = userId
        
        let userMailAddress = NCMBUser.current()?.mailAddress
        mailAddressTextField.text = userMailAddress
        
        // storyboardの背景色を変える
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        //       ナビゲーションバーの背景色
                            self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                     //        ナビゲーションバーのアイテムの色　（戻る　＜　とか　読み込みゲージとか）
                             self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.251144737, green: 0.1601424813, blue: 0.1088011637, alpha: 1)
                     //        ナビゲーションバーのテキストを変更する
                            self.navigationController?.navigationBar.titleTextAttributes = [
                     //        文字の色
                             .foregroundColor: #colorLiteral(red: 0.251144737, green: 0.1601424813, blue: 0.1088011637, alpha: 1)
                            ]
               
        userNameTextField.text = ""
        userTitleTextField.text = ""
        userBioTextView.text = ""
        
        
        // 枠のカラー
        // userBioTextView.layer.borderColor = UIColor.
        // 枠の幅
        // userBioTextView.layer.borderWidth = 1.0
        // 枠を角丸にする
        // userBioTextView.layer.cornerRadius = 10.0
        // userBioTextView.layer.masksToBounds = true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool { // 入力を反映させたテキストを取得する
        let resultText: String = (userTitleTextField.text! as NSString).replacingCharacters(in: range, with: string)
        if resultText.count <= 10 {
            return true
        }
        return false
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // 入力を反映させたテキストを取得する
        let resultText: String = (userBioTextView.text! as NSString).replacingCharacters(in: range, with: text)
        if resultText.count <= 10 {
            return true
        }
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadUserInfo()
    }
    func loadUserInfo(){
           userIdTextField.text = userInfo?.userId
           userNameTextField.text = userInfo?.userDisplayName
           userTitleTextField.text = userInfo?.userTitle
           userBioTextView.text = userInfo?.userBio
           mailAddressTextField.text = userInfo?.mailAddress
           
           //String To Date
           let file = NCMBFile.file(withName: userInfo!.objectId + ".jpg", data: nil) as! NCMBFile
           file.getDataInBackground { (Data, error) in
               if Data != nil {
                   let image = UIImage(data: Data!)
                   self.userImageView.image = image
               }
           }
       }
        
        
    
    // 入力後にキーボードが閉じるようにする（常にこれは書くこと）
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
    // 選択した画像を読み込む
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        let resizedImage = selectedImage.scale(byFactor: 0.3)
        //        userImageView.image = selectedImage
        
        // 読み込んだら閉じる
        picker.dismiss(animated: true, completion: nil)
        
        //　　 画像をNCMBにアップロードする
        let data = resizedImage?.pngData()
        //        let file = NCMBFile.file(with: data) as! NCMBFile
        guard let name = NCMBUser.current()?.objectId else {return}
        
        let currentFile = NCMBFile.file(withName: name + ".jpg", data: data) as! NCMBFile
        currentFile.saveInBackground({ (error) in
            if error != nil {
                print(error)
            } else {
                print ("Upload successful")
                
                self.userImageView.image = selectedImage
            }
        })
        
    }
    
    @IBAction func selectImage () {
        let actionController = UIAlertController(title: "画像の選択", message: "選択して下さい", preferredStyle: .actionSheet)
        // カメラ起動
        let cameraAction = UIAlertAction(title: "カメラ", style: .default) { (action) in
            // カメラ機能が使える機種であれば
            if UIImagePickerController.isSourceTypeAvailable(.camera) == true {
                let picker = UIImagePickerController()
                picker.sourceType = .camera
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
            } else{
                print("この機種ではカメラが使用できません。")
            }
        }
        // アルバム起動
        let albumAction = UIAlertAction(title: "フォトライブラリ", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) == true {
                let picker = UIImagePickerController()
                picker.sourceType = .photoLibrary
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
            } else{
                print("この機種ではフォトライブラリが使用できません。")
            }
        }
        
        // キャンセル機能
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            actionController.dismiss(animated: true, completion: nil)
        }
        
        // アクション機能をつける
        actionController.addAction(cameraAction)
        actionController.addAction(albumAction)
        actionController.addAction(cancelAction)
        self.present(actionController, animated: true, completion: nil)
    }
    
    // キャンセルで画面を閉じる
    @IBAction func closeEditViewControlller () {
        self.dismiss(animated: true, completion: nil)
    }
    
   @IBAction func saveUserInfo() {
          guard let user = NCMBUser.current() else{ return }
          user.setObject(userIdTextField.text, forKey: "userDisplayName")
          user.setObject(userNameTextField.text, forKey: "userName")
          user.setObject(userTitleTextField.text, forKey: "userTitle")
          user.setObject(userBioTextView.text, forKey: "userBio")
          user.setObject(mailAddressTextField.text, forKey: "mailAddress")
          user.saveInBackground({ (error) in
              if error != nil {
                  let alert = UIAlertController(title: "送信エラー", message: error!.localizedDescription, preferredStyle: .alert)
                  let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                      alert.dismiss(animated: true, completion: nil)
                  })
                  alert.addAction(okAction)
                  self.present(alert, animated: true, completion: nil)
              } else {
                  self.dismiss(animated: true, completion: nil)
              }
          })
      }
      
}

