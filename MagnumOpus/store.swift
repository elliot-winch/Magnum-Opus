//
//  store.swift
//  MagnumOpus
//
//  Created by Elliot Richard John Winch on 11/20/17.
//  Copyright © 2017 nyu.edu. All rights reserved.
//
import Foundation
import SpriteKit

public class Store{
    
    var parent : SKNode
    var drawDeck : DrawDeck
    private var currentStore : [CardNode]
    private var spaces: [StoreSlot]
    
    init(){
        self.drawDeck = DrawDeck()
        self.currentStore = [CardNode]()
        self.spaces = [StoreSlot]()
        
        for i in 0..<8{
            let space = StoreSlot(x: (i/2) * 180 + 100, y: 425 - (i % 2) * 270, rotation: (i % 2 == 0 ? Double.pi : Double(0)))
            
            spaces.append(space)
        }
        
        //Ideally this should be nil but Swift wouldn't let me do that (Elliot from 2017)
        //Elliot from 2018 say this is weirdly set up but okay
        parent = SKNode()
    }
    
    func roundStart(){
        //initial number of cards in store is 4
        for i in 0..<4{
            let card = drawDeck.draw()!

            card.state = .InStore
            
            let cardNode = CardNode(card: card, imageNamed: cardSetSelected + String(card.getRawValue()), color: UIColor.gray, size: CGSize(width: 180, height: 260))
            cardNode.name = "card-" + String(card.tag)
            
            cardNode.zRotation = CGFloat(i % 2 == 0 ? Double.pi : Double(0))
            
            addToCurrentStore(cardNode: cardNode, withDelay: 0.5 - (0.1 * Double(i)), withStartingPosition: CGPoint(x: -300,y: 425 - (i % 2) * 270))
            
        }
    }
    
    func changeAllColor(color: UIColor){
        for i in 0..<currentStore.count{
            currentStore[i].color = color
        }
    }
    
    func addToCurrentStore(cardNode: CardNode, withDelay: Double, withStartingPosition: CGPoint){
        cardNode.card.state = .InStore
        
        for s : StoreSlot in spaces{
            s.age+=1
        }
        
        parent.addChild(cardNode)
        cardNode.position = withStartingPosition
        cardNode.zPosition = 31
        
        let space = findSpace()
        
        cardNode.run(SKAction.sequence([SKAction.wait(forDuration: withDelay), SKAction.resize(toWidth: 180, height: 260, duration: 0.4)]))
        cardNode.run(SKAction.sequence([SKAction.wait(forDuration: withDelay), SKAction.move(to: space.point, duration: 0.4)]))
        
        cardNode.run(SKAction.sequence([SKAction.wait(forDuration: withDelay), SKAction.rotate(toAngle: CGFloat(space.orientation), duration: 0.4)]))
        
        space.addCard(cardNode: cardNode)
        self.currentStore.append(cardNode)
    }
    
    func findSpace() -> StoreSlot{
        for i in 0..<spaces.count{
            if(spaces[i].cardNode == nil){
                return spaces[i]
            }
        }
        
        var max = spaces[0]
        for i in 0..<spaces.count{
            if(max.age < spaces[i].age){
                max = spaces[i]
            }
        }
        
        let toRemove = max.cardNode!
        
        let shrinkAnimation = SKAction.resize(toWidth:0, height:0, duration: 0.2)
        let deleteAnimation = SKAction.customAction(withDuration: 0.01) { node, elaspedTime in
            toRemove.removeFromParent() }
        
        toRemove.run(SKAction.sequence([shrinkAnimation, deleteAnimation]))
        
        
        return max
    }
    
    func removeFromCurrentStore(cardNode: CardNode){
        for i in 0..<currentStore.count{
            if(cardNode.card.tag == currentStore[i].card.tag){
                currentStore.remove(at: i)
                cardNode.removeFromParent()
                
                for i in 0..<spaces.count{
                    if(spaces[i].cardNode == cardNode){
                        spaces[i].cardNode = nil
                    }
                }
                cardNode.position = CGPoint(x: cardNode.position.x + parent.position.x, y:  cardNode.position.y + parent.position.y)
                return
            }
        }
    }
    
    func roundEnd(){
        
        for i in (0..<currentStore.count).reversed(){
            self.drawDeck.add(c: currentStore[i].card)
            
            for j in 0..<spaces.count{
                if(spaces[j].cardNode == currentStore[i]){
                    spaces[j].cardNode = nil
                }
            }
            
            currentStore[i].removeFromParent()
        }
    }
}

class StoreSlot {
    let point : CGPoint
    let orientation : CGFloat
    var cardNode : CardNode?
    var age : Int
    
    init(point: CGPoint, rotation: Double){
        self.point = point
        self.orientation = CGFloat(rotation)
        self.cardNode = nil
        self.age = 0
    }
    
    init(x: Int, y: Int, rotation: Double){
        self.point = CGPoint(x: CGFloat(x), y: CGFloat(y))
        self.orientation = CGFloat(rotation)
        self.cardNode = nil
        self.age = 0
    }
    
    func addCard(cardNode: CardNode){
        self.cardNode = cardNode
        self.age = 0
    }
}
