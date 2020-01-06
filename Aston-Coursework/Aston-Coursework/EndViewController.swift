//
//  EndViewController.swift
//  Aston-Coursework
//
//  Created by A&M on 05/01/2020.
//  Copyright © 2020 16052488. All rights reserved.
//

import UIKit

class EndViewController: UIViewController {
    
    /* Interface Builder: Outlets/Actions */
    @IBOutlet weak var mainMenuButton: UIButton!
    @IBOutlet weak var replayButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Orientation initialisation
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    /* Function to force orientation to landscape. */
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    /* Function to allow autorotate of orientation. */
    override var shouldAutorotate: Bool {
        return true
    }

}
