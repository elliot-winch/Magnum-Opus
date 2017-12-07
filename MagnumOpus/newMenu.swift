//
//  newMenu.swift
//  MagnumOpus
//
//  Created by Nina Demirjian on 11/23/17.
//  Copyright © 2017 nyu.edu. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit
import GameplayKit
import SceneKit


class newMenu: SKScene {
    
    var title:SKLabelNode!
    var backdrop: SKEmitterNode!
    var startButton : SKSpriteNode!
    var startLabel : SKLabelNode!
    var tutorialLabel : SKLabelNode!
    var settingsLabel : SKLabelNode!
    var creditsLabel : SKLabelNode!
    
    
    override func didMove(to view: SKView) {
       
        let rotateSlow = SKAction.rotate(byAngle: CGFloat(-M_PI * 0.5), duration: 10)
        let loopSlow = SKAction.repeatForever(rotateSlow)
        
        let startButton = SKSpriteNode(imageNamed: "startStar2.png")
        self.addChild(startButton)
        startButton.name = "begin two player"
        startButton.zPosition = 2
        startButton.position = CGPoint(x: 2, y: -440)
        startButton.size = CGSize(width: 90, height: 90)
        let rotate = SKAction.rotate(byAngle: CGFloat(-M_PI * 0.5), duration: 5)
        let loop = SKAction.repeatForever(rotate)
        startButton.run(loop, withKey: "rotate")
        
        let tutorialButton = SKSpriteNode(imageNamed: "startStar2.png")
        self.addChild(tutorialButton)
        tutorialButton.name = "tutorial"
        tutorialButton.zPosition = 2
        tutorialButton.position = CGPoint(x: 0, y: 227)
        tutorialButton.size = CGSize(width: 80, height: 80)
        tutorialButton.run(loop, withKey: "rotate")
        
        let settingsButton = SKSpriteNode(imageNamed: "startStar2.png")
        self.addChild(settingsButton)
        settingsButton.name = "settings"
        settingsButton.zPosition = 2
        settingsButton.position = CGPoint(x: -110  , y: -22)
        settingsButton.size = CGSize(width: 70, height: 70)
        settingsButton.run(loop, withKey: "rotate")
        
        let creditsButton = SKSpriteNode(imageNamed: "startStar2.png")
        self.addChild(creditsButton)
        creditsButton.name = "credits"
        creditsButton.zPosition = 2
        creditsButton.position = CGPoint(x: 110  , y: -22)
        creditsButton.size = CGSize(width: 70, height: 70)
        creditsButton.run(loop, withKey: "rotate")
        
        let horn = SKSpriteNode(imageNamed: "whiteStar.png")
        self.addChild(horn)
        horn.name = "horn"
        horn.zPosition = 2
        horn.position = CGPoint(x: -286  , y: 345)
        horn.size = CGSize(width: 45, height: 45)
        horn.run(loopSlow, withKey: "rotate")
    
        let horn2 = SKSpriteNode(imageNamed: "whiteStar.png")
        self.addChild(horn2)
        horn2.name = "horn"
        horn2.zPosition = 2
        horn2.position = CGPoint(x: 286  , y: 345)
        horn2.size = CGSize(width: 45, height: 45)
        horn2.run(loopSlow, withKey: "rotate")
        
        
        
        
        let startLabel = SKLabelNode(fontNamed: "My Font")
        startLabel.text = "BEGIN TWO-PLAYER"
        startLabel.fontSize = 45
        startLabel.position = CGPoint(x:frame.midX, y: -530)
        startLabel.zPosition = 0.1
        self.addChild(startLabel)
        
        let settingsLabel = SKLabelNode(fontNamed: "My Font")
        settingsLabel.text = "SETTINGS"
        settingsLabel.fontSize = 35
        settingsLabel.position = CGPoint(x:-200, y: -35)
        settingsLabel.zPosition = 0.1
        self.addChild(settingsLabel)
        
        let creditsLabel = SKLabelNode(fontNamed: "My Font")
        creditsLabel.text = "CREDITS"
        creditsLabel.fontSize = 35
        creditsLabel.position = CGPoint(x:200, y: -35)
        creditsLabel.zPosition = 0.1
        self.addChild(creditsLabel)
        
        let tutorialLabel = SKLabelNode(fontNamed: "My Font")
        tutorialLabel.text = "TUTORIAL"
        tutorialLabel.fontSize = 40
        tutorialLabel.position = CGPoint(x:0, y: 270)
        tutorialLabel.zPosition = 0.1
        self.addChild(tutorialLabel)
        
        title = SKLabelNode(fontNamed: "My Font")
        title.text = "MAGNUM OPUS"
        title.yScale = title.yScale * 1.5
        title.xScale = title.xScale * 1.2
        title.fontSize = 130
        title.position = CGPoint(x: frame.midX, y: 500)
        title.zPosition = 1
    
        
        self.addChild(title)
        
        print("yo")
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let rotate = SKAction.rotate(byAngle: CGFloat(-M_PI * 1.5), duration: 0.5)
       
        for touch in touches {
            let location = touch.location(in: self)
            let node : SKNode = self.atPoint(location)
            
                if node.name == "begin two player" {
                print("Start two player game")
                node.run(rotate)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    if let view = self.view as! SKView? {
                        // Load the SKScene from 'newMenu.sks'
                        if let scene = SKScene(fileNamed: "naming") {
                            // Set the scale mode to scale to fit the window
                            scene.scaleMode = .aspectFill
                            let transition = SKTransition.fade(withDuration: 1)
                            
                            // Present the scene
                            view.presentScene(scene, transition: transition)
                        }
                    }
                    


                }
            }
            if node.name == "tutorial"{
                print("Tutorial")
                node.run(rotate)
                
                
            }
            if node.name == "settings"{
                print("Settings")
                node.run(rotate)
            }
            if node.name == "credits"{
                print("Credits")
                node.run(rotate)
            }
            if node.name == "single player"{
                print("Start Single-Player Game")
                node.run(rotate)
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
       
    }
   


}
