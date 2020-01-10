//
//  MenuViewController.swift
//  Aston-Coursework
//
//  Created by A&M on 05/01/2020.
//  Copyright © 2020 16052488. All rights reserved.
//
var menuViewControllerInstance = MenuViewController()
import UIKit
import CoreData
var timeRemaining = 0
var playerName: String?
let creditsLabel = UILabel()
var lastScoreText: String?

class MenuViewController: UIViewController, UITextFieldDelegate {
    let enterName = UITextField()
    /* Interface Builder: Outlets/Actions */
    @IBOutlet weak var resetScoresButton: UIButton!
    @IBAction func resetScoresButtonPressed(_ sender: Any) {
        deleteScoreData()
        if lastScore == 0 {
            lastScoreText = "Nothing set yet"
        } else {
            lastScoreText = String(lastScore)
        }
        
        creditsLabel.text = "Scores\n\nLast Score: \(lastScoreText ?? "Nothing set yet")\nHighscore: Nothing set yet\n\nDeveloped by Aston Turner"
    }
    @IBOutlet weak var playButton: UIButton!
    @IBAction func playButtonPressed(_ sender: Any) {
        
        if enterName.hasText == false {
            enterName.layer.borderColor = UIColor.red.cgColor
        } else {
            playerName = enterName.text
            audioPlayer3?.stop()
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "Main") as! ViewController
            vc.dismiss(animated: false, completion: nil)
            vc.selectLevel(level: 1)
            self.present(vc, animated: false, completion: nil)
        }
        
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
        
        let fetchRequest: NSFetchRequest<Score> = Score.fetchRequest()
        
        do {
            let scoresFetch = try PersistenceService.context.fetch(fetchRequest)
            scores = scoresFetch
        } catch {
            print(error)
        }
        
        menuDynamicAnimator = UIDynamicAnimator(referenceView: self.view)
        
