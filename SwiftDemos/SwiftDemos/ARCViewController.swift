//
//  通过代码或约束的方式让UIView呈现出不同的布局
//  ARCViewController.swift
//  SwiftDemos
//
//  Created by tdc-sw on 15/12/8.
//  Copyright © 2015年 twt. All rights reserved.
//

import UIKit

class ARCViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        initView2()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
    x^2 + y^2 = r^2 标准圆公式
    
    
    */
    let num  = 20
    let width = UIScreen.mainScreen().bounds.size.width - 14
    
    private func initView(){
        print("width = \(width)")
        // 圆半径
        let r = width  / 2
        // 半径的平方
        let r2 = r * r
        
        let stepLength:CGFloat = r*2 / CGFloat(num )
        print("r = \(r) stepLength = \(stepLength)")
        
        let a:CGFloat = r
        let b:Double = Double(r)
        
        for i in 0..<num {

            print("i = \(i)")
            let x = stepLength * CGFloat(i)
            let x2 = (x - a) * (x - a)
            print("(\(x2))")
            let y = -sqrt((Double(r2) - Double(x2))) + b
            
            print("(\(x),\(y))")
            let button = ImageButton(frame: CGRect(origin: CGPoint(x: Double(x) + 7, y: y + 40), size: CGSize(width: 10, height: 10)))
            button.titleLabel?.text = "\(i)"
            button.backgroundColor = UIColor(red: 255, green: 0, blue: 0, alpha: CGFloat(i) / CGFloat(num) + 0.1)
            self.view.addSubview(button)
        }
        //let button = ImageButton(frame: CGRect(origin: CGPoint(x: Double(r), y:40), size: CGSize(width: 10, height: 10)))
        
        //button.backgroundColor = UIColor(red: 255, green: 0, blue: 0, alpha: CGFloat(5) / CGFloat(num) + 0.1)
        //self.view.addSubview(button)

    }
    let PHOTONUM = 10
    let RADIUS = 100.0
    /*
    x = rcos（θ），
    y = rsin（θ）
    */
    private func initView2(){
        let centery = self.view.center.y;
        let centerx = self.view.center.x;
        
        for (var i = 0 ; i < PHOTONUM ; i++) {
//            let tmpy =  Double(centery) + RADIUS*abs(cos(2.0 * M_PI * Double(i) / Double(PHOTONUM)))
//            let tmpx =	Double(centerx) - RADIUS*(sin(2.0 * M_PI * Double(i) / Double(PHOTONUM)))
            
            let tmpy =  Double(centery) + RADIUS*(sin(2.0 * M_PI * Double(i) / Double(PHOTONUM) + M_PI ))
            let tmpx =	Double(centerx) - RADIUS*(cos(2.0 * M_PI * Double(i) / Double(PHOTONUM) - M_PI ))
            print("tmpy = \(tmpy) tmpx = \(tmpx)")
            let button = ImageButton(frame: CGRect(origin: CGPoint(x: tmpx - 15, y: tmpy - 15), size: CGSize(width: 30, height: 30)))
            button.backgroundColor = UIColor(red: 255, green: 0, blue: 0, alpha: CGFloat(i) / CGFloat(PHOTONUM) + 0.1)
            self.view.addSubview(button)
            
        }
    }
    
    @IBAction func onClick(sender: AnyObject) {
//        var beginNumber = 860860000030301;
//        
//        for _ in 1...50{
////            print(beginNumber)
////            print()
//            print("\(beginNumber),\(String(beginNumber).md5())")
//            beginNumber += 1
//        }
    }
    @IBOutlet var onClick: UIButton!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


