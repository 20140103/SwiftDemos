//
//  TableViewTableViewCell.swift
//  Demos
//
//  Created by tdc-sw on 15/12/2.
//  Copyright © 2015年 tdc-sw. All rights reserved.
//

import UIKit

class SelfSizeCellTableViewTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var bodyLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
