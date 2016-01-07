//
//  MotionManagerViewController.swift
//  SwiftDemos
//
//  Created by tdc-sw on 16/1/7.
//  Copyright © 2016年 twt. All rights reserved.
//

import UIKit
import CoreMotion

class MotionManagerViewController: UIViewController {
    
    @IBOutlet var graphViews: [APLGraphView]!
    var motionManger:CMMotionManager!
    
    let gyroChangeBlock = { (gyroData:CMGyroData?,error:NSError?) in
        MotionManagerViewController.gyroChange(gyroData, error: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        motionManger =  CMMotionManager()
        showGraphAtIndex(0)
    }
    override func viewDidAppear(animated: Bool) {
        if(motionManger.gyroAvailable){
            motionManger.gyroUpdateInterval = 1/10
            //            motionManger.startGyroUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: gyroChangeBlock)
            motionManger.startGyroUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: { (gyroData:CMGyroData?,error:NSError?) in
//                    MotionManagerViewController.gyroChange(gyroData, error: nil)
                    self.graphViews[0].addX(gyroData!.rotationRate.x, y: gyroData!.rotationRate.y , z: gyroData!.rotationRate.z)
                }
            )
        }
        
    }
    override func viewDidDisappear(animated: Bool) {
        self.motionManger.stopGyroUpdates()
    }
    
    func proximityChange(notification:NSNotificationCenter){
        print("proximityState = \(UIDevice.currentDevice().proximityState)")
    }
    class func gyroChange(gyroData:CMGyroData?,error:NSError?){
        print("\(gyroData!.rotationRate.x, gyroData!.rotationRate.y , gyroData!.rotationRate.z)")
//        [[weakSelf.graphViews objectAtIndex:kDeviceMotionGraphTypeRotationRate] addX:deviceMotion.rotationRate.x y:deviceMotion.rotationRate.y z:deviceMotion.rotationRate.z];
    }
    
    func showGraphAtIndex(selectedIndex:Int){
        for (index,value) in self.graphViews.enumerate(){
            let hidden = index != selectedIndex
            value.hidden = hidden
        }
        
    }
}
