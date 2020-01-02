//
//  ViewController.swift
//  Aston-Coursework
//
//  Created by Aston on 09/12/2019.
//  Copyright © 2019 16052488. All rights reserved.
//

import UIKit

protocol crosshairViewDelegate {
    
}

class ViewController: UIViewController, crosshairViewDelegate {
    
    let h = UIScreen.main.bounds.height;
    let w = UIScreen.main.bounds.width;
    

    @IBOutlet weak var crosshairImageView: DragImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        crosshairImageView.myDelegate = self
    }
}
