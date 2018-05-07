//
//  AboutInteractor.swift
//  IBRCurrencyConverter
//
//  Created by Ibrakhim Nikishin on 07.05.2018.
//  Copyright © 2018 Loftymoon. All rights reserved.
//

import Foundation

class AboutInteractor: AboutInteractorProtocol {
    
    weak var presenter: AboutPresenterProtocol!
    
    let serverService = ServerService()
    
    required init(presenter: AboutPresenterProtocol) {
        self.presenter = presenter
    }
    
    var urlRatesSource: String {
        get {
            return serverService.urlRatesSource
        }
    }
    
    func openUrl(with urlString: String) {
        serverService.openUrl(with: urlString)
    }
}
