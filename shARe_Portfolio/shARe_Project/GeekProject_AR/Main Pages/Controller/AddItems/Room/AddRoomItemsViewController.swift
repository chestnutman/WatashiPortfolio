//
//  AddRoomItemsViewController.swift
//  GeekProject_AR
//
//  Created by yanagimachi_riku on 2020/07/01.
//  Copyright © 2020 Riku Yanagimachi. All rights reserved.
//

import UIKit
import NCMB

class AddRoomItemsViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet var newRoomNameTextField: UITextField!
    @IBOutlet var addInvitationCodeTextField: UITextField!
    @IBOutlet var invitationCodeButton: UIButton!
    @IBOutlet var displayInvitationConde: UILabel!
    
    
    var delegate: MemoARKitViewControllerDelegate?
    
    var room: Room!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newRoomNameTextField.delegate = self
        
        
        displayInvitationConde.text = Room.randomString(length: 12)
        
        self.view.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    @IBAction func saveRoom(){
        if newRoomNameTextField.text != ""{
            let object = NCMBObject(className: "Room")
            guard let currentUser = NCMBUser.current() else { return }
            object?.setObject([currentUser.objectId], forKey: "userIds")
            object?.setObject(displayInvitationConde.text, forKey: "invitationCode")
            object?.setObject(newRoomNameTextField.text, forKey: "name")
            object?.saveInBackground({ (error) in
                guard error == nil else { return }
                print("正常に新しいルームが追加されました")
                self.delegate?.endAddition()
            })
        }else if addInvitationCodeTextField.text != ""{
            let query = NCMBQuery(className: "Room")
            guard let currentUser = NCMBUser.current() else { return }
            query?.whereKeyExists("invitationCode")
            query?.findObjectsInBackground({ (results, error) in
                guard error == nil else { return }
                for result in results as! [NCMBObject]{
                    let invCode = result.object(forKey: "invitationCode") as! String
                    if invCode == self.addInvitationCodeTextField.text{
                        let object = NCMBObject(className: "Room")
                        guard let currentUser = NCMBUser.current() else { return }
                        object?.objectId = result.objectId
                        object?.object(forKey: "userIds")
                        object?.fetchInBackground({ (error) in
                            if error != nil {
                                print(error)
                            }else{
                                object?.addUniqueObjects(from: [currentUser.objectId], forKey: "userIds")
                                object?.saveInBackground({ (error) in
                                    if error != nil {
                                        print(error)
                                    }else{
                                        
                                        let query2 = NCMBQuery(className: "Memo")
                                        guard let currentUser = NCMBUser.current() else { return }
                                        query2?.whereKeyExists("shareUsers")
                                        query2?.findObjectsInBackground({ (results2, error) in
                                            guard error == nil else { return }
                                            for result2 in results2 as! [NCMBObject]{
                                                let object2 = NCMBObject(className: "Memo")
                                                object2?.objectId = result2.objectId
                                                object2?.object(forKey: "shareUsers")
                                                object2?.fetchInBackground({ (error) in
                                                    if error != nil{
                                                        print(error)
                                                    }else{
                                                        //①
                                                        //userIdsを入れない理由は、同じID被りを防ぐためである。
                                                        //逆に被りを防ぐための条件式を書いてやる必要がある。
                                                        let userId = object?.object(forKey: "userIds") as! [Any]
                                                        for uid in userId{
                                                            object2?.addUniqueObjects(from: [uid], forKey: "shareUsers")
                                                        }
                                                        //object2?.addUniqueObject(userId, forKey: "shareUsers")
                                                        //object2?.addUniqueObjects(from: userId, forKey: "shareUsers")
                                                        object2?.saveInBackground({ (error) in
                                                            if error != nil{
                                                                print(error)
                                                            }else{
                                                                
                                                                print("正常に招待コードが追加されました")
                                                                self.delegate?.endAddition()
                                                            }
                                                        })
                                                    }
                                                })
                                            }
                                            
                                        })
                                    }
                                })
                            }
                        })
                    }else{
                        print("ダメだよ")
                    }
                }
            })
        }else{
            print("値を入力してください")
        }
        
    }
    
}
