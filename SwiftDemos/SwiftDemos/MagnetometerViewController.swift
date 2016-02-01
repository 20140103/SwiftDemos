//
//  MagnetometerViewController.swift
//  SwiftDemos
//
//  Created by tdc-sw on 16/1/12.
//  Copyright © 2016年 twt. All rights reserved.
//

import UIKit

class MagnetometerViewController: MotionManagerViewController {

    
    @IBOutlet var graphView: APLGraphView!
    
    let magnetometerMin = 0.01
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func startUpdatesWithSliderValue(sliderValue: Int) {
        let delta:NSTimeInterval = 0.005
        let updateInterval:NSTimeInterval = magnetometerMin + delta * Double(sliderValue)
        if(self.motionManger.magnetometerAvailable){
            self.motionManger.magnetometerUpdateInterval = updateInterval
            self.motionManger.startMagnetometerUpdatesToQueue(NSOperationQueue.mainQueue()){
                    (magnetometerData, error) in
                    NSLog((magnetometerData?.debugDescription)!)
                    self.setLabelValueX((magnetometerData?.magneticField.x)!, y: (magnetometerData?.magneticField.y)!, z: (magnetometerData?.magneticField.y)!)
                    self.graphView.addX((magnetometerData?.magneticField.x)!, y: (magnetometerData?.magneticField.y)!, z: (magnetometerData?.magneticField.y)!)
                
                }
        }
        self.updateIntervalLabel.text = "\(updateInterval)"
    }
    override func stopUpdates() {
        self.motionManger.stopMagnetometerUpdates()
    }


}
