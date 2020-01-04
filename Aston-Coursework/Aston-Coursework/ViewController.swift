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
let birdSize: CGFloat = (screenHeight-30)/5
let ballSize: CGFloat = 50; // Ball size - square - even x and y dimensions

/* 5 possible bird co-ordinate positions TR -> BR */
let positionsArray: [CGRect] = [
    CGRect(x:(screenWidth - maxNotch) - (birdSize/2 + 5), y: 5, width: birdSize, height: birdSize),
    CGRect(x:(screenWidth - maxNotch) - (birdSize/2 + 5), y: 10 + birdSize, width: birdSize, height: birdSize),
    CGRect(x:(screenWidth - maxNotch) - (birdSize/2 + 5), y: 15 + (birdSize*2), width: birdSize, height: birdSize),
    CGRect(x:(screenWidth - maxNotch) - (birdSize/2 + 5), y: 20 + (birdSize*3), width: birdSize, height: birdSize),
    CGRect(x:(screenWidth - maxNotch) - (birdSize/2 + 5), y: 25 + (birdSize*4), width: birdSize, height: birdSize)]

/* Protocols for delegated functions */
protocol ballViewDelegate {
    func shoot()
}

class ViewController: UIViewController, ballViewDelegate {
    
    /* Ball storage */
    var shotBall = UIImageView(image: nil)
    var shotBalls = [UIImageView]()

    /* Bird storage */
    var bird = UIImageView(image:nil)
    var birds = [UIImageView]()
    var birdPositions: [Int] = [0,0,0,0,0] // Bird position slots TR -> BR. 0 = Empty. 1 = Occupied.
    
    /* UI */
    let scoreLabel = UILabel()
    var totalScore: Int = 0
    
    /* Behavioural variables */
    var dynamicAnimator: UIDynamicAnimator! // Physics Engine
    var dynamicBehavior: UIDynamicItemBehavior!
    var collisionBehavior: UICollisionBehavior!
    var gravityBehavior: UIGravityBehavior!

    @IBOutlet weak var crosshairImageView: DragImageView! // Crosshair image outlet reference
    
    /* Setup */
    override func viewDidLoad() {
        super.viewDidLoad()

        /* Passes the main view to dynamics as the reference view. */
        dynamicAnimator = UIDynamicAnimator(referenceView: self.view)
        
        /* Checks every x seconds and adds a random bird to a random empty slot. */
        _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block:{_ in
            self.checkEmptyBirdPositions()
        })
        
        
        _ = Timer.scheduledTimer(withTimeInterval: 5, repeats: false, block:{_ in
            self.gameOver()
        })
        
        /* Orientation Initialisation */
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        crosshairImageView.myBallDelegate = self
        initialiseCrosshair()
        initialiseScoreLabel()
    }
    
    func gameOver(){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "endGame") as! EndViewController
        
        self.present(vc, animated: false, completion: nil)
    }
    
    /* Function to force orientation to landscape. */
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    /* Function to allow autorotate of orientation. */
    override var shouldAutorotate: Bool {
        return true
    }
    
    func initialiseScoreLabel() {
        scoreLabel.frame = CGRect(x:maxNotch, y:10, width:100, height:20)
        scoreLabel.textAlignment = NSTextAlignment.left
        scoreLabel.text = "Score: \(totalScore)"
        self.view.addSubview(scoreLabel)
    }
    
    func increaseScore(score:Int) {
        totalScore = totalScore + score
        scoreLabel.text = "Score: \(totalScore)"
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
  
        /* Create a new bird object */
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
        
        /* Create a ball and add it to the subview */
        shotBall = UIImageView(image: nil)
        shotBall.image = UIImage(named: "ball.png")
        shotBall.frame = CGRect(x: maxNotch, y: (screenHeight/2 - crosshairSize/2), width: ballSize, height: ballSize)
        self.view.addSubview(shotBall)
        shotBalls.append(shotBall) // Add newly created ball to shotBalls[] array
        
        /* Behaviours */

        /* Dynamic Item Behaviour */
        dynamicBehavior = UIDynamicItemBehavior(items: [shotBall])
        self.dynamicBehavior.addLinearVelocity(CGPoint(x:crosshairVectorXY.x, y:crosshairVectorXY.y), for: shotBall)      // Speed and direction
        dynamicAnimator.addBehavior(dynamicBehavior)    // Add dynamicItem to animator

        /* Gravity Behaviour */
        gravityBehavior = UIGravityBehavior(items: [shotBall])
        self.gravityBehavior.magnitude = 0.2            // Gravitational force
        dynamicAnimator.addBehavior(gravityBehavior)    // Add gravity to animator

        /* Collision Behaviour */
        collisionBehavior = UICollisionBehavior(items: shotBalls)
        dynamicAnimator.addBehavior(collisionBehavior)  // Add collision to animator
        
        /* Passively checks for collision between ball and bird */
        collisionBehavior.action = {
            for itemA in self.shotBalls {
                for itemB in self.birds {
                    if itemA.frame.intersects(itemB.frame) {
                        let preSubviewAmount = self.view.subviews.count
                        itemB.removeFromSuperview()
                        let postSubviewAmount = self.view.subviews.count
                        
                        if (preSubviewAmount != postSubviewAmount){
                            self.birdPositions[Int(itemB.tag)] = 0
                            self.increaseScore(score: 1)
                        }
                    }
                }
            }
        }
        
        /* Despawn balls after 5 seconds - prevents memory leak. */
        _ = Timer.scheduledTimer(withTimeInterval: 5, repeats: false, block:{_ in
            if self.shotBalls.isEmpty == false {
                self.shotBalls[0].removeFromSuperview()
                self.shotBalls.removeFirst()
            }
        })
        
        /* Collision Boundaries - left, top and bottom sides of the screen. */
        self.collisionBehavior.addBoundary(withIdentifier: "leftBoundary" as NSCopying, from: CGPoint(x:0, y:0), to: CGPoint(x:0, y:screenHeight))
        self.collisionBehavior.addBoundary(withIdentifier: "topBoundary" as NSCopying, from: CGPoint(x:0, y:0), to: CGPoint(x: screenWidth + maxNotch, y: 0))
        self.collisionBehavior.addBoundary(withIdentifier: "bottomBoundary" as NSCopying, from: CGPoint(x:0, y:screenHeight), to: CGPoint(x: screenWidth + maxNotch, y: screenHeight))
    }
}
