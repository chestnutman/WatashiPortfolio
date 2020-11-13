//
//  SettingHomeViewController.swift
//  GeekProject_AR
//
//  Created by yanagimachi_riku on 2020/07/21.
//  Copyright © 2020 Riku Yanagimachi. All rights reserved.
//

import UIKit

class SettingHomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.view.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        
        self.view.addSubview(notYetInstalled())
    }
    
    func notYetInstalled()->UIView{
        let comingSoonView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        comingSoonView.layer.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.9)
        let label = UILabel(frame: CGRect(x: 25, y: comingSoonView.bounds.height/2, width: comingSoonView.frame.size.width-50, height: 100))
        label.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.0)
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.text = "近日実装予定"
        
        comingSoonView.addSubview(label)
        return comingSoonView
    }
    
}
