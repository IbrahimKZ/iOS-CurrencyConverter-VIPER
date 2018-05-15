//
//  MainViewController.swift
//  IBRCurrencyConverter
//
//  Created by Ibrakhim Nikishin on 18.04.2018.
//  Copyright © 2018 Loftymoon. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, MainViewProtocol, UITextFieldDelegate {
    
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var inputCurrencyButton: UIButton!
    @IBOutlet weak var outputLabel: UILabel!
    @IBOutlet weak var outputCurrencyButton: UIButton!
    @IBOutlet weak var HUDView: UIView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var loadCurrenciesButton: UIButton!
    @IBOutlet weak var currencyPickerView: CurrencyPickerView!    
    @IBOutlet weak var offsetBottomCurrencyPickerView: NSLayoutConstraint!
    @IBOutlet weak var rateLabel: UILabel!
    
    var presenter: MainPresenterProtocol!
    var configurator: MainConfiguratorProtocol = MainConfigurator()
    
    let selfToAboutSegueName = "MainToAboutSegue"
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(with: self)
        presenter.configureView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Action methods
    
    @IBAction func inputCurrencyButtonClicked(_ sender: UIButton) {
        presenter.inputCurrencyButtonClicked()
    }
    
    @IBAction func outputCurrencyButtonClicked(_ sender: UIButton) {
        presenter.outputCurrencyButtonClicked()
    }
    
    @IBAction func loadCurrenciesButtonClicked(_ sender: UIButton) {
        presenter.loadCurrenciesButtonClicked()
    }
    
    @IBAction func infoButtonClicked(_ sender: UIButton) {
        presenter.infoButtonClicked()
    }
    
    // MARK: - TextField delegate methods
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        presenter.textFieldDidBeginEditing()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == inputTextField {
            if textField.availableAdding(string: string) {
                textField.addString(string)
                self.presenter.inputValueChanged(to: textField.text ?? "")
            }
            return false
        }
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if textField == inputTextField {
            textField.clear()
            self.presenter.inputValueCleared()
            return false
        }
        return true
    }
        
    // MARK: - MainViewProtocol methods
    
    func setInputValue(with value: String?) {
        DispatchQueue.main.async {
            self.inputTextField.text = value
        }
    }
    
    func setOutputValue(with value: String?) {
        DispatchQueue.main.async {
            self.outputLabel.text = value
        }
    }
    
    func setInputCurrencyShortName(with shortName: String) {
        DispatchQueue.main.async {
            self.inputCurrencyButton.setTitle(shortName, for: .normal)
        }
    }
    
    func setOutputCurrencyShortName(with shortName: String) {
        DispatchQueue.main.async {
            self.outputCurrencyButton.setTitle(shortName, for: .normal)
        }
    }
    
    func addDoneOnInputCurrencyKeyboard() {
        inputTextField.addDoneOnKeyboard()
    }
    
    func showHUD() {
        DispatchQueue.main.async {
            self.view.bringSubview(toFront: self.HUDView)
            self.activityIndicatorView.alpha = 1
            self.loadCurrenciesButton.alpha = 0
            UIView.animate(withDuration: 0.5) {
                self.HUDView.alpha = 1
            }
        }
    }
    
    func showLoadCurrenciesButton() {
        DispatchQueue.main.async {
            self.view.bringSubview(toFront: self.HUDView)
            self.activityIndicatorView.alpha = 0
            self.loadCurrenciesButton.alpha = 1
            UIView.animate(withDuration: 0.5) {
                self.HUDView.alpha = 1
            }
        }
    }
    
    func hideHUD() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5) {
                self.HUDView.alpha = 0
            }
        }
    }
    
    func showAlertView(with text: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "", message: text, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
                
            })
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func showPickerView() {
        UIView.animate(withDuration: 0.5) {
            self.offsetBottomCurrencyPickerView.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func hidePickerView() {
        UIView.animate(withDuration: 0.5) {
            self.offsetBottomCurrencyPickerView.constant = self.currencyPickerView.frame.size.height
            self.view.layoutIfNeeded()
        }
    }
    
    func hideKeyboard() {
        view.endEditing(true)
    }
    
    func setRateText(with rateText: String) {
        DispatchQueue.main.async {
            self.rateLabel.text = rateText
        }
    }
    
    // MARK: - Navigation methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        presenter.router.prepare(for: segue, sender: sender)
    }
}
