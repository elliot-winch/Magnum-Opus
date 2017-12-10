
//  GameScene.swift
//  MagnumOpus
//
//  Created by Nina Demirjian on 11/14/17.
//  Copyright © 2017 nyu.edu. All rights reserved.
//
//meat of game
import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var myView : UIViewController?
    
    var playerOneName : String = "Player One"
    var playerTwoName : String = "Player Two"
    var players : [Player]
    var playersInRound : [Player]
    var currentPlayer : Player?
    var passingPlayer: Player?
    var currentPlayerIndex : Int
    var store : Store
    
    required init?(coder aDecoder: NSCoder) {
        players = [Player]()
        playersInRound = [Player]()
        store = Store()
        
        self.currentPlayerIndex = 0
        
        super.init(coder: aDecoder)
        players.append(Player(id: 0, handSize: 7, parent: self, name : ""))
        players.append(Player(id: 1, handSize: 7, parent: self, name : ""))
        currentPlayerIndex = 0//Int(arc4random_uniform(UInt32(players.count)))
        currentPlayer = players[currentPlayerIndex]
        
        store.parent = self.childNode(withName: "StoreBackground")!
    }
    
    override func didMove(to view: SKView) {
        
        playerOneName = GameViewController.playerOneName
        playerTwoName = GameViewController.playerTwoName
        
        players[0].name = playerOneName
        players[1].name = playerTwoName
        
        //Player One Name Label
        let nameLabelPlayerOne = SKLabelNode()
        nameLabelPlayerOne.name = "Player One Label"
        nameLabelPlayerOne.text = playerOneName
        
        nameLabelPlayerOne.position = CGPoint(x: 360, y: 450)
        GameScene.setLabelToStandard(label: nameLabelPlayerOne)
        self.addChild(nameLabelPlayerOne)

        
        //Player Two Name Label
        let nameLabelPlayerTwo = SKLabelNode()
        nameLabelPlayerTwo.name = "Player Two Label"
        nameLabelPlayerTwo.text = playerTwoName
        
        nameLabelPlayerTwo.zRotation = CGFloat.pi
        nameLabelPlayerTwo.position = CGPoint(x: 360, y: 900)
        GameScene.setLabelToStandard(label: nameLabelPlayerTwo)
        self.addChild(nameLabelPlayerTwo)
        
        
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
    
    static func setLabelToStandard(label: SKLabelNode){
        label.fontName = "My Font"
        label.fontSize = 100
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        label.zPosition = 5
        
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let positionInScene = touch.location(in: self)
        let touchedNode = self.atPoint(positionInScene) as? SKSpriteNode
        
        if(touchedNode != nil){
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
                
            } else {
                if (touchedNode!.name == "PassButton"){
                    
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
        let buttonRotate = SKAction.rotate(byAngle: CGFloat.pi, duration: 0)
        buttonMoveAction.timingMode = .easeInEaseOut
        let buttonSequence = SKAction.sequence([SKAction.wait(forDuration: withDelay + 0.3), buttonRotate, buttonMoveAction])
        
        self.childNode(withName: "QuitButton")?.run(buttonSequence)
        self.childNode(withName: "PassButton")?.run(buttonSequence)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {}
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {}
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {}
}
