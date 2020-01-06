//
//  CompleteViewController.swift
//  Aston-Coursework
//
//  Created by A&M on 05/01/2020.
//  Copyright © 2020 16052488. All rights reserved.
//

import UIKit

class CompleteViewController: UIViewController {

    /* Interface Builder: Outlets/Actions */
    @IBOutlet weak var mainMenuButton: UIButton!
    
//    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Main") as! ViewController
//    
//    // Reset game variables
//    totalScore = 0
//    levelNum = levelNum + 1
//    birdTimer?.invalidate()
//    gameTimer?.invalidate()
//    
//    // Level selection
//    if levelNum == 2 {
//        goalScore = 4
//        gameTime = 40
//        self.present(vc, animated: false, completion: nil)
    
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
