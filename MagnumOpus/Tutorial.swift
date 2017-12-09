//
//  Tutorial.swift
//  MagnumOpus
//
//  Created by Elliot Richard John Winch on 12/8/17.
//  Copyright © 2017 nyu.edu. All rights reserved.
//

import Foundation
import SpriteKit

class Tutorial : SKScene {
    
    var myView : UIViewController?
    
    var players : [Player]
    var playersInRound : [Player]
    var currentPlayer : Player?
    var passingPlayer: Player?
    var currentPlayerIndex : Int
    var store : Store
    
    var pausedForTutorial : Bool
    let tutorialBoxLabel : SKLabelNode
    let tutorialBoxBackground : SKSpriteNode
    var tutorialBoxPositions = [CGPoint]()
    var tutorialBoxTexts = [String]()
    var tutorialBoxSizes = [CGSize]()
    var currentTipIndex = -1
    
    
    required init?(coder aDecoder: NSCoder) {
        tutorialBoxPositions.append(CGPoint(x: 300, y:300))
        tutorialBoxTexts.append("It's a welcome!")
        tutorialBoxSizes.append(CGSize(width: 100, height: 100))
        
        tutorialBoxPositions.append(CGPoint(x: 300, y:400))
        tutorialBoxTexts.append("It's a continuation!")
        tutorialBoxSizes.append(CGSize(width: 150, height: 50))

        
        players = [Player]()
        playersInRound = [Player]()
        store = Store()
        
        self.currentPlayerIndex = 0
        
        pausedForTutorial = true
        
        tutorialBoxLabel = SKLabelNode()
        tutorialBoxLabel.name = "Tutorial Box"
        tutorialBoxLabel.fontName = "My Font"
        tutorialBoxLabel.fontSize = 30
        tutorialBoxLabel.horizontalAlignmentMode = .center
        tutorialBoxLabel.verticalAlignmentMode = .top
        tutorialBoxLabel.zPosition = 1000
        
        tutorialBoxBackground = SKSpriteNode(color: UIColor.blue, size: CGSize(width: 300, height: 300))
        tutorialBoxBackground.alpha = 0.2
        tutorialBoxBackground.zPosition = 1000
        tutorialBoxBackground.name = "Tutorial Box"

        super.init(coder: aDecoder)
        players.append(Player(id: 0, handSize: 7, parent: self, name : ""))
        players.append(Player(id: 1, handSize: 7, parent: self, name : ""))
        currentPlayerIndex = 0//Int(arc4random_uniform(UInt32(players.count)))
        currentPlayer = players[currentPlayerIndex]
        
        store.parent = self.childNode(withName: "StoreBackground")!
        self.addChild(tutorialBoxLabel)
        tutorialBoxLabel.addChild(tutorialBoxBackground)
        
        displayNextTutorialTip()

    }
    
    func displayNextTutorialTip(){
        currentTipIndex+=1

        if(currentTipIndex >= tutorialBoxTexts.count){
            print("Tutorial is finished")
            return
        }
        
        tutorialBoxLabel.isHidden = false
        
        let moveAnimation = SKAction.move(to: tutorialBoxPositions[currentTipIndex], duration: 0.2)
        moveAnimation.timingMode = .easeInEaseOut
        
        let changeText = SKAction.customAction(withDuration: 0.001) { node, elaspedTime in
            self.tutorialBoxLabel.text = self.tutorialBoxTexts[self.currentTipIndex]
        }
        
        let changeTextAnimation = SKAction.sequence([SKAction.fadeOut(withDuration: 0.1), changeText, SKAction.fadeIn(withDuration: 0.1)])
        
        tutorialBoxLabel.run(moveAnimation)
        tutorialBoxLabel.run(changeTextAnimation)
        tutorialBoxBackground.run(SKAction.resize(toWidth: tutorialBoxSizes[currentTipIndex].width, height:tutorialBoxSizes[currentTipIndex].height, duration: 0.2))
        
        pausedForTutorial = true

    }
    
