//
//  CurrencyPickerView.swift
//  IBRCurrencyConverter
//
//  Created by Ibrakhim Nikishin on 04.05.2018.
//  Copyright © 2018 Loftymoon. All rights reserved.
//

import UIKit

protocol CurrencyPickerViewProtocol: class {
    var arrayCurrencyNames: [String] { set get }
    var title: String { set get }
    var selectedCurrencyIndex: Int? { set get }
    func reload()
}

protocol CurrencyPickerViewDelegate {
    func currencyPickerViewCancelButtonClicked()
    func currencyPickerViewApplyButtonClicked(selectedRow: Int)
}

class CurrencyPickerView: UIView, UIPickerViewDataSource, UIPickerViewDelegate, CurrencyPickerViewProtocol {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var delegate: CurrencyPickerViewDelegate?
    private let numberOfComponents = 1
    private let componentIndex = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }

    private func xibSetup() {
        Bundle.main.loadNibNamed("CurrencyPickerView", owner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    // MARK: - CurrencyPickerViewProtocol
    
    var arrayCurrencyNames = [String]()
    var title = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    func reload() {
        pickerView.reloadAllComponents()
    }
    
    var selectedCurrencyIndex: Int? {
        didSet {
            pickerView.selectRow(selectedCurrencyIndex!, inComponent: componentIndex, animated: false)
        }
    }
    
    // MARK: - UIPickerView dataSource methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return numberOfComponents
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayCurrencyNames.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrayCurrencyNames[row]
    }
    
    // MARK: - Action methods
    
    @IBAction func cancelButtonClicked(_ sender: UIButton) {
        delegate?.currencyPickerViewCancelButtonClicked()
    }
    
    @IBAction func applyButtonClicked(_ sender: UIButton) {
        delegate?.currencyPickerViewApplyButtonClicked(selectedRow: pickerView.selectedRow(inComponent: componentIndex))
    }
}
