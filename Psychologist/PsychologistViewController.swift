//
//  ViewController.swift
//  Psychologist
//
//  Created by Amin Amjadi on 7/15/16.
//  Copyright © 2016 MDJD. All rights reserved.
//

import UIKit

class PsychologistViewController: UIViewController
{
    
    @IBAction func nothing(sender: UIButton) {
        performSegueWithIdentifier("nothing", sender: nil)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination = segue.destinationViewController as UIViewController
        if let navCon = destination as? UINavigationController {
            destination = navCon.visibleViewController! //visibleViewController points to the UIView that NavigationController is connecting to
        }
        if let hvc = destination as? HappinessViewController {
            if let identifier = segue.identifier {
                switch identifier {
                case "sad":
                    hvc.happiness = 0
                case "happy":
                    hvc.happiness = 100
                case "nothing":
                    hvc.happiness = 40
                default:
                    hvc.happiness = 50
                }
            }
        }
    }


}

