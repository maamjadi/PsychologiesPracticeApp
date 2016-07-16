//
//  HappinessViewController.swift
//  Happiness
//
//  Created by Amin Amjadi on 7/8/16.
//  Copyright © 2016 MDJD. All rights reserved.
//

import UIKit

class HappinessViewController: UIViewController, FaceViewDataSource //when we implement the protocol here we will get error if we wouldn't write its function
{
    
    @IBOutlet weak var faceView: FaceView! {
        didSet {
            faceView.dataSource = self
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(target: faceView, action: #selector(FaceView.changeScale(_:))))
            //faceView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "changeHappiness:"))
            //instead of doing this line of code we are going to do this in our storyboard
        }
    }
    
    
    var happiness: Int = 80 { // 0 = very sad, 100 = ecstatic, we have to say it is equal to something cz we have to initialize all of the properties in Swift
        didSet {
            happiness = min(max(happiness, 0), 100) // we always say min(max(.., ..), ..) to make a range that we can't get value out of that range 
            print("happiness = \(happiness)")
            updateUI() //if someone update our model, we need to update our UI (want to UI to be changes too)
        }
    }
    
    func updateUI() {
        faceView?.setNeedsDisplay()
        
        switch happiness {
        case 100:
            title = "Ecstatic"
        case 50:
            title = "Don't care"
        case 40:
            title = "Not Very Happpy"
        case 0:
            title = "Very Sad"
        default:
            if happiness>50 {
                title = "Happy"
            }
            else {
                title = "Sad"
            }
        }
    }
    
    private struct Constants {
        static let HappinessGestureScale: CGFloat = 4
    }
    
    @IBAction func changeHappiness(gesture: UIPanGestureRecognizer) {
        
        switch gesture.state {
        case .Ended: fallthrough
        case .Changed:
            let translation = gesture.translationInView(faceView)
            let happinessChange = Int(translation.y / Constants.HappinessGestureScale)
            if happinessChange != 0 {
                happiness += happinessChange
                gesture.setTranslation(CGPointZero, inView: faceView)
            }
            
        default: break
        }
    }
    
    func smilinessForFaceView(sender: FaceView) -> Double? {
        return Double(happiness-50)/50
    }
}
