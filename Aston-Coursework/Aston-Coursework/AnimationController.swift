//
//  AnimationController.swift
//  Aston-Coursework
//
//  Created by A&M on 06/01/2020.
//  Copyright © 2020 16052488. All rights reserved.
//

import Foundation
import UIKit


var stopAllAnimations: Bool = false
let explosionImages = createImageArray(total:64, imagePrefix: "tile0")


func createImageArray(total: Int, imagePrefix: String) -> [UIImage] {
    var imageArray: [UIImage] = []
    
    for imageCount in 0..<total {
        let imageName = "\(imagePrefix)\(imageCount)"
        let image = UIImage(named: imageName)!
        
        imageArray.append(image)
    }
    return imageArray
}

func animate(imageView: UIImageView, images: [UIImage]){
    imageView.animationImages = images
    imageView.animationDuration = 1.0
    imageView.animationRepeatCount = 1
    imageView.startAnimating()
}
    
func addDeadBirdAnimation(pos: Int, vc: ViewController) {
    let birdFeathers = UIImageView(image:nil)
    birdFeathers.frame = positionsArray[pos]
    
    animate(imageView: birdFeathers, images: explosionImages)
    vc.view.addSubview(birdFeathers)

    if stopAllAnimations == true {
        birdFeathers.removeFromSuperview()
    }
}


