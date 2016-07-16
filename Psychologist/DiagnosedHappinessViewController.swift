//
//  DiagnosedHappinessViewController.swift
//  Psychologist
//
//  Created by Amin Amjadi on 7/15/16.
//  Copyright © 2016 MDJD. All rights reserved.
//

import UIKit

class DiagnosedHappinessViewController: HappinessViewController, UIPopoverPresentationControllerDelegate
{
    override var happiness: Int {
        didSet { //so here when we say didSet it's not going to override our didSet we had in HVC but it's gonna do the first didSet and then this one
            diagnosticHistory += [happiness]
        }
    }
    
    private let defaults =  NSUserDefaults.standardUserDefaults()
    
    var diagnosticHistory: [Int] {
        get { return defaults.objectForKey(History.defaultsKey) as? [Int] ?? [] }
        set { defaults.setObject(newValue, forKey: History.defaultsKey) }
    }
    
    private struct History {
        static let segueIdentifier = "Show Diagnostic History"
        static let defaultsKey = "DiagnosedHappinessViewController.History" //we can put anything we want in "" here but to remember that the defaults is the database that shared with entire application so we might want to give it a good name like this
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case History.segueIdentifier:
                if let tvc = segue.destinationViewController as? TextViewController {
                    if let ppc = tvc.popoverPresentationController { ///this is a method in UIViewController and it will return nil if we are currently in the proccess of being peresented by popover
                        ppc.delegate = self //this is because the popover controllers' delegate allows us to have someone else control the way presentation works
                    }
                    tvc.text = "\(diagnosticHistory)"
                }
            default:
                break
            }
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
}