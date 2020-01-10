//
//  ViewController.swift
//  Aston-Coursework
//
//  Created by Aston on 09/12/2019.
//  Copyright © 2019 16052488. All rights reserved.
//

import UIKit

/* Global variables */
/* Dimensions */
let maxNotch: CGFloat = 35 // Maximum thickness of the notch area on an iPhone
var screenWidth = UIScreen.main.bounds.width - maxNotch // Overall screen width - not including notch
var screenHeight = UIScreen.main.bounds.height
let crosshairSize: CGFloat = 50 // Crosshair size - square - even x and y dimensions
var crosshairVectorXY = CGPoint(x:0,y:0) // Vector used to store and retrieve the angle of the shot fired
let birdSize: CGFloat = (screenHeight-55)/5
var ballSize: CGFloat! // Ball size - square - even x and y dimensions

/* Time and game configurations */
var gameTime: TimeInterval = 0
var goalScore: Int = 3
var gameInProgress: Bool = true;
var levelNum = 0
var birdTimer: Timer?
var gameTimer: Timer?

//View Controller reference for AnimationController
var mainViewControllerInstance = ViewController()

/* 5 possible bird co-ordinate positions TR -> BR */
let positionsArray: [CGRect] = [
    CGRect(x:(screenWidth - maxNotch) - (birdSize/2 + 5), y: 30, width: birdSize, height: birdSize),
    CGRect(x:(screenWidth - maxNotch) - (birdSize/2 + 5), y: 35 + birdSize, width: birdSize, height: birdSize),
    CGRect(x:(screenWidth - maxNotch) - (birdSize/2 + 5), y: 40 + (birdSize*2), width: birdSize, height: birdSize),
    CGRect(x:(screenWidth - maxNotch) - (birdSize/2 + 5), y: 45 + (birdSize*3), width: birdSize, height: birdSize),
    CGRect(x:(screenWidth - maxNotch) - (birdSize/2 + 5), y: 50 + (birdSize*4), width: birdSize, height: birdSize)]

/* Protocols for delegated functions */
protocol ballViewDelegate {
    func shoot()
}

/*
 * ViewController Class Main
 */
class ViewController: UIViewController, ballViewDelegate {

    /* Interface Builder: Outlets/Actions */
    @IBOutlet weak var nextLevelButton: UIButton!
    @IBAction func nextLevelButtonPressed(_ sender: Any) {
        gameItems.removeAll()
        nextLevelButton.isHidden = true
        selectLevel(level: levelNum+1)
    }
    @IBOutlet weak var crosshairImageView: DragImageView! // Crosshair image outlet reference
    
    /* Game items storage */
    var shotBall = UIImageView(image: nil)
    var gameItems = [UIImageView]() // Collection of ball and obtacle items

    /* Bird storage */
    var bird = UIImageView(image:nil)
    var birds = [UIImageView]()
    var birdPositions: [Int] = [0,0,0,0,0] // Bird position slots TR -> BR. 0 = Empty. 1 = Occupied.
    
    /* UI */
    var uiBar = UIImageView()
    let scoreLabel = UILabel()
    var totalScore: Int = 0
    let timeLabel = UILabel()
    let backgroundFrame = UIImageView(image: nil)
    
    /* Behavioural variables */
    var dynamicAnimator: UIDynamicAnimator! // Physics Engine
    var dynamicBehavior: UIDynamicItemBehavior!
    var collisionBehavior: UICollisionBehavior!
    var gravityBehavior: UIGravityBehavior!
    
    /*
     * Setup
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        mainViewControllerInstance = self
        stopAllAnimations = false
        // Passes the main view to dynamics as the reference view
        dynamicAnimator = UIDynamicAnimator(referenceView: self.view)
        
        // Checks every x seconds and adds a random bird to a random empty slot
        birdTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {_ in
            if (gameInProgress) {
                self.checkEmptyBirdPositions()
                self.updateTimeLabel()
            }
        })
        
        // Timer until game is over
        gameTimer = Timer.scheduledTimer(withTimeInterval: gameTime, repeats: false, block:{_ in
            self.gameOver()
        })

        crosshairImageView.myBallDelegate = self
        initialiseUI()
    }
    
    /* Function to force orientation to landscape. */
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    /* Function to allow autorotate of orientation. */
    override var shouldAutorotate: Bool {
        return true
    }
    