    override func didMove(to view: SKView) {
        
        if(players.count != 2){
            print("Increase number of players, son")
        }
        
        let splitDeck = Deck()
        
        for i in 1...52{
            let c = Card(value: i % 13 + 1, tag: i)
            let d = Card(value: i % 13 + 1, tag: i + 52)
            
            splitDeck.add(c: c)
            store.drawDeck.add(c: d)
        }
        
        for p : Player in players{
            //change to accomodate for more layers
            for _ in 0..<26{
                let card = splitDeck.draw()!
                p.addToDrawDeck(card: card)
                card.player = p
            }
        }
        
        for p : Player in players{
            playersInRound.append(p)
            
            p.drawFreshHand()
        }
        
        self.childNode(withName: "StoreBackground")!.position = CGPoint(x: 0, y: 150 + (534 * currentPlayer!.playerNum))
        store.roundStart()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let positionInScene = touch.location(in: self)
        let touchedNode = self.atPoint(positionInScene) as? SKSpriteNode
        
        if(touchedNode != nil){
            if(pausedForTutorial == false){
                if let cardNode = touchedNode as? CardNode{
                    switch(cardNode.card.state){
                    case State.InHand:
                        if(cardNode.card.player === currentPlayer){
                            currentPlayer!.moveFromHandToStaging(cardNode: cardNode)
                            
                            if(isMeld(cards: currentPlayer!.staging)){
                                store.changeAllColor(color: UIColor.white)
                            } else {
                                store.changeAllColor(color: UIColor.gray)
                            }
                        }
                    
                    case State.InStaging:
                        currentPlayer!.moveFromStagingToHand(cardNode: cardNode)
                    
                        if(isMeld(cards: currentPlayer!.staging)){
                            store.changeAllColor(color: UIColor.white)
                        } else {
                            store.changeAllColor(color: UIColor.gray)
                        }
                    case State.InStore:
                        if(isMeld(cards: currentPlayer!.staging)){
                            store.removeFromCurrentStore(cardNode: cardNode)
                            currentPlayer!.moveFromStoreToHand(cardNode: cardNode)
                            currentPlayer!.moveFromStagingToStore(store: store)
                            store.changeAllColor(color: UIColor.gray)
                        
                            endTurn(withStoreAnimationDelay: 0.6)
                        }
                    case State.InDeck:
                        print("Error: Card with state 'InDeck' should not be displayed")
                    }
                }
            } else {
                if (pausedForTutorial == false && touchedNode!.name == "PassButton"){
                    
                    for i in (0..<playersInRound.count).reversed(){
                        if(playersInRound[i] === currentPlayer!){
                            playersInRound.remove(at: i)
                        }
                        
                        if(passingPlayer == nil){
                            passingPlayer = currentPlayer!
                        }
                    }
                    
                    if(playersInRound.count <= 0){
                        endRound(withStoreAnimationDelay: 0.6)
                    } else {
                        endTurn(withStoreAnimationDelay: 0.1)
                    }
                }
                else if (touchedNode!.name == "QuitButton"){
                    
                    //create alert
                    let alert = UIAlertController(title: "Returning to Menu", message: "Are you sure you want to quit?", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: {action in
                        // Load the SKScene from 'newMenu.sks'
                        if let scene = SKScene(fileNamed: "newMenu") {
                            // Set the scale mode to scale to fit the window
                            scene.scaleMode = .aspectFill
                            let transition = SKTransition.fade(withDuration: 1)
                            
                            // Present the scene
                            self.view!.presentScene(scene, transition: transition)
                        }
                    }))
                    
                    
                    alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
                    
                    
                    GameViewController.instance.present(alert, animated: true, completion: nil)
                }
                else if (touchedNode!.name == "Tutorial Box"){
                    displayNextTutorialTip()
                }
            }
        }
        
    }
    
    
    func endRound(withStoreAnimationDelay: Double){
        store.roundEnd()
        
        for p : Player in players{
            p.discardEntireHand()
            
            //Start of round
            playersInRound.append(p)
            
            if(p.drawFreshHand()){
                print( "Player name has won!")
            }
        }
        
        if(passingPlayer != nil){
            currentPlayer = passingPlayer!
            currentPlayerIndex = currentPlayer!.playerNum
            passingPlayer = nil
        }
        
        animateMovingStore(withDelay: withStoreAnimationDelay)
        store.roundStart()
        
    }
    
    func endTurn(withStoreAnimationDelay: Double){
        currentPlayer!.endTurn()
        
        let previousPlayer = currentPlayer!
        
        currentPlayerIndex+=1
        currentPlayer! = playersInRound[currentPlayerIndex % playersInRound.count]
        
        if(previousPlayer !== currentPlayer!){
            animateMovingStore(withDelay: withStoreAnimationDelay)
        }
    }
    
    func animateMovingStore(withDelay: Double) {
        let wait = SKAction.wait(forDuration: withDelay)
        let moveAction = SKAction.move(to: CGPoint(x: 0, y: 150 + (484 * currentPlayer!.playerNum) ), duration: 0.5)
        moveAction.timingMode = .easeInEaseOut
        let sequence = SKAction.sequence([wait, moveAction])
        self.childNode(withName: "StoreBackground")!.run(sequence)
        
        let buttonMoveAction = SKAction.move(by: CGVector(dx: 0, dy: (currentPlayer!.playerNum == 0 ? 186 : -186)), duration: 0.5)
        let buttonRotate = SKAction.rotate(byAngle: CGFloat(Double.pi/1.0), duration: 0)
        buttonMoveAction.timingMode = .easeInEaseOut
        let buttonSequence = SKAction.sequence([SKAction.wait(forDuration: withDelay + 0.3), buttonRotate, buttonMoveAction])
        
        self.childNode(withName: "QuitButton")?.run(buttonSequence)
        self.childNode(withName: "PassButton")?.run(buttonSequence)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {}
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {}
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {}
}
