//
//  DragImageView.swift
//  Aston-Coursework
//
//  Created by A&M on 02/01/2020.
//  Copyright © 2020 16052488. All rights reserved.
//

import UIKit

class DragImageView: UIImageView {

    var startLocation: CGPoint?
    var myDelegate: crosshairViewDelegate?;
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        startLocation = touches.first?.location(in: self)
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let currentLocation = touches.first?.location(in: self)
        
        let dx = currentLocation!.x - startLocation!.x
        let dy = currentLocation!.y - startLocation!.y
        var newCenter = CGPoint(x: self.center.x+dx, y: self.center.y+dy)
        
        
        //Constrain the movement to the phone screen bounds

        let halfx = self.bounds.midX // half the width of the flower image
        newCenter.x = max(halfx, newCenter.x) // left side boundary
        newCenter.x = min(120 - halfx, newCenter.x) // right side boundary
        
        let halfy = self.bounds.midY // half the height of the flower image
        newCenter.y = max(self.superview!.bounds.height/2 - 60 + halfy, newCenter.y) // top boundary
        newCenter.y = min(self.superview!.bounds.height/2 + 60 - halfy, newCenter.y) // bottom boundary
        // self.superview!.bounds.height - the height of the screen
        self.center = newCenter
        
        //self.myDelegate?.displayImagePosition();
        
        
    }
}
