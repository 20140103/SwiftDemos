//
//  CustomView.swift
//  MyCart
//
//  Created by tdc-sw on 15/12/15.
//  Copyright © 2015年 tdc-sw. All rights reserved.
//

import UIKit

class CustomView: UIView ,UISearchBarDelegate{

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    //AutoLayout
    
    
    @IBOutlet var searchBar: UISearchBar!
    
    @IBOutlet var cancelButton: UIButton!
    
    @IBOutlet var randerButton: UIButton!
    
    @IBOutlet var contentView: UIView!{
        didSet{
            
            if(self.frame.height < 44) {
                contentView.frame = CGRect(origin: self.frame.origin, size: CGSize(width: self.frame.size.width,height: 44))
            }else{
                contentView.frame = self.frame
            }
        }
    }
    
    var flag = true
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        print("frame \(frame.height)")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func awakeFromNib() {
        
        NSBundle.mainBundle().loadNibNamed("CustomView", owner: self, options: nil)
        print("awakeFromNib \(contentView.frame.height) \(contentView.frame.width) \(frame.height) \(frame.width)")
        self.contentView.backgroundColor = UIColor.redColor()
        self.addSubview(self.contentView)
        initView()
    }
    
    
    
    private func initView(){
        self.searchBar.delegate = self
    }
    
    //MARK: UISearchBarDelegate
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        print("searchBarShouldBeginEditing")
//        if(self.flag){
//            self.contentView.removeConstraint(self.bar_leading)
//        }else{
//            self.contentView.addConstraint(self.bar_leading)
//        }
        cancelButton.hidden = !self.flag
        randerButton.hidden = self.flag
        self.flag = !self.flag
        return false
    }
    
}
