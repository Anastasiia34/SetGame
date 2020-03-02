//
//  File.swift
//  Set
//
//  Created by Анастасия Стрекалова on 25.11.2019.
//  Copyright © 2019 Анастасия Стрекалова. All rights reserved.
//

import Foundation

struct Card: Equatable {
    
    let identifier: Int
    let color : Int
    let quantity : Int
    let filling : Int
    let sign : Int
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }

    static var identifierFactory = -1

    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    private static func getColor (id : Int) -> Int {
        if id <= 26 {
            return 1
        }else if id >= 54 {
            return 2
        }else{
            return 3
        }
    }
    
    private static func getQuantity (id : Int) -> Int {
        if id < 9 || id > 26 && id < 36 || id > 53 && id < 63 {
            return 1
        } else if id > 8 && id < 18 || id > 35 && id < 45 || id > 62 && id < 72{
            return 2
        } else if id > 17 && id < 27 || id > 44 && id < 54 || id > 71 {
            return 3
        } else {
            return 0
        }
    }
    
    private static func getFilling (id : Int) -> Int {
        if id%3 == 0 {
            return 1
        } else if id%3 == 1 {
            return 2
        } else {
            return 3
        }
    }
    
    private static func getSign (id : Int) -> Int {
        if Int(id/3)%3 == 0 {
            return 1
        }else if Int(id/3)%3 == 1 {
            return 2
        } else {
            return 3
        }
    }
    
    init(){
        identifier = Card.getUniqueIdentifier()
        color = Card.getColor(id: identifier)
        quantity = Card.getQuantity(id: identifier)
        filling = Card.getFilling(id: identifier)
        sign = Card.getSign(id: identifier)
    }
}
