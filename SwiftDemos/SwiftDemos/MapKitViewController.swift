//
//  MapKitViewController.swift
//  SwiftDemos
//
//  Created by tdc-sw on 16/9/1.
//  Copyright © 2016年 twt. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
class MapKitViewController: UIViewController,MKMapViewDelegate {

    
    
    @IBOutlet var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func locationAction(sender: UIBarButtonItem) {
//        mapView.showsUserLocation = true
//        mapView.userTrackingMode = .Follow
        //113.937632,22.479762
//        mapView.userLocation.coordinate = CLLocationCoordinate2D(latitude: 113.937632, longitude: 22.479762)
        let coordinate = CLLocationCoordinate2D(latitude:22.475762, longitude:  113.937632)
        addAnnotation(coordinate)
//        addOverlay(coordinate)
        addCharacterLocation()
    }
    var timer:NSTimer?
    @IBAction func changeAction(sender: UIBarButtonItem) {
        timer = NSTimer(timeInterval: 1000, target: self, selector: #selector(timerOut(_:)), userInfo: nil, repeats: true)
        
        
    }
    func timerOut(timer:NSTimer){
//        self.circleView.fillColor = UIColor.redColor()
//        self.circleView.overlay.
    }
    func addAnnotation(coordinate:CLLocationCoordinate2D){
       // mapView.userLocation.coordinate
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
    }
    
    func addOverlay(centerCoordinate:CLLocationCoordinate2D){
        let circle =  MKCircle(centerCoordinate: centerCoordinate, radius: 30.2)
        
        mapView.addOverlay(circle)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    var circleView:MKCircleRenderer!
    //MARK: -MKMapViewDelegate
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
//        if overlay is ParkMapOverlay {
//            let magicMountainImage = UIImage(named: "overlay_park")
//            let overlayView = ParkMapOverlayView(overlay: overlay, overlayImage: magicMountainImage!)
//            
//            return overlayView
//        } else 
        if overlay is MKPolyline {
            let lineView = MKPolylineRenderer(overlay: overlay)
            lineView.strokeColor = UIColor.greenColor()
            
            return lineView
        } else if overlay is MKPolygon {
            let polygonView = MKPolygonRenderer(overlay: overlay)
            polygonView.strokeColor = UIColor.magentaColor()
            
            return polygonView
        } else if overlay is Character {
            circleView = MKCircleRenderer(overlay: overlay)
            circleView.strokeColor = (overlay as! Character).color
            circleView.fillColor = (overlay as! Character).color
            return circleView
        }
//        return MKCircleView()
        return MKCircleRenderer(overlay: overlay)
        //return nil
    }
    var annotationView:MKAnnotationView?
    let width = 100
    let height = 100
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
//        let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "annotation")
//        pinAnnotationView.pinColor = .Purple
//        pinAnnotationView.draggable = true
//        pinAnnotationView.canShowCallout = true
//        pinAnnotationView.animatesDrop = true
//        
//        let button = UIButton(type: UIButtonType.Custom)
//        button.frame.size.width = 44
//        button.frame.size.height = 44
//        button.backgroundColor = UIColor.redColor()
//        button.setImage(UIImage(named: "trash"), forState: .Normal)
//        
//        pinAnnotationView.leftCalloutAccessoryView = button
//        return pinAnnotationView
        annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "test")
        
        annotationView?.frame = CGRect(x: 50, y: 50, width: width, height: height)
        annotationView?.backgroundColor = UIColor.redColor()
        annotationView?.layer.cornerRadius = 50
        annotationView?.layer.masksToBounds = true
        //设置动画效果，动画时间长度 1 秒。
//        UIView.animateWithDuration(1, delay:0.01,
//                                   options:UIViewAnimationOptions.TransitionNone, animations:
//            {
//                ()-> Void in
//                //在动画中，数字块有一个角度的旋转。
//                annotationView.layer.setAffineTransform(CGAffineTransformMakeRotation(90))
//            },
//                                   completion:{
//                                    (finished:Bool) -> Void in
//                                    UIView.animateWithDuration(1, animations:{
//                                        ()-> Void in
//                                        //完成动画时，数字块复原
//                                        annotationView.layer.setAffineTransform(CGAffineTransformIdentity)
//                                    })
//        })
        playAnimation()
        
