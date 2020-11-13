//
//  SetMemoDetailViewController.swift
//  GeekProject_AR
//
//  Created by yanagimachi_riku on 2020/07/01.
//  Copyright © 2020 Riku Yanagimachi. All rights reserved.
//

import UIKit
import NCMB

protocol SetMemoDetailDelegate {
    func endAddition(title: String, createdBy: String, text: String)
}

class SetMemoDetailViewController: UIViewController {
    
    @IBOutlet var roomSelectLabel: UILabel!
    @IBOutlet var memoTitle: UITextField!
    @IBOutlet var memoText: UITextView!
    
    
    @IBOutlet var titleCountLabel: UILabel!
    @IBOutlet var textCountLabel: UILabel!
    
    @IBOutlet var saveMemo: UIButton!
    
    var room: Room!
    
    var delegate: SetMemoDetailDelegate?
    
    var tapped: Bool = false
    
    var pickerArray:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.view.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        
        memoTitle.delegate = self
        memoText.delegate = self
        
        memoTitle.returnKeyType = UIReturnKeyType.done
        memoTitle.textAlignment = .center
        memoText.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        
        roomSelectLabel.layer.cornerRadius = 5
        roomSelectLabel.layer.borderWidth = 0.5
        roomSelectLabel.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        roomSelectLabel.layer.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        closeTextViewKeyboard()
        
        getRoomData()
        roomLabelProperty()
        
        saveMemo.layer.cornerRadius = saveMemo.frame.width/5
    }
    
    
    func roomLabelProperty(){
        roomSelectLabel.textAlignment = .center
        roomSelectLabel.isUserInteractionEnabled = true
        let tapGestureAddMemo = UITapGestureRecognizer(target: self, action: #selector(tappedPickerKeyboard(_:)))
        //UIGestureのデリゲート
        tapGestureAddMemo.delegate = self
        //viewに追加
        roomSelectLabel.addGestureRecognizer(tapGestureAddMemo)
    }
    
    
    
    func getRoomData(){
        let query = NCMBQuery(className: "Room")
        query?.whereKeyExists("userIds")
        query?.findObjectsInBackground({ (results, error) in
            if error != nil {
                print(error)
            }else{
                for result in results as! [NCMBObject]{
                    
                    let roomName = result.object(forKey: "name") as! String
                    let userIdsArray = result.object(forKey: "userIds") as! [String]
                    if userIdsArray.contains(NCMBUser.current()?.objectId ?? ""){
                        self.pickerArray.append(roomName)
                    }
                }
            }
        })
    }
    
    
    func worldSave(){
        // 現状のwordldMapの取得
        MemoARKitViewController().sceneView?.session.getCurrentWorldMap { worldMap, error in
            guard let map = worldMap
                else { self.showAlert(title: "Can't get current world map", message: error!.localizedDescription); return }
            
            // Add a snapshot image indicating where the map was captured.
            guard let snapshotAnchor = SnapshotAnchor(capturing: MemoARKitViewController().sceneView)
                else { fatalError("Can't take snapshot") }
            //map.anchors.append(snapshotAnchor)
            do {
                try MemoARKitViewController().archive(worldMap: map, url: MemoARKitViewController().mapSaveURL)
                //                        UserDefaults.standard.set(self.mapSaveURL, forKey: "savedUrl")
                
                
            } catch {
                fatalError("Can't save map: \(error.localizedDescription)")
            }
        }
    }
    
    
    @IBAction func addShortMemo(){
        
        let query = NCMBQuery(className: "Room")
        query?.whereKey("name", equalTo: self.roomSelectLabel.text!)
        query?.findObjectsInBackground({ (results, error) in
            if error != nil{
                print(error)
            }else{
                for result in results as! [NCMBObject]{
                    let roomId = result.objectId!
                    let userIds = result.object(forKey: "userIds") as! [String]
                    self.room = Room(id: roomId, roomName: self.roomSelectLabel.text!, userIds: userIds)
                }
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let destinationVC = storyboard.instantiateViewController(withIdentifier: "MemoARKitViewController") as! MemoARKitViewController
                //NCMB上に、メモプロパティを保存するーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー
                    destinationVC.room = self.room
                    
                    
                    guard let title = self.memoTitle.text, let text = self.memoText.text else { return }
                    destinationVC.argString1 = title
                    destinationVC.argString2 = NCMBUser.current()!.userName
                    destinationVC.argString3 = text
                    
                    self.present(destinationVC, animated: true, completion: nil)
            }
        })
    }
}