    func gameOver() {
        
        // gameInProgress check ensures that the game isn't paused or in a transition screen
        if (gameInProgress) {
            gameItems.removeAll()
            stopAllAnimations = true
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "endGame") as! EndViewController
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    func gameWon() {
        gameItems.removeAll()
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "completeGame") as! CompleteViewController
        self.present(vc, animated: false, completion: nil)
    }
    
    func levelWon() {
        
        let nextLevelScreen = UIImageView()
        nextLevelScreen.frame = CGRect(x: 0, y: 0, width: screenWidth + maxNotch, height: screenHeight)
        nextLevelScreen.backgroundColor = UIColor.black
        nextLevelScreen.image = UIImage(named: "menuBackground")
        gameInProgress = false
   
        self.view.addSubview(nextLevelScreen)
        nextLevelButton.isHidden = false
        crosshairImageView.removeFromSuperview()
        self.view.bringSubviewToFront(nextLevelButton)
    }
    
    /* Resets game state and loads new settings based on the level. Only three levels currently exist.
     * In future, a function could be made to automatically increase variables based on level number.
     */
    func selectLevel(level: Int) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Main") as! ViewController
        
        // Reset game variables
        totalScore = 0
        levelNum = level
        birdTimer?.invalidate()
        gameTimer?.invalidate()
        
