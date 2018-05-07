//
//  CurrencyStorageService.swift
//  IBRCurrencyConverter
//
//  Created by Ibrakhim Nikishin on 02.05.2018.
//  Copyright © 2018 Loftymoon. All rights reserved.
//

import Foundation

class StorageService {
    
    private let kSavedInputValue = "IBR.savedInputValue"
    private let kSavedInputCurrency = "IBR.savedInputCurrency"
    private let kSavedOutputCurrency = "IBR.savedOutputCurrency"
    
    func savedInputValue() -> Double? {
        return UserDefaults.standard.double(forKey: kSavedInputValue);
    }
    
    func saveInputValue(with value: Double?) {
        if let newValue = value {
            UserDefaults.standard.set(newValue, forKey: kSavedInputValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    func savedInputCurrency() -> Currency? {
        
        if let data = UserDefaults.standard.value(forKey:kSavedInputCurrency) as? Data {
            let currency = try? PropertyListDecoder().decode(Currency.self, from: data)
            return currency
        }
        return nil
    }
    
    func saveInputCurrency(with currency: Currency) {
        
        UserDefaults.standard.set(try? PropertyListEncoder().encode(currency), forKey:kSavedInputCurrency)
        UserDefaults.standard.synchronize()
    }
    
    func savedOutputCurrency() -> Currency? {
        
        if let data = UserDefaults.standard.value(forKey:kSavedOutputCurrency) as? Data {
            let currency = try? PropertyListDecoder().decode(Currency.self, from: data)
            return currency
        }
        return nil
    }
    
    func saveOutputCurrency(with currency: Currency) {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(currency), forKey:kSavedOutputCurrency)
        UserDefaults.standard.synchronize()
    }
}
