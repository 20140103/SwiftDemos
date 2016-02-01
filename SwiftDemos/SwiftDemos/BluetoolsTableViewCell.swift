//
//  BluetoolsTableViewCell.swift
//  SwiftDemos
//
//  Created by tdc-sw on 16/1/12.
//  Copyright © 2016年 twt. All rights reserved.
//

import UIKit

class BluetoolsTableViewCell: UITableViewCell {

    @IBOutlet var blueName: UILabel!
    
    @IBOutlet var servicesLabel: UILabel!
    
    @IBOutlet var signalView: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
