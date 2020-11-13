//
//  AppDelegate.swift
//  OriginalApp
//
//  Created by 鈴木賀子 on 05/07/2020.
//  Copyright © 2020 Yoshiko. All rights reserved.
//

import UIKit
import NCMB
import NYXImagesKit
import UITextView_Placeholder
import SVProgressHUD
import Kingfisher

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//Oriku
        let applicationKey = "9376bc0a3d88d31216d9f2b72339e7e246b8e01726aa0390af453f46e457d9f5"
        let clientKey = "6a402a62ab9d8071aa9e1e4ac0d1d58b531d0f4aea56efde2b50abd32039153b"
        
//Yoshiko
//        let applicationKey = "2e2a9c768bf6fa747d0fa1d2caa58686c5d610fc5a6ca3fc45d66a666e91d72e"
//        let clientKey = "cdf67c683c129385af2a1f876f4bdf5466b38fc928ba8eaab87eb583177f0b9d"
        
        NCMB.setApplicationKey(applicationKey, clientKey: clientKey)
        
      // ユーザーデフォルトで管理する
            let ud = UserDefaults.standard
            let isLogin = ud.bool(forKey: "isLogin")
        
            // ログイン中だったら
            if isLogin == true {
                self.window = UIWindow(frame: UIScreen.main.bounds)
                // ストーリーボードを取得する
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                // 一番初めに表示する画面を指定する
                let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootTabBarController")
                
                self.window?.rootViewController = rootViewController
                self.window?.backgroundColor = UIColor.white
                self.window?.makeKeyAndVisible()
                // ログインしてなかったら
            } else{
                self.window = UIWindow(frame: UIScreen.main.bounds)
                let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
                let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
                self.window?.rootViewController = rootViewController
                self.window?.backgroundColor = UIColor.white
                self.window?.makeKeyAndVisible ()
                }

        return true
        
    }

    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }




}

