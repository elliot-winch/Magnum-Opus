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
            spaces.append(StoreSlot(x: (i/2) * 180 + 100, y: 425 - (i % 2) * 270))
        }
        
        //Ideally this should be nil but Swift wouldn't let me do that
        parent = SKNode()
    }
    
    func roundStart(){
        //initial number of cards in store is 4
        for _ in 0..<4{
            let card = drawDeck.draw()
            card.state = .InStore
            
            let cardNode = CardNode(card: card, imageNamed: "inverted" + String(card.getRawValue()), color: UIColor.gray, size: CGSize(width: 180, height: 260))
            cardNode.name = "card-" + String(card.tag)
            
            addToCurrentStore(cardNode: cardNode)
            
        }
    }
    
    func changeAllColor(color: UIColor){
        for i in 0..<currentStore.count{
            currentStore[i].color = color
        }
    }
    
    func addToCurrentStore(cardNode: CardNode){
        for s : StoreSlot in spaces{
            s.age+=1
        }
        
        parent.addChild(cardNode)
        
        cardNode.colorBlendFactor = 1
        cardNode.size = CGSize(width: 180, height: 260)
        cardNode.zPosition = 31
        
        let space = findSpace()
        
        cardNode.position = space.point
        
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
    var cardNode : CardNode?
    var age : Int
    
    init(point: CGPoint){
        self.point = point
        self.cardNode = nil
        self.age = 0
    }
    
    init(x: Int, y: Int){
        self.point = CGPoint(x: CGFloat(x), y: CGFloat(y))
        self.cardNode = nil
        self.age = 0
    }
    
    func addCard(cardNode: CardNode){
        self.cardNode = cardNode
        self.age = 0
    }
}
