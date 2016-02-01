//
//  LocationManagerViewController.swift
//  SwiftDemos
//
//  Created by tdc-sw on 16/1/11.
//  Copyright © 2016年 twt. All rights reserved.
//

import UIKit
import CoreLocation

class LocationManagerViewController: UIViewController ,CLLocationManagerDelegate{
    
    @IBOutlet var latTextField: UITextField!
    @IBOutlet var longTextField: UITextField!
    
    @IBOutlet var addressTextView: UITextView!
    var locationManager:CLLocationManager! //实例化一个CLLocationManager对象
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initLoactionManager()
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.locationManager.stopUpdatingLocation()
    }
    func initLoactionManager(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest //设置为最高的精度
        locationManager.requestAlwaysAuthorization()  //如果是IOS8及以上
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        NSLog("\(locations.count)")
        let location = locations.last
        let latitude = location!.coordinate.latitude  //得到经伟度
        let longtitude = location!.coordinate.longitude
        self.latTextField.text = "\(latitude)"
        self.longTextField.text = "\(longtitude)"
        reverseGeocode(location!.coordinate)
        self.locationManager.stopUpdatingLocation()
        NSLog("\(latitude,longtitude)")
        
    }
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        NSLog("\(error.debugDescription)")
    }
    
    @IBAction func updateLoaction(sender: UIButton) {
//        版本需调用这个方法
        locationManager.startUpdatingLocation()  //start updating location
    }
    
    @IBAction func getCoordinate(sender: UIButton) {
        if(self.addressTextView.text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)>0){
            self.locationEncode(self.addressTextView.text)
        }
    }
    
    //地理信息编码 经纬度->地址
    func reverseGeocode(latitude:CLLocationDegrees,longitude:CLLocationDegrees){
        let geocoder = CLGeocoder()
        //        var p:CLPlacemark?
        let currentLocation = CLLocation(latitude: latitude, longitude: longitude)
        
        geocoder.reverseGeocodeLocation(currentLocation){
            (placemarks, error) in
            NSLog(placemarks.debugDescription)
            let array = NSArray(object: "zh-hans")
            NSUserDefaults.standardUserDefaults().setObject(array, forKey: "AppleLanguages")
            if placemarks!.count > 0{
                self.addressTextView.text  = placemarks![0].name
            }
            
        }
    }
    //     CLLocationCoordinate2D
    func reverseGeocode(coordinate:CLLocationCoordinate2D){
        reverseGeocode(coordinate.latitude,longitude: coordinate.longitude)
    }
    //地理信息反编码 地址->经纬度
    func locationEncode(address:String){
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address){
            (placemarks,error) in
            //            NSLog(placemarks.debugDescription)
            if(placemarks?.count > 0 ){
                let p = placemarks![0]
                let lat = p.location?.coordinate.latitude
                let long = p.location?.coordinate.longitude
                NSLog("\(lat,long)")
            }
        }
    }
}
