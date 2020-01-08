//
//  MenuViewController.swift
//  Aston-Coursework
//
//  Created by A&M on 05/01/2020.
//  Copyright © 2020 16052488. All rights reserved.
//
var menuViewControllerInstance = MenuViewController()
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

    @IBOutlet weak var creditsButton: UIButton!
    @IBAction func creditsButtonPressed(_ sender: Any) {
        showCreditsPop()
    }
    
    
    @IBOutlet weak var quitButton: UIButton!
    @IBAction func quitPressed(_ sender: Any) {
        exit(-1)
    }
    
    
    @IBOutlet weak var closeButton: UIButton!
    @IBAction func closeButtonPressed(_ sender: Any) {
        creditsView.isHidden = true
        closeButton.isHidden = true
    }
    
    
    
    
    let creditsFrame = CGRect(x: (screenWidth+maxNotch)*0.05, y: screenHeight*0.05, width: (screenWidth+maxNotch)*0.9, height: screenHeight*0.9)
    let creditsView = UITextView()
    let menuUI = UIImageView(image: nil)
    var menuDynamicAnimator: UIDynamicAnimator!
    var menuDynamicBehavior: UIDynamicItemBehavior!
    let star1 = UIImageView(image: nil)
    let star2 = UIImageView(image: nil)
    let star3 = UIImageView(image: nil)
    let star4 = UIImageView(image: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "Main") as! ViewController
        vc.dismiss(animated: false, completion: nil)
        
        
        menuDynamicAnimator = UIDynamicAnimator(referenceView: self.view)
        
        
        menuViewControllerInstance = self
        initialiseUI()
        playMenuMusic()
        
        
        // Orientation initialisation
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        addStars()
    }
    
    func initialiseUI() {

        menuUI.frame = CGRect(x: 0, y: 0, width: screenWidth + maxNotch, height: screenHeight)
        menuUI.backgroundColor = UIColor.black
        self.view.addSubview(menuUI)
        
        initialiseGameLogo()
        initialiseStartButton()
        initialiseCreditsButton()
        initialiseQuitButton()
        initialiseCloseButton()
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
    
    func initialiseCreditsButton() {
        creditsButton.backgroundColor = UIColor.purple
        creditsButton.frame = CGRect(x:0, y: (screenHeight/8)*4, width: (screenWidth+maxNotch)/4, height: screenHeight/8)
        creditsButton.center.x = menuUI.center.x
        
    }
    
    func initialiseCloseButton(){
        closeButton.frame = CGRect(x: (screenWidth+maxNotch)*0.07, y: screenHeight*0.07, width: 30, height: 30)
        closeButton.setBackgroundImage(UIImage(named:"close"), for: .normal)
        closeButton.isHidden = true
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
    
    
    private func addStars() {
        star1.image = UIImage(named: "star")
        star1.frame = CGRect(x:screenWidth/12, y:screenHeight/5, width: 20, height: 20)
        self.view.addSubview(star1)
        
        
        star2.image = UIImage(named: "star")
        star2.frame = CGRect(x:screenWidth/10, y: (screenHeight*3)/5, width: 20, height: 20)
        self.view.addSubview(star2)
        
        
        star3.image = UIImage(named: "star")
        star3.frame = CGRect(x:(screenWidth*3)/4, y:screenHeight/2, width: 20, height: 20)
        self.view.addSubview(star3)
        
        star4.image = UIImage(named: "star")
        star4.frame = CGRect(x:(screenWidth*3.5)/4, y:screenHeight/3, width: 20, height: 20)
        self.view.addSubview(star4)
        
      let settings: UIView.AnimationOptions = [.curveEaseInOut,
                                              .repeat,
                                              .autoreverse]
      
      UIView.animate(withDuration: 1.1,
                     delay: 0.2,
                     options: settings,
                     animations: { [weak self] in
                      self?.star1.frame.size.height *= 1.35
                      self?.star1.frame.size.width *= 1.35
      }, completion: nil)
      
      UIView.animate(withDuration: 1.4,
                     delay: 0.15,
                     options: settings,
                     animations: { [weak self] in
                      self?.star2.frame.size.height *= 1.3
                      self?.star2.frame.size.width *= 1.3
      }, completion: nil)
      
        UIView.animate(withDuration: 1.0,
                     delay: 0.25,
                     options: settings,
                     animations: { [weak self] in
                      self?.star3.frame.size.height *= 1.25
                      self?.star3.frame.size.width *= 1.25
      }, completion: nil)
        
        UIView.animate(withDuration: 1.2,
                       delay: 0.22,
                       options: settings,
                       animations: { [weak self] in
                        self?.star4.frame.size.height *= 1.2
                        self?.star4.frame.size.width *= 1.2
        }, completion: nil)
        
    }
    
    private func showCreditsPop() {
        creditsView.frame = creditsFrame
        creditsView.textContainerInset = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
        view.addSubview(creditsView)
        view.addSubview(closeButton)
        creditsView.textAlignment = .center
        creditsView.textColor = UIColor.lightGray
        creditsView.isEditable = false
        
        creditsView.text =
        """
        Credits
        
        
        Audio\n
        
        Death Sound (boing.wav) by https://freesound.org/people/davidou/©\n
        Shooting Sound (shot.wav) by Mattias "MATTIX" Lahoud©\n
        Menu Music (menu.wav) by https://freesound.org/people/wi-photos/©\n
        Win Sound (win.mp3) by https://freesound.org/people/mickleness/©\n
        Loss Sound (loss.wave) by https://freesound.org/people/themusicalnomad/©\n
        
        Visual\n
        
        Explosion /ExplosionFrames by Sinestesia© https://opengameart.org/content/2d-explosion-animations-frame-by-frame\n
        Stone Texture (stoneTexture) by Daniel Smith© https://www.publicdomainpictures.net/pictures/70000/velka/stone-texture-i.jpg\n
        Close Button (close) by Molumen© http://www.freestockphotos.biz/stockphoto/15107\n
        
        """
        creditsView.backgroundColor = UIColor.darkGray
        creditsView.isHidden = false
        closeButton.isHidden = false
        view.bringSubviewToFront(closeButton)
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
