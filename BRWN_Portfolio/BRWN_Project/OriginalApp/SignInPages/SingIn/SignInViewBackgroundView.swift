//
//  SignInViewController.swift
//  OriginalApp
//
//  Created by 鈴木賀子 on 11/07/2020.
//  Copyright © 2020 Yoshiko. All rights reserved.
//

import UIKit
import NCMB

class SignInViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var userIdTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var forgetPasswordButton: UIButton!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var signInButton: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        
        userIdTextField.delegate = self
        passwordTextField.delegate = self
    
        userIdTextField.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        // 表示したい画像の名前(拡張子含む)を引数とする。
        self.view.SignInBackground(name: "SignInBackground@3x")
        
        // ボタンの装飾
        signUpButton.center = self.view.center
        signUpButton.backgroundColor = #colorLiteral(red: 1, green: 0.4250276685, blue: 0.1568083763, alpha: 1) // 3
        signUpButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        //signUpButton.layer.borderWidth = 5
        //signUpButton.layer.borderColor = #colorLiteral(red: 0.69402951, green: 0.6292691827, blue: 0.5502912998, alpha: 1)
        signUpButton.layer.cornerRadius = 25
        
        // ボタンの装飾
        signInButton.center = self.view.center
        signInButton.backgroundColor = #colorLiteral(red: 1, green: 0.4250276685, blue: 0.1568083763, alpha: 1) // 3
        signInButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        signInButton.layer.cornerRadius = 25
        
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func signIn () {
        
        // UserIDとPassowrdが一致したら、X → Aに画面遷移する
        if (userIdTextField.text?.count)! > 0 && (passwordTextField.text?.count)! > 0 {
            NCMBUser.logInWithUsername(inBackground: userIdTextField.text!, password: passwordTextField.text!) { (user, error) in
                if error != nil {
                    print(error)
                }else{
                    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    let rootViewController = storyboard.instantiateViewController(identifier: "RootTabBarController")
                    UIApplication.shared.keyWindow?.rootViewController = rootViewController
                    
                    // ログインできたらログイン情報を保持する
                    let ud = UserDefaults.standard
                    ud.set(true, forKey: "isLogin")
                    ud.synchronize()
                }
            }
        }
        
    }
    @IBAction func signUp () {
        self.performSegue(withIdentifier: "toTerm", sender: nil)
    }
    
    @IBAction func forgetPassword () {
        self.performSegue(withIdentifier: "toChangePassword", sender: nil)
        
    }
    
    
}
