//
//  deck.swift
//  Merchant
//
//  Created by Christopher Winch on 13/11/2017.
//  Copyright © 2017 nyu.edu. All rights reserved.
//
import Foundation

public class Deck {
    
    var deck : [Card]
    
    init(){
        deck = [Card]()
    }
    
    init(cards: [Card]){
        deck = [Card]()
        
        for i in 0..<cards.count{
            deck.append(cards[i])
        }
    }
    
    func add(c : Card) {
        deck.append(c)
    }
    
    func draw() -> Card? {
        if(deck.count > 0){
            let randNum = Int(arc4random_uniform(UInt32(deck.count)))
            return deck.remove(at: randNum)
        }
        return nil
    }
    
    public var description: String{
        var s = "This deck contains the \(deck.count) following cards: "
        if(deck.count > 0){
            for i in 0...deck.count - 1{
                s += deck[i].description + ". "
            }
            return s
        } else {
            return "This deck is empty"
        }
    }
    
}
