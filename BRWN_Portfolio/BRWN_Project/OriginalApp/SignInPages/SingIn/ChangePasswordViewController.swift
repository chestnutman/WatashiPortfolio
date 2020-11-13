//
//  ChangePasswordViewController.swift
//  OriginalApp
//
//  Created by 鈴木賀子 on 14/08/2020.
//  Copyright © 2020 Yoshiko. All rights reserved.
//

import UIKit
import NCMB

class ChangePasswordViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var mailAddressLabel: UILabel!
    @IBOutlet var explainTextView: UITextView!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var sendEmailButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        emailTextField.keyboardType = UIKeyboardType.emailAddress //メールアドレス
    
}
    
    @IBAction func sendEmail () {
        
    var error : NSError? = nil
    NCMBUser.requestAuthenticationMail(emailTextField.text, error: &error)
    if error != nil {
    }else{
        let alertController = UIAlertController(title: "登録URLを送信しました", message: "メールボックスを確認してください", preferredStyle: .alert)
      let okAcrion = UIAlertAction(title: "OK", style: .default) { (action) in
          //１つ戻るコード
        self.navigationController?.popViewController(animated: true)
      }
      alertController.addAction(okAcrion)
      self.present(alertController, animated: true, completion: nil)
    }
    // メールアドレス認証ユーザの登録メールアドレス宛にパスワード再設定のメールを送信
 /*   NCMB.self;.User.requestPasswordReset() {
    .then(function(){
    /* 再設定メール送信成功時の処理（例） */
    console.log("再設定メール送信成功");
    })
    .catch(function(error){
    /* 再設定メール送信失敗時の処理（例） */
    console.log("再設定メール送信失敗:" + JSON.stringify(error));
    });
    
    
    }
}*/
}
}
