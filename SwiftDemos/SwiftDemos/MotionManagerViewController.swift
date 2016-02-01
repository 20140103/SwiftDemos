//
//  MotionManagerViewController.swift
//  SwiftDemos
//
//  Created by tdc-sw on 16/1/7.
//  Copyright © 2016年 twt. All rights reserved.
//
/*
运动传感器\加速度传感器\加速计（Motion/Accelerometer Sensor）
环境光传感器（Ambient Light Sensor）
距离传感器（Proximity Sensor）
磁力计传感器（Magnetometer Sensor）
内部温度传感器（Internal Temperature Sensor）
湿度传感器（Moisture Sensor）
陀螺仪（Gyroscope）

*/
import UIKit
import CoreMotion

class MotionManagerViewController: UIViewController {
    
    @IBOutlet var xLabel: UILabel!
 
    @IBOutlet var yLabel: UILabel!
    
    @IBOutlet var zLabel: UILabel!
    
    @IBOutlet var updateIntervalLabel: UILabel!
    
    @IBOutlet var updateIntervalSlider: UISlider!
    
    var motionManger:CMMotionManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        motionManger =  CMMotionManager()
        self.updateIntervalSlider.value = 0.0
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
//        [self startUpdatesWithSliderValue:(int)(self.updateIntervalSlider.value * 100)];
        self.startUpdatesWithSliderValue(Int(self.updateIntervalSlider.value * 100.0))
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        stopUpdates()
    }
    
    @IBAction func takeSliderValueFrom(sender: UISlider) {
        self.startUpdatesWithSliderValue(Int(sender.value * 100))
    }
    func setLabelValueX(x:Double,y:Double,z:Double){
        self.xLabel.text = String(format: "x:%.4f", x)
        self.yLabel.text = String(format: "y:%.4f", y)//"y:\(y)"
        self.zLabel.text = String(format: "z:%.4f", z)//"z:\(z)"
    }
    func setLabelValueRoll(roll:Double,pitch:Double,yaw:Double){
        self.xLabel.text = String(format: "roll:.4f", roll)
        self.yLabel.text = String(format: "pitch:.4f", pitch)//"pitch:\(pitch)"
        self.zLabel.text = String(format: "yaw:.4f", yaw)//"yaw:\(yaw)"
    }
    func startUpdatesWithSliderValue(sliderValue:Int){
        
    }
    func stopUpdates(){
        
    }
}
