//
//  EditCellViewController.swift
//  GeekProject_AR
//
//  Created by yanagimachi_riku on 2020/04/14.
//  Copyright © 2020 Riku Yanagimachi. All rights reserved.
//

import UIKit
import SwiftMessages
import NCMB

class EditCellViewController: UIViewController {
    
    var memo: Memo!
    
    var delegate:MemoARKitViewControllerDelegate?
    
    @IBOutlet var titleDisplay: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let memo = memo else{
            print("値なし")
            return
        }
        titleDisplay.text = memo.title
        
    }
 
    

    
//データベースをいじる何かを行う
    
    @IBAction func edit(){
        print("edit")
    }
    
    @IBAction func delete(){
        print("delete")
        
        let memoData = NCMBObject(className: "Memo")
        memoData?.objectId = memo.id
        memoData?.fetchInBackground({ (error) in
            if error != nil{
                print(error)
            }else{
                //deleteが成功した時
                //dismissして、アラート表示のシグナル（あたいはなんでも良い）をHomeVCに送る
               // self.dismiss(animated: true, completion: nil)
                
                
                let alertController = UIAlertController(title: "メモ削除", message: "本当に削除しますか？", preferredStyle: .actionSheet)
                
                let deleteAction = UIAlertAction(title: "\(self.memo.title)を削除", style: .default) { (action) in
                        memoData?.deleteInBackground({ (error) in
                        if error != nil{
                            print(error)
                        }else{
                            print("削除完了")
                            self.dismiss(animated: true, completion: nil)
                            self.delegate?.endAddition()
                        }
                    })
                }
                
                let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
                    alertController.dismiss(animated: true, completion: nil)
                    
                }
                
                alertController.addAction(deleteAction)
                alertController.addAction(cancelAction)
                
                self.present(alertController, animated: true, completion: nil)

            }
        })
    }
}
