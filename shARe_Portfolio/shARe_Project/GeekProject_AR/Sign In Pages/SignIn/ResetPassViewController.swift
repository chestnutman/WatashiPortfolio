//
//  ResetPassViewController.swift
//  GeekProject_AR
//
//  Created by yanagimachi_riku on 2020/09/15.
//  Copyright © 2020 Riku Yanagimachi. All rights reserved.
//

import UIKit
import NCMB

class ResetPassViewController: UIViewController {

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var sendEmailButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func resetPassword(){
        
        //        self.performSegue(withIdentifier: "toResetPassword", sender: nil)
        
        NCMBUser.requestPasswordResetForEmail(inBackground: emailTextField.text) { (error) in
            if error != nil{
                print("dcmecmke")
            }else{
                let alert = UIAlertController(title: "パスワードリセットURLを送信しました。", message: "メールボックスを確認してください。", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
                    let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
                    //このアプリの一番下のwindowにrootVCを入れて画面切り替え
                    UIApplication.shared.keyWindow?.rootViewController = rootViewController
                }
                
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                
            }
        }
    }
    
}

