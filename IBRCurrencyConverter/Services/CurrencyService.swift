//
//  CurrencyService.swift
//  IBRCurrencyConverter
//
//  Created by Ibrakhim Nikishin on 01.05.2018.
//  Copyright © 2018 Loftymoon. All rights reserved.
//

import Foundation

struct ApiCurrencyItem: Decodable{
    let id: String
    let currencyName: String
    let currencySymbol: String?
}

struct CurrencyResponse: Decodable {
    let results:[String:ApiCurrencyItem]
}

struct CurrencyError : Error {
    let description : String    
    var localizedDesc: String {
        return NSLocalizedString(description, comment: "")
    }
}

struct CurrencyRatio: Decodable {
    let name: String
    let ratio: Double
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        guard let result = try? container.decode(Dictionary<String, Double>.self) else {
            throw CurrencyRatioCodingError.decoding("CurrencyRatioCodingError")
        }
        
        name = result.first!.key
        ratio = result.first!.value
    }
    
    enum CurrencyRatioCodingError: Error {
        case decoding(String)
    }
}

protocol CurrencyServiceProtocol: class {
    var currencies: [Currency] { set get }
    var currencyNames: [String] { set get }
    var inputValue: Double { set get }
    var outputValue: Double { get }
    var inputCurrency: Currency { set get }
    var outputCurrency: Currency { set get }
    var outputRatio: Double { get }
    func getAllCurrencies<T:Decodable>(completion: @escaping (Result<T>) -> Void)
    func getRatio<T:Decodable>(inputCurrencyShortName: String, outputCurrencyShortName: String, completion: @escaping (Result<T>) -> Void)
    func updateCurrentCurrencies()
}

class CurrencyService: CurrencyServiceProtocol {
    private let serverService: ServerServiceProtocol = ServerService()
    private let storageService: StorageServiceProtocol = StorageService()
    var currencies = [Currency]()
    var currencyNames = [String]()
    var currentRatio: CurrencyRatio?
    
    let urlRatesSource = "https://free.currencyconverterapi.com"
    lazy var URLAllCurrencies: String = {
        return "\(urlRatesSource)/api/v5/currencies"
    }()
    
    
    init() {
        inputValue = storageService.savedInputValue() ?? 100
        inputCurrency = storageService.savedInputCurrency() ?? Currency.defaultCurrencyInput()
        outputCurrency = storageService.savedOutputCurrency() ?? Currency.defaultCurrencyOutput()
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
            return convertWithRatio(inputValue)
        }
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
    
    var outputRatio: Double {
        get {
            if let ratio = currentRatio {
                return ratio.ratio
            }
            
            return 0
        }
    }
    
    private func URLGetRatio(inputCurrencyShortName: String, outputCurrencyShortName: String) -> String {
        return "\(urlRatesSource)/api/v5/convert?q=\(inputCurrencyShortName)_\(outputCurrencyShortName)&compact=ultra"
    }
    
    func getAllCurrencies<T:Decodable>(completion: @escaping (Result<T>) -> Void) {
        if let URL = URL(string: URLAllCurrencies) {
            serverService.getJSON(URL: URL) { [unowned self] (result: Result<CurrencyResponse>) in
                switch result {
                case .success(let data):
                    self.saveAllCurrencies(data, completion: completion)
                case .failure(let error):
                    completion(Result.failure(error))
                }
            }
        }
    }
    
    func getRatio<T:Decodable>(inputCurrencyShortName: String, outputCurrencyShortName: String, completion: @escaping (Result<T>) -> Void) {
        let URLString = URLGetRatio(inputCurrencyShortName: inputCurrencyShortName, outputCurrencyShortName: outputCurrencyShortName)
        
        if let URL = URL(string: URLString) {
            serverService.getJSON(URL: URL) { [unowned self] (result: Result<CurrencyRatio>) in
                switch result {
                case .success(let ratio):
                    self.currentRatio = ratio
                    completion(Result.success(ratio as! T))
                case .failure(let error):
                    completion(Result.failure(error))
                }
            }
        }
    }
    
    func saveAllCurrencies<T:Decodable>(_ data:CurrencyResponse, completion: @escaping (Result<T>) -> Void) {
        currencies = [Currency]()
        currencyNames = [String]()
        
        for (index, item) in data.results.enumerated() {
            let currency = Currency(fullName: item.value.currencyName, shortName: item.value.id, index: index)
            currencies.append(currency)
            
            let name = "\(currency.shortName) : \(currency.fullName)"
            currencyNames.append(name)
        }
        
        updateCurrentCurrencies()
        
        completion(Result.success(currencies as! T))
    }
    
    func updateCurrentCurrencies() {
        if currencies.isEmpty {
            return
        }
        
        var inputCurrencyUpdated = false
        var outputCurrencyUpdated = false
        
        for currency in currencies {
            if inputCurrency.shortName == currency.shortName {
                inputCurrency = currency
                inputCurrencyUpdated = true
            }
            
            if outputCurrency.shortName == currency.shortName {
                outputCurrency = currency
                outputCurrencyUpdated = true
            }
        }
        
        if !inputCurrencyUpdated {
            inputCurrency = currencies.first!
        }
        
        if !outputCurrencyUpdated {
            outputCurrency = currencies.first!
        }
    }
    
    func convertWithRatio(_ value: Double) -> Double {
        guard let ratio = currentRatio else {
            return 0
        }
        
        let convertedKey = ("\(inputCurrency.shortName)_\(outputCurrency.shortName)")
        if ratio.name != convertedKey {
            return 0
        }
        
        return value * ratio.ratio
    }
}
