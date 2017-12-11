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
    
    var cardParent : SKNode
    
    var mainLabelStrings = [[String]]()
    var fontSizes = [CGFloat]()
    var events = [Int: () -> ()]()
    var currentIndex = 0
    let maxNumLines = 5
    
    var tapToContinueTimer : Double = 0
    let timeToShowTapToContinue : Double = 5
    var deltaTime : Double = 0
    var previousTime : Double = 0
    
    required init?(coder aDecoder: NSCoder) {
        mainLabelStrings.append(["Welcome To Magnum Opus", "A Two-Player", "Card Game for iOS"])
        mainLabelStrings.append(["The objective of Magnum Opus", "is to draw a perfect hand"])
        mainLabelStrings.append(["A perfect hand", "looks like this"])
        mainLabelStrings.append(["It contains two melds.", "A meld is a group of cards that either", " make a run (sequentially acsending cards)", "or have the same value"])
        mainLabelStrings.append(["This hand has a run of 4", "(A, 2, 3, 4)", "and three of a kind", "(J, J, J)"])
        mainLabelStrings.append(["Here is another example of a winning hand.", "It has a run of three", "(4, 5, 6)", "and a run of four.", "(J, Q, K, A)"])
        mainLabelStrings.append(["Here is another example of a winning hand.", "It has three of a kind", "(10, 10, 10)", "and four of a kind.", "(Q, Q, Q, Q)"])
        mainLabelStrings.append(["At the beginning of the game," , "you are dealt 26 cards.", "", "This is your personal draw deck.", "Any cards you discard go into", "you own personal discard pile."])
        
        
        
        fontSizes.append(48)
        fontSizes.append(36)
        
        cardParent = SKNode()
        cardParent.name = "cardParent"
        
        
        //Have to init these variables before call to super (or make them optional but that's more annoying)
        mainLabel = SKLabelNode()
        supportLabel = SKLabelNode()
        
        super.init(coder: aDecoder)
        
        self.addChild(cardParent)
        
        mainLabel = self.childNode(withName: "MainLabel") as! SKLabelNode
        supportLabel = self.childNode(withName: "TapToContinueLabel") as! SKLabelNode
        

        events[2] = {
            self.spawnExampleCards( cards: [1, 2, 3, 4, 11, 11, 11] )
        }
        
        events[5] = {
            self.removeAllCardsFromScene()
            self.spawnExampleCards(cards: [4, 5, 6, 11, 12, 13, 1])
        }
        
        events[6] = {
            self.removeAllCardsFromScene()
            self.spawnExampleCards(cards: [10, 10, 10, 12, 12, 12, 12])
        }
        
        events[7] = {
            self.removeAllCardsFromScene()
        }
        
        for i in 0..<maxNumLines{
            let multiLineNode = SKLabelNode()
            multiLineNode.fontName = "Futura"
            multiLineNode.fontSize = 36
            multiLineNode.name = "MultiLineNode"
            multiLineNode.position = CGPoint(x: 0, y: -60 * (i + 1))
            
            mainLabel.addChild(multiLineNode)
        }
        
    }
    
    func spawnExampleCards(cards: [Int]){
        for i in 0..<cards.count{
            let card = Card(value: Value(rawValue: cards[i])!, tag: i, player: nil)
            let cardNode = CardNode(card: card, imageNamed: cardSetSelected + String(card.getRawValue()), color: UIColor.white, size: CGSize(width:240,height:340))
            
            self.cardParent.addChild(cardNode)
            
            cardNode.position = CGPoint(x:i * 80 - 230, y: -1000) //starts 500 off screen
            cardNode.zPosition = CGFloat(i) + 1
            
            let cardMoveInAnimation = SKAction.move(by: CGVector(dx: 0, dy: 900), duration: 1.2)
            cardMoveInAnimation.timingMode = .easeInEaseOut
            
            cardNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.1 * Double(i)), cardMoveInAnimation]))
        }
    }
    
    func removeAllCardsFromScene(){
        
        let deletionAnimation = SKAction.customAction(withDuration: 0.01) {
            node, elapasedTime in
            node.removeFromParent()
        }
        
        
        for i in 0..<self.cardParent.children.count{
            
            let cardMoveOutAnimation = SKAction.move(by: CGVector(dx: 0, dy: -900), duration: 1.2)
            cardMoveOutAnimation.timingMode = .easeInEaseOut
            
            self.cardParent.children[i].run(SKAction.sequence([SKAction.wait(forDuration: 0.1 * Double(i)), cardMoveOutAnimation, deletionAnimation]))
        }
    }
    
    
    override func didMove(to view: SKView) {
        

            self.mainLabel.alpha = 0
            self.mainLabel.colorBlendFactor = 1
            self.mainLabel.fontName = "Futura"

            self.supportLabel.text = "Tap To Continue"
            self.supportLabel.fontName = "Futura"
            self.supportLabel.alpha = 0
            self.supportLabel.colorBlendFactor = 1
        
        self.nextText()
        
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
            }
        
            supportLabel.alpha = 0

            if(currentIndex >= mainLabelStrings.count){
                if let scene = SKScene(fileNamed: "Tutorial") {
                    scene.scaleMode = .aspectFill
                    let transition = SKTransition.fade(withDuration: 1)
                
                    self.view!.presentScene(scene, transition: transition)
                }
            } else {
                nextText()
            }
        }
    }
    
    func nextText(){
        let changeText = SKAction.customAction(withDuration: 0.001, actionBlock: { node, elapsedTime in
            
            if(self.currentIndex < self.mainLabelStrings.count){
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
                    print(self.currentIndex)
                    self.events[self.currentIndex]!();
                }
            
                self.currentIndex+=1
            }
        })
        
        mainLabel.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.3), changeText, SKAction.fadeIn(withDuration: 0.3)]))
        
        tapToContinueTimer = 0
        supportLabel.alpha = 0
    }
    
    override func update(_ currentTime: TimeInterval) {        
        deltaTime = currentTime - previousTime
        previousTime = currentTime
        
        tapToContinueTimer += deltaTime
        
        if(tapToContinueTimer > timeToShowTapToContinue){
            tapToContinueTimer = 0
            supportLabel.run ( SKAction.fadeIn(withDuration: 0.6))
        }
    }
}
