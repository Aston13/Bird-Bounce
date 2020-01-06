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
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "Main") as! ViewController
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialiseUI()
        
        // Orientation initialisation
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    func initialiseUI() {
        initialiseStartButton()
        initialiseHowToPlayButton()
        initialiseQuitButton()
    }
    
    func initialiseStartButton() {
        playButton.backgroundColor = UIColor.systemPink
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        playButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func initialiseHowToPlayButton() {
        howToPlayButton.backgroundColor = UIColor.purple
        
        howToPlayButton.translatesAutoresizingMaskIntoConstraints = false
        let centerXConstraint = NSLayoutConstraint(item: howToPlayButton!, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        let centerYConstraint = NSLayoutConstraint(item: howToPlayButton!, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.2, constant: 0.0)
        NSLayoutConstraint.activate([centerXConstraint, centerYConstraint])
    }
    
    func initialiseQuitButton() {
        quitButton.backgroundColor = UIColor.green
        
        quitButton.translatesAutoresizingMaskIntoConstraints = false
        let centerXConstraint = NSLayoutConstraint(item: quitButton!, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        let centerYConstraint = NSLayoutConstraint(item: quitButton!, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.4, constant: 0.0)
        NSLayoutConstraint.activate([centerXConstraint, centerYConstraint])
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
