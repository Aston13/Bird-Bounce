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
        completeUI.backgroundColor = UIColor.black
        completeUI.image = UIImage(named: "menuBackground")
        self.view.addSubview(completeUI)
        
        initialiseGameCompletedLogo()
        initialiseReplayButton()
        initialiseMainMenuButton()

        self.view.sendSubviewToBack(completeUI)
    }
    
    func initialiseGameCompletedLogo(){
        let completeLogoHeight = (screenHeight/8)*2.5
        let gameCompletedLogo = UIImageView(image: nil)
        gameCompletedLogo.frame = CGRect(x:0, y: (screenHeight/8), width: completeLogoHeight*5.5, height: completeLogoHeight)
        gameCompletedLogo.center.x = completeUI.center.x

        gameCompletedLogo.image = UIImage(named:"gameComplete")
        
        
        self.view.addSubview(gameCompletedLogo)
    }
    
    func initialiseReplayButton(){
        replayButton.frame = CGRect(x:0, y: (screenHeight/8)*4, width: (screenWidth+maxNotch)/5.5, height: screenHeight/8)
        replayButton.center.x = completeUI.center.x
        
        replayButton.layer.cornerRadius = 5
        replayButton.layer.borderWidth = 1
        replayButton.layer.borderColor = UIColor.lightGray.cgColor
        replayButton.setBackgroundImage(UIImage(named:"Replay"), for: .normal)
        replayButton.setTitle(nil, for: .normal)
    }
    
    func initialiseMainMenuButton(){
        mainMenuButton.frame = CGRect(x:0, y: (screenHeight/8)*5, width: (screenWidth+maxNotch)/5.5, height: screenHeight/8)
        mainMenuButton.center.x = completeUI.center.x
        
        mainMenuButton.layer.cornerRadius = 5
        mainMenuButton.layer.borderWidth = 1
        mainMenuButton.layer.borderColor = UIColor.lightGray.cgColor
        mainMenuButton.setBackgroundImage(UIImage(named:"Menu"), for: .normal)
        mainMenuButton.setTitle(nil, for: .normal)
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
