//Determines if a sorted array of cards is a meld
func isMeld(cards: [CardNode]) -> Bool{
    return OfAKind(cards: cards) || Run(cards: cards)
}

func isMeld(cardSlice: ArraySlice<CardNode>) -> Bool{
    let cards : [CardNode] = Array(cardSlice)
    return OfAKind(cards: cards) || Run(cards: cards)
}

func OfAKind(cards: [CardNode]) -> Bool{
    if(cards.count <= 1){
        return false
    }
    
    for i in 0..<cards.count - 1{
        if(cards[i].card.getRawValue() != cards[i + 1].card.getRawValue()){
            return false
        }
    }
    
    return true
}

func Run(cards: [CardNode]) -> Bool{
    if(cards.count <= 1){
        return false
    }
    
    //hand will be sorted instead so will we need rthis?
    var sorted = cards.sorted(by: { (c1: CardNode, c2: CardNode) -> Bool in return c1.card.getRawValue() < c2.card.getRawValue()})
    var b = true
    
    for i in 0..<sorted.count - 1{
        if(sorted[i].card.getRawValue() != sorted[i+1].card.getRawValue() - 1){
            b = false
        }
    }
    
    if(b == false && sorted[0].card.getValue() == .Ace){
        b = true
        
        var cardVals = [Int]()
        for i in 1..<sorted.count{
            cardVals.append(sorted[i].card.getRawValue())
        }
        cardVals.append(14)
        
        for i in 0..<sorted.count - 1{
            if(cardVals[i] != cardVals[i + 1] - 1){
                b = false
            }
        }
    }
    
    return b
}



