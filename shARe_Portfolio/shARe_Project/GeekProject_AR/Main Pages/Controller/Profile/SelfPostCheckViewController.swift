//
//  UserViewController.swift
//  GeekProject_AR
//
//  Created by yanagimachi_riku on 2020/06/21.
//  Copyright © 2020 Riku Yanagimachi. All rights reserved.
//

import UIKit
import NCMB


class SelfPostCheckViewController: UIViewController {
    
    @IBOutlet var selfPostCheckTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selfPostCheckTableView.delegate = self
        selfPostCheckTableView.dataSource = self
        
        selfPostCheckTableView.register(UINib(nibName: "SelfPostCheckTableViewCell", bundle: Bundle.main),forCellReuseIdentifier:"Cell")
    }
    
    func loadMyRooms(){
        
    }
    
    
    
    
}


extension SelfPostCheckViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SelfPostCheckTableViewCell
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        <#code#>
//    }

}
