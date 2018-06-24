//
//  Currency.swift
//  IBRCurrencyConverter
//
//  Created by Ibrakhim Nikishin on 04.05.2018.
//  Copyright © 2018 Loftymoon. All rights reserved.
//

import Foundation

struct Currency: Codable, Equatable {
    
    let shortName: String
    let fullName: String
    let index: Int
    
    init(fullName: String, shortName: String, index: Int) {
        self.fullName = fullName
        self.shortName = shortName
        self.index = index
    }
    
    static func defaultCurrencyInput() -> Currency {
        let currency = self.init(fullName: "United States Dollar", shortName: "USD", index: 0)
        return currency
    }
    
    static func defaultCurrencyOutput() -> Currency {
        let currency = self.init(fullName: "Euro", shortName: "EUR", index: 1)
        return currency
    }
    
    static func == (lhs: Currency, rhs: Currency) -> Bool {
        if lhs.fullName == rhs.fullName, lhs.shortName == rhs.shortName, lhs.index == rhs.index {
            return true
        }
        return false
    }
}
