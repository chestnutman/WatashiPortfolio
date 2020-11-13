//
//  AddMemoItemsViewController.swift
//  GeekProject_AR
//
//  Created by yanagimachi_riku on 2020/07/01.
//  Copyright © 2020 Riku Yanagimachi. All rights reserved.
//

import UIKit

class AddMemoItemsViewController: UIViewController, UIGestureRecognizerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layer.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        
        self.view.addSubview(createShort())
        self.view.addSubview(createLong())
        self.view.addSubview(createPresent())
        self.view.addSubview(createComingSoon())
    }
    
    
}


extension AddMemoItemsViewController{
    
    @objc func moveToShort(_ sender: UITapGestureRecognizer){
        print("おされた")
        let storybaord = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storybaord.instantiateViewController(identifier: "SetMemoDetailViewController")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func moveToLong(_ sender: UITapGestureRecognizer){
        print("Long")
        let storybaord = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storybaord.instantiateViewController(identifier: "SetMemoDetailViewController")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func moveToPresent(_ sender: UITapGestureRecognizer){
        print("Present")
        //        let storybaord = UIStoryboard(name: "Main", bundle: Bundle.main)
        //        let vc = storybaord.instantiateViewController(identifier: "SetMemoDetailViewController")
        //        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func moveToComingSoon(_ sender: UITapGestureRecognizer){
        print("ComingSOon")
        //        let storybaord = UIStoryboard(name: "Main", bundle: Bundle.main)
        //        let vc = storybaord.instantiateViewController(identifier: "SetMemoDetailViewController")
        //        self.navigationController?.pushViewController(vc, animated: true)
    }
}



extension AddMemoItemsViewController{
    
    func createShort() -> UIView{
        let view = UIView(frame: CGRect(x: 23.5, y: 150, width: 175, height: 150))
        view.layer.borderColor = #colorLiteral(red: 0.6369528174, green: 0.9702519774, blue: 0.6744869947, alpha: 1)
        view.layer.borderWidth = 5.0
        let image = UIImage(systemName: "plus.bubble")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 12.5, y: 12.5, width: view.bounds.width - 25, height: view.bounds.height - 25)
        
        let label = UILabel(frame: CGRect(x: view.center.x/3, y: 100, width: view.bounds.width, height: view.bounds.height))
        label.text = "ショートメモ"
        
        let iconLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        iconLabel.layer.cornerRadius = iconLabel.frame.width/4
        iconLabel.layer.borderColor = #colorLiteral(red: 0.6369528174, green: 0.9702519774, blue: 0.6744869947, alpha: 1)
        iconLabel.layer.borderWidth = 5.0
        
        view.addSubview(label)
        view.addSubview(iconLabel)
        view.addSubview(imageView)
        
        iconLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(moveToShort(_:)))
        tapGesture.delegate = self
        iconLabel.addGestureRecognizer(tapGesture)
        
        return view
    }
    
    
    
    func createLong() -> UIView{
        let view = UIView(frame: CGRect(x: 215.5, y: 150, width: 175, height: 150))
        view.layer.borderColor = #colorLiteral(red: 0.6369528174, green: 0.9702519774, blue: 0.6744869947, alpha: 1)
        view.layer.borderWidth = 5.0
        let image = UIImage(systemName: "envelope")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 12.5, y: 12.5, width: view.bounds.width - 25, height: view.bounds.height - 25)
        let label = UILabel(frame: CGRect(x: view.center.x/6, y: 100, width: view.bounds.width, height: view.bounds.height))
        label.text = "ロングメモ"
        
        let iconLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        iconLabel.layer.cornerRadius = iconLabel.frame.width/4
        iconLabel.layer.borderColor = #colorLiteral(red: 0.6369528174, green: 0.9702519774, blue: 0.6744869947, alpha: 1)
        iconLabel.layer.borderWidth = 5.0
        
        view.addSubview(label)
        view.addSubview(iconLabel)
        view.addSubview(imageView)
        
        iconLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(moveToLong(_:)))
        tapGesture.delegate = self
        iconLabel.addGestureRecognizer(tapGesture)
        
        return view
    }
    
    func createPresent() -> UIView{
        let view = UIView(frame: CGRect(x: 23.5, y: 450, width: 175, height: 150))
        view.layer.borderColor = #colorLiteral(red: 0.6369528174, green: 0.9702519774, blue: 0.6744869947, alpha: 1)
        view.layer.borderWidth = 5.0
        let image = UIImage(systemName: "gift.fill")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 12.5, y: 12.5, width: view.bounds.width - 25, height: view.bounds.height - 25)
        let label = UILabel(frame: CGRect(x: view.center.x/3, y: 100, width: view.bounds.width, height: view.bounds.height))
        label.text = "プレゼントメモ"
        
        let iconLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        iconLabel.layer.cornerRadius = iconLabel.frame.width/4
        iconLabel.layer.borderColor = #colorLiteral(red: 0.6369528174, green: 0.9702519774, blue: 0.6744869947, alpha: 1)
        iconLabel.layer.borderWidth = 5.0
        
        view.addSubview(label)
        view.addSubview(iconLabel)
        view.addSubview(imageView)
        
        
        iconLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(moveToPresent(_:)))
        tapGesture.delegate = self
        iconLabel.addGestureRecognizer(tapGesture)
        
        return view
    }
    
    
    func createComingSoon() -> UIView{
        let view = UIView(frame: CGRect(x: 215.5, y: 450, width: 175, height: 150))
        view.layer.borderColor = #colorLiteral(red: 0.6369528174, green: 0.9702519774, blue: 0.6744869947, alpha: 1)
        view.layer.borderWidth = 5.0
        let image = UIImage(systemName: "flame")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 12.5, y: 12.5, width: view.bounds.width - 25, height: view.bounds.height - 25)
        let label = UILabel(frame: CGRect(x: view.center.x/7, y: 100, width: view.bounds.width, height: view.bounds.height))
        label.text = "カミングスーン"
        
        let iconLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        iconLabel.layer.cornerRadius = iconLabel.frame.width/4
        iconLabel.layer.borderColor = #colorLiteral(red: 0.6369528174, green: 0.9702519774, blue: 0.6744869947, alpha: 1)
        iconLabel.layer.borderWidth = 5.0
        
        view.addSubview(label)
        view.addSubview(iconLabel)
        view.addSubview(imageView)
        
        iconLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(moveToComingSoon(_:)))
        tapGesture.delegate = self
        iconLabel.addGestureRecognizer(tapGesture)
        
        return view
    }
}
