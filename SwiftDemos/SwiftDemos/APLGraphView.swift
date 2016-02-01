//
//  APLGraphView.swift
//  SwiftDemos
//
//  Created by tdc-sw on 16/1/7.
//  Copyright © 2016年 twt. All rights reserved.
//

import UIKit
import QuartzCore



func createDeviceGrayColor(w:CGFloat,a:CGFloat)->CGColorRef{
    let gray = CGColorSpaceCreateDeviceGray()
    let comps = [w,a]
    let color = CGColorCreate(gray,comps)
    return color!
}
func createDeviceRGBColor(r:CGFloat,g:CGFloat,b:CGFloat,a:CGFloat)->CGColorRef{
    let gray = CGColorSpaceCreateDeviceRGB()
    let comps = [r,g,b,a]
    let color = CGColorCreate(gray,comps)
    return color!
}
func graphBackgroundColor()->CGColorRef{
    let c = createDeviceGrayColor(0.6, a: 1.0)
    return c
//    return UIColor.clearColor().CGColor
}
func graphLineColor()->CGColorRef{
    let c = createDeviceGrayColor(0.5, a: 1.0)
    return c
}
func graphXColor()->CGColorRef{
    let c = createDeviceRGBColor(1.0, g: 0.0, b: 0.0, a: 1.0)
    return c
}
func graphYColor()->CGColorRef{
    let c = createDeviceRGBColor(0.0, g: 1.0, b: 0.0, a: 1.0)
    return c
}
func graphZColor()->CGColorRef{
    let c = createDeviceRGBColor(0.0, g: 0.0, b: 1.0, a: 1.0)
    return c
}
func drawGridlines(context:CGContextRef,x:CGFloat,width:CGFloat){
    for(var y:CGFloat = -48.5;y <= 48.5;y += 16.0){
//        y = -48.5
        CGContextMoveToPoint(context, x, y)
        CGContextAddLineToPoint(context, x + width, y)
        
//        NSLog("form\(x,y) to\(x+width,y)")
    }
    CGContextSetStrokeColorWithColor(context, graphLineColor())
    CGContextStrokePath(context)
}
var fag = 0

struct color {
    var r:CGFloat
    var g:CGFloat
    var b:CGFloat
}
let colors = [
    color(r: 1, g: 0, b: 0)
    ,color(r: 0, g: 1, b: 0)
    ,color(r: 0, g: 0, b: 1)
    ,color(r: 1, g: 0, b: 1)
    ,color(r: 1, g: 1, b: 0)
    
    ,color(r: 0, g: 1, b: 1)
    ,color(r: 1, g: 0.5, b: 0)
    ,color(r: 1, g: 0, b: 0.5)
    ,color(r: 1, g: 0.5, b: 0.5)
    ,color(r: 0.5, g: 0, b: 0)
    ,color(r: 0.4, g: 0, b: 0.5)
    ,color(r: 0.5, g: 0.5, b: 1)
]

