//
//  MagneticBubbleView.swift
//  MagneticBubble
//
//  Created by yanagimachi_riku on 2020/07/19.
//  Copyright © 2020 Riku_Yanagimachi. All rights reserved.
//

import SpriteKit

public class MagneticBubbleView: SKView {
    
    @objc
    public lazy var magnetic: Magnetic = { [unowned self] in
        let scene = Magnetic(size: self.bounds.size)
        self.presentScene(scene)
        return scene
    }()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    func commonInit() {
        _ = magnetic
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        magnetic.size = bounds.size
    }
    
}
