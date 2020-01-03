//
//  ViewController.swift
//  Aston-Coursework
//
//  Created by Aston on 09/12/2019.
//  Copyright © 2019 16052488. All rights reserved.
//
    
import UIKit

/* Global variables */
public var maxNotch: CGFloat = 35; // Maximum thickness of the notch area on an iPhone
public var crosshairSize: CGFloat = 50; // Crosshair size - square - even x and y dimensions
public var ballSize: CGFloat = 50; // Ball size - square - even x and y dimensions
public var screenWidth = UIScreen.main.bounds.width - maxNotch // Overall screen width - not including notch
public var screenHeight = UIScreen.main.bounds.height

var shotBalls = [UIDynamicItem]() // Delaration of an array to store UIDynamicItem objects
public var crosshairVectorXY = CGPoint(x:0,y:0)

/* Protocols for delegated functions */
protocol ballViewDelegate {
    func shoot()
}

class ViewController: UIViewController, ballViewDelegate {

    @IBOutlet weak var crosshairImageView: DragImageView! // Crosshair image outlet reference
    
    var dynamicAnimator: UIDynamicAnimator!
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
    
    /* Function called by touchesEnded() in DragImageView that 'shoots' a ball. The function creates a new
     * UIImage Ball, adds it to the subview and the ball array and then UIDynamics is implemented.
     */
    func shoot() {
        /* Create a ball and add it to the subview */
        let shotBall = UIImageView(image: nil)
        shotBall.image = UIImage(named: "ball.png")
        shotBall.frame = CGRect(x: maxNotch, y: (screenHeight/2 - crosshairSize/2), width: ballSize, height: ballSize)
        self.view.addSubview(shotBall)
        
        shotBalls.append(shotBall) // Add the newly created ball that has been shot to the balls array
        
        /* Add behaviours to the ball objects */
        /* Dynamic Item Behaviour */
        dynamicBehavior = UIDynamicItemBehavior(items: shotBalls) // Add balls to the dynamic item behaviour
        dynamicAnimator.addBehavior(dynamicBehavior) // Add behaviour to the animator
        
        
        /* Gravity Behaviour */
        gravityBehavior = UIGravityBehavior(items: shotBalls)
        dynamicAnimator.addBehavior(gravityBehavior)
        
        /* Collision Behaviour */
        collisionBehavior = UICollisionBehavior(items: shotBalls)
        dynamicAnimator.addBehavior(collisionBehavior)
        
        /* Behaviour Configurations */
        // Angle
        self.dynamicBehavior.addLinearVelocity(CGPoint(x:crosshairVectorXY.x, y:crosshairVectorXY.y), for: shotBall) // Speed and direction
        self.gravityBehavior.magnitude = 0.2 // Gravitational force

        /* Collision Boundaries - left, top and bottom sides of the screen */
        self.collisionBehavior.addBoundary(withIdentifier: "leftBoundary" as NSCopying, from: CGPoint(x:0, y:0), to: CGPoint(x:0, y:screenHeight))
        self.collisionBehavior.addBoundary(withIdentifier: "topBoundary" as NSCopying, from: CGPoint(x:0, y:0), to: CGPoint(x: screenWidth + maxNotch, y: 0))
        self.collisionBehavior.addBoundary(withIdentifier: "bottomBoundary" as NSCopying, from: CGPoint(x:0, y:screenHeight), to: CGPoint(x: screenWidth + maxNotch, y: screenHeight))
    }
    
    /* Intialise and setup */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Passes the main view to dynamics as the reference view */
        dynamicAnimator = UIDynamicAnimator(referenceView: self.view)
        
        crosshairImageView.myBallDelegate = self
        
        /* Orientation Initialisation */
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        initialiseCrosshair()
    }
    
    
    
    
    /* Functions to force orientation and autorotate */
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
}
