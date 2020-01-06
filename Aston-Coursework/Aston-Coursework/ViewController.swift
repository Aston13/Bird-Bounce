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
let ballSize: CGFloat = 50; // Ball size - square - even x and y dimensions

/* Time and game configurations */
var gameTime: TimeInterval = 30
var goalScore: Int = 3
var gameInProgress: Bool = true;
var levelNum = 1
var birdTimer: Timer?
var gameTimer: Timer?

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
    
    /* Game items storage */
    var shotBall = UIImageView(image: nil)
    var gameItems = [UIImageView]() // Collection of ball and obtacle items

    /* Bird storage */
    var bird = UIImageView(image:nil)
    var birds = [UIImageView]()
    var birdPositions: [Int] = [0,0,0,0,0] // Bird position slots TR -> BR. 0 = Empty. 1 = Occupied.
    
    /* UI */
    var uiBar = UIView()
    let scoreLabel = UILabel()
    var totalScore: Int = 0
    let timeLabel = UILabel()
    
    /* Behavioural variables */
    var dynamicAnimator: UIDynamicAnimator! // Physics Engine
    var dynamicBehavior: UIDynamicItemBehavior!
    var collisionBehavior: UICollisionBehavior!
    var gravityBehavior: UIGravityBehavior!

    /* Interface Builder: Outlets/Actions */
    @IBOutlet weak var nextLevelButton: UIButton!
    @IBAction func nextLevelButtonPressed(_ sender: Any) {
        nextLevelButton.isHidden = true
        increaseLevel()
    }
    @IBOutlet weak var crosshairImageView: DragImageView! // Crosshair image outlet reference
    
    /*
     * Setup
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        // Orientation initialisation
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")

        crosshairImageView.myBallDelegate = self
        initialiseUI()
    }
    
    func gameOver() {
        
        // gameInProgress check ensures that the game isn't paused or in a transition screen
        if (gameInProgress) {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "endGame") as! EndViewController
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    func gameWon() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "completeGame") as! CompleteViewController
        self.present(vc, animated: false, completion: nil)
    }
    
    func levelWon() {
        let nextLevelScreen = UIView()
        nextLevelScreen.frame = CGRect(x: 0, y: 0, width: screenWidth + maxNotch, height: screenHeight)
        nextLevelScreen.backgroundColor = UIColor.yellow
        
        gameInProgress = false
        
        self.view.addSubview(nextLevelScreen)
        nextLevelButton.isHidden = false
        self.view.bringSubviewToFront(nextLevelButton)
    }
    
    /* Resets game state and loads new settings based on the level. Only three levels currently exist.
     * In future, a function could be made to automatically increase variables based on level number.
     */
    func increaseLevel() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Main") as! ViewController
        
        // Reset game variables
        totalScore = 0
        levelNum = levelNum + 1
        birdTimer?.invalidate()
        gameTimer?.invalidate()
        
        // Level selection
        if levelNum == 2 {
            goalScore = 4
            gameTime = 40
            self.present(vc, animated: false, completion: nil)
            gameInProgress = true
            vc.addRandomObstacle()
        } else if levelNum == 3 {
            goalScore = 5
            gameTime = 50
            self.present(vc, animated: false, completion: nil)
            gameInProgress = true
            vc.addRandomObstacle()
            vc.addRandomObstacle()
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
        let randomWH: Int = Int.random(in: (Int(screenHeight/2) - Int(ballSize*2))...(Int(screenHeight/2) - Int(ballSize*2)))
        let rangeXMax: Int = Int(screenWidth)-(randomWH*2)
        let rangeYMax: Int = Int(screenHeight)-randomWH
        let randomY: Int = Int.random(in: 25...rangeYMax)
        let randomX: Int = Int.random(in: rangeXMin...rangeXMax)
        
        // Create obstacle
        obstacle.frame = CGRect(x:randomX,y:randomY,width:randomWH,height:randomWH)
        obstacle.backgroundColor = UIColor.red
        self.view.addSubview(obstacle)
        gameItems.append(obstacle)
        
        // Behaviours
        dynamicBehavior = UIDynamicItemBehavior(items: [obstacle])
        self.dynamicBehavior.isAnchored = true // Fixed position
        dynamicAnimator.addBehavior(dynamicBehavior)

        collisionBehavior = UICollisionBehavior(items: [obstacle])
        dynamicAnimator.addBehavior(collisionBehavior) // Add collision to animator
    }
    
    /* Function to force orientation to landscape. */
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    /* Function to allow autorotate of orientation. */
    override var shouldAutorotate: Bool {
        return true
    }
    
    func initialiseUI() {
        let uiBarWidth: CGFloat = (screenWidth + maxNotch)
        let uiBarItemAmount: CGFloat = 3;
        
        uiBar.frame = CGRect(x:0, y:0, width: uiBarWidth, height: 25)
        uiBar.backgroundColor = UIColor.systemGray
        self.view.addSubview(uiBar)
        
        initialiseCrosshair()
        initialiseScoreLabel(scaledWidth: uiBarWidth, amount: uiBarItemAmount)
        initialiseTimeLabel(scaledWidth: uiBarWidth, amount: uiBarItemAmount)
        initialiseLevelLabel(scaledWidth: uiBarWidth, amount: uiBarItemAmount)
    }
    
    func initialiseScoreLabel(scaledWidth: CGFloat, amount: CGFloat) {
        scoreLabel.frame = CGRect(x:maxNotch, y: 0, width: scaledWidth/amount, height: 25)
        scoreLabel.textAlignment = NSTextAlignment.left
        scoreLabel.text = "Score: \(totalScore)/\(goalScore)"
        self.view.addSubview(scoreLabel)
    }
    
    func initialiseTimeLabel(scaledWidth: CGFloat, amount: CGFloat) {
        timeLabel.frame = CGRect(x:maxNotch + (screenWidth/3), y: 0, width: (scaledWidth/amount)*2, height: 25)
        timeLabel.textAlignment = NSTextAlignment.left
        timeLabel.text = "Time Remaining: \(Int(gameTime))"
        self.view.addSubview(timeLabel)
    }
    
    func initialiseLevelLabel(scaledWidth: CGFloat, amount: CGFloat) {
        let levelLabel = UILabel()
        levelLabel.frame = CGRect(x:maxNotch + (screenWidth/3)*2, y: 0, width: (scaledWidth/amount)*3, height: 25)
        levelLabel.textAlignment = NSTextAlignment.left
        levelLabel.text = "Level: \(levelNum)"
        self.view.addSubview(levelLabel)
    }
    
    func updateTimeLabel() {
        gameTime = gameTime - 1
        timeLabel.text = "Time Remaining: \(Int(gameTime))"
    }
    
    func increaseScore(score:Int) {
        totalScore = totalScore + score
        scoreLabel.text = "Score: \(totalScore)/\(goalScore)"
        if Int(totalScore) == Int(goalScore) {
            if levelNum == 3 {
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
        shotBall.image = UIImage(named: "ball.png")
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
                        itemB.removeFromSuperview()
                        let postSubviewAmount = self.view.subviews.count
                        
                        if (preSubviewAmount != postSubviewAmount) {
                            self.increaseScore(score: 1)

                            // 1 second timer set so that a bird cannot respawn in the same place instantly
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
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
        self.collisionBehavior.addBoundary(withIdentifier: "leftBoundary" as NSCopying, from: CGPoint(x:0, y:0), to: CGPoint(x:0, y:screenHeight))
        self.collisionBehavior.addBoundary(withIdentifier: "topBoundary" as NSCopying, from: CGPoint(x:0, y:25), to: CGPoint(x: screenWidth + maxNotch, y: 25))
        self.collisionBehavior.addBoundary(withIdentifier: "bottomBoundary" as NSCopying, from: CGPoint(x:0, y:screenHeight), to: CGPoint(x: screenWidth + maxNotch, y: screenHeight))
        
    }
}