        return annotationView
    }
    func playAnimation()
    {
        UIView.animateWithDuration(1.6, delay: 1.4, options: [.Repeat, .Autoreverse],
                                   animations: {
//                                    self.annotationView?.frame.origin.x = self.view.bounds.width - ((self.annotationView?.frame.width) ?? 0)
//                                    if self.annotationView?.frame.size.width < 20 {
//                                        self.annotationView?.frame.size.width = CGFloat(self.width)
//                                    }else{
//                                         self.annotationView?.frame.size.width -= 5
//                                    }
//                                    if self.annotationView?.frame.size.height < 20 {
//                                        self.annotationView?.frame.size.height = CGFloat(self.height)
//                                    }else{
//                                        self.annotationView?.frame.size.height -= 5
//                                    }
                                    self.annotationView?.frame.size.width = 20
                                     self.annotationView?.frame.size.height = 20
                                    self.annotationView?.alpha = 0.1
            },
                                   completion: nil)
    }
    class Character: MKCircle {
        
        var name: String?
        
        var color: UIColor?
        
    }
    
    func addCharacterLocation() {
        
//        let batmanFilePath = NSBundle.mainBundle().pathForResource("BatmanLocations", ofType: "plist")
//        
//        let batmanLocations = NSArray(contentsOfFile: batmanFilePath!)
//        
//        let batmanPoint = CGPointFromString(batmanLocations![Int(rand()%4)] as! String)
//        
//        let batmanCenterCoordinate = CLLocationCoordinate2DMake(CLLocationDegrees(batmanPoint.x), CLLocationDegrees(batmanPoint.y))
//        
        let batmanCenterCoordinate = CLLocationCoordinate2D(latitude:22.479762, longitude:  113.937632)
        let batmanRadius = CLLocationDistance(max(5, Int(rand()%40)))
        
        let batman = Character(centerCoordinate:batmanCenterCoordinate, radius:batmanRadius)
        
        batman.color = UIColor.blueColor()
        
        
        
//        let tazFilePath = NSBundle.mainBundle().pathForResource("TazLocations", ofType: "plist")
//        
//        let tazLocations = NSArray(contentsOfFile: tazFilePath!)
//        
//        let tazPoint = CGPointFromString(tazLocations![Int(rand()%4)] as! String)
//        
//        let tazCenterCoordinate = CLLocationCoordinate2DMake(CLLocationDegrees(tazPoint.x), CLLocationDegrees(tazPoint.y))
//
        let tazCenterCoordinate = CLLocationCoordinate2D(latitude:22.469762, longitude:  113.937632)
        let tazRadius = CLLocationDistance(max(5, Int(rand()%40)))
        
        let taz = Character(centerCoordinate:tazCenterCoordinate, radius:tazRadius)
        taz.color = UIColor.orangeColor()
        
        
        
//        let tweetyFilePath = NSBundle.mainBundle().pathForResource("TweetyBirdLocations", ofType: "plist")
//        
//        let tweetyLocations = NSArray(contentsOfFile: tweetyFilePath!)
//        
//        let tweetyPoint = CGPointFromString(tweetyLocations![Int(rand()%4)] as! String)
//        
//        let tweetyCenterCoordinate = CLLocationCoordinate2DMake(CLLocationDegrees(tweetyPoint.x), CLLocationDegrees(tweetyPoint.y))
        let tweetyCenterCoordinate = CLLocationCoordinate2D(latitude:22.459762, longitude:  113.937632)
        let tweetyRadius = CLLocationDistance(max(5, Int(rand()%40)))
        
        let tweety = Character(centerCoordinate:tweetyCenterCoordinate, radius:tweetyRadius)
        
        tweety.color = UIColor.yellowColor()
        
        
        mapView.addOverlay(batman)
        
        mapView.addOverlay(taz)
        
        mapView.addOverlay(tweety)
        
    }
}
