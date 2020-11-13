//
//  SignInViewController.swift
//  GeekProject_AR
//
//  Created by yanagimachi_riku on 2019/07/12.
//  Copyright © 2019 Riku Yanagimachi. All rights reserved.
//

import UIKit
import NCMB
//delegateはTextFieldの決まり文句
class SignInViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var userIdTextField:UITextField!
    @IBOutlet var passwordTextField:UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userIdTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    //キーボードを閉じるコード（改行ボタン）
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func signIn(){
        if userIdTextField.text! != nil && passwordTextField.text! != nil{
            NCMBUser.logInWithUsername(inBackground: userIdTextField.text!, password: passwordTextField.text!) { (user, error) in
                if error != nil{
                    print(error)
                }else{
                    //ログイン成功
                    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootTabBarController")
                    UIApplication.shared.keyWindow?.rootViewController = rootViewController
                    
                    //ログイン状態の保持
                    let ud = UserDefaults.standard
                    ud.set(true, forKey: "isLogin")
                    ud.synchronize()
                }
            }
            
        }
    }
    @IBAction func forgetPassword(){
        
    }
}
