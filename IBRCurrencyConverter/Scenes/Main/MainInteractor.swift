//
//  MainInteractor.swift
//  IBRCurrencyConverter
//
//  Created by Ibrakhim Nikishin on 01.05.2018.
//  Copyright © 2018 Loftymoon. All rights reserved.
//

import Foundation

enum CurrencyChangingMode {
    case inputCurrencyChanging
    case outputCurrencyChanging
}

class MainInteractor: MainInteractorProtocol {
    
    weak var presenter: MainPresenterProtocol!
    
    let currencyService = CurrencyService()
    let serverService = ServerService()
    
    var currencyChangingMode: CurrencyChangingMode?
    
    required init(presenter: MainPresenterProtocol) {
        self.presenter = presenter
    }
    
    // MARK: - MainInteractorProtocol methods
    
    var inputValue: Double {
        set {
            currencyService.inputValue = newValue
        }
        get {
            return currencyService.inputValue
        }
    }
    var outputValue: Double {
        get {
            return currencyService.outputValue
        }
    }
    var inputCurrencyShortName: String {
        get {
            return currencyService.inputCurrency.shortName
        }
    }
    var outputCurrencyShortName: String {
        get {
            return currencyService.outputCurrency.shortName
        }
    }
    
    var inputCurrencyIndex: Int {
        get {
            return currencyService.inputCurrency.index
        }
    }
    
    var outputCurrencyIndex: Int {
        get {
            return currencyService.outputCurrency.index
        }
    }
    
    var outputCurrencyRatio: Double {
        get {
            return currencyService.outputCurrency.ratio
        }
    }
    
    func getAllCurrencies() {
        presenter.showHUD()
        serverService.getAllCurrencies { (dict, error) in
            
            if let error = error {
                self.presenter.hideHUD()
                self.presenter.showLoadCurrenciesButton()
                self.presenter.showAlertView(with: error.localizedDescription)
                return
            }
            
            if let dictResponse = dict {
                self.currencyService.saveAllCurrencies(with: dictResponse, completion: { (error) in
                    
                    if let error = error {
                        self.presenter.hideHUD()
                        self.presenter.showAlertView(with: error.localizedDesc)
                        return
                    }
                    self.currencyService.sortAndUpdateCurrentCurrencies()
                    self.getOutputCurrencyRatio(newCurrency: nil)
                })
            }
        }
    }
    
    func getOutputCurrencyRatio(newCurrency: Currency?) {
        presenter.showHUD()
        
        var requestInputCurrencyShortName = inputCurrencyShortName
        var requestOutputCurrencyShortName = outputCurrencyShortName
        
        if let mode = self.currencyChangingMode, let newCurrency = newCurrency {
            switch mode {
            case .inputCurrencyChanging:
                requestInputCurrencyShortName = newCurrency.shortName
            case .outputCurrencyChanging:
                requestOutputCurrencyShortName = newCurrency.shortName
            }
        }
        
        serverService.getRatio(inputCurrencyShortName: requestInputCurrencyShortName, outputCurrencyShortName: requestOutputCurrencyShortName) { (dict, error) in
            
            self.presenter.hideHUD()
            
            if error != nil {
                if let errorText = error?.localizedDescription {
                    self.presenter.showAlertView(with: errorText)
                }
                return
            }
            
            if let dictResponse = dict {
                
                if let mode = self.currencyChangingMode, let newCurrency = newCurrency {
                    switch mode {
                    case .inputCurrencyChanging:
                        self.currencyService.inputCurrency = newCurrency
                        self.presenter.inputCurrencyNameUpdated()
                    case .outputCurrencyChanging:
                        self.currencyService.outputCurrency = newCurrency
                        self.presenter.outputCurrencyNameUpdated()
                    }
                }
                
                self.currencyService.saveOutputCurrencyRatio(with: dictResponse, completion: { (error) in
                    
                    if let error = error {
                        self.presenter.showAlertView(with: error.localizedDesc)
                        return
                    }
                    self.presenter.updateOutputValue()
                    self.presenter.updateRateText()
                })
            }
        }
    }
    
    func getCurrencyNames() -> [String] {
        return currencyService.currencyNames
    }
    
    func inputCurrencyChanging() {
        currencyChangingMode = .inputCurrencyChanging
    }
    
    func outputCurrencyChanging() {
        currencyChangingMode = .outputCurrencyChanging
    }
    
    func currencyChanged(selectedIndex: Int) {
        if currencyService.currencies.count > selectedIndex {
            
            let newCurrency = currencyService.currencies[selectedIndex]
            getOutputCurrencyRatio(newCurrency: newCurrency)
        }
    }    
}
