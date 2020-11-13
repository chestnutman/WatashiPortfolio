//
//  TimeLineTableViewCell.swift
//  OriginalApp
//
//  Created by 鈴木賀子 on 11/07/2020.
//  Copyright © 2020 Yoshiko. All rights reserved.
//

import UIKit

protocol TimeLineTableViewCellDelegate {
}

//fontArrange
extension UIFont {
    convenience init(name: FontNames2, size: CGFloat) {
        self.init(name: name.rawValue, size: size)!
    }
}

public enum FontNames2: String {
    case yuGothicBold = "YuGo-Bold"
    case yoGothicMedium = "YuGo-Medium"
    case hiraMaru = "HiraMaruProN-W4"
    case arialBrack = "Arial-Black"
    case hiraginoW3 = "HiraginoSans-W3"
    case hiraginoW5 = "HiraginoSans-W5"
    case hiraginoW4 = "HiraginoSans-W4"
    case hiraginoW1 = "HiraginoSans-W1"
    case hiraginoW2 = "HiraginoSans-W2"
    //追加していく
}

class TimeLineTableViewCell: UITableViewCell {
    
    var delegate: TimeLineTableViewCellDelegate?
    
    @IBOutlet var postImageView: UIImageView!
    @IBOutlet var postTitleTextView: UITextView!
    @IBOutlet var postShopNameLabel: UILabel!
    @IBOutlet var userTitleLabel: UILabel!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var timeStampLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userImageView.layer.cornerRadius = userImageView.bounds.width/2.0
        userImageView.clipsToBounds = true
//フォント
        // 字体の宣言
        self.postTitleTextView!.font = UIFont(name: "HiraginoSans-W5", size: 17)
        
        //色変わる
        self.postShopNameLabel.font = UIFont(name: "HiraginoSans-W3", size: 19)
        self.userTitleLabel.font = UIFont(name: "HiraMaruProN-W2", size: 12)
        self.userNameLabel.font = UIFont(name: "HiraMaruProN-W4", size: 18)
        self.timeStampLabel.font = UIFont(name: "HiraMaruProN-W1", size: 9)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
