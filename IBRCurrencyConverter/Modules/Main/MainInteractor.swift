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
    
    let currencyService: CurrencyServiceProtocol = CurrencyService()
    
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
            return currencyService.outputRatio
        }
    }
    
    func getAllCurrencies() {
        presenter.showHUD()
        currencyService.getAllCurrencies { (result: Result<[Currency]>) in
            self.presenter.hideHUD()
            
            switch result {
            case .success(_):
                self.getOutputCurrencyRatio(newCurrency: nil)
            case .failure(let error):
                self.presenter.showLoadCurrenciesButton()
                self.presenter.showAlertView(with: error.localizedDescription)
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
        
        currencyService.getRatio(inputCurrencyShortName: requestInputCurrencyShortName, outputCurrencyShortName: requestOutputCurrencyShortName) { (result: Result<CurrencyRatio>) in
            self.presenter.hideHUD()
            
            switch result {
            case .success(_):
                self.updateCurrencies(newCurrency: newCurrency)
                self.presenter.updateOutputValue()
                self.presenter.updateRateText()
            case .failure(let error):
                self.presenter.showAlertView(with: error.localizedDescription)
            }
        }
    }
    
    private func updateCurrencies(newCurrency: Currency?) {
        
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
