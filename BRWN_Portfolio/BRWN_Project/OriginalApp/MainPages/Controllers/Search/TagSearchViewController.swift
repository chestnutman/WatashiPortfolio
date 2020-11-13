//
//  TagSearchViewController.swift
//  OriginalApp
//
//  Created by yanagimachi_riku on 2020/08/20.
//  Copyright © 2020 Yoshiko. All rights reserved.
//

//update2~~~~~~
import UIKit

protocol BackTo{
    func backAndDeselect(magnetic: Magnetic, node: Node)
}

class TagSearchViewController: UIViewController {
    
//    var viewBackgroundColor: UIColor?
    
    var delegate: BackTo?
    
    var selectedNode: Node?
    
    var magnetic: Magnetic?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 0)
//        self.transitioningDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        view.transform = CGAffineTransform(scaleX: 0.00001, y: 0.00001)

        UIView.animate(withDuration: 1.0, animations: { [weak self] in
//            self?.view.transform = CGAffineTransform.identity
            self?.view.backgroundColor = self?.selectedNode?.color
        })
    }
    
    @IBAction func back(){
        self.delegate?.backAndDeselect(magnetic: self.magnetic!, node: self.selectedNode!)
        
        self.dismiss(animated: true, completion: nil)
    }
}

