//
//  CompleteViewController.swift
//  Aston-Coursework
//
//  Created by A&M on 05/01/2020.
//  Copyright © 2020 16052488. All rights reserved.
//

import UIKit
import CoreData

var scores = [Score]()
var lastScore = 0

class CompleteViewController: UIViewController {

    /* Interface Builder: Outlets/Actions */
    @IBOutlet weak var scoresLabel: UILabel!
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
        lastScore = timeRemaining
        saveScore()
        initialiseUI()
        playWinSound()
        
    }
    

    
    func saveScore(){
        let player = Score(context: PersistenceService.context)
        player.name = playerName
        player.score = Int16(timeRemaining)
        PersistenceService.saveContext()
        scores.append(player)
    }
    
    
    func initialiseScores(){
        scoresLabel.frame = CGRect(x:0, y: (screenHeight/8)*5, width: (screenWidth+maxNotch), height: (screenHeight/8)*3)
        scoresLabel.center.x = completeUI.center.x
        scoresLabel.textAlignment = .center
        scoresLabel.textColor = UIColor.white
        scoresLabel.text = "Scores (Total Time Remaining over 3 Levels)\n\n\(getPlayerScore())\n\(getHighScore())"
        scoresLabel.numberOfLines = 0
        self.view.addSubview(scoresLabel)
    }
    
    public func getPlayerScore() -> (String){
        let playerScoreStr: String = "Your Score: " + String(timeRemaining) + " (" + playerName! + ")"
        return playerScoreStr
    }
    
    func initialiseUI() {

        completeUI.frame = CGRect(x: 0, y: 0, width: screenWidth + maxNotch, height: screenHeight)
        completeUI.backgroundColor = UIColor.black
        completeUI.image = UIImage(named: "menuBackground")
        self.view.addSubview(completeUI)
        
        initialiseGameCompletedLogo()
        initialiseReplayButton()
        initialiseMainMenuButton()
        initialiseScores()

        self.view.sendSubviewToBack(completeUI)
    }
    
    func initialiseGameCompletedLogo(){
        let completeLogoHeight = (screenHeight/8)*2.5
        let gameCompletedLogo = UIImageView(image: nil)
        gameCompletedLogo.frame = CGRect(x:0, y: (screenHeight/14), width: completeLogoHeight*5.5, height: completeLogoHeight)
        gameCompletedLogo.center.x = completeUI.center.x

        gameCompletedLogo.image = UIImage(named:"gameComplete")
        
        
        self.view.addSubview(gameCompletedLogo)
    }
    
    func initialiseReplayButton(){
        replayButton.frame = CGRect(x:0, y: (screenHeight/8)*3, width: (screenWidth+maxNotch)/5.5, height: screenHeight/8)
        replayButton.center.x = completeUI.center.x
        
        replayButton.layer.cornerRadius = 5
        replayButton.layer.borderWidth = 1
        replayButton.layer.borderColor = UIColor.lightGray.cgColor
        replayButton.setBackgroundImage(UIImage(named:"Replay"), for: .normal)
        replayButton.setTitle(nil, for: .normal)
    }
    
    func initialiseMainMenuButton(){
        mainMenuButton.frame = CGRect(x:0, y: (screenHeight/8)*4, width: (screenWidth+maxNotch)/5.5, height: screenHeight/8)
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

public func getHighScore() -> (String){
    var highscoreVal = 0
    var highscoreNameStr = ""
    var count = 0
    
    for _ in scores {
        if scores[count].score > highscoreVal {
            highscoreVal = Int(scores[count].score)
            highscoreNameStr = scores[count].name!
        }
        count+=1
    }
    if highscoreVal == 0 {
        return "Highscore: Nothing set yet"
    } else {
        let highscoreStr: String = "Highscore: " + String(highscoreVal) + " seconds set by " + highscoreNameStr
        return highscoreStr
    }
}

