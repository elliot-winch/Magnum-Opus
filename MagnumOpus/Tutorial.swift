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
    var tutorialBoxTexts = [[String]]()
    let maxLines = 5
    var currentTipIndex = -1
    var events = [Int: () -> ()]()
    
    
    required init?(coder aDecoder: NSCoder) {
        
        tutorialBoxPositions.append(CGPoint(x: 300, y:300))
        tutorialBoxTexts.append(["Press Me To Continue The Tutorial!"])
        
        tutorialBoxPositions.append(CGPoint(x: 300, y:400))
        tutorialBoxTexts.append(["This is your hand"])
        
        tutorialBoxPositions.append(CGPoint(x: 300, y:400))
        tutorialBoxTexts.append(["This is your opponent's hand","Magnum Opus is played open handed"])
        
        tutorialBoxPositions.append(CGPoint(x: 300, y:400))
        tutorialBoxTexts.append(["This number is the number of cards", "in your draw deck"])
        
        tutorialBoxPositions.append(CGPoint(x: 300, y:400))
        tutorialBoxTexts.append(["This number is the number of cards", "in your discard pile"])
        
        tutorialBoxPositions.append(CGPoint(x: 300, y:400))
        tutorialBoxTexts.append(["This is the store", "We will come back to this shortly"])
        
        tutorialBoxPositions.append(CGPoint(x: 300, y:400))
        tutorialBoxTexts.append(["At the start of the round,", "you draw seven cards from", "your draw deck"])
        
        tutorialBoxPositions.append(CGPoint(x: 300, y:400))
        tutorialBoxTexts.append(["If there are not enough cards", "in your draw deck,", "you shuffle your discard pile", "and it becomes your draw deck"])
        
        tutorialBoxPositions.append(CGPoint(x: 300, y:400))
        tutorialBoxTexts.append(["Once you have draw your hand,", "you check to see if", "you have won"])
        
        tutorialBoxPositions.append(CGPoint(x: 300, y:400))
        tutorialBoxTexts.append(["Remember:", "this means you've drawn", "a meld of three and", "a meld of four"])
        
        tutorialBoxPositions.append(CGPoint(x: 300, y:400))
        tutorialBoxTexts.append(["If neither player has won,", "you play the round"])
        
        tutorialBoxPositions.append(CGPoint(x: 300, y:400))
        tutorialBoxTexts.append(["Players take it in turns", "to trade meld of size", "two or greater", "for a single card in the store"])
        
        tutorialBoxPositions.append(CGPoint(x: 300, y:400))
        tutorialBoxTexts.append(["Try it now!", "Trade in the 4 and the 5", "in your hand", "for the Q on the store"])
        
        //Touch lock off
        tutorialBoxPositions.append(CGPoint(x: 300, y:400))
        tutorialBoxTexts.append(["Tap on the 4", "to select it"])
        
        //Touch lock off
        tutorialBoxPositions.append(CGPoint(x: 300, y:400))
        tutorialBoxTexts.append(["Tap on the 5", "to select it too"])
        
        //Touch lock off
        tutorialBoxPositions.append(CGPoint(x: 300, y:400))
        tutorialBoxTexts.append(["The store lights up", "if you have selected", "a valid meld"])
        
        //Touch lock off
        tutorialBoxPositions.append(CGPoint(x: 300, y:400))
        tutorialBoxTexts.append(["Reminder: a valid meld for trading", "is a run or of-a-kind", "of size two or greater"])
        
        //only touch the store card
        tutorialBoxPositions.append(CGPoint(x: 300, y:400))
        tutorialBoxTexts.append(["Good!", "Now it is your opponent's turn"])
        
        //oppoent takes turn
        tutorialBoxPositions.append(CGPoint(x: 300, y:400))
        tutorialBoxTexts.append(["You take turns to trade", "cards with the store", "until both players", "hit the pass button"])
        
        tutorialBoxPositions.append(CGPoint(x: 300, y:400))
        tutorialBoxTexts.append(["The store can hold", "up to eight cards"])
        
        tutorialBoxPositions.append(CGPoint(x: 300, y:400))
        tutorialBoxTexts.append(["If you are happy with your hand,", "or you cannot make any more trades", "you can pass for the rest of the round"])
        
        tutorialBoxPositions.append(CGPoint(x: 300, y:400))
        tutorialBoxTexts.append(["The player that passes", "first gets to play first", "in the next round"])
        
        tutorialBoxPositions.append(CGPoint(x: 300, y:400))
        tutorialBoxTexts.append(["Once a player passes, their" , "opponent can makes as many trades", "as they see fit before they", "too opt to pass"])
        
        tutorialBoxPositions.append(CGPoint(x: 300, y:400))
        tutorialBoxTexts.append(["And that's it.", "Thank you for completing", "the Magnum Opus Tutorial"])
        
        tutorialBoxPositions.append(CGPoint(x: 300, y:400))
        tutorialBoxTexts.append(["To play a full two player game", "select 'Begin Two Player'", "from the main menu"])

        
        players = [Player]()
        playersInRound = [Player]()
        store = Store()
        
        self.currentPlayerIndex = 0
        
        pausedForTutorial = true
        
        tutorialBoxLabel = SKLabelNode()
        tutorialBoxLabel.name = "Tutorial Box"
        tutorialBoxLabel.fontName = "My Font"
        tutorialBoxLabel.fontSize = 48
        tutorialBoxLabel.horizontalAlignmentMode = .center
        tutorialBoxLabel.verticalAlignmentMode = .center
        tutorialBoxLabel.zPosition = 1000
        
        tutorialBoxBackground = SKSpriteNode(color: UIColor.blue, size: CGSize(width: 300, height: 300))
        tutorialBoxBackground.alpha = 0.2
        tutorialBoxBackground.zPosition = 1
        tutorialBoxBackground.name = "Tutorial Box"

        super.init(coder: aDecoder)
        
        players.append(Player(id: 0, handSize: 7, parent: self, name : ""))
        players.append(Player(id: 1, handSize: 7, parent: self, name : ""))
        currentPlayerIndex = 0//Int(arc4random_uniform(UInt32(players.count)))
        currentPlayer = players[currentPlayerIndex]
        
        store.parent = self.childNode(withName: "StoreBackground")!
        
        self.addChild(tutorialBoxLabel)
        tutorialBoxLabel.addChild(tutorialBoxBackground)
        
        
        for i in 0..<maxLines{
            let aditionalLine = SKLabelNode()
            tutorialBoxLabel.addChild(aditionalLine)

            aditionalLine.name = "Tutorial Box"
            aditionalLine.fontName = "My Font"
            aditionalLine.fontSize = 48
            aditionalLine.horizontalAlignmentMode = .center
            aditionalLine.verticalAlignmentMode = .center
            aditionalLine.position = CGPoint(x: 0, y: -40 * (i + 1))
        }
        
        events[1] = {
            self.begin()
        }
        
        displayNextTutorialTip()

    }
    
    func displayNextTutorialTip(){
        currentTipIndex+=1

        if(currentTipIndex >= tutorialBoxTexts.count){
            if(currentTipIndex >= tutorialBoxTexts.count){
                if let scene = SKScene(fileNamed: "newMenu") {
                    scene.scaleMode = .aspectFill
                    let transition = SKTransition.fade(withDuration: 1)
                    
                    self.view!.presentScene(scene, transition: transition)
                }
            }
            return
        }
        
        tutorialBoxLabel.isHidden = false
        
        let moveAnimation = SKAction.move(to: tutorialBoxPositions[currentTipIndex], duration: 0.2)
        moveAnimation.timingMode = .easeInEaseOut
        
        let changeText = SKAction.customAction(withDuration: 0.001) { node, elaspedTime in
            self.tutorialBoxLabel.text = self.tutorialBoxTexts[self.currentTipIndex][0]
            
            var i = 0
            for child in self.tutorialBoxLabel.children {
                if let labelChild = child as? SKLabelNode{
                    i+=1
                
                    if(i >= self.tutorialBoxTexts[self.currentTipIndex].count){
                        labelChild.text = ""
                        continue
                    }
                
                    labelChild.text = self.tutorialBoxTexts[self.currentTipIndex][i]
                }
            }
        }
        
        let changeTextAnimation = SKAction.sequence([SKAction.fadeOut(withDuration: 0.1), changeText, SKAction.fadeIn(withDuration: 0.1)])
        
        tutorialBoxLabel.run(moveAnimation)
        tutorialBoxLabel.run(changeTextAnimation)
        
        var longestStringLength = 0
        for i in 0..<tutorialBoxTexts[self.currentTipIndex].count{
            if(tutorialBoxTexts[self.currentTipIndex][i].characters.count > longestStringLength){
                longestStringLength = tutorialBoxTexts[self.currentTipIndex][i].characters.count
            }
        }
        
        
        let tutorialBoxNewSize = CGSize(width: CGFloat(longestStringLength * 10 + 10), height: CGFloat(tutorialBoxTexts[self.currentTipIndex].count + 1) * tutorialBoxLabel.frame.size.height + 10)
        
        
        tutorialBoxBackground.run(SKAction.resize(toWidth: tutorialBoxNewSize.width, height: tutorialBoxNewSize.height, duration: 0.2))
        
        pausedForTutorial = true
        
        if(self.events.keys.contains(self.currentTipIndex)){
            self.events[self.currentTipIndex]!();
        }
        

    }
    
    func begin() {
        
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
            if (touchedNode!.name == "Tutorial Box"){
                displayNextTutorialTip()
            }
            
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
