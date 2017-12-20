//
//  deck.swift
//  Merchant
//
//  Created by Elliot Winch on 13/11/2017.
//  Copyright © 2017 nyu.edu. All rights reserved.
//
import Foundation

//Representation of a deck of cards
public class Deck {
    
    //Array stores card info (NB not card nodes)
    var deck : [Card]
    
    //Initialisers - can be init'ed with empty array
    init(){
        deck = [Card]()
    }
    
    init(cards: [Card]){
        deck = [Card]()
        
        for i in 0..<cards.count{
            deck.append(cards[i])
        }
    }
    
    //Adds a card to the deck
    func add(c : Card) {
        deck.append(c)
    }
    
    //Draws a card from the deck, if there are cards to draw. Else returns nil
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
