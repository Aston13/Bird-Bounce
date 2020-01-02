//
//  DragImageView.swift
//  Aston-Coursework
//
//  Created by A&M on 02/01/2020.
//  Copyright © 2020 16052488. All rights reserved.
//

import UIKit

class DragImageView: UIImageView {
    
    /* Original starting location used by touchesEnded() to reset crosshair */
    var spawnPoint = CGPoint(x: maxNotch + crosshairSize/2,y: screenHeight/2)
    
    var startLocation: CGPoint? // Starting location used by touchesMoved()
    var myDelegate: crosshairViewDelegate?;

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        startLocation = touches.first?.location(in: self)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let currentLocation = touches.first?.location(in: self)
        
        let dx = currentLocation!.x - startLocation!.x
        let dy = currentLocation!.y - startLocation!.y
        var newCenter = CGPoint(x: self.center.x+dx, y: self.center.y+dy)
        
        /* Constrain the movement of the crosshair.
         * Comments are in perspective to the top-left corner of the screen (x0,y0).
         */

        let halfx = self.bounds.midX // Half the width of the crosshair image
        newCenter.x = max((maxNotch + halfx), newCenter.x) // Left boundary
        newCenter.x = min(screenWidth * 0.20 - halfx, newCenter.x) // Right boundary

        let halfy = self.bounds.midY // Half the height of the crosshair image
        newCenter.y = min(screenHeight * 0.70 - halfy, newCenter.y) // Bottom boundary
        newCenter.y = max(screenHeight * 0.30 + halfy, newCenter.y) // Top boundary
        
        self.center = newCenter
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.center = spawnPoint
    }
}
