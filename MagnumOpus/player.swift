//
//  player.swift
//  Merchant
//
//  Created by Elliot Winch on 14/11/2017.
//  Copyright © 2017 nyu.edu. All rights reserved.
//
import Foundation
import SpriteKit

public class Player {
    
    let playerNum : Int
    var parent : SKNode
    var staging : [CardNode]
    
    let drawDeck : DrawDeck
    let hand : Hand
    
    let drawNumLabel : SKLabelNode
    let discardNumLabel : SKLabelNode
    
    var name : String
    
    init(id: Int, handSize: Int, parent: SKNode, name: String){
        playerNum = id
        drawDeck = DrawDeck()
        hand = Hand(handSize: handSize)
        staging = [CardNode]()
        self.name = name
        
        self.parent = parent
        
        self.drawNumLabel = SKLabelNode()
        drawNumLabel.name = "Player \(playerNum) Draw Label"
        
        drawNumLabel.position = CGPoint(x: 680 - (640 * playerNum), y: 900 - (450 * playerNum))
        drawNumLabel.zRotation = CGFloat(Double.pi - (Double.pi * Double(playerNum)))
        
        GameScene.setLabelToStandard(label: drawNumLabel)
        
        parent.addChild(drawNumLabel)
        
        self.discardNumLabel = SKLabelNode()
        discardNumLabel.name = "Player \(playerNum) Discard Label"
        
        discardNumLabel.position = CGPoint(x: 40 + (640 * playerNum), y: 900 - (450 * playerNum))
        discardNumLabel.zRotation = CGFloat(Double.pi - (Double.pi * Double(playerNum)))

        
        GameScene.setLabelToStandard(label: discardNumLabel)
        
        parent.addChild(discardNumLabel)

    }
    
    func drawFreshHand() -> Bool{
        for _ in 0..<hand.getMaxHandSize(){
            let card = drawDeck.draw();
            
            hand.add(c: CardNode(card: card, imageNamed: cardSetSelected + String(card.getRawValue()), color: UIColor.white, size: CGSize(width:240,height:340)))
        }
        
        //        drawingPileSizeText.text = String(drawDeck.deck.count)
        //        discardPileSizeText.text = String(drawDeck.discardPile.deck.count)
        
        hand.sort(reversed: playerNum == 0)
        
        let cardMoveInAnimation = SKAction.move(by: CGVector(dx: 0, dy:  -500 + (playerNum * 1000)), duration: 0.5)
        cardMoveInAnimation.timingMode = .easeOut
        
        for i in 0..<hand.hand.count{
            let cardNode = hand.hand[i]
            
            addCardToHand(cardNode: cardNode)
            cardNode.size = CGSize(width: 240, height: 340)
            cardNode.zRotation = CGFloat(Double(playerNum - 1) * Double.pi)
            
            cardNode.position = CGPoint(x:i * 80 + 120, y: 1634 - (playerNum * 1900)) //starts 500 off screen
            cardNode.zPosition = CGFloat(i)
            
            let cardDelayAnimation = SKAction.wait(forDuration: Double(i) * 0.1)
            let cardEntrance = SKAction.sequence([cardDelayAnimation, cardMoveInAnimation])
            
            cardNode.run(cardEntrance)
            
            cardNode.name = "card-" + String(cardNode.card.tag)
        }
        
        drawNumLabel.text = String(describing: String(describing: self.drawDeck.deck.count))
        discardNumLabel.text = String(describing: self.drawDeck.discardPile.deck.count)
        
        return (isMeld(cardSlice: hand.hand[0...2]) && isMeld(cardSlice: hand.hand[3...6])) || (isMeld(cardSlice: hand.hand[0...3]) && isMeld(cardSlice: hand.hand[4...6]))
    }
    
    func addCardToHand(cardNode: CardNode){
        cardNode.card.state = .InHand
        cardNode.card.player = self
        cardNode.color = UIColor.white

        hand.add(c: cardNode)
        parent.addChild(cardNode)
    }
    
