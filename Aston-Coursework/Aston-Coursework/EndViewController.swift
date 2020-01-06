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
    @IBAction func replayButtonPressed(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "Main") as! ViewController
        vc.dismiss(animated: false, completion: nil)
        vc.selectLevel(level: 1)
        self.present(vc, animated: false, completion: nil)
    }
    
    let gameOverUI = UIImageView(image: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialiseUI()

        // Orientation initialisation
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    func initialiseUI() {

        gameOverUI.frame = CGRect(x: 0, y: 0, width: screenWidth + maxNotch, height: screenHeight)
        gameOverUI.backgroundColor = UIColor.darkGray
        self.view.addSubview(gameOverUI)
        
        initialiseGameOverLogo()
        initialiseReplayButton()
        initialiseMainMenuButton()

        self.view.sendSubviewToBack(gameOverUI)
    }
    
    func initialiseGameOverLogo(){
        let gameOverLogo = UIImageView(image: nil)
        gameOverLogo.backgroundColor = UIColor.green
        gameOverLogo.frame = CGRect(x:0, y: (screenHeight/8), width: (screenWidth+maxNotch)/2, height: (screenHeight/8)*2)
        gameOverLogo.center.x = gameOverUI.center.x
        
        self.view.addSubview(gameOverLogo)
    }
    
    func initialiseReplayButton(){
        replayButton.backgroundColor = UIColor.systemPink
        replayButton.frame = CGRect(x:0, y: (screenHeight/8)*4, width: (screenWidth+maxNotch)/4, height: screenHeight/8)
        replayButton.center.x = gameOverUI.center.x
    }
    
    func initialiseMainMenuButton(){
        mainMenuButton.backgroundColor = UIColor.systemPink
        mainMenuButton.frame = CGRect(x:0, y: (screenHeight/8)*5, width: (screenWidth+maxNotch)/4, height: screenHeight/8)
        mainMenuButton.center.x = gameOverUI.center.x
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
