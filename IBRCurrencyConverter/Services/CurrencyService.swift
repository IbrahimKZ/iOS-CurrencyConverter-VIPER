//
//  CurrencyService.swift
//  IBRCurrencyConverter
//
//  Created by Ibrakhim Nikishin on 01.05.2018.
//  Copyright © 2018 Loftymoon. All rights reserved.
//

import Foundation

struct CurrencyError : Error {
    let description : String    
    var localizedDesc: String {
        return NSLocalizedString(description, comment: "")
    }
}

class CurrencyService {
    
    let storageService = StorageService()
    var currencies = [Currency]()
    var currencyNames = [String]()
    
    init() {
        
        inputValue = storageService.savedInputValue() ?? 100
        inputCurrency = storageService.savedInputCurrency() ?? Currency.defaultCurrency1()
        outputCurrency = storageService.savedOutputCurrency() ?? Currency.defaultCurrency2()
    }
        
    var inputValue: Double {
        didSet {
            if (oldValue != inputValue) {
                storageService.saveInputValue(with: inputValue)
            }
        }
    }
    var outputValue: Double {
        get {
            var value = inputValue 
            value *= outputCurrency.ratio
            return value
        }
    }
    
    func saveAllCurrencies(with dict: [String: Any], completion: @escaping (CurrencyError?) -> Swift.Void) {
        
        currencies = [Currency]()
        currencyNames = [String]()
        
        if let dictResults = dict["results"] as! [String: [String: String]]? {
            if dictResults.count > 0 {
                
                for (_, value) in dictResults {
                    if let fullName = value["currencyName"], let shortName = value["id"] {
                        let currency = Currency(fullName: fullName, shortName: shortName, ratio: 1, index: 0)
                        currencies.append(currency)
                        
                    }
                }
                completion(nil)
                return
            }
        }
        completion(CurrencyError(description: "Currencies' data format is wrong"))
    }
    
    func sortAndUpdateCurrentCurrencies() {
        
        if currencies.count > 0 {
            currencies.sort {
                $0.shortName < $1.shortName
            }
            
            var index = 0
            var inputCurrencyUpdated = false
            var outputCurrencyUpdated = false
            
            
            for currency in currencies {
                let name = "\(currency.shortName) : \(currency.fullName)"
                currencyNames.append(name)
                currency.index = index
                
                if inputCurrency.shortName == currency.shortName {
                    inputCurrency = currency
                    inputCurrencyUpdated = true
                }
                if outputCurrency.shortName == currency.shortName {
                    outputCurrency = currency
                    outputCurrencyUpdated = true
                }
                index += 1
            }
            
            if !inputCurrencyUpdated {
                inputCurrency = currencies.first!
            }
            if !outputCurrencyUpdated {
                outputCurrency = currencies.first!
            }
        }
    }
    
    func saveOutputCurrencyRatio(with dict: [String: Any], completion: @escaping (CurrencyError?) -> Swift.Void) {
        
        let key = "\(inputCurrency.shortName)_\(outputCurrency.shortName)"
        
        if let dictValue = dict[key] as! [String: Double]? {
            if dictValue.count > 0 {
                
                if let val = dictValue["val"] {
                    outputCurrency.ratio = val
                    storageService.saveOutputCurrency(with: outputCurrency)
                    completion(nil)
                    return
                }
            }
        }
        completion(CurrencyError(description: "Error in saving ratio for currency"))
    }
    
    var inputCurrency: Currency {
        didSet {
            if (oldValue != inputCurrency) {
                storageService.saveInputCurrency(with: inputCurrency)
            }
        }
    }
    
    var outputCurrency: Currency {
        didSet {
            if (oldValue != outputCurrency) {
                storageService.saveOutputCurrency(with: outputCurrency)
            }
        }
    }    
}
