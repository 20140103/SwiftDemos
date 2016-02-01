//
//  tableViewHeaderView.swift
//  SwiftDemos
//
//  Created by tdc-sw on 16/1/13.
//  Copyright © 2016年 twt. All rights reserved.
//

import UIKit



protocol TableViewHeaderViewDelegate{
    func headerViewButtonDidClick(tableViewHeaderView:NibTableViewHeaderView,isShow:Bool)
}

class NibTableViewHeaderView: UITableViewHeaderFooterView {

 
    @IBOutlet var titleLable: UILabel!
    
    var isShow:Bool = false
    var delegate:TableViewHeaderViewDelegate!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
//        awakeFromNib()
//        isShow = false
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    @IBAction func headerViewButonDidClick(sender: UIButton) {
        NSLog("headerViewButonDidClick isShow = \(isShow)")
        delegate?.headerViewButtonDidClick(self,isShow: isShow)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        NSLog("\(self.frame.size.height,self.frame.size.width)")
        NSLog("\(self.layer.debugDescription)")
        
    }
}