        self.enterName.delegate = self
        menuViewControllerInstance = self
        initialiseUI()
        playMenuMusic()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        addStars()
    }
    
    func initialiseUI() {

        menuUI.frame = CGRect(x: 0, y: 0, width: screenWidth + maxNotch, height: screenHeight)
        menuUI.backgroundColor = UIColor.black
        menuUI.image = UIImage(named: "menuBackground")
        self.view.addSubview(menuUI)
        
        initialiseGameLogo()
        initialiseEnterName()
        initialiseStartButton()
        initialiseCreditsButton()
        initialiseQuitButton()
        initialiseCloseButton()
        initialiseCreditsLabel()
        initialiseResetScoresButton()
        
        self.view.sendSubviewToBack(menuUI)
    }
    
    func initialiseGameLogo() {
        let gameLogoHeight = (screenHeight/8)*2.5
        let gameLogo = UIImageView(image: nil)
        gameLogo.frame = CGRect(x:0, y: (screenHeight/20), width: gameLogoHeight*4.5, height: gameLogoHeight)
        gameLogo.center.x = menuUI.center.x
        gameLogo.image = UIImage(named: "birdBounce")
        
        self.view.addSubview(gameLogo)
    }
    
    func initialiseEnterName() {
        enterName.layer.cornerRadius = 5
        enterName.layer.borderWidth = 2
        enterName.layer.borderColor = UIColor.lightGray.cgColor
        enterName.backgroundColor = UIColor.lightGray
        enterName.textAlignment = .center
        enterName.placeholder = "Enter Name"
        enterName.keyboardType = .asciiCapable
        enterName.frame = CGRect(x:0, y: (screenHeight/8)*3, width: (screenWidth+maxNotch)/2.75, height: screenHeight/8)
        enterName.center.x = menuUI.center.x
        self.view.addSubview(enterName)
    }
    
    func initialiseStartButton() {
        playButton.layer.cornerRadius = 5
        playButton.layer.borderWidth = 1
        playButton.layer.borderColor = UIColor.lightGray.cgColor
        
        playButton.frame = CGRect(x:0, y: 1+(screenHeight/8)*4, width: (screenWidth+maxNotch)/5.5, height: screenHeight/8)
        playButton.center.x = menuUI.center.x
        playButton.setBackgroundImage(UIImage(named:"Play"), for: .normal)
        playButton.setTitle(nil, for: .normal)
    }
    
    func initialiseCreditsButton() {
        creditsButton.layer.cornerRadius = 5
        creditsButton.layer.borderWidth = 1
        creditsButton.layer.borderColor = UIColor.lightGray.cgColor
        
        creditsButton.frame = CGRect(x:0, y: 2+(screenHeight/8)*5, width: (screenWidth+maxNotch)/5.5, height: screenHeight/8)
        creditsButton.center.x = menuUI.center.x
        creditsButton.setBackgroundImage(UIImage(named:"Credits"), for: .normal)
        creditsButton.setTitle(nil, for: .normal)
        
        
    }
    
    func initialiseCloseButton(){
        closeButton.frame = CGRect(x: (screenWidth+maxNotch)*0.07, y: screenHeight*0.07, width: 30, height: 30)
        closeButton.setBackgroundImage(UIImage(named:"close"), for: .normal)
        closeButton.isHidden = true
    }
    
    func initialiseQuitButton() {
        quitButton.layer.cornerRadius = 5
        quitButton.layer.borderWidth = 1
        quitButton.layer.borderColor = UIColor.lightGray.cgColor
        
        quitButton.frame = CGRect(x:0, y: 3+(screenHeight/8)*6, width: (screenWidth+maxNotch)/5.5, height: screenHeight/8)
        quitButton.center.x = menuUI.center.x
        quitButton.setBackgroundImage(UIImage(named:"Quit"), for: .normal)
        quitButton.setTitle(nil, for: .normal)
    }
    
    func initialiseCreditsLabel() {
        creditsLabel.frame = CGRect(x:screenWidth - (screenWidth+maxNotch)/2.8, y: (screenHeight/8)*5.5, width: (screenWidth+maxNotch)/2.8, height: (screenHeight/8)*2.5)
        creditsLabel.textAlignment = .right
        creditsLabel.textColor = UIColor.white
        
        if lastScore == 0 {
            lastScoreText = "Nothing set yet"
        } else {
            lastScoreText = String(lastScore)
        }
        
        creditsLabel.text = "Scores\n\nLast Score: \(lastScoreText ?? "Nothing set yet")\n\(getHighScore())\n\nDeveloped by Aston Turner"
        creditsLabel.adjustsFontSizeToFitWidth = true
        creditsLabel.numberOfLines = 6
        self.view.addSubview(creditsLabel)
    }
    
    func initialiseResetScoresButton() {
        resetScoresButton.setTitle("Reset Highscore", for: .normal)
        resetScoresButton.setTitleColor(UIColor.systemBlue, for: .normal)
        resetScoresButton.frame = CGRect(x:screenWidth - (screenWidth+maxNotch)/7.5, y: (screenHeight/2), width: (screenWidth+maxNotch)/7.5, height: (screenHeight/8))
        resetScoresButton.layer.borderColor = UIColor.lightGray.cgColor
        resetScoresButton.center.y = self.view.center.y
        resetScoresButton.layer.borderWidth = 1
        resetScoresButton.layer.cornerRadius = 5
        resetScoresButton.titleLabel?.adjustsFontSizeToFitWidth = true
        self.view.addSubview(resetScoresButton)
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
        Menu Background by Siripoom© https://pixabay.com/photos/star-background-night-dark-4246461/\n
        In-Game Backgrounds by CraftPix© https://craftpix.net/freebies/free-horizontal-2d-game-backgrounds/\n
        Red Crosshair (redAim) by Aris Katsaris© https://en.m.wikipedia.org/wiki/File:Crosshairs_Red.svg\n
        Ball by Vexels©\n
        
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
    
    /* Functions to hide keyboard after use */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    /* Deletes (resets) all data from the Score CoreData entity */
    func deleteScoreData() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Score")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try PersistenceService.context.execute(deleteRequest)
            print("SCORES DELETED")
        } catch let error as NSError {
            print(error)
        }
    }
}