class APLGraphView:UIView {
    let kSegmentInitialPosition = CGPointMake(14.0, 56.0)
    var segments:NSMutableArray!
    var current:APLGraphViewSegment!
    var textView:APLGraphTextView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        
        
    }
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit(){
        self.segments = NSMutableArray()
        
        let text = APLGraphTextView(frame: CGRectMake(0.0, 0.0, 32.0, 112.0))
        self.addSubview(text)
        self.textView = text
        
        self.current = self.addSegment()
    }
    func addSegment()->APLGraphViewSegment{
        let segment = APLGraphViewSegment()
//        segment.layer.backgroundColor = UIColor.redColor().CGColor//createDeviceRGBColor(colors[fag].r,g: colors[fag].g,b: colors[fag].b,a: 1)
//        fag++
        self.segments.insertObject(segment, atIndex: 0)
        self.layer.insertSublayer(segment.layer, below: self.textView.layer)
//        self.layer.backgroundColor = UIColor.clearColor().CGColor
//        self.layer.backgroundColor = UIColor.greenColor().CGColor
//        self.backgroundColor = UIColor.clearColor()
//        self.backgroundColor = UIColor.redColor()
        segment.layer.position = kSegmentInitialPosition
        return segment
    }
    func addX(x:Double,y:Double,z:Double){
        if(self.current.addX(x, y: y, z: z)){
            self.recycleSegment()
            self.current.addX(x, y: y, z: z)
        }
        for segment in self.segments {
            var position = (segment as! APLGraphViewSegment).layer.position
            position.x += 1.0
            segment.layer.position = position
        }
    }
    
    func recycleSegment(){
        let last = self.segments.lastObject as! APLGraphViewSegment
        if(last.isVisibleInRect(self.layer.bounds)){
            self.current = self.addSegment()
        }
        else{
            last.reset()
            last.layer.position = kSegmentInitialPosition
            self.segments.insertObject(last, atIndex: 0)
            self.segments.removeLastObject()
            self.current = last
        }
    }
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
//        CGContextSetFillColorWithColor(context, graphBackgroundColor())
        CGContextSetFillColorWithColor(context,UIColor.clearColor().CGColor)
        CGContextFillRect(context, self.bounds);
        
        // Draw the grid lines.
        let width = self.bounds.size.width;
        CGContextTranslateCTM(context, 0.0, 56.0);
        drawGridlines(context!, x: 0.0, width: width);

    }
    
    class APLGraphViewSegment: NSObject {
        var xHistory:[Double]
        var yHistory:[Double]
        var zHistory:[Double]
        var index:Int
        var layer:CALayer
        var tag:Int
        override init() {
            
            self.layer = CALayer()
            tag = fag++
            index = 33
            self.xHistory = [Double](count: 33, repeatedValue: 0.0)
            self.yHistory = [Double](count: 33, repeatedValue: 0.0)
            self.zHistory = [Double](count: 33, repeatedValue: 0.0)
            super.init()
            self.layer.delegate = self
            self.layer.bounds = CGRectMake(0.0, -56.0, 32.0, 112.0)
            self.layer.opaque = true
//            self.layer.backgroundColor = UIColor.greenColor().CGColor
            //self.accessibilityValue =
        }
        
        func addX(x:Double,y:Double,z:Double)->Bool{
            if(index > 0){
                --index
                NSLog("APLGraphViewSegment index = \(index)")
                self.xHistory[index] = x
                self.yHistory[index] = y
                self.zHistory[index] = z
                self.layer.setNeedsDisplay()
            }
            return index == 0
        }
        func reset(){
            self.xHistory = [Double](count: 33, repeatedValue: 0.0)
            self.yHistory = [Double](count: 33, repeatedValue: 0.0)
            self.zHistory = [Double](count: 33, repeatedValue: 0.0)
            self.index = 33
            self.layer.setNeedsDisplay()
        }
        func isFull()->Bool{
            return index == 0
        }
        func isVisibleInRect(r:CGRect)->Bool{
//            NSLog("\(r.origin.x , r.origin.y)\(r.size.width,r.size.height)")
            return CGRectIntersectsRect(r, self.layer.frame)
        }
        
        override func drawLayer(layer: CALayer, inContext ctx: CGContext) {
            CGContextSetFillColorWithColor(ctx, graphBackgroundColor())
            CGContextFillRect(ctx, self.layer.bounds)
            
            // Draw the grid lines.
            drawGridlines(ctx, x: 0.0, width: 32.0)
            
            // Draw the graph.
//            CGPoint lines[64];
            var lines = [CGPoint](count: 64,repeatedValue: CGPoint())
//            int i;
            var i:Int
            
            // X
            for (i = 0; i < 32; ++i)
            {
                
//                lines[i*2].x = i
                lines[i*2].x = CGFloat(i)
                lines[i*2].y = CGFloat(-xHistory[i] * 16.0)
                lines[i*2+1].x = CGFloat(i + 1)
                lines[i*2+1].y = CGFloat(-xHistory[i+1] * 16.0)
            }
            CGContextSetStrokeColorWithColor(ctx, graphXColor())
            CGContextStrokeLineSegments(ctx, lines, 64)
            
            // Y
            for (i = 0; i < 32; ++i)
            {
                lines[i*2].y = CGFloat(-yHistory[i] * 16.0)
                lines[i*2+1].y = CGFloat(-yHistory[i+1] * 16.0)
            }
            CGContextSetStrokeColorWithColor(ctx, graphYColor())
            CGContextStrokeLineSegments(ctx, lines, 64)

            // Z
            for (i = 0; i < 32; ++i)
            {
                lines[i*2].y = CGFloat(-zHistory[i] * 16.0)
                lines[i*2+1].y = CGFloat(-zHistory[i+1] * 16.0)
            }
            CGContextSetStrokeColorWithColor(ctx, graphZColor())
            CGContextStrokeLineSegments(ctx, lines, 64);
            NSLog("tag = \(tag)")
            let text1:NSString = "\(tag)"
//             text1.drawInRect(CGRectMake(self.layer.bounds.origin.x,self.layer.bounds.origin.y, 24.0, 16.0), withAttributes: nil)
            text1.drawInRect(CGRectMake(lines[0].x,lines[0].y, 24.0, 16.0), withAttributes: nil)
        }
        
        override func actionForLayer(layer: CALayer, forKey event: String) -> CAAction? {
            return nil
        }
        
    }
    
    class APLGraphTextView:UIView {
        override func drawRect(rect: CGRect) {
            let context = UIGraphicsGetCurrentContext()
            
            CGContextSetFillColorWithColor(context, graphBackgroundColor())
            CGContextFillRect(context, self.bounds)
            
            CGContextTranslateCTM(context, 0.0, 56.0)
            
            drawGridlines(context!, x: 26.0, width: 6.0)
            
//            let systemFont = UIFont.systemFontOfSize(12.0)
            
            UIColor.whiteColor().set()
 
            let text1:NSString = "+3.0"
            text1.drawInRect(CGRectMake(2.0, -56.0, 24.0, 16.0), withAttributes: nil)
            let text2:NSString = "+2.0"
            text2.drawInRect(CGRectMake(2.0, -40.0, 24.0, 16.0), withAttributes: nil)
            let text3:NSString = "+1.0"
            text3.drawInRect(CGRectMake(2.0, -24.0, 24.0, 16.0), withAttributes: nil)
            
            let text4:NSString = "+0.0"
            text4.drawInRect(CGRectMake(2.0, -8.0, 24.0, 16.0), withAttributes: nil)
            let text5:NSString = "-1.0"
            text5.drawInRect(CGRectMake(2.0, 8.0, 24.0, 16.0), withAttributes: nil)
            let text6:NSString = "-2.0"
            text6.drawInRect(CGRectMake(2.0, 24.0, 24.0, 16.0), withAttributes: nil)
            let text7:NSString = "-3.0"
            text7.drawInRect(CGRectMake(2.0, 40.0, 24.0, 16.0), withAttributes: nil)
        }
    }
    
}
