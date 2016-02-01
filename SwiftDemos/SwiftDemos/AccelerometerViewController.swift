//
//  AccelerometerViewController1.swift
//  SwiftDemos
//
//  加速度计
//  Created by tdc-sw on 16/1/8.
//  Copyright © 2016年 twt. All rights reserved.
//

import Foundation

import UIKit
import CoreMotion

class AccelerometerViewController: MotionManagerViewController {
    
   
    @IBOutlet var graphView: APLGraphView!
    
//    var motionManger:CMMotionManager!
    let accelerometerMin = 0.01
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func proximityChange(notification:NSNotificationCenter){
        print("proximityState = \(UIDevice.currentDevice().proximityState)")
    }
   
    override func startUpdatesWithSliderValue(sliderValue: Int) {
        NSLog("sliderValue = \(sliderValue)")
        
        let delta:NSTimeInterval = 0.005
        let updateInterval:NSTimeInterval = accelerometerMin + delta * Double(sliderValue)
        if(motionManger.accelerometerAvailable){
            motionManger.accelerometerUpdateInterval = updateInterval
            motionManger.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: { (accelerometerData:CMAccelerometerData?,error:NSError?) in
//                NSLog("\(accelerometerData!.acceleration.x,accelerometerData!.acceleration.y,accelerometerData!.acceleration.z)")
                self.setLabelValueX(accelerometerData!.acceleration.x,y: accelerometerData!.acceleration.y,z: accelerometerData!.acceleration.z)
                self.graphView.addX(accelerometerData!.acceleration.x,y: accelerometerData!.acceleration.y,z: accelerometerData!.acceleration.z)
            })
        }
        self.updateIntervalLabel.text = "\(updateInterval)"
    }
    override func stopUpdates() {
        self.motionManger.stopAccelerometerUpdates()
    }
}