//
//  CurrencyStorageService.swift
//  IBRCurrencyConverter
//
//  Created by Ibrakhim Nikishin on 02.05.2018.
//  Copyright © 2018 Loftymoon. All rights reserved.
//

import Foundation

protocol StorageServiceProtocol: class {
    func savedInputValue() -> Double?
    func saveInputValue(with value: Double?)
    func savedInputCurrency() -> Currency?
    func saveInputCurrency(with currency: Currency)
    func savedOutputCurrency() -> Currency?
    func saveOutputCurrency(with currency: Currency)
}

class StorageService: StorageServiceProtocol {
    
    private let kSavedInputValue = "IBR.savedInputValue"
    private let kSavedInputCurrency = "IBR.savedInputCurrency"
    private let kSavedOutputCurrency = "IBR.savedOutputCurrency"
    
    // MARK: - StorageServiceProtocol methods
    
    func savedInputValue() -> Double? {
        if UserDefaults.standard.object(forKey: kSavedInputValue) != nil {
            return UserDefaults.standard.double(forKey: kSavedInputValue);
        }
        return nil
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
