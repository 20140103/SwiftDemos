//
//  CyroViewController.swift
//  SwiftDemos
//
//  陀螺仪
//  Created by tdc-sw on 16/1/8.
//  Copyright © 2016年 twt. All rights reserved.
//

import Foundation
import CoreMotion

class CyroViewController: MotionManagerViewController {
    @IBOutlet var graphView: APLGraphView!
    let  gyroMin:NSTimeInterval = 0.01
    override func startUpdatesWithSliderValue(sliderValue: Int) {
        let delta:NSTimeInterval = 0.005;
        let updateInterval:NSTimeInterval = gyroMin + delta * Double(sliderValue);
        if(motionManger.gyroAvailable){
            motionManger.gyroUpdateInterval = updateInterval//1/10
            //            motionManger.startGyroUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: gyroChangeBlock)
            motionManger.startGyroUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: { (gyroData:CMGyroData?,error:NSError?) in
                
                self.graphView.addX(gyroData!.rotationRate.x, y: gyroData!.rotationRate.y , z: gyroData!.rotationRate.z)
                NSLog("\(gyroData!.rotationRate.x, y: gyroData!.rotationRate.y , z: gyroData!.rotationRate.z)")
                self.setLabelValueX(gyroData!.rotationRate.x, y: gyroData!.rotationRate.y , z: gyroData!.rotationRate.z)
                
                }
            )
        }
        self.updateIntervalLabel.text = "\(updateInterval)"
        
    }
    override func stopUpdates() {
        motionManger.stopGyroUpdates()
    }
}