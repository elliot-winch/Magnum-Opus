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

/*
 
 This class will now take you to the scene which has the same name as the tapped node.
 
 */

class newMenu: SKScene {
    
    var sceneNames = ["naming", "TutorialIntro", "SettingsScreen", "CreditsScreen"]
    
    var title:SKLabelNode!
    var backdrop: SKEmitterNode!
    var startButton : SKSpriteNode!
    var startLabel : SKLabelNode!
    var tutorialLabel : SKLabelNode!
    var settingsLabel : SKLabelNode!
    var creditsLabel : SKLabelNode!
    
    //Lods the menu
    override func didMove(to view: SKView) {
       
        let rotateSlow = SKAction.rotate(byAngle: CGFloat(-Double.pi * 0.5), duration: 10)
        let loopSlow = SKAction.repeatForever(rotateSlow)
        
        let startButton = SKSpriteNode(imageNamed: "startStar2.png")
        self.addChild(startButton)
        startButton.name = sceneNames[0]
        startButton.zPosition = 2
        startButton.position = CGPoint(x: 2, y: -440)
        startButton.size = CGSize(width: 90, height: 90)
        let rotate = SKAction.rotate(byAngle: CGFloat(-Double.pi * 0.5), duration: 5)
        let loop = SKAction.repeatForever(rotate)
        startButton.run(loop, withKey: "rotate")
        
        let tutorialButton = SKSpriteNode(imageNamed: "startStar2.png")
        self.addChild(tutorialButton)
        tutorialButton.name = sceneNames[1]
        tutorialButton.zPosition = 2
        tutorialButton.position = CGPoint(x: 0, y: 227)
        tutorialButton.size = CGSize(width: 80, height: 80)
        tutorialButton.run(loop, withKey: "rotate")
        
        let settingsButton = SKSpriteNode(imageNamed: "startStar2.png")
        self.addChild(settingsButton)
        settingsButton.name = "SettingsScreen"
        settingsButton.zPosition = 2
        settingsButton.position = CGPoint(x: -110  , y: -22)
        settingsButton.size = CGSize(width: 70, height: 70)
        settingsButton.run(loop, withKey: "rotate")
        
        let creditsButton = SKSpriteNode(imageNamed: "startStar2.png")
        self.addChild(creditsButton)
        creditsButton.name = "CreditsScreen"
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
                
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let rotate = SKAction.rotate(byAngle: CGFloat(-Double.pi * 1.5), duration: 0.5)
       
        for touch in touches {
            let location = touch.location(in: self)
            let node : SKNode? = self.atPoint(location)
            
            //Is the tapped node a sprite and has a valid scene name?
            if (node as? SKSpriteNode) != nil && node!.name != nil && sceneNames.contains(node!.name!){
                node!.run(rotate)
                launchScene(named: node!.name)
                print(node!.name!)
            }
        }
    }
    
    func launchScene(named: String?){
        if(named == nil){
            print("Error: Menu node not named")
            return
        }
        
        if(sceneNames.contains(named!)){
            
            //The scene's launch is delayed by 0.3 seconds so the spin animation can run
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            
                if let scene = SKScene(fileNamed: named!) {
                    scene.scaleMode = .aspectFill
                    let transition = SKTransition.fade(withDuration: 1)
                
                    self.view!.presentScene(scene, transition: transition)
                }
            }
        } else{
            print("Failed to switch scene; no scene named: \(named!)")
        }
    }


}
