//  card.swift
//  Merchant
//
//  Created by Elliot Winch on 13/11/2017.
//  Copyright © 2017 nyu.edu. All rights reserved.
//
import Foundation
import SpriteKit

public enum Value : Int{
    
    case Ace = 1, Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten, Jack, Queen, King
    
    static var length = 13
}

public enum State{
    
    case InDeck, InHand, InStaging, InStore //more cases to be added if needed
}

public class Card {
    
    let tag : Int
    private let value: Value
    
    var state : State
    var player : Player?
    
    init(value: Value, tag : Int, player: Player?){
        self.value = value
        self.tag = tag
        
        self.state = .InDeck
        self.player = player
    }
    
    init(value: Int, tag : Int){
        self.value = Value(rawValue: value)!
        self.tag = tag
        
        self.state = .InDeck
    }
    
    func getValue() -> Value {
        return self.value
    }
    
    func getRawValue() -> Int {
        return self.value.rawValue
    }
    
    public var description: String {
        return String(describing: self.value)
    }
}

public class CardNode : SKSpriteNode{
    
    let card : Card
    
    init(card: Card, imageNamed: String, color: UIColor, size: CGSize){
        self.card = card
        super.init(texture: SKTexture(imageNamed: imageNamed), color: color, size: size)
        self.colorBlendFactor = 1
    }
    
    public required init?(coder aDecoder: NSCoder) {
        
        fatalError("CardNode initialiser not implemented")
    }
}
