//
//  MenuViewController.swift
//  Aston-Coursework
//
//  Created by A&M on 05/01/2020.
//  Copyright © 2020 16052488. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    /* Interface Builder: Outlets/Actions */

    @IBOutlet weak var playButton: UIButton!
    @IBAction func playButtonPressed(_ sender: Any) {
        audioPlayer3?.stop()
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "Main") as! ViewController
        vc.dismiss(animated: false, completion: nil)
        vc.selectLevel(level: 1)
        self.present(vc, animated: false, completion: nil)
    }
    @IBOutlet weak var howToPlayButton: UIButton!
    @IBAction func howToPlayPressed(_ sender: Any) {
        //displayHowToPlayView()
    }
    @IBOutlet weak var quitButton: UIButton!
    @IBAction func quitPressed(_ sender: Any) {
        exit(-1)
    }
    
    let menuUI = UIImageView(image: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "Main") as! ViewController
        vc.dismiss(animated: false, completion: nil)
        initialiseUI()
        playMenuMusic()
        
        // Orientation initialisation
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    func initialiseUI() {

        menuUI.frame = CGRect(x: 0, y: 0, width: screenWidth + maxNotch, height: screenHeight)
        menuUI.backgroundColor = UIColor.darkGray
        self.view.addSubview(menuUI)
        
        initialiseGameLogo()
        initialiseStartButton()
        initialiseHowToPlayButton()
        initialiseQuitButton()
        initialiseCreditsLabel()
        
        self.view.sendSubviewToBack(menuUI)
    }
    
    func initialiseGameLogo() {
        let gameLogo = UIImageView(image: nil)
        gameLogo.backgroundColor = UIColor.green
        gameLogo.frame = CGRect(x:0, y: (screenHeight/8), width: (screenWidth+maxNotch)/2, height: (screenHeight/8)*2)
        gameLogo.center.x = menuUI.center.x
        
        self.view.addSubview(gameLogo)
    }
    
    func initialiseStartButton() {
        playButton.backgroundColor = UIColor.systemPink
        playButton.frame = CGRect(x:0, y: (screenHeight/8)*3, width: (screenWidth+maxNotch)/4, height: screenHeight/8)
        playButton.center.x = menuUI.center.x
    }
    
    func initialiseHowToPlayButton() {
        howToPlayButton.backgroundColor = UIColor.purple
        howToPlayButton.frame = CGRect(x:0, y: (screenHeight/8)*4, width: (screenWidth+maxNotch)/4, height: screenHeight/8)
        howToPlayButton.center.x = menuUI.center.x
    }
    
    func initialiseQuitButton() {
        quitButton.backgroundColor = UIColor.green
        quitButton.frame = CGRect(x:0, y: (screenHeight/8)*5, width: (screenWidth+maxNotch)/4, height: screenHeight/8)
        quitButton.center.x = menuUI.center.x
    }
    
    func initialiseCreditsLabel() {
        let creditsLabel = UILabel()
        creditsLabel.backgroundColor = UIColor.blue
        creditsLabel.frame = CGRect(x:screenWidth - (screenWidth+maxNotch)/2, y: (screenHeight/8)*7, width: (screenWidth+maxNotch)/2, height: screenHeight/8)
        creditsLabel.textAlignment = .right
        creditsLabel.text = "Developed by Aston Turner"
        
        
        self.view.addSubview(creditsLabel)
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
