//
//  ColumnViewController.swift
//  OriginalApp
//
//  Created by 鈴木賀子 on 2020/08/17.
//  Copyright © 2020 Yoshiko. All rights reserved.
//

import UIKit

class ColumnViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //       ナビゲーションバーの背景色
               self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        //        ナビゲーションバーのアイテムの色　（戻る　＜　とか　読み込みゲージとか）
                self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.3648911119, green: 0.2378712296, blue: 0.1605188251, alpha: 1)
        //        ナビゲーションバーのテキストを変更する
               self.navigationController?.navigationBar.titleTextAttributes = [
        //        文字の色
                .foregroundColor: #colorLiteral(red: 0.3648911119, green: 0.2378712296, blue: 0.1605188251, alpha: 1)
               ]
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
