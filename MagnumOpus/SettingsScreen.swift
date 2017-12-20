//
//  SettingsScreen.swift
//  MagnumOpus
//
//  Created by "Rebecca Tolpin" on 12/9/17.
//  Copyright © 2017 nyu.edu. All rights reserved.
//

import SpriteKit
import UIKit
import GameplayKit
import SceneKit

var cardSetSelected : String = "inverted"

class SettingsScreen: SKScene {
    
    var highlightNode : SKSpriteNode!
    
    //List of themes
    let cardSetNames = ["inverted" , "card" , "blood"]
    
    override func didMove(to view: SKView) {
        
        //Create labels for the screen
        //Main settings label
        let settingsLabel = SKLabelNode(fontNamed: "My Font")
        settingsLabel.text = "SETTINGS"
        settingsLabel.fontSize = 100
        settingsLabel.position = CGPoint(x: 0, y: 500)
        settingsLabel.zPosition = 0.1
        settingsLabel.verticalAlignmentMode = .center
        settingsLabel.horizontalAlignmentMode = .center
        
        self.addChild(settingsLabel)
        
        //Choose theme label
        let chooseThemeLabel = SKLabelNode(fontNamed: "My Font")
        chooseThemeLabel.text = "THEME SELECT"
        chooseThemeLabel.fontSize = 64
        chooseThemeLabel.position = CGPoint(x: 0, y: 420)
        chooseThemeLabel.zPosition = 0.1
        chooseThemeLabel.verticalAlignmentMode = .center
        chooseThemeLabel.horizontalAlignmentMode = .center
        
        self.addChild(chooseThemeLabel)
        
        //Create image on the screen to choose from 
        //Inverted, or the green Standard cards
        let invertedCardNode = SKSpriteNode(imageNamed: "inverted10.png")
        invertedCardNode.name = "inverted"
        invertedCardNode.position = CGPoint(x: -150, y : 180)
        invertedCardNode.zPosition = 10
        invertedCardNode.size = CGSize(width: 240, height: 340)
        invertedCardNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.addChild(invertedCardNode)
        
        //Label for the standard card
        let standardLabel = SKLabelNode(fontNamed: "My Font")
        standardLabel.text = "STANDARD"
        standardLabel.fontSize = 50
        standardLabel.position = CGPoint(x: -150, y: -25)
        standardLabel.zPosition = 0.1
        standardLabel.verticalAlignmentMode = .center
        standardLabel.horizontalAlignmentMode = .center
        
        self.addChild(standardLabel)
        
        //Here is the Voodoo themed image
        let cardCardNode = SKSpriteNode(imageNamed: "card10.png")
        cardCardNode.name = "card"
        cardCardNode.position = CGPoint(x: 150, y : 180)
        cardCardNode.zPosition = 10
        cardCardNode.size = CGSize(width: 240, height: 340)
        cardCardNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.addChild(cardCardNode)
        
        //Label for voodoo choice
        let voodooLabel = SKLabelNode(fontNamed: "My Font")
        voodooLabel.text = "VOODOO"
        voodooLabel.fontSize = 50
        voodooLabel.position = CGPoint(x: 150, y: -25)
        voodooLabel.zPosition = 0.1
        voodooLabel.verticalAlignmentMode = .center
        voodooLabel.horizontalAlignmentMode = .center
        self.addChild(voodooLabel)
        
        //Blood Moon Card image
        let bloodCardNode = SKSpriteNode(imageNamed: "blood10.png")
        bloodCardNode.name = "blood"
        bloodCardNode.position = CGPoint(x: 0, y : -270)
        bloodCardNode.zPosition = 10
        bloodCardNode.size = CGSize(width: 240, height: 340)
        bloodCardNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.addChild(bloodCardNode)
        
        //Blood Moon Label
        let bloodLabel = SKLabelNode(fontNamed: "My Font")
        bloodLabel.text = "BLOOD MOON"
        bloodLabel.fontSize = 50
        bloodLabel.position = CGPoint(x: 0, y: -475)
        bloodLabel.zPosition = 0.1
        bloodLabel.verticalAlignmentMode = .center
        bloodLabel.horizontalAlignmentMode = .center
        self.addChild(bloodLabel)
        
        highlightNode = SKSpriteNode(color: UIColor(red: 172, green: 224, blue: 172, alpha: 1), size: CGSize(width: 260, height: 360))
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
                if(cardSetNames.contains(node.name!)) {
                    cardSetSelected = node.name!
                    
                    
                    let fadeOutAnimation = SKAction.fadeOut(withDuration: 0.2)

                    let changeParent = SKAction.customAction(withDuration: 0.01) {
                        otherNode, elapsedTime in
                        self.highlightNode.removeFromParent()
                        spriteNode.addChild(self.highlightNode)
                    }

                    let fadeInAnimation = SKAction.fadeIn(withDuration: 0.2)

                    highlightNode?.run(SKAction.sequence([fadeOutAnimation, changeParent, fadeInAnimation]))

                    
                    print(cardSetSelected)
                }
            }
        }
    }
    
}
