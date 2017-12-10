//
//  TutorialIntro.swift
//  MagnumOpus
//
//  Created by Elliot Richard John Winch on 12/9/17.
//  Copyright © 2017 nyu.edu. All rights reserved.
//

import Foundation
import SpriteKit

class TutorialIntro : SKScene {
    
    var mainLabel : SKLabelNode
    //multiple lines are stored as children of the mainLabel node
    var supportLabel : SKLabelNode
    
    var mainLabelStrings = [[String]]()
    var fontSizes = [CGFloat]()
    var events = [Int: () -> ()]()
    var currentIndex = 0
    let maxNumLines = 5
    
    var tapToContinueTimer : Double = 0
    let timeToShowTapToContinue : Double = 1
    
    required init?(coder aDecoder: NSCoder) {
        mainLabelStrings.append(["Welcome To Magnum Opus", "A Two-Player", "Card Game for iOS"])
        mainLabelStrings.append(["The objective of Magnum Opus", "is to draw a perfect hand"])
        mainLabelStrings.append(["A perfect hand", "looks like this"])
        
        fontSizes.append(64)
        fontSizes.append(48)
        
        //Have to init these variables before call to super (or make them optional but that's more annoying)
        mainLabel = SKLabelNode()
        supportLabel = SKLabelNode()
        
        super.init(coder: aDecoder)
        
        mainLabel = self.childNode(withName: "MainLabel") as! SKLabelNode
        supportLabel = self.childNode(withName: "TapToContinueLabel") as! SKLabelNode
        
        let exampleWinningHand = [1, 2, 3, 4, 11, 11, 11]

        events[2] = {
            for i in 0..<7{
                let card = Card(value: Value(rawValue: exampleWinningHand[i])!, tag: i, player: nil)
                let cardNode = CardNode(card: card, imageNamed: "inverted" + String(card.getRawValue()), color: UIColor.white, size: CGSize(width:240,height:340))
                
                self.addChild(cardNode)
                
                cardNode.position = CGPoint(x:i * 80 + 120, y: -500) //starts 500 off screen
                cardNode.zPosition = CGFloat(i)
                
                let cardMoveInAnimation = SKAction.move(by: CGVector(dx: 0, dy: 667), duration: 0.8)
                cardMoveInAnimation.timingMode = .easeOut
                
                cardNode.run(cardMoveInAnimation)
            }
        }
        
        print(events[2]!)
        
        for i in 0..<maxNumLines{
            let multiLineNode = SKLabelNode()
            multiLineNode.fontName = "My Font"
            multiLineNode.fontSize = 48
            multiLineNode.name = "MultiLineNode"
            multiLineNode.position = CGPoint(x: 0, y: -60 * (i + 1))
            
            mainLabel.addChild(multiLineNode)
        }
    }
    
    override func didMove(to view: SKView) {
        mainLabel.alpha = 0
        mainLabel.run(SKAction.fadeIn(withDuration: 0.6))
        mainLabel.fontName = "My Font"

        supportLabel.text = "Tap To Continue"
        supportLabel.fontName = "My Font"
        supportLabel.alpha = 0
        supportLabel.run ( SKAction.sequence([ SKAction.wait(forDuration: 0.6), SKAction.fadeIn(withDuration: 0.6)]))
        
        nextText()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        supportLabel.alpha = 0

        if(currentIndex >= mainLabelStrings.count){
            //load next scene
        } else {
            nextText()
        }
    }
    
    func nextText(){
        let changeText = SKAction.customAction(withDuration: 0.001, actionBlock: { node, elapsedTime in
            
            self.mainLabel.text = self.mainLabelStrings[self.currentIndex][0]
            
            var i = 0
            for child in self.mainLabel.children as! [SKLabelNode] {
                i+=1
                
                if(i >= self.mainLabelStrings[self.currentIndex].count){
                    child.text = ""
                    continue
                }
                
                child.text = self.mainLabelStrings[self.currentIndex][i]
            }
            
            if(self.currentIndex < self.fontSizes.count){
                self.mainLabel.fontSize = self.fontSizes[self.currentIndex]
            }
            
            if(self.events.keys.contains(self.currentIndex)){
                self.events[self.currentIndex]!();
            }
            
            self.currentIndex+=1
        })
        
        mainLabel.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.3), changeText, SKAction.fadeIn(withDuration: 0.3)]))
        
        supportLabel.alpha = 0
    }
    
    override func update(_ currentTime: TimeInterval) {
        tapToContinueTimer += currentTime
        
        if(tapToContinueTimer > timeToShowTapToContinue){
            tapToContinueTimer = 0
            supportLabel.run ( SKAction.fadeIn(withDuration: 0.6))
        }
    }
}
