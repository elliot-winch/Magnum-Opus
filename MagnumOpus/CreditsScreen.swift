//
//  CreditsScreen.swift
//  MagnumOpus
//
//  Created by Rebecca Tolpin on 12/10/17.
//  Copyright © 2017 nyu.edu. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import SceneKit

class CreditsScreen: SKScene {
    
    override func didMove(to view: SKView) {
        let creditLabel = SKLabelNode(fontNamed: "My Font")
        creditLabel.text = "CREDITS"
        creditLabel.fontSize = 100
        creditLabel.position = CGPoint(x: 0, y: 450)
        creditLabel.zPosition = 0.1
        creditLabel.verticalAlignmentMode = .center
        creditLabel.horizontalAlignmentMode = .center
        
        self.addChild(creditLabel)
        
        let creditLabelEW = SKLabelNode(fontNamed: "My Font")
        creditLabelEW.text = "Elliot Winch"
        creditLabelEW.fontSize = 50
        creditLabelEW.position = CGPoint(x: 8, y: 254)
        creditLabelEW.zPosition = 0.1
        creditLabelEW.verticalAlignmentMode = .center
        creditLabelEW.horizontalAlignmentMode = .right
        
        self.addChild(creditLabelEW)
        
        let creditLabelND = SKLabelNode(fontNamed: "My Font")
        creditLabelND.text = "Nina Demirjian"
        creditLabelND.fontSize = 50
        creditLabelND.position = CGPoint(x: 35, y: 13)
        creditLabelND.zPosition = 0.1
        creditLabelND.verticalAlignmentMode = .center
        creditLabelND.horizontalAlignmentMode = .center
        
        
        self.addChild(creditLabelND)
        
        let creditLabelRT = SKLabelNode(fontNamed: "My Font")
        creditLabelRT.text = "Rebecca Tolpin"
        creditLabelRT.fontSize = 50
        creditLabelRT.position = CGPoint(x: 20, y: -334)
        creditLabelRT.zPosition = 0.1
        creditLabelRT.verticalAlignmentMode = .center
        creditLabelRT.horizontalAlignmentMode = .center
        
        self.addChild(creditLabelRT)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            let node : SKNode = self.atPoint(location)
            
            if let spriteNode = node as? SKSpriteNode{
                if(node.name == "goHomeBtn"){
                    if let scene = SKScene(fileNamed: "newMenu") {
                        // Set the scale mode to scale to fit the window
                        scene.scaleMode = .aspectFill
                        let transition = SKTransition.fade(withDuration: 1)
                        // Present the scene
                        view!.presentScene(scene, transition: transition)
                    }
                }
            }
        }
    }
}
