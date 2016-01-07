//
//  DropDownList.swift
//  MyCart
//
//  Created by tdc-sw on 15/12/14.
//  Copyright © 2015年 tdc-sw. All rights reserved.
//

import UIKit

class DropDownList: UIView ,UITableViewDataSource,UITableViewDelegate{

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    var showList = false

    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var contentView: UIView!{
        didSet{
            
            print("DropDownList contentView \(contentView.frame.height) \(contentView.frame.width) \(contentView.frame.origin.x) \(contentView.frame.origin.y) \(frame.height) \(frame.width) \(frame.origin.x)  \(frame.origin.y) ")
//            self.contentView.frame
            self.contentView.frame.size = frame.size
        }
    }
    override init(frame: CGRect) {
        super.init(frame:frame)
        print("frame \(frame.height)")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("coder \(frame.height)")
        
    }
    
    override func awakeFromNib() {
        NSBundle.mainBundle().loadNibNamed("DropDownList", owner: self, options: nil)
//        print("DropDownList awakeFromNib \(contentView.frame.height) \(contentView.frame.width) \(frame.height) \(frame.width)")
        print("DropDownList awakeFromNib \(contentView.frame.height) \(contentView.frame.width) \(contentView.frame.origin.x) \(contentView.frame.origin.y) \(frame.height) \(frame.width) \(frame.origin.x)  \(frame.origin.y) ")
        self.contentView.backgroundColor = UIColor.greenColor()
        initView()
        self.addSubview(self.contentView)
    }
    
    
    private func initView(){
        tableView.delegate = self
        tableView.dataSource = self
    }
    func showDropdownList(){
        if(showList){
            return
        }
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        cell.backgroundColor = UIColor.yellowColor()
        print("cellForRowAtInfexPath")
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
}
