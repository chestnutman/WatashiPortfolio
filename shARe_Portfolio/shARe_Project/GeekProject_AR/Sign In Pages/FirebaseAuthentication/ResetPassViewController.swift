////
////  ResetPassViewController.swift
////  GeekProject_AR
////
////  Created by yanagimachi_riku on 2020/05/02.
////  Copyright © 2020 Riku Yanagimachi. All rights reserved.
////
//
//import UIKit
//import Firebase
//
//class ResetPassViewController: UIViewController {
//    
//    
//    @IBOutlet private weak var emailTextField: UITextField!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // Do any additional setup after loading the view.
//    }
//    
//    
//    @IBAction private func sendResetMail() {
//        
//        let email = emailTextField.text ?? ""
//        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
//            guard let self = self else { return }
//            if error != nil {
//                // 送信完了画面へ
//                self.showErrorIfNeeded(error)
//
//            }else{
//                let message = "送信されました" // ここは後述しますが、とりあえず固定文字列
//                let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                self.present(alert, animated: true, completion: nil)
//            }
//        }
//    }
//    
//    private func showErrorIfNeeded(_ errorOrNil: Error?) {
//        // エラーがなければ何もしません
//        guard let error = errorOrNil else { return }
//        
//        let message = "エラーが起きました" // ここは後述しますが、とりあえず固定文字列
//        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        present(alert, animated: true, completion: nil)
//    }
//    
//}
//
//
//