    func moveFromStagingToStore(store: Store){
        
        for i in (0..<staging.count).reversed(){
                        
            staging[i].removeFromParent()
            
            store.addToCurrentStore(cardNode: staging[i], withDelay: 0, withStartingPosition: CGPoint(x: staging[i].position.x - store.parent.position.x, y: staging[i].position.y - store.parent.position.y))
            
            staging.remove(at: i)
        }
    }
    
    func moveFromStoreToHand(cardNode: CardNode){
        addCardToHand(cardNode: cardNode)
        
        cardNode.run(SKAction.resize(toWidth: 240, height: 340, duration: 0.3))
        let rotationAnimation = SKAction.rotate(toAngle: CGFloat(Double(playerNum - 1) * Double.pi), duration: 0.3)
        rotationAnimation.timingMode = .easeInEaseOut
        cardNode.run(rotationAnimation)
        
        hand.sort(reversed: playerNum == 0)
        
        for i in 0..<hand.hand.count {
            let moveAnimation = SKAction.move(to: CGPoint(x:i * 80 + 120, y: 1334 - 200 - (playerNum * 900)), duration: 0.3)
            moveAnimation.timingMode = .easeInEaseOut
            hand.hand[i].run(moveAnimation)
            hand.hand[i].zPosition = CGFloat(i) + 100
            
            hand.hand[i].run(SKAction.sequence(
                [SKAction.wait(forDuration: 0.3),
                 SKAction.customAction(withDuration: 0.01) {node, elapsedTime in
                    self.hand.hand[i].zPosition = self.hand.hand[i].zPosition - CGFloat(100)}
                ]))
        }
        
    }
    
    func moveFromHandToStaging(cardNode: CardNode){
        cardNode.run(SKAction.move(by: CGVector(dx: 0, dy: -100 + (200 * playerNum)), duration: 0.1))
        
        staging.append(cardNode)
        cardNode.card.state = .InStaging
        
        hand.remove(card: cardNode)
    }
    
    func moveFromStagingToHand(cardNode: CardNode){
        cardNode.run(SKAction.move(by: CGVector(dx: 0, dy: 100 - (200 * playerNum)), duration: 0.1))
        
        for i in 0..<staging.count{
            if(cardNode.card.tag == staging[i].card.tag){
                staging.remove(at: i)
                break
            }
        }
        
        hand.add(c: cardNode)
        cardNode.card.state = .InHand
        
    }
    
    func discardEntireHand(){
        
        let cardMoveOutAnimation = SKAction.move(by: CGVector(dx: 0, dy:  1000 - (playerNum * 2000)), duration: 0.5)
        cardMoveOutAnimation.timingMode = .easeIn
        
        
        for i in (0..<hand.hand.count).reversed(){
            let c = hand.removeAt(i: i)
            drawDeck.add(c: c.card)
            
            let cardDelay = SKAction.wait(forDuration: 0.1 * Double(i))
            let deleteCard = SKAction.run({ c.removeFromParent() } )
            let sequence = SKAction.sequence([cardDelay, cardMoveOutAnimation, deleteCard])
            c.run(sequence)
        }
        
        for i in (0..<staging.count).reversed(){
            let c = staging.remove(at: i)
            drawDeck.add(c: c.card)
            
            let cardDelay = SKAction.wait(forDuration: 0.1 * Double(i))
            let deleteCard = SKAction.run({ c.removeFromParent() } )
            let sequence = SKAction.sequence([cardDelay, cardMoveOutAnimation, deleteCard])
            c.run(sequence)
        }
    }
    
    
    func endTurn(){
        for c : CardNode in staging{
            moveFromStagingToHand(cardNode: c)
        }
        
    }
    
    func addToDrawDeck(card: Card){
        drawDeck.add(c: card)
    }
}
