//
//  nameScreen.swift
//  MagnumOpus
//
//  Created by Nina Demirjian on 11/29/17.
//  Copyright © 2017 nyu.edu. All rights reserved.
//

import Foundation
import UIKit
import SceneKit
import SpriteKit
import GameplayKit

class nameScene: SKScene {
    
    var playerOneBox : UITextField!
    var playerTwoBox : UITextField!
    var enter : SKSpriteNode!
    
    
    override func didMove(to view: SKView){
        let playerOneBox = UITextField()
        playerOneBox.font =  UIFont(name: "Eunomia.otf", size: 16)
        playerOneBox.borderStyle = UITextBorderStyle.roundedRect
        playerOneBox.backgroundColor = UIColor.white
        playerOneBox.frame = CGRect(x: 0, y: 0, width: 300, height: 40)
        self.view?.addSubview(playerOneBox)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let rotate = SKAction.rotate(byAngle: CGFloat(-M_PI * 1.5), duration: 0.5)
        
        for touch in touches {
            let location = touch.location(in: self)
            let node : SKNode = self.atPoint(location)
            
            if node.name == "enter" {
            }
        }
    }
    override func update(_ currentTime: TimeInterval) {
        
    }

}


