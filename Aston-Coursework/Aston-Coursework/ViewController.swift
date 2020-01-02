//
//  ViewController.swift
//  Aston-Coursework
//
//  Created by Aston on 09/12/2019.
//  Copyright © 2019 16052488. All rights reserved.
//
    
import UIKit

// Global variables
public var crosshairSize: CGFloat = 50;
public var screenWidth = UIScreen.main.bounds.width
public var screenHeight = UIScreen.main.bounds.height

protocol crosshairViewDelegate {
    
}

class ViewController: UIViewController, crosshairViewDelegate {

    @IBOutlet weak var crosshairImageView: DragImageView!
    
    func initialiseCrosshair() {
        crosshairImageView.image = UIImage(named: "aim.png")
        crosshairImageView.frame = CGRect(x: screenWidth * 0.10 - crosshairSize/2, y: (screenHeight/2) - (crosshairSize/2), width: crosshairSize, height: crosshairSize)
        self.view.addSubview(crosshairImageView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        crosshairImageView.myDelegate = self
        initialiseCrosshair()
    }
}
