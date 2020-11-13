//
//  HomeTableViewCell4.swift
//  GeekProject_AR
//
//  Created by yanagimachi_riku on 2020/07/21.
//  Copyright © 2020 Riku Yanagimachi. All rights reserved.
//

import UIKit

class HomeTableViewCell4: UITableViewCell {

    @IBOutlet var userPic: UIImageView!
    @IBOutlet var userName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
