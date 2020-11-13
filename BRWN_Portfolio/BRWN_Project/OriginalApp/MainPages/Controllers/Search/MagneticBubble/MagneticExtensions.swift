//
//  MagneticExtensions.swift
//  MagneticBubble
//
//  Created by yanagimachi_riku on 2020/07/19.
//  Copyright © 2020 Riku_Yanagimachi. All rights reserved.
//

import SpriteKit

extension CGFloat {
    static func random(_ lower: CGFloat = 0, _ upper: CGFloat = 1) -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UINT32_MAX)) * (upper - lower) + lower
    }
}

extension Array {
    
    func randomItem() -> Element {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
    
}

extension CGPoint {
    func distance(from point: CGPoint) -> CGFloat {
        return hypot(point.x - x, point.y - y)
    }
}

extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: 1)
    }
    

    static var kuchiba: UIColor {
         return UIColor(red: 226, green: 148, blue: 59)
     }

     static var karakurenai: UIColor {
         return UIColor(red: 208, green: 16, blue: 76)
     }

     static var imayoh: UIColor {
         return UIColor(red: 208, green: 90, blue: 110)
     }

     static var kokiake: UIColor {
         return UIColor(red: 134, green: 71, blue: 63)
     }

     static var jinzamomi: UIColor {
         return UIColor(red: 235, green: 122, blue: 119)
     }

     static var sakuranezumi: UIColor {
         return UIColor(red: 177, green: 150, blue: 147)
     }

     static var haizakura: UIColor {
         return UIColor(red: 215, green: 196, blue: 187)
     }

     static var kuwazome: UIColor {
         return UIColor(red: 100, green: 54, blue: 60)
     }

     static var shikancha: UIColor {
         return UIColor(red: 181, green: 93, blue: 76)
     }

     static let colors: [UIColor] = [.kuchiba, .karakurenai, .imayoh, .kokiake, .jinzamomi, .sakuranezumi, .haizakura, .kuwazome, .shikancha]
    
}


extension UIImage {
    func aspectFill(_ size: CGSize) -> UIImage {
        let aspectWidth = size.width / self.size.width
        let aspectHeight = size.height / self.size.height
        let aspectRatio = max(aspectWidth, aspectHeight)
        
        var newSize = self.size
        newSize.width *= aspectRatio
        newSize.height *= aspectRatio
        return resize(newSize)
    }
    func resize(_ size: CGSize) -> UIImage {
        var rect = CGRect.zero
        rect.size = size
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    
    //NCMBのデータを参照して引っ張ってくる → 上位15件分
    static let names: [String] = ["創業100年","創業50年","創業30年","喫茶店","BAR","酒場","食堂","レストラン"]
    
    
}
