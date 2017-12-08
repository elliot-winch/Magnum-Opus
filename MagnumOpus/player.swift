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
    var additionals : [SKNode]
    var staging : [CardNode]
    
    let drawDeck : DrawDeck
    let hand : Hand
    
    var name : String
    
    //    let drawingPileSizeText : SKLabelNode
    //    let discardPileSizeText : SKLabelNode
    //    let totalCardsSizeText : SKLabelNode
    //    let drawDeckNode : SKSpriteNode
    //    let discardPileNode : SKSpriteNode
    
    init(id: Int, handSize: Int, parent: SKNode, name: String){
        playerNum = id
        drawDeck = DrawDeck()
        hand = Hand(handSize: handSize)
        staging = [CardNode]()
        additionals = [SKNode]()
        self.name = name
        
        self.parent = parent
        
        //        drawingPileSizeText = SKLabelNode(fontNamed: "Futura")
        //        drawingPileSizeText.text = "0 "
        //        drawingPileSizeText.fontName = String(18)
        //        drawingPileSizeText.position = CGPoint(x: 140, y: 80)
        //        parent.addChild(drawingPileSizeText)
        //        additionals.append(drawingPileSizeText)
        //
        //        discardPileSizeText = SKLabelNode(fontNamed: "Futura")
        //        discardPileSizeText.text = "0 "
        //        discardPileSizeText.fontName = String(18)
        //        discardPileSizeText.position = CGPoint(x: 580, y: 80)
        //        parent.addChild(discardPileSizeText)
        //        additionals.append(discardPileSizeText)
        
        
        //        totalCardsSizeText = SKLabelNode(fontNamed: "Chalkduster")
        //        totalCardsSizeText.text = "0 "
        //        drawingPileSizeText.position = CGPoint(x: 140, y: 75)
        //        parent.addChild(totalCardsSizeText)
        //        additionals.append(totalCardsSizeText)
        //
        //        drawDeckNode = SKSpriteNode(imageNamed: "invertedCardBack" /*will be back of card*/)
        //        drawDeckNode.color = UIColor.white
        //        drawDeckNode.anchorPoint = CGPoint(x:0.5,y:1)
        //        drawDeckNode.size = CGSize(width: 240, height: 340)
        //        drawDeckNode.position = CGPoint(x: 140, y: 75)
        //        parent.addChild(drawDeckNode)
        //        additionals.append(drawDeckNode)
        //
        //
        //        discardPileNode = SKSpriteNode(imageNamed: "invertedCardBack" /*will be back of card*/)
        //        discardPileNode.color = UIColor.white
        //        discardPileNode.anchorPoint = CGPoint(x:0.5,y:1)
        //        discardPileNode.size = CGSize(width: 240, height: 340)
        //        discardPileNode.position = CGPoint(x: 580, y: 75)
        //        parent.addChild(discardPileNode)
        //        additionals.append(discardPileNode)
    }
    
    func drawFreshHand() -> Bool{
        for _ in 0..<hand.getMaxHandSize(){
            let card = drawDeck.draw();
            hand.add(c: CardNode(card: card, imageNamed: "inverted" + String(card.getRawValue()), color: UIColor.white, size: CGSize(width:240,height:340)))
        }
        
        //        drawingPileSizeText.text = String(drawDeck.deck.count)
        //        discardPileSizeText.text = String(drawDeck.discardPile.deck.count)
        
        hand.sort(reversed: playerNum == 0)
        
        let cardMoveInAnimation = SKAction.move(by: CGVector(dx: 0, dy:  -500 + (playerNum * 1000)), duration: 0.5)
        cardMoveInAnimation.timingMode = .easeOut
        
        for i in 0..<hand.hand.count{
            let cardNode = hand.hand[i]
            
            addCardToHand(cardNode: cardNode)
            
            cardNode.position = CGPoint(x:i * 80 + 120, y: 1634 - (playerNum * 1900)) //starts 500 off screen
            cardNode.zPosition = CGFloat(i)
            
            let cardDelayAnimation = SKAction.wait(forDuration: Double(i) * 0.1)
            let cardEntrance = SKAction.sequence([cardDelayAnimation, cardMoveInAnimation])
            
            cardNode.run(cardEntrance)
            
            cardNode.name = "card-" + String(cardNode.card.tag)
        }
        
        //        setHideHand(b: true)
        
        return (isMeld(cardSlice: hand.hand[0...2]) && isMeld(cardSlice: hand.hand[3...6])) || (isMeld(cardSlice: hand.hand[0...3]) && isMeld(cardSlice: hand.hand[4...6]))
    }
    
    func addCardToHand(cardNode: CardNode){
        cardNode.card.state = .InHand
        cardNode.card.player = self
        cardNode.color = UIColor.white
        cardNode.size = CGSize(width: 240, height: 340)
        cardNode.zRotation = CGFloat(Double(playerNum - 1) * Double.pi)
        hand.add(c: cardNode)
        parent.addChild(cardNode)
    }
    
    func moveFromStagingToStore(store: Store){
        
        for i in (0..<staging.count).reversed(){
            
            staging[i].card.state = .InStore
            
            staging[i].removeFromParent()
            
            store.addToCurrentStore(cardNode: staging[i])
            
            staging.remove(at: i)
        }
    }
    
    func moveFromStoreToHand(cardNode: CardNode){
        addCardToHand(cardNode: cardNode)
        
        hand.sort(reversed: playerNum == 0)
        
        for i in 0..<hand.hand.count {
            hand.hand[i].position = CGPoint(x:i * 80 + 120, y: 1334 - 200 - (playerNum * 900))
            hand.hand[i].zPosition = CGFloat(i)
        }
    }
    
    func moveFromHandToStaging(cardNode: CardNode){
        if(playerNum == 0){
            cardNode.position = CGPoint(x: cardNode.position.x, y: cardNode.position.y - 100)
        } else {
            cardNode.position = CGPoint(x: cardNode.position.x, y: cardNode.position.y + 100)
        }
        
        staging.append(cardNode)
        cardNode.card.state = .InStaging
        
        hand.remove(card: cardNode)
    }
    
    func moveFromStagingToHand(cardNode: CardNode){
        if(playerNum == 0){
            cardNode.position = CGPoint(x: cardNode.position.x, y: cardNode.position.y + 100)
        } else {
            cardNode.position = CGPoint(x: cardNode.position.x, y: cardNode.position.y - 100)
        }
        
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
