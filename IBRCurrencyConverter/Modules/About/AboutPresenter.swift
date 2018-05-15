//
//  AboutPresenter.swift
//  IBRCurrencyConverter
//
//  Created by Ibrakhim Nikishin on 07.05.2018.
//  Copyright © 2018 Loftymoon. All rights reserved.
//

import Foundation

class AboutPresenter: AboutPresenterProtocol {
    
    weak var view: AboutViewProtocol!
    var interactor: AboutInteractorProtocol!
    var router: AboutRouterProtocol!
    
    required init(view: AboutViewProtocol) {
        self.view = view
    }
    
    // MARK: - AboutPresenterProtocol methods
    
    func configureView() {
        view.setUrlButtonTitle(with: interactor.urlRatesSource)
    }
    
    func closeButtonClicked() {
        router.closeCurrentViewController()
    }
    
    func urlButtonClicked(with urlString: String?) {
        if let url = urlString {
            interactor.openUrl(with: url)
        }
    }
}