        // Level selection
        if levelNum == 1 {
            timeRemaining = 0
            goalScore = 3
            gameTime = 30
            ballSize = 50
            backgroundFrame.image = (UIImage(named: "gameBackground1"))
            self.present(vc, animated: false, completion: nil)
            gameInProgress = true
        } else if levelNum == 2 {
            timeRemaining += Int(gameTime)
            goalScore = 6
            gameTime = 40
            ballSize = 50
            self.present(vc, animated: false, completion: nil)
            gameInProgress = true
            vc.addRandomObstacle()
            vc.backgroundFrame.image = (UIImage(named: "gameBackground2"))
        } else if levelNum == 3 {
            timeRemaining += Int(gameTime)
            goalScore = 9
            gameTime = 50
            ballSize = 30
            self.present(vc, animated: false, completion: nil)
            gameInProgress = true
            vc.addRandomObstacle()
            vc.addRandomObstacle()
            vc.backgroundFrame.image = (UIImage(named: "gameBackground4"))
        }
    }
    
    /* Creates an obstacle of a random size and position (within a range),
     * the obstacle is given behaviours and added to gameItems[] and the subview.
     */
    func addRandomObstacle() {
        let obstacle = UIImageView(image: nil)
        let rangeXMin: Int = Int(screenWidth/4)
        
        /* Biggest size allowed per obstacle is half the screen size -ballSize*2,
         * to always allow enough space for a ball to pass between two obstacles
         */
        let randomWH: Int = Int.random(in: 40...(Int(screenHeight/2) - Int(ballSize*2)))
        let rangeXMax: Int = Int(screenWidth-birdSize)-(randomWH*2)
        let rangeYMax: Int = Int(screenHeight)-randomWH
        let randomY: Int = Int.random(in: 25...rangeYMax)
        let randomX: Int = Int.random(in: rangeXMin...rangeXMax)
        
        // Create obstacle
        obstacle.frame = CGRect(x:randomX,y:randomY,width:randomWH,height:randomWH)
        obstacle.image = UIImage(named: "stoneTexture")
        obstacle.layer.borderWidth = 2
        obstacle.layer.borderColor = UIColor.darkGray.cgColor
        self.view.addSubview(obstacle)
        gameItems.append(obstacle)
        
        // Behaviours
        dynamicBehavior = UIDynamicItemBehavior(items: [obstacle])
        self.dynamicBehavior.isAnchored = true // Fixed position
        dynamicAnimator.addBehavior(dynamicBehavior)

        collisionBehavior = UICollisionBehavior(items: [obstacle])
        dynamicAnimator.addBehavior(collisionBehavior) // Add collision to animator
    }
    

    
    func initialiseUI() {
        let uiBarWidth: CGFloat = (screenWidth + maxNotch)
        let uiBarItemAmount: CGFloat = 3;
        backgroundFrame.frame = CGRect(x:0, y:0, width: screenWidth + maxNotch, height: screenHeight)
        
        self.view.addSubview(backgroundFrame)
        self.view.sendSubviewToBack(backgroundFrame)
        uiBar.image = UIImage(named:"menuBackground")
        uiBar.frame = CGRect(x:0, y:-1, width: uiBarWidth, height: 26)
        uiBar.backgroundColor = UIColor.darkGray
        
        uiBar.layer.borderWidth = 1
        uiBar.layer.borderColor = UIColor.lightGray.cgColor
        uiBar.layer.cornerRadius = 5
        self.view.addSubview(uiBar)
        
        initialiseCrosshair()
        initialiseScoreLabel(scaledWidth: uiBarWidth, amount: uiBarItemAmount)
        initialiseTimeLabel(scaledWidth: uiBarWidth, amount: uiBarItemAmount)
        initialiseLevelLabel(scaledWidth: uiBarWidth, amount: uiBarItemAmount)
        initialiseNextLevelButton()
    }
    
    func initialiseScoreLabel(scaledWidth: CGFloat, amount: CGFloat) {
        scoreLabel.frame = CGRect(x:maxNotch, y: 0, width: scaledWidth/amount, height: 25)
        scoreLabel.textAlignment = NSTextAlignment.center
        scoreLabel.textColor = UIColor.white
        scoreLabel.text = "Score: \(totalScore)/\(goalScore)"
        self.view.addSubview(scoreLabel)
    }
    
    func initialiseTimeLabel(scaledWidth: CGFloat, amount: CGFloat) {
        timeLabel.frame = CGRect(x:maxNotch + (screenWidth/3), y: 0, width: (scaledWidth/amount), height: 25)
        timeLabel.textAlignment = NSTextAlignment.center
        timeLabel.textColor = UIColor.white
        timeLabel.text = "Time Remaining: \(Int(gameTime))"
        self.view.addSubview(timeLabel)
    }
    
    func initialiseLevelLabel(scaledWidth: CGFloat, amount: CGFloat) {
        let levelLabel = UILabel()
        levelLabel.frame = CGRect(x:maxNotch + (screenWidth/3)*2, y: 0, width: (scaledWidth/amount), height: 25)
        levelLabel.textAlignment = NSTextAlignment.center
        levelLabel.textColor = UIColor.white
        levelLabel.text = "Level: \(levelNum)"
        self.view.addSubview(levelLabel)
    }
    
    func initialiseNextLevelButton(){
        nextLevelButton.frame = CGRect(x:0, y: 0, width: (screenWidth+maxNotch)/4, height: screenHeight/8)
        nextLevelButton.center.x = (screenWidth+maxNotch)/2
        nextLevelButton.center.y = (screenHeight/2)
        
        nextLevelButton.layer.cornerRadius = 5
        nextLevelButton.layer.borderWidth = 1
        nextLevelButton.layer.borderColor = UIColor.lightGray.cgColor
        nextLevelButton.setBackgroundImage(UIImage(named:"nextLevel"), for: .normal)
        nextLevelButton.setTitle(nil, for: .normal)
    }
    
    func updateTimeLabel() {
        gameTime = gameTime - 1
        timeLabel.text = "Time Remaining: \(Int(gameTime))"
    }
    
    func increaseScore(score:Int) {
        totalScore = totalScore + score
        scoreLabel.text = "Score: \(totalScore)/\(goalScore)"
        if Int(totalScore) == Int(goalScore) {
            stopAllAnimations = true
            if levelNum == 3 {
                timeRemaining += Int(gameTime)
                gameWon()   // Game complete
            } else {
                levelWon()  // Next level
            }
        }
    }
    
    /* Function to setup and add a crosshair to the subview with an image,
     * starting location and dimensions.
     */
    func initialiseCrosshair() {
        crosshairImageView.image = UIImage(named: "aim.png")
        crosshairImageView.frame = CGRect(x: maxNotch, y: (screenHeight/2) - (crosshairSize/2), width: crosshairSize, height: crosshairSize)
        self.view.addSubview(crosshairImageView)
    }
    
    /* Checks a random bird slot (0-4) in birdPositions. If slot is empty,
     * then a function to add a random bird to that slot is called.
     */
    func checkEmptyBirdPositions() {
        let randomSlotNum: Int = Int(arc4random_uniform(5)) // Random number 0-4
        
        if birdPositions[randomSlotNum] == 0 { // If slot is empty
            addBird(position: positionsArray[randomSlotNum], slotNum: randomSlotNum) // Add bird to slot
                birdPositions[randomSlotNum] = 1 // Set slot to occupied (1)
        }
    }
    
    
    /* Adds a random bird in the position (0-4) passed.
     * slotNum is used as an identifaction tag to track the slot position.
     */
    func addBird(position: CGRect, slotNum: Int) {
  
        // Create a new bird object
        bird = UIImageView(image: nil)
        
        // Loads a bird image at random from 1-12
        bird.image = UIImage(named: "bird\(arc4random_uniform(12) + 1)")
        bird.frame = position   // Pre-set CGRect position
        bird.tag = slotNum      // ID Number relating to position
        self.view.addSubview(bird)
        birds.append(bird)      // Add to birds[] array
    }
    
    /* Function called by touchesEnded() in DragImageView that 'shoots' a ball. The function creates a new
     * UIImage Ball, adds it to the subview and the ball array and then UIDynamics is implemented.
     */
    func shoot() {
        
        // Create a ball and add it to the subview
        shotBall = UIImageView(image: nil)
        shotBall.image = UIImage(named: "yellowBall")
        shotBall.frame = CGRect(x: maxNotch, y: (screenHeight/2 - crosshairSize/2), width: ballSize, height: ballSize)
        self.view.addSubview(shotBall)
        gameItems.insert(shotBall, at: 0)
        
        /* Behaviours */
        /* Dynamic Item Behaviour */
        dynamicBehavior = UIDynamicItemBehavior(items: [shotBall])
        self.dynamicBehavior.addLinearVelocity(CGPoint(x:crosshairVectorXY.x, y:crosshairVectorXY.y), for: shotBall)      // Speed and direction
        dynamicAnimator.addBehavior(dynamicBehavior)    // Add dynamicItem to animator
        

        gravityBehavior = UIGravityBehavior(items: gameItems)
        self.gravityBehavior.magnitude = 0.2            // Gravitational force
        dynamicAnimator.addBehavior(gravityBehavior)    // Add gravity to animator

        /* Collision Behaviour */
        collisionBehavior = UICollisionBehavior(items: gameItems)
        dynamicAnimator.addBehavior(collisionBehavior)  // Add collision to animator
        
        /* Passively checks for collision between ball and bird */
        collisionBehavior.action = {
            for itemA in self.gameItems {
                for itemB in self.birds {
                    if itemA.frame.intersects(itemB.frame) {
                        let preSubviewAmount = self.view.subviews.count
                        itemB.removeFromSuperview() // Dead bird
                        
                        
                        let postSubviewAmount = self.view.subviews.count
                        
                        if (preSubviewAmount != postSubviewAmount) {
                            self.increaseScore(score: 1)
                            playVibrate()
                            playDeathSound()
                            addDeadBirdAnimation(pos: itemB.tag, vc: mainViewControllerInstance)

                            // 2 second delay set so that a bird cannot respawn in the same place instantly
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                self.birdPositions[Int(itemB.tag)] = 0
                            }
                        }
                    }
                }
            }
        }
        
        /* Despawn balls after 2 seconds, if over 25 balls exist at once - prevents memory leak. */
        _ = Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: {_ in
            if self.gameItems.count > 25 {
                
                // count-3, as the last two indexes are reserved for obstacles items
                self.gameItems[self.gameItems.count-3].removeFromSuperview()
                self.gameItems.removeLast()
            }
        })
        
        /* Collision Boundaries - left, top and bottom sides of the screen. */
        self.collisionBehavior.addBoundary(withIdentifier: "leftBoundary" as NSCopying, from: CGPoint(x:0, y:0), to: CGPoint(x:maxNotch, y:screenHeight))
        self.collisionBehavior.addBoundary(withIdentifier: "topBoundary" as NSCopying, from: CGPoint(x:0, y:25), to: CGPoint(x: screenWidth + maxNotch, y: 25))
        self.collisionBehavior.addBoundary(withIdentifier: "bottomBoundary" as NSCopying, from: CGPoint(x:0, y:screenHeight), to: CGPoint(x: screenWidth + maxNotch, y: screenHeight))
        
    }
    
}
