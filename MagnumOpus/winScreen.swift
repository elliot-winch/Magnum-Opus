//
//  winScreen.swift
//  MagnumOpus
//
//  Created by Rebecca Tolpin on 12/6/17.
//  Copyright © 2017 nyu.edu. All rights reserved.
//

import Foundation
//
//  WinScreen.swift
//  MagnumOpus
//
//  Created by Rebecca Tolpin on 11/29/17.
//  Copyright © 2017 nyu.edu. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit
import SceneKit

class WinScreen: SKScene {
    
    var winLabel:SKLabelNode!
    var goHomeBtn:SKSpriteNode!
    var goHomeLabel:SKLabelNode!
    
    override func didMove(to view: SKView) {
        let winCardImage = SKSpriteNode(imageNamed: "inverted13.png")
        self.addChild(winCardImage)
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let positionInScene = touch.location(in: self)
        let touchedNode = self.atPoint(positionInScene) as? SKSpriteNode
        if(touchedNode != nil){
            if (touchedNode!.name == "goHomeBtn" || touchedNode!.name == "goHomeLabel"){
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    if let view = self.view {
                        // Load the SKScene from 'newMenu.sks'
                        if let scene = SKScene(fileNamed: "newMenu") {
                            // Set the scale mode to scale to fit the window
                            scene.scaleMode = .aspectFill
                            let transition = SKTransition.fade(withDuration: 1)
                            
                            // Present the scene
                            view.presentScene(scene, transition: transition)
                        }
                    }
                    
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {}
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {}
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {}
    
}
