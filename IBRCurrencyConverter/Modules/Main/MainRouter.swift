//
//  MainRouter.swift
//  IBRCurrencyConverter
//
//  Created by Ibrakhim Nikishin on 02.05.2018.
//  Copyright © 2018 Loftymoon. All rights reserved.
//

import Foundation
import UIKit

class MainRouter: MainRouterProtocol {
    
    weak var viewController: MainViewController!
    
    init(viewController: MainViewController) {
        self.viewController = viewController
    }
    
    func showAboutScene() {
        viewController.performSegue(withIdentifier: viewController.selfToAboutSegueName, sender: nil)
    }
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // prepare here some data for destination viewController
    }
}
