//
//  TimeLineDetailTableViewCell.swift
//  OriginalApp
//
/////  Created by 鈴木賀子 on 10/08/2020.
//  Copyright © 2020 Yoshiko. All rights reserved.
//

import UIKit

protocol TimeLineDetailTableViewCellDelegate {
    func didTapGoodButton(tableViewCell: UITableViewCell, button: UIButton)
    func didTapMenuButton(tableViewCell: UITableViewCell, button: UIButton)
    func didTapCommentsButton(tableViewCell: UITableViewCell, button: UIButton)
}

extension UIFont {
    convenience init(name: FontNames6, size: CGFloat) {
        self.init(name: name.rawValue, size: size)!
    }
}

public enum FontNames6: String {
    case yuGothicBold = "YuGo-Bold"
    case yoGothicMedium = "YuGo-Medium"
    case hiraMaru = "HiraMaruProN-W4"
    case arialBrack = "Arial-Black"
    case hiraginoW3 = "HiraginoSans-W3"
    case hiraginoW5 = "HiraginoSans-W5"
    case hiraginoW4 = "HiraginoSans-W4"
    case hiraginoW1 = "HiraginoSans-W1"
    case hiraginoW2 = "HiraginoSans-W2"
    case system = "System"
    //追加していく
}

class TimeLineDetailTableViewCell: UITableViewCell {
    
    var delegate: TimeLineDetailTableViewCellDelegate?
    
    @IBOutlet var postImageView: UIImageView!
    @IBOutlet var postTitleTextView: UITextView!
    @IBOutlet var postDetailTextView: UITextView!
    @IBOutlet var postShopNameLabel: UILabel!
    @IBOutlet var postShopStationLabel: UILabel!
    @IBOutlet var postShopAddressLabel: UILabel!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var userTitleLabel: UILabel!
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var timeStampLabel: UILabel!
    
    @IBOutlet var goodButton: UIButton!
    @IBOutlet var commentButton: UIButton!
    @IBOutlet var menuButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        userImageView.layer.cornerRadius = userImageView.bounds.width / 2.0
        userImageView.clipsToBounds = true
        // 字体の宣言
        postShopAddressLabel.font = UIFont(name: "SHiraMaruProN-W3", size: 12)
        postShopStationLabel.font = UIFont(name: "HiraMaruProN-W3", size: 13)
        postShopNameLabel.font = UIFont(name: "HiraMaruProN-W3", size: 16)
        postDetailTextView.font = UIFont(name: "HiraMaruProN-W3", size: 14)
        postTitleTextView.font = UIFont(name: "HiraginoSans-W5", size: 18)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func good(button: UIButton) {
        self.delegate?.didTapGoodButton(tableViewCell: self, button: button)
    }
    
    @IBAction func openMenu(button: UIButton) {
        self.delegate?.didTapMenuButton(tableViewCell: self, button: button)
    }
    
    @IBAction func showComments(button: UIButton) {
        self.delegate?.didTapCommentsButton(tableViewCell: self, button: button)
    }
    
}
