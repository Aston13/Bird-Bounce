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
    @IBOutlet weak var replayButton: UIButton!
    @IBAction func replayButtonPressed(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "Main") as! ViewController
        vc.selectLevel(level: 1)
        self.present(vc, animated: false, completion: nil)
    }

    let completeUI = UIImageView(image: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        initialiseUI()
        playWinSound()
    
        // Orientation initialisation
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    func initialiseUI() {

        completeUI.frame = CGRect(x: 0, y: 0, width: screenWidth + maxNotch, height: screenHeight)
        completeUI.backgroundColor = UIColor.darkGray
        self.view.addSubview(completeUI)
        
        initialiseGameCompletedLogo()
        initialiseReplayButton()
        initialiseMainMenuButton()

        self.view.sendSubviewToBack(completeUI)
    }
    
    func initialiseGameCompletedLogo(){
        let gameCompletedLogo = UIImageView(image: nil)
        gameCompletedLogo.backgroundColor = UIColor.green
        gameCompletedLogo.frame = CGRect(x:0, y: (screenHeight/8), width: (screenWidth+maxNotch)/2, height: (screenHeight/8)*2)
        gameCompletedLogo.center.x = completeUI.center.x
        
        self.view.addSubview(gameCompletedLogo)
    }
    
    func initialiseReplayButton(){
        replayButton.backgroundColor = UIColor.systemYellow
        replayButton.frame = CGRect(x:0, y: (screenHeight/8)*4, width: (screenWidth+maxNotch)/4, height: screenHeight/8)
        replayButton.center.x = completeUI.center.x
    }
    
    func initialiseMainMenuButton(){
        mainMenuButton.backgroundColor = UIColor.systemYellow
        mainMenuButton.frame = CGRect(x:0, y: (screenHeight/8)*5, width: (screenWidth+maxNotch)/4, height: screenHeight/8)
        mainMenuButton.center.x = completeUI.center.x
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
