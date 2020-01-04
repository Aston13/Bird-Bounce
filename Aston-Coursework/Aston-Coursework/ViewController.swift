//
//  ViewController.swift
//  Aston-Coursework
//
//  Created by Aston on 09/12/2019.
//  Copyright © 2019 16052488. All rights reserved.
//
    
import UIKit

/* Global variables */
public var maxNotch: CGFloat = 35 // Maximum thickness of the notch area on an iPhone
public var crosshairSize: CGFloat = 50 // Crosshair size - square - even x and y dimensions
public var ballSize: CGFloat = 50; // Ball size - square - even x and y dimensions
public var screenWidth = UIScreen.main.bounds.width - maxNotch // Overall screen width - not including notch
public var screenHeight = UIScreen.main.bounds.height
public var birdSize: CGFloat = (screenHeight-30)/5

var bird = UIImageView(image:nil)
var birds = [UIImageView]()
var shotBall = UIImageView(image: nil)
var shotBalls = [UIImageView]() // Delaration of an array to store UIDynamicItem objects
var obstacleArray = [UIImageView]()
let scoreLabel = UILabel()

var birdPositions = [Int]()

public var crosshairVectorXY = CGPoint(x:0,y:0)

/* Protocols for delegated functions */
protocol ballViewDelegate {
    func shoot()
}

class ViewController: UIViewController, ballViewDelegate {

    @IBOutlet weak var crosshairImageView: DragImageView! // Crosshair image outlet reference
    
    var dynamicAnimator: UIDynamicAnimator!     // Physics Engine
    var dynamicBehavior: UIDynamicItemBehavior! // Declare dynamic behaviour
    var collisionBehavior: UICollisionBehavior! // Declare collisions
    var gravityBehavior: UIGravityBehavior!     // Declare gravity
    
    /* Function to setup and add a crosshair to the subview with an image,
     * starting location and dimensions.
     */
    func initialiseCrosshair() {
        crosshairImageView.image = UIImage(named: "aim.png")
        crosshairImageView.frame = CGRect(x: maxNotch, y: (screenHeight/2) - (crosshairSize/2), width: crosshairSize, height: crosshairSize)
        self.view.addSubview(crosshairImageView)
    }
    
    func addBird() {
        var position = CGRect(x:(screenWidth - maxNotch) - (birdSize/2 + 5), y: 5, width: birdSize, height: birdSize)
        
        for emptyPosition in birdPositions {
            if emptyPosition == 1 {
                position = CGRect(x:(screenWidth - maxNotch) - (birdSize/2 + 5), y: 5, width: birdSize, height: birdSize)
            } else if emptyPosition == 2 {
                
            } else if emptyPosition == 3 {
                
            } else if emptyPosition == 4 {
                
            } else if emptyPosition == 5 {
                
            } else {
                break
            }
        }
        
        bird = UIImageView(image: nil)
        bird.image = UIImage(named: "bird4.png")
        bird.frame = position
        //bird.backgroundColor = UIColor.red
        self.view.addSubview(bird)

        birds.append(bird)

//        dynamicBehavior = UIDynamicItemBehavior(items: [bird])
//        dynamicAnimator.addBehavior(dynamicBehavior)
//
//        collisionBehavior = UICollisionBehavior(items: [bird])
//        //collisionBehavior = UICollisionBehavior(items: birds)
//        dynamicAnimator.addBehavior(collisionBehavior)
        
    }
    
    /* Function called by touchesEnded() in DragImageView that 'shoots' a ball. The function creates a new
     * UIImage Ball, adds it to the subview and the ball array and then UIDynamics is implemented.
     */
    func shoot() {
        
        /* Create a ball and add it to the subview */
        shotBall = UIImageView(image: nil)
        shotBall.image = UIImage(named: "ball.png")
        shotBall.frame = CGRect(x: maxNotch, y: (screenHeight/2 - crosshairSize/2), width: ballSize, height: ballSize)
        //shotBall.backgroundColor = UIColor.blue
        self.view.addSubview(shotBall)
        
        shotBalls.append(shotBall) // Add the newly created ball that has been shot to the shotBalls array
        
        /* Behaviours */
        
        /* Dynamic Item Behaviour */
        dynamicBehavior = UIDynamicItemBehavior(items: [shotBall]) // Add balls to the dynamic item behaviour
        
        // Speed and direction
        self.dynamicBehavior.addLinearVelocity(CGPoint(x:crosshairVectorXY.x, y:crosshairVectorXY.y), for: shotBall)
        
        dynamicAnimator.addBehavior(dynamicBehavior) // Add dynamic item to animator

        /* Gravity Behaviour */
        gravityBehavior = UIGravityBehavior(items: [shotBall])
        self.gravityBehavior.magnitude = 0.2 // Gravitational force
        
        dynamicAnimator.addBehavior(gravityBehavior) // Add gravity to animator

        /* Collision Behaviour */
        collisionBehavior = UICollisionBehavior(items: shotBalls)
        collisionBehavior.action = {
            
            for item in shotBalls {
                if item.frame.intersects(bird.frame) {
                    bird.isHidden = true
                    self.increaseScore(score: 10)
                }
            }
        }
        
        // Collision Boundaries - left, top and bottom sides of the screen
        self.collisionBehavior.addBoundary(withIdentifier: "leftBoundary" as NSCopying, from: CGPoint(x:0, y:0), to: CGPoint(x:0, y:screenHeight))
        self.collisionBehavior.addBoundary(withIdentifier: "topBoundary" as NSCopying, from: CGPoint(x:0, y:0), to: CGPoint(x: screenWidth + maxNotch, y: 0))
        self.collisionBehavior.addBoundary(withIdentifier: "bottomBoundary" as NSCopying, from: CGPoint(x:0, y:screenHeight), to: CGPoint(x: screenWidth + maxNotch, y: screenHeight))
        
        dynamicAnimator.addBehavior(collisionBehavior) // Add collision to animator
    }
    
    func initialiseScoreLabel(score:Int) {
        scoreLabel.frame = CGRect(x:maxNotch, y:10, width:100, height:20)
        scoreLabel.textAlignment = NSTextAlignment.left
        scoreLabel.text = "Score: \(score)"
        self.view.addSubview(scoreLabel)
        
    }
    
    func increaseScore(score:Int) {
        var total = 0
        total += score
        scoreLabel.text = "Score: \(total)"
    }
    
    /* Intialise and setup */
    override func viewDidLoad() {
        super.viewDidLoad()
        /* Passes the main view to dynamics as the reference view */
        dynamicAnimator = UIDynamicAnimator(referenceView: self.view)
        addBird()
        crosshairImageView.myBallDelegate = self
    
        /* Orientation Initialisation */
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        

        initialiseCrosshair()
        initialiseScoreLabel(score:0)

    }
    
    /* Functions to force orientation and autorotate */
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
}
