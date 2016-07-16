//
//  FaceView.swift
//  Happiness
//
//  Created by Amin Amjadi on 7/8/16.
//  Copyright © 2016 MDJD. All rights reserved.
//

import UIKit

protocol FaceViewDataSource: class { //this class is cz we would have error for datasource in FaceView if we don't say it
    //and it means the FaceViewDataSource can only be implemented by a class
    func smilinessForFaceView(sender: FaceView) -> Double?
}

@IBDesignable
class FaceView: UIView
{
    @IBInspectable
    var linewidth: CGFloat = 3.0 { didSet {setNeedsDisplay()} } //everytime someone changes my line width, i need to redraw myself
    
    //so everytime we have a property in our view that changes how we drawn just put property observer and setNeedsDisplay after it
    @IBInspectable
    var color: UIColor = UIColor.darkGrayColor().colorWithAlphaComponent(0.5) { didSet {setNeedsDisplay()} }
    @IBInspectable
    var scale: CGFloat = 0.90 { didSet {setNeedsDisplay()} }
    
    var faceCenter: CGPoint {
        return convertPoint(center, fromView: superview)
    }
    var faceRadius: CGFloat {
        return min(bounds.size.height, bounds.size.width) / 2 * scale
    }
    
    weak var dataSource = FaceViewDataSource?()
    //for memory management, it's really managed for us but since that this property is pointing to our protocol 
    //and our protocol is pointing back to our property and so on... it will stay in the memory cz they are pointing to each other all the time...
    //so here we must wrtie weak which means it can't and musn't stay in our memory
    
    
    func changeScale(gesture: UIPinchGestureRecognizer) {
        if gesture.state == .Changed {
            scale *= gesture.scale
            gesture.scale = 1
        }
    }
    
    private struct Scaling {
        static let FaceRadiusToEyeRadiusRatio: CGFloat = 10
        static let FaceRadiusToEyeOffsetRatio: CGFloat = 3
        static let FaceRadiusToEyeSeparationRatio: CGFloat = 1.5
        static let FaceRadiusToMouthWidthRatio: CGFloat = 1
        static let FaceRadiusToMouthHeightRatio: CGFloat = 3
        static let FaceRadiusToMouthOffsetRatio: CGFloat = 3
    }
    
    private enum Eye { case Left, Right }
    
    private func bezierPathForEye(whichEye: Eye) -> UIBezierPath
    {
        let eyeRadius = faceRadius / Scaling.FaceRadiusToEyeRadiusRatio
        let eyeVerticalOffset = faceRadius / Scaling.FaceRadiusToEyeOffsetRatio
        let eyeHorizontalSeparation = faceRadius / Scaling.FaceRadiusToEyeSeparationRatio
        
        var eyeCenter = faceCenter
        eyeCenter.y -= eyeVerticalOffset
        
        switch whichEye {
        case .Left:
            eyeCenter.x -= eyeHorizontalSeparation / 2
        case .Right:
            eyeCenter.x += eyeHorizontalSeparation / 2
        }
        
        let path = UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
        path.lineWidth = linewidth
        return path
        
    }
    
    private func bezierPathForSmile(fractionOFMaxSmile: Double) -> UIBezierPath
    {
        let mouthWidth = faceRadius / Scaling.FaceRadiusToMouthWidthRatio
        let mouthHeight = faceRadius / Scaling.FaceRadiusToMouthHeightRatio
        let mouthVerticalOffset = faceRadius / Scaling.FaceRadiusToMouthOffsetRatio
        
        let smileHeight = CGFloat(max(min(fractionOFMaxSmile, 1), -1)) * mouthHeight //max(min(.., ..), ..) is just to won't be able to enter out of range
        
        let start = CGPoint(x: faceCenter.x - mouthWidth / 2, y: faceCenter.y + mouthVerticalOffset)
        let end = CGPoint(x: start.x + mouthWidth, y: start.y)
        let cp1 = CGPoint(x: start.x + mouthWidth / 3, y: start.y + smileHeight)
        let cp2 = CGPoint(x: end.x - mouthWidth / 3, y: cp1.y)
        
        let path = UIBezierPath()
        path.moveToPoint(start)
        path.addCurveToPoint(end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = linewidth
        
        return path
        
    }
    
    
    
    override func drawRect(rect: CGRect) {
        let facePath = UIBezierPath(arcCenter: faceCenter, radius: faceRadius, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
        facePath.lineWidth = linewidth
        color.set() //set means for both stroke and fill
        UIColor.yellowColor().setFill()
        facePath.stroke()
        facePath.fill()
        
        UIColor.whiteColor().setFill()
        bezierPathForEye(.Left).stroke()
        bezierPathForEye(.Left).fill()
        bezierPathForEye(.Right).stroke()
        bezierPathForEye(.Right).fill()
        
        let smiliness = dataSource?.smilinessForFaceView(self) ?? 0.0 //this "??" means if the thing in left hand side of it is not nil use it
        //otherwise use the thing which is in right hand side
        
        let smilePath = bezierPathForSmile(smiliness)
        smilePath.stroke()
    }

}