extension SetMemoDetailViewController: UITextFieldDelegate, UITextViewDelegate{
    
    //文字数制限系
    func textViewDidChange(_ textView: UITextView) {
        let count = memoText.text?.count
        textCountLabel.text = String(count!)
        if count! > 140{
            textCountLabel.textColor = UIColor.red
            memoText.textColor = UIColor.red
        }else{
            textCountLabel.textColor = UIColor.white
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let count = memoTitle.text?.count
        titleCountLabel.text = String(count!)
        if count! > 20{
            titleCountLabel.textColor = UIColor.red
            memoTitle.textColor = UIColor.red
        }else{
            titleCountLabel.textColor = UIColor.white
        }
    }
    
    //キーボード閉じる系
    
    func closeTextViewKeyboard(){
        let custombar = UIView(frame: CGRect(x:0, y:0,width:(UIScreen.main.bounds.size.width),height:40))
        custombar.backgroundColor = UIColor.groupTableViewBackground
        let commitBtn = UIButton(frame: CGRect(x:(UIScreen.main.bounds.size.width)-70,y:0,width:70,height:40))
        commitBtn.setTitle("閉じる", for: .normal)
        commitBtn.setTitleColor(UIColor.white, for:.normal)
        commitBtn.layer.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        commitBtn.layer.cornerRadius = commitBtn.frame.width/5
        commitBtn.addTarget(self, action:#selector(self.onClickCloseButton), for: .touchUpInside)
        custombar.addSubview(commitBtn)
        memoTitle.inputAccessoryView = custombar
        memoText.inputAccessoryView = custombar
    }
    
    @objc func onClickCloseButton (sender: UIButton) {
        if(memoText.isFirstResponder){
            memoText.resignFirstResponder()
        }else if (memoTitle.isFirstResponder){
            memoTitle.resignFirstResponder()
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードを閉じる
        textField.resignFirstResponder()
        return true
    }
    
}

extension SetMemoDetailViewController: UIPickerViewDelegate, UIPickerViewDataSource, UIGestureRecognizerDelegate{
    
    @objc private func tappedPickerKeyboard(_ sender: UITapGestureRecognizer) {
        tapped = true
        self.becomeFirstResponder()
    }
    
    override var canBecomeFirstResponder: Bool {
        return tapped
    }
    
    override var inputView: UIView? {
        let pickerView: UIPickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        pickerView.autoresizingMask = [.flexibleHeight]
        
        // SafeArea対応をする為にUIViewを挟む
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        view.autoresizingMask = [.flexibleHeight]
        view.addSubview(pickerView)
        
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        pickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pickerView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
        
        return view
    }
    
    
    override var inputAccessoryView: UIView? {
        
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
        view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 44)
        
        let closeButton = UIButton(frame: CGRect(x:(UIScreen.main.bounds.size.width)-70,y:0,width:70,height:44))
        closeButton.setTitle("閉じる", for: .normal)
        closeButton.setTitleColor(UIColor.white, for:.normal)
        closeButton.layer.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        closeButton.layer.cornerRadius = closeButton.frame.width/5
        closeButton.sizeToFit()
        closeButton.addTarget(self, action: #selector(tappedCloseButton(_:)), for: .touchUpInside)
        //closeButton.setTitleColor(UIColor(red: 0, green: 122/255, blue: 1, alpha: 1.0), for: .normal)
        
        view.contentView.addSubview(closeButton)
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.widthAnchor.constraint(equalToConstant: closeButton.frame.size.width).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: closeButton.frame.size.height).isActive = true
        closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 5).isActive = true
        closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        return view
    }
    
    @objc private func tappedCloseButton(_ sender: UIButton) {
        resignFirstResponder()
        tapped = false
    }
    
    
    
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        roomSelectLabel.text = pickerArray[row]
    }
    
}

