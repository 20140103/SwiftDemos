//
//  ImageButton.swift
//  SwiftDemos
//
//  Created by tdc-sw on 15/12/8.
//  Copyright © 2015年 twt. All rights reserved.
//

import UIKit

@IBDesignable
class ImageButton: UIButton {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    
    internal var radius:CGFloat!{
        didSet{
            self.layer.cornerRadius = radius
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.layer.cornerRadius = max(self.bounds.height,self.bounds.width) / 2
        print("frame \(self.layer.cornerRadius)")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let size = max(bounds.width,bounds.height)
        let radius = size / 2
        self.layer.cornerRadius = radius
    }

    override func prepareForInterfaceBuilder() {
        let size = max(bounds.width,bounds.height)
        radius = size / 2
    }
}
