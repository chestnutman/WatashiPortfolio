//
//  TabBarViewController.swift
//  GeekProject_AR
//
//  Created by yanagimachi_riku on 2020/06/29.
//  Copyright © 2020 Riku Yanagimachi. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    var viewTapped:Bool = false
    
    let viewButton = UIView(frame: CGRect(x: 175, y: 790, width: 65, height: 65))
    let view1 = UIView(frame: CGRect(x: 175, y: 790, width: 65, height: 65))
    let view2 = UIView(frame: CGRect(x: 175, y: 790, width: 65, height: 65))
    
    
    var tapGesture = UITapGestureRecognizer(target: nil, action: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = #colorLiteral(red: 0.6369528174, green: 0.9702519774, blue: 0.6744869947, alpha: 1)
        
        self.tabBar.items![2].isEnabled = false
        
        self.view.addSubview(self.createMemo())
        self.view.addSubview(self.createRoom())
        self.view.addSubview(self.createView())
    }
    
    
    
    @objc func moveToAddMemo(_ sender: UITapGestureRecognizer){
        if let tabvc = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController  {
            
            DispatchQueue.main.async {
                tabvc.selectedIndex = 2
            }
        }
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let nc: UINavigationController = storyboard.instantiateViewController(withIdentifier: "MakeMemoNavigationController") as! UINavigationController
//        backAnimationButton1()
        self.viewControllers?[2] = nc
        self.tabBarController?.navigationController?.pushViewController(nc, animated: true)
       
    }
    
    
    @objc func moveToAddRoom(_ sender: UITapGestureRecognizer){
        if let tabvc = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController  {
            
            DispatchQueue.main.async {
                tabvc.selectedIndex = 2
            }
        }
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let nc: UINavigationController = storyboard.instantiateViewController(withIdentifier: "MakeRoomNavigationController") as! UINavigationController
//①~~~~~~~
//        backAnimationButton1()
        self.viewControllers?[2] = nc
        self.tabBarController?.navigationController?.pushViewController(nc, animated: true)
        
    }
    
}



extension TabBarViewController:UIGestureRecognizerDelegate{
    
    func createMemo() -> UIView {
        let label1 = UILabel(frame: CGRect(x: 0, y: 0, width: view1.bounds.width, height: view1.bounds.height))
        let image1 = UIImage(systemName: "plus.bubble")
        let imageView1 = UIImageView(image: image1)
        imageView1.frame = CGRect(x: 12.5, y: 12.5, width: view1.bounds.width - 25, height: view1.bounds.height - 25)
        label1.layer.cornerRadius = label1.frame.width/2
        label1.layer.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        
        view1.addSubview(label1)
        view1.addSubview(imageView1)
        
        label1.isUserInteractionEnabled = true
        let tapGestureAddMemo = UITapGestureRecognizer(target: self, action: #selector(moveToAddMemo(_:)))
        //UIGestureのデリゲート
        tapGestureAddMemo.delegate = self
        //viewに追加
        label1.addGestureRecognizer(tapGestureAddMemo)
        
        return view1
    }
    
    func createRoom() -> UIView{
        let label2 = UILabel(frame: CGRect(x: 0, y: 0, width: view2.bounds.width, height: view2.bounds.height))
        let image2 = UIImage(systemName: "doc.text")
        let imageView2 = UIImageView(image: image2)
        imageView2.frame = CGRect(x: 12.5, y: 12.5, width: view2.bounds.width - 25, height: view2.bounds.height - 25)
        label2.layer.cornerRadius = label2.frame.width/2
        label2.layer.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        view2.addSubview(label2)
        view2.addSubview(imageView2)
        
        label2.isUserInteractionEnabled = true
        let tapGestureAddRoom = UITapGestureRecognizer(target: self, action: #selector(moveToAddRoom(_:)))
        //UIGestureのデリゲート
        tapGestureAddRoom.delegate = self
        //viewに追加
        label2.addGestureRecognizer(tapGestureAddRoom)
        return view2
    }
    
    func createView() -> UIView {
        viewButton.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: viewButton.bounds.width, height: viewButton.bounds.height))
        label.layer.cornerRadius = label.frame.width/2
        label.layer.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.layer.borderWidth = 5.0
        label.layer.borderColor = #colorLiteral(red: 0.6369528174, green: 0.9702519774, blue: 0.6744869947, alpha: 1)
        let image = UIImage(systemName: "plus")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 12.5, y: 12.5, width: viewButton.bounds.width - 25, height: viewButton.bounds.height - 25)
        viewButton.addSubview(label)
        viewButton.addSubview(imageView)
        
        label.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(userDidTapLabel(tapGestureRecognizer:)))
        label.addGestureRecognizer(tapGesture)
        
        return viewButton
    }
    
    
    
    @objc func userDidTapLabel(tapGestureRecognizer: UITapGestureRecognizer) {
        
        //        if let tabvc = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController  {
        //
        //            //左から２番目のタブアイコンを選択状態にする(0が一番左)
        //            DispatchQueue.main.async {
        //                tabvc.selectedIndex = 2
        //            }
        //        }
        
        if viewTapped == false{
            self.view.addSubview(animationButton1())
            self.view.addSubview(animationButton2())
            self.view.bringSubviewToFront(self.viewButton)
            viewTapped = true
            cancelAddMemoButton()
        }
        
    }
    
    
    func animationButton1() -> UIView{
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .allowAnimatedContent, animations: {
            self.view1.center.y -= 70.0
            self.view1.center.x -= 40.0
            
        }, completion: nil)
        
        
        return view1
    }
    
    func animationButton2() -> UIView{
        
        UIView.animate(withDuration: 0.2, delay: 0.1, options: .allowAnimatedContent, animations: {
            
            self.view2.center.y -= 70.0
            self.view2.center.x += 40.0
            
        }, completion: nil)
        
        
        return view2
    }
    
    
    func backAnimationButton1(){
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .allowAnimatedContent, animations: {
            
            self.view.bringSubviewToFront(self.viewButton)
        
            
            if self.view1.center.y >= 822.5 && self.view1.center.x >= 207.5{
                return
            }else{
                self.view1.center.y += 70.0
                self.view1.center.x += 40.0
            }
            
            if self.view2.center.y >= 822.5 && self.view2.center.x <= 207.5{
                return
            }else{
                self.view2.center.y += 70.0
                self.view2.center.x -= 40.0
            }
            
            
        }, completion: {(finished) in
            
            self.viewTapped = false
            
        })
        
    }
    
    
    func cancelAddMemoButton(){
        //UIGestureのインスタンス
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
        //UIGestureのデリゲート
        tapGesture.delegate = self
        //viewに追加
        self.view.addGestureRecognizer(tapGesture)
    }
    
    
    
    @objc func tapped(_ sender: UITapGestureRecognizer) {
        //タップ直後に中身を実行
        if sender.state == .ended {
            if viewTapped == true{
                backAnimationButton1()
                viewTapped = false
                self.view.removeGestureRecognizer(tapGesture)
            }
        }
    }
    
    
}
