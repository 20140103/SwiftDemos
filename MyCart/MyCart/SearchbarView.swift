//
//  SearchbarView.swift
//  MyCart
//
//  Created by tdc-sw on 15/12/14.
//  Copyright © 2015年 tdc-sw. All rights reserved.
//

import UIKit

class SearchbarView: UIView {
    

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
        
    @IBOutlet var dropDownList: UITableView!

    @IBOutlet var searchBar: UISearchBar!
    
    @IBOutlet var readerButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("frame \(frame.width)")
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("coder \(frame.width) \(frame.height)")
        
        
    }
    
    /*

    - (void)awakeFromNib
    {
    NSLog(@"awake from nib");
    [[NSBundle mainBundle] loadNibNamed:@"MyView" owner:self options:nil];
    [self addSubview:self.contentView];
    }
    */
//    override func awakeFromNib() {
//        NSBundle.mainBundle().loadNibNamed("SearchbarView", owner: self, options: nil)
////        self.addSubview(contentView)
//    }
}
