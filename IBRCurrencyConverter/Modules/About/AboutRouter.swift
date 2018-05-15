//
//  AboutRouter.swift
//  IBRCurrencyConverter
//
//  Created by Ibrakhim Nikishin on 07.05.2018.
//  Copyright © 2018 Loftymoon. All rights reserved.
//

import Foundation
import UIKit

class AboutRouter: AboutRouterProtocol {
    
    weak var viewController: AboutViewController!
    
    init(viewController: AboutViewController) {
        self.viewController = viewController
    }
    
    func closeCurrentViewController() {
        viewController.dismiss(animated: true, completion: nil)
    }
}
