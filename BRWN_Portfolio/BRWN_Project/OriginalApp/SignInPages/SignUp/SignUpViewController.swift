//
//  SignUViewController.swift
//  OriginalApp
//
//  Created by 鈴木賀子 on 05/07/2020.
//  Copyright © 2020 Yoshiko. All rights reserved.
//

import UIKit
import NCMB

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
       @IBOutlet var userIdTextField: UITextField!
       @IBOutlet var emailTextField: UITextField!
       @IBOutlet var passwordTextField: UITextField!
       @IBOutlet var confirmTextField: UITextField!
       @IBOutlet var signUpButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        userIdTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmTextField.delegate = self
        passwordTextField.textContentType = .oneTimeCode
        confirmTextField.textContentType = .oneTimeCode
        emailTextField.keyboardType = UIKeyboardType.emailAddress //メールアドレス
        
        // ボタンの装飾
        signUpButton.center = self.view.center
               
        signUpButton.backgroundColor = #colorLiteral(red: 0.251144737, green: 0.1601424813, blue: 0.1088011637, alpha: 1) // 3
        signUpButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        
        //consentButton1.layer.borderWidth = 4
        //consentButton1.layer.borderColor = #colorLiteral(red: 0.930855453, green: 0.8780241609, blue: 0.8337224126, alpha: 1)
        
        signUpButton.layer.cornerRadius = 25
        
        // 表示したい画像の名前(拡張子含む)を引数とする。
        self.view.SignUpBackground(name: "SignUpBackground@3x")
        
        
          }
          
       func textFieldShouldReturn(_ textField: UITextField) -> Bool {
              textField.resignFirstResponder()
              return true
          }
          
          @IBAction func signUp () {
                 let user = NCMBUser ()
                 let groupACL = NCMBACL()
                 
                 user.userName = userIdTextField.text!
                 user.mailAddress = emailTextField.text!
                 if passwordTextField.text == confirmTextField.text{
                     user.password = passwordTextField.text!
                 }else{
                     print("パスワードの不一致")
                 }
                 // 登録に成功したらY→Aに遷移する
                 user.signUpInBackground { (error) in
                     if error != nil {
                         print(error)
                     } else{
                         let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                         let rootViewController = storyboard.instantiateViewController(identifier: "RootTabBarController")
                         UIApplication.shared.keyWindow?.rootViewController = rootViewController
                     
                         //ユーザ（currentUser）の権限
                         //for: userは、自分（currentUser）に対してacl情報を書き換える
                         groupACL.setReadAccess(true, for: user)
                         groupACL.setWriteAccess(true, for: user)
                         
                         //全てのユーザの権限
                         //個々のReadAccessをtrueにすれば他人の情報を取得可能！
                         groupACL.setPublicReadAccess(true)
                         groupACL.setPublicWriteAccess(true)
                         
                         //userクラスにACLを設定
                         user.acl = groupACL
                         
                         print(user)
                         //userデータを保存する
                         user.save(nil)
                         
                         
                         // ログインできたらログイン情報を保持する
                         let ud = UserDefaults.standard
                         ud.set(true, forKey: "isLogin")
                         ud.synchronize()

                     }
                     
                 }
             }
             
              
    }
    

  
