//
//  MoreSensorViewController.swift
//  SwiftDemos
//
//  Created by tdc-sw on 16/1/12.
//  Copyright © 2016年 twt. All rights reserved.
//

import UIKit

class MoreSensorViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "proximityChange:", name: UIDeviceProximityStateDidChangeNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    @IBAction func proximitySensorAction(sender: UIButton) {
        UIDevice.currentDevice().proximityMonitoringEnabled = !UIDevice.currentDevice().proximityMonitoringEnabled
        NSLog(UIDevice.currentDevice().systemName)//设备名称
        NSLog(UIDevice.currentDevice().systemVersion)//IOS版本号
        NSLog("orientation \(UIDevice.currentDevice().orientation.isLandscape)")
    }
    
    func proximityChange(notification:NSNotificationCenter){
        NSLog("proximityChange \(UIDevice.currentDevice().proximityState)")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
