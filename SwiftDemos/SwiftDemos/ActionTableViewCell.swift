//
//  ActionTableViewCell.swift
//  SwiftDemos
//
//  Created by tdc-sw on 16/1/21.
//  Copyright © 2016年 twt. All rights reserved.
//

import UIKit

protocol ActionTableViewCellDelegate{
    func rightButtonOnClick(tableViewCell:ActionTableViewCell)
    func leftButtonOnClick(tableViewCell:ActionTableViewCell)
}

class ActionTableViewCell: UITableViewCell {

    
    @IBOutlet var leftBtn: UIButton!
    
    @IBOutlet var rightBtn: UIButton!
    
    
    var delegate:ActionTableViewCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func actionOnClick(sender: UIButton) {
        switch(sender){
        case leftBtn:
            NSLog("leftBtn")
            delegate?.leftButtonOnClick(self)
        case rightBtn:
            NSLog("rightBtn")
            delegate?.rightButtonOnClick(self)
        default:
            break
        }
    }
   
}
