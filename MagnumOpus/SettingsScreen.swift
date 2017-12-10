//
//  SettingsScreen.swift
//  MagnumOpus
//
//  Created by Rebecca Tolpin on 12/9/17.
//  Copyright © 2017 nyu.edu. All rights reserved.
//

import SpriteKit
import UIKit
import GameplayKit
import SceneKit

var cardSetSelected : String = "inverted"

class SettingsScreen: SKScene {
    
    var darkCard : SKSpriteNode!
    var invertedCard : SKSpriteNode!
    
    let cardSetNames = ["inverted", "card"]
    
    override func didMove(to view: SKView) {
        
        let settingsLabel = SKLabelNode(fontNamed: "My Font")
        settingsLabel.text = "SETTINGS"
        settingsLabel.fontSize = 100
        settingsLabel.position = CGPoint(x: 0, y: 450)
        settingsLabel.zPosition = 0.1
        settingsLabel.verticalAlignmentMode = .center
        settingsLabel.horizontalAlignmentMode = .center
        
        self.addChild(settingsLabel)
        
        let chooseThemeLabel = SKLabelNode(fontNamed: "My Font")
        chooseThemeLabel.text = "THEME SELECT"
        chooseThemeLabel.fontSize = 64
        chooseThemeLabel.position = CGPoint(x: -180, y: 90)
        chooseThemeLabel.zPosition = 0.1
        chooseThemeLabel.verticalAlignmentMode = .center
        chooseThemeLabel.horizontalAlignmentMode = .center
        
        self.addChild(chooseThemeLabel)
        
        let invertedCardNode = SKSpriteNode(imageNamed: "inverted10.png")
        invertedCardNode.name = "inverted"
        invertedCardNode.position = CGPoint(x: -150, y : -150)
        invertedCardNode.zPosition = 10
        invertedCardNode.size = CGSize(width: 240, height: 340)
        invertedCardNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.addChild(invertedCardNode)
        
        let cardCardNode = SKSpriteNode(imageNamed: "card10.png")
        cardCardNode.name = "card"
        cardCardNode.position = CGPoint(x: 150, y : -150)
        cardCardNode.zPosition = 10
        cardCardNode.size = CGSize(width: 240, height: 340)
        cardCardNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.addChild(cardCardNode)

        
        let highlightNode = SKSpriteNode(color: UIColor.green, size: CGSize(width: 260, height: 360))
        highlightNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        highlightNode.name = "highlightNode"
        
        if(cardSetSelected == "inverted"){
            invertedCardNode.addChild(highlightNode)
        } else {
            cardCardNode.addChild(highlightNode)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            let node : SKNode = self.atPoint(location)
            
            if(node.name == "goHomeBtn"){
                if let scene = SKScene(fileNamed: "newMenu") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    let transition = SKTransition.fade(withDuration: 1)
                    // Present the scene
                    view!.presentScene(scene, transition: transition)
                }
            } else if let spriteNode = node as? SKSpriteNode {
                if(cardSetNames.contains(spriteNode.name!)) {
                    cardSetSelected = node.name!
                    
                    var nextIndex = cardSetNames.index(of: node.name!)
                    nextIndex!+=1
                    let otherNode = self.childNode(withName: cardSetNames[nextIndex! % 2])
                    let highlightNode = otherNode?.childNode(withName: "highlightNode")
                    
                    
                    let fadeOutAnimation = SKAction.fadeOut(withDuration: 0.2)
                    
                    let changeParent = SKAction.customAction(withDuration: 0.01) {
                        otherNode, elapsedTime in
                        highlightNode?.removeFromParent()
                        node.addChild(highlightNode!)
                    }
                    
                    let fadeInAnimation = SKAction.fadeIn(withDuration: 0.2)
                    
                    highlightNode?.run(SKAction.sequence([fadeOutAnimation, changeParent, fadeInAnimation]))
                    
                    
                    print(cardSetSelected)
                }
            }
        }
    }
    
}
