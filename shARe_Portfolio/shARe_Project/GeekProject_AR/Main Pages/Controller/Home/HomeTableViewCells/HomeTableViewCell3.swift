//
//  HomeTableViewCell3.swift
//  GeekProject_AR
//
//  Created by yanagimachi_riku on 2020/06/21.
//  Copyright © 2020 Riku Yanagimachi. All rights reserved.
//

import UIKit

class HomeTableViewCell3: UITableViewCell {

    @IBOutlet var roomNameLabel: UILabel!
    @IBOutlet var arrowImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.roomNameLabel.layer.borderWidth = 5.0
//        self.roomNameLabel.layer.borderColor = #colorLiteral(red: 0.6369528174, green: 0.9702519774, blue: 0.6744869947, alpha: 1)
        self.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
