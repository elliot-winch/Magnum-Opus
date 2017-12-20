//
//  drawDeck.swift
//  Merchant
//
//  Created by Elliot Winch on 14/11/2017.
//  Copyright © 2017 nyu.edu. All rights reserved.
//
import Foundation

//Representation of a deck and its asociated discard pile.
//Inherits from deck.
public class DrawDeck : Deck {
    
    let discardPile = Deck()
    
    //If the draw deck is empty, shuffle the discard pile
    //and use this as your new deck.
    override func draw() -> Card? {
        if(deck.count <= 0){
            for _ in 0..<discardPile.deck.count{
                let card = discardPile.draw()
                if(card != nil){
                    super.add(c: card!)
                } else {
                    return nil
                }
            }
        }
        return super.draw()
    }
    
    override func add(c: Card) {
        discardPile.add(c: c)
        c.state = .InDeck
    }
}
