//
//  TTTimeLine.swift
//  SwiftDemos
//
//  Created by tdc-sw on 16/8/8.
//  Copyright © 2016年 twt. All rights reserved.
//

import UIKit

class TTTimeLine: UITableView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        self.transform  = CGAffineTransformMakeRotation(CGFloat(M_PI / 2))
    }
}
