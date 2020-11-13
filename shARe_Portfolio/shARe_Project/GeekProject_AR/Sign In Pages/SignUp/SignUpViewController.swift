//
//  SignUpViewController.swift
//  GeekProject_AR
//
//  Created by yanagimachi_riku on 2019/07/12.
//  Copyright © 2019 Riku Yanagimachi. All rights reserved.
//

import UIKit
import NCMB

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var userIdTextField:UITextField!
    @IBOutlet var emailTextField:UITextField!
    @IBOutlet var passwordTextField:UITextField!
    @IBOutlet var confirmTextField:UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userIdTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmTextField.delegate = self
    }
    //キーボードを閉じるコード(改行ボタンが機能する)
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func signUp(){
        let user = NCMBUser()
        let groupACL = NCMBACL()
        
        if (userIdTextField.text?.count)! <= 4 {
            print("文字数が足りません")
            return
        }
        user.userName = userIdTextField.text!
        user.mailAddress = emailTextField.text!
        if passwordTextField.text == confirmTextField.text{
            user.password = passwordTextField.text!
        }else{
            print("パスワードが違います")
        }
        
        user.signUpInBackground { (error) in
            if error != nil{
                //エラーがあった場合
                print(error)
            }else{
                //成功した場合

                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootTabBarController")
                UIApplication.shared.keyWindow?.rootViewController = rootViewController
   
                 //会員本人（currentUser）の権限
                 //for: userは、自分（currentUser）に対してacl情報を書き換える
                 groupACL.setReadAccess(true, for: user)
                 groupACL.setWriteAccess(true, for: user)

                 //全てのユーザの権限
                 //setPublicReadAccessをtrueにすれば他人の情報を取得可能！
                 //基本的にsetPublicWriteAccessをtrueにすると、他人でもユーザ消したり、情報変更できてしまうから注意
                 groupACL.setPublicReadAccess(true)
                 groupACL.setPublicWriteAccess(false)

                 //userクラスにこれまで設定してきたACL情報をセット
                 user.acl = groupACL

                 //userデータ(設定したacl情報)を保存する
                 user.save(nil)
                
                
                //ログイン状態の保持
                let ud = UserDefaults.standard
                ud.set(true, forKey: "isLogin")
                ud.synchronize()
            }
            
        }
    }
    
}
