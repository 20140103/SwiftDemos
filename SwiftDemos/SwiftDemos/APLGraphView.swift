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
    let gray = CGColorSpaceCreateDeviceGray()
    let comps = [r,g,b,a]
    let color = CGColorCreate(gray,comps)
    return color!
}
func graphBackgroundColor()->CGColorRef{
    let c = createDeviceGrayColor(0.6, a: 1.0)
    return c
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
        
        CGContextMoveToPoint(context, x, y)
        CGContextAddLineToPoint(context, x + width, y)
    }
    CGContextSetStrokeColorWithColor(context, graphLineColor())
    CGContextStrokePath(context)
}

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
        self.segments.insertObject(segment, atIndex: 0)
        self.layer.insertSublayer(segment.layer, above: self.textView.layer)
        segment.layer.position = kSegmentInitialPosition
        return segment
    }
    func addX(x:Double,y:Double,z:Double){
        if(self.current.addX(z, y: z, z: z)){
//            self.recycleSegment()
            self.current.addX(x, y: y, z: z)
        }
        for segment in self.segments {
            var position = (segment as! APLGraphViewSegment).layer.position
            position.x += 1.0
            segment.layer.position = position
        }
    }
    
    func recycleSegment(){
        let last = self.segments.lastObject
        if(last!.isVisibleInRect(self.layer.bounds)){
            self.current = self.addSegment()
        }
        else{
            last?.reset()
            last?.layer.position = kSegmentInitialPosition
            self.segments.insertObject(last!, atIndex: 0)
            self.segments.removeLastObject()
            self.current = last as! APLGraphViewSegment
        }
    }
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, graphBackgroundColor())
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
        
        override init() {
            
            self.layer = CALayer()
           
            index = 33
            self.xHistory = [Double](count: 32, repeatedValue: 0.0)
            self.yHistory = [Double](count: 32, repeatedValue: 0.0)
            self.zHistory = [Double](count: 32, repeatedValue: 0.0)
            super.init()
            self.layer.delegate = self
            self.layer.bounds = CGRectMake(0.0, -56.0, 32.0, 112.0)
            self.layer.opaque = true
            //self.accessibilityValue =
        }
        
        func addX(x:Double,y:Double,z:Double)->Bool{
            if(index > 0){
                --index
                self.xHistory[index] = x
                self.yHistory[index] = y
                self.zHistory[index] = z
                self.layer.setNeedsDisplay()
            }
            return index == 0
        }
        func reset(){
            self.xHistory.removeAll(keepCapacity: true)
            self.yHistory.removeAll(keepCapacity: true)
            self.zHistory.removeAll(keepCapacity: true)
            self.index = 33
        }
        func isFull()->Bool{
            return index == 0
        }
        func isVisibleInRect(r:CGRect)->Bool{
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
            
            drawGridlines(context!, x: 26.0, width: 56.0)
            
//            let systemFont = UIFont.systemFontOfSize(12.0)
            
            UIColor.whiteColor().set()
//            [@"+3.0" drawInRect:CGRectMake(2.0, -56.0, 24.0, 16.0) withFont:systemFont lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentRight];
//            [@"+2.0" drawInRect:CGRectMake(2.0, -40.0, 24.0, 16.0) withFont:systemFont lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentRight];
//            [@"+1.0" drawInRect:CGRectMake(2.0, -24.0, 24.0, 16.0) withFont:systemFont lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentRight];
//            [@" 0.0" drawInRect:CGRectMake(2.0,  -8.0, 24.0, 16.0) withFont:systemFont lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentRight];
//            [@"-1.0" drawInRect:CGRectMake(2.0,   8.0, 24.0, 16.0) withFont:systemFont lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentRight];
//            [@"-2.0" drawInRect:CGRectMake(2.0,  24.0, 24.0, 16.0) withFont:systemFont lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentRight];
//            [@"-3.0" drawInRect:CGRectMake(2.0,  40.0, 24.0, 16.0) withFont:systemFont lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentRight];

//            let textFontAttributes = NSDictionary<NSObject,NSObject>[
////                NSFontAttributeName: systemFont,
//                NSTextAlignment: NSTextAlignment.Right ,
//                NSLineBreakMode: NSLineBreakMode.ByWordWrapping,
//            ]
            
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
