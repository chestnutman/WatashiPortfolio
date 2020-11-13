//
//  ProfileViewController.swift
//  GeekProject_AR
//
//  Created by yanagimachi_riku on 2020/05/01.
//  Copyright © 2020 Riku Yanagimachi. All rights reserved.
//

import UIKit
import NCMB


class ProfileViewController: UIViewController {
    
    @IBOutlet var userInfoButton: UIButton!
    @IBOutlet var mainThemeColorButton: UIButton!
    @IBOutlet var boughtAssetsListButton: UIButton!
    
    
    @IBOutlet var viewOfTableView: UIView!
    @IBOutlet var view01: UIView!
    @IBOutlet var view02: UIView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var statusLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.view.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        
        userInfoButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        userInfoButton.layer.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        userInfoButton.layer.cornerRadius = 30
        mainThemeColorButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        mainThemeColorButton.layer.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        mainThemeColorButton.layer.cornerRadius = 30
        boughtAssetsListButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        boughtAssetsListButton.layer.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        boughtAssetsListButton.layer.cornerRadius = 30
        
        view01.backgroundColor = .white
        view02.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3)
        
        userNameLabel.font = UIFont(name: "Neoneon", size:  20)
        statusLabel.numberOfLines = 3
        statusLabel.text = "今めちゃくちゃ稼動率高め"
    }
    
    
    
    @IBAction func changeAppearance(){
        
        UIView.animate(withDuration: 0.2, delay: 0.1, options: .allowAnimatedContent, animations: {
            
            self.userInfoButton.center.x = 130
            self.userInfoButton.center.y = 150
            self.mainThemeColorButton.center.x = 80
            self.mainThemeColorButton.center.y = 250
            self.boughtAssetsListButton.center.x = 130
            self.boughtAssetsListButton.center.y = 350
            
            self.view01.frame.size.height += self.view01.frame.size.height
            self.view02.frame.size.height += self.view02.frame.size.height
            
            self.view01.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 1.5)
            self.userNameLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
            
            self.view01.center.x = self.view.frame.size.width - self.view01.frame.size.height / 2
            self.view01.center.y = self.viewOfTableView.frame.minY - self.view01.frame.size.height / 2
    
            
            self.view02.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 1.5)
            self.statusLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
            
            self.view02.center.x = self.view.frame.size.width - self.view02.frame.size.height / 2
            self.view02.center.y = self.viewOfTableView.frame.minY - self.view02.frame.size.height / 2
            
            
        }, completion: nil)
    }
    
    
    
    @IBAction func showMenu(){
        let alertController = UIAlertController(title: "メニュー", message: "メニューを選択してください", preferredStyle: .actionSheet)
        let signOutAction = UIAlertAction(title: "ログアウト", style: .default) { (action) in
            NCMBUser.logOutInBackground({ (error) in
                if error != nil{
                    print(error)
                }else{
                    //ログアウト成功した場合
                    let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
                    let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
                    UIApplication.shared.keyWindow?.rootViewController = rootViewController
                    //ログアウト状態の保持
                    let ud = UserDefaults.standard
                    ud.set(false, forKey: "isLogin")
                    ud.synchronize()
                }
            })
        }
        
        
        let deleteAction = UIAlertAction(title: "退会", style: .default) { (action) in
            let user = NCMBUser.current()
            user?.deleteInBackground({ (error) in
                if error != nil{
                    print(error)
                }else{
                    //ログアウト成功した場合
                    let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
                    let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
                    UIApplication.shared.keyWindow?.rootViewController = rootViewController
                    //ログアウト状態の保持
                    let ud = UserDefaults.standard
                    ud.set(false, forKey: "isLogin")
                    ud.synchronize()
                }
                
            })
        }
        
        
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            alertController.dismiss(animated: true, completion: nil)
            
        }
        
        alertController.addAction(signOutAction)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}
