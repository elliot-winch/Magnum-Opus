//
//  File.swift
//  Merchant
//
//  Created by Elliot Winch on 13/11/2017.
//  Copyright © 2017 nyu.edu. All rights reserved.
//
import Foundation

public class Hand {
    
    private var handSize : Int
    var hand : [CardNode]
    //
    //    func draw() -> Card? {
    //        if(deck.count > 0){
    //            let randNum = Int(arc4random_uniform(UInt32(deck.count)))
    //            return deck.remove(at: randNum)
    //        }
    //        return nil
    //    }
    
    
    init(handSize: Int){
        self.handSize = handSize
        self.hand = [CardNode]()
    }
    
    init(cards: [CardNode], handSize: Int) {
        self.handSize = handSize
        self.hand = [CardNode]()
    }
    
    func get(i: Int) -> CardNode{
        return hand[i]
    }
    
    func getRange(i: Int, j: Int) -> [CardNode]?{
        if(i < 0 || i >= handSize || j < 0 || j >= handSize || j < i){
            return nil
        } else {
            return Array(hand[i...j])
        }
    }
    
    func getMaxHandSize() -> Int{
        
        return handSize
    }
    
    func removeAt(i: Int) -> CardNode{
        //        if(i < 0 || i >= handSize ){
        return hand.remove(at: i)
        //     }
    }
    
    func remove(card: CardNode) -> Int{
        for i in 0..<hand.count{
            if(card.card.tag == hand[i].card.tag){
                hand.remove(at: i)
                return i
            }
        }
        return -1
    }
    
    func add(c: CardNode){
        if(hand.count < handSize){
            
            hand.append(c)
        }
    }
    
    func sort(reversed: Bool){
        hand.sort(by:
            reversed ?
                {(c1: CardNode, c2: CardNode) -> Bool in return c1.card.getRawValue() > c2.card.getRawValue()}
                : {(c1: CardNode, c2: CardNode) -> Bool in return c1.card.getRawValue() < c2.card.getRawValue()})
    }
}
