//
//  AboutViewController.swift
//  IBRCurrencyConverter
//
//  Created by Ibrakhim Nikishin on 07.05.2018.
//  Copyright © 2018 Loftymoon. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController, AboutViewProtocol {
    
    @IBOutlet weak var urlButton: UIButton!
    
    var presenter: AboutPresenterProtocol!
    var configurator = AboutConfigurator()

    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(with: self)
        presenter.configureView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    // MARK: - Action methods
    
    @IBAction func closeButtonClicked(_ sender: UIBarButtonItem) {
        presenter.closeButtonClicked()
    }
    
    @IBAction func urlButtonClicked(_ sender: UIButton) {
        presenter.urlButtonClicked(with: sender.currentTitle)
    }
    
    // MARK: - AboutViewProtocol methods
    
    func setUrlButtonTitle(with title: String) {
        urlButton.setTitle(title, for: .normal)
    }
}
