//
//  HomeTableViewCell.swift
//  GeekProject_AR
//
//  Created by yanagimachi_riku on 2020/04/12.
//  Copyright © 2020 Riku Yanagimachi. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var byWhoLabel: UILabel!
    @IBOutlet var createdDateLabel: UILabel!
    @IBOutlet var backView: UIView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.isOpaque = false // 不透明を false
        self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)

        self.backView.layer.backgroundColor = #colorLiteral(red: 0.003921568627, green: 1, blue: 0.7647058824, alpha: 1)
        self.backView.layer.cornerRadius = 30
//        self.backView.layer.borderWidth = 0.5
//        self.backView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        
        titleLabel.textColor = .black
        byWhoLabel.textColor = .black
        createdDateLabel.textColor = .black
        
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
