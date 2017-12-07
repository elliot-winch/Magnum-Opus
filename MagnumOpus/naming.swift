//
//  naming.swift
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

class naming: SKScene {
    
    //var playerOneBox : UITextField!
    
    var enter : SKSpriteNode!
    var playerOneBox : UITextField = UITextField()
    var playerTwoBox : UITextField = UITextField()
    var playerOneLabel : SKLabelNode!
    var playerTwoLabel : SKLabelNode!
    
    
    override func didMove(to view: SKView){
        
        playerOneBox.font =  UIFont(name: "My Font", size: 16)
        playerOneBox.textColor = UIColor.white
        playerOneBox.backgroundColor = UIColor.darkGray
        playerOneBox.frame = CGRect(x: 150, y: 200, width: 175, height: 40)
        playerOneBox.text = "PLAYER ONE";
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.view?.addSubview(self.playerOneBox)
        }
        
        
        playerTwoBox.font =  UIFont(name: "My Font", size: 16)
        playerTwoBox.textColor = UIColor.white
        playerTwoBox.backgroundColor = UIColor.darkGray
        playerTwoBox.frame = CGRect(x: 150, y: 280, width: 175, height: 40)
        playerTwoBox.text = "PLAYER TWO";
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.view?.addSubview(self.playerTwoBox)
        }
        
        let playerOneLabel = SKLabelNode()
        playerOneLabel.text = "1."
        playerOneLabel.fontName = "Futura"
        playerOneLabel.fontSize = 45
        playerOneLabel.position = CGPoint(x: -100, y: 190)
        self.addChild(playerOneLabel)
        
        let playerTwoLabel = SKLabelNode()
        playerTwoLabel.text = "2."
        playerTwoLabel.fontName = "Futura"
        playerTwoLabel.fontSize = 45
        playerTwoLabel.position = CGPoint(x: -100, y: 32)
        self.addChild(playerTwoLabel)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //let rotate = SKAction.rotate(byAngle: CGFloat(-Double.pi * 1.5), duration: 0.5)
        for touch in touches {
            let location = touch.location(in: self)
            let node : SKNode = self.atPoint(location)
            
            if node.name == "enter" {
                if let scene = SKScene(fileNamed: "GameScene") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    let transition = SKTransition.fade(withDuration: 1)
                    GameViewController.playerOneName = (playerOneBox.text?.uppercased())!
                    GameViewController.playerTwoName = (playerTwoBox.text?.uppercased())!
                    playerOneBox.removeFromSuperview()
                    playerTwoBox.removeFromSuperview()
                    // Present the scene
                    view!.presentScene(scene, transition: transition)
                }
            }
        }
    }
    override func update(_ currentTime: TimeInterval) {
        
    }
    
}


