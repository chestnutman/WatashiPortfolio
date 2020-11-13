//
//  SelfPostCheckTableViewCell.swift
//  GeekProject_AR
//
//  Created by yanagimachi_riku on 2020/08/22.
//  Copyright © 2020 Riku Yanagimachi. All rights reserved.
//

import UIKit

class SelfPostCheckTableViewCell: UITableViewCell {

    @IBOutlet var roomLabel: UILabel!
    @IBOutlet var createdUserLabel: UILabel!
    @IBOutlet var updateDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
