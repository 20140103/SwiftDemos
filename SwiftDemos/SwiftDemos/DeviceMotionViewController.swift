//
//  DeviceMotion.swift
//  SwiftDemos
//
//  Created by tdc-sw on 16/1/8.
//  Copyright © 2016年 twt. All rights reserved.
//

import Foundation
import UIKit
import CoreMotion

let  deviceMotionMin:NSTimeInterval = 0.01;

enum DeviceMotionGraphType : Int {
    case kDeviceMotionGraphTypeAttitude = 0,
    kDeviceMotionGraphTypeRotationRate,
    kDeviceMotionGraphTypeGravity,
    kDeviceMotionGraphTypeUserAcceleration
}



class DeviceMotionViewController:MotionManagerViewController {
    
    @IBOutlet var graphViews: [APLGraphView]!
    
    @IBOutlet var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showGraphAtIndex(0)
    }
    
    
    func showGraphAtIndex(selectedIndex:Int){
        for (index,value) in self.graphViews.enumerate(){
            let hidden = index != selectedIndex
            value.hidden = hidden
        }
        
    }
    @IBAction func segmentedControlChanged(sender: UISegmentedControl) {
        showGraphAtIndex(sender.selectedSegmentIndex)
        showGraphAtIndex(sender.selectedSegmentIndex)
    }
    
    override func startUpdatesWithSliderValue(sliderValue: Int) {
        let delta:NSTimeInterval = 0.005
        let updateInterval:NSTimeInterval = deviceMotionMin + delta * Double(sliderValue)
        
        if(motionManger.deviceMotionAvailable){
            motionManger.deviceMotionUpdateInterval = updateInterval
            motionManger.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler:{(deviceMotion:CMDeviceMotion?,error:NSError?) in
                //self.graphViews.insert(<#T##newElement: Element##Element#>, atIndex: DeviceMotionGraphType.kDeviceMotionGraphTypeAttitude)
                self.graphViews[DeviceMotionGraphType.kDeviceMotionGraphTypeAttitude.rawValue].addX( deviceMotion!.attitude.roll, y:deviceMotion!.attitude.pitch ,z:deviceMotion!.attitude.yaw)
                self.graphViews[DeviceMotionGraphType.kDeviceMotionGraphTypeRotationRate.rawValue].addX( deviceMotion!.rotationRate.x, y:deviceMotion!.rotationRate.y ,z:deviceMotion!.rotationRate.z)
                self.graphViews[DeviceMotionGraphType.kDeviceMotionGraphTypeGravity.rawValue].addX( deviceMotion!.gravity.x, y:deviceMotion!.gravity.y ,z:deviceMotion!.gravity.z)
                self.graphViews[DeviceMotionGraphType.kDeviceMotionGraphTypeUserAcceleration.rawValue].addX( deviceMotion!.userAcceleration.x, y:deviceMotion!.userAcceleration.y ,z:deviceMotion!.userAcceleration.z)
                
                switch(self.segmentedControl.selectedSegmentIndex){
                case DeviceMotionGraphType.kDeviceMotionGraphTypeAttitude.rawValue:
                    self.setLabelValueX(deviceMotion!.attitude.roll, y:deviceMotion!.attitude.pitch ,z:deviceMotion!.attitude.yaw)
                    
                case DeviceMotionGraphType.kDeviceMotionGraphTypeRotationRate.rawValue:
                    self.setLabelValueX( deviceMotion!.rotationRate.x, y:deviceMotion!.rotationRate.y ,z:deviceMotion!.rotationRate.z)
                case DeviceMotionGraphType.kDeviceMotionGraphTypeGravity.rawValue:
                    self.setLabelValueX( deviceMotion!.gravity.x, y:deviceMotion!.gravity.y ,z:deviceMotion!.gravity.z)
                case DeviceMotionGraphType.kDeviceMotionGraphTypeUserAcceleration.rawValue:
                    self.setLabelValueX( deviceMotion!.userAcceleration.x, y:deviceMotion!.userAcceleration.y ,z:deviceMotion!.userAcceleration.z)
                default:
                    break;
                }
//                NSLog("\(self.graphViews.count)")
            })
        }
        self.updateIntervalLabel.text = "\(updateInterval)"
    }
    override func stopUpdates() {
        motionManger.startDeviceMotionUpdates()
    }
}