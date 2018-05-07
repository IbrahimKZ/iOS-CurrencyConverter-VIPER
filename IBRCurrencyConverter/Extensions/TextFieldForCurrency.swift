//
//  TextFieldForCurrency.swift
//  IBRCurrencyConverter
//
//  Created by Ibrakhim Nikishin on 19.04.2018.
//  Copyright © 2018 Loftymoon. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    
    func availableAdding(string: String) -> Bool {
        switch string {
        case "":
            return self.text != ""
        case "0"..."9":
            return self.text != "0"
        case ".", ",":
            return self.text!.count > 0 && self.text!.range(of: ".") == nil && self.text!.range(of: ",") == nil
        default:
            return false
        }
    }
    
    func addString(_ string: String) {
        var newValue: String = self.text ?? ""
        var addingString = string
        if addingString == "", newValue.count > 0 {
            newValue.removeLast()
        } else if addingString != "" {
            if addingString == "," {
                addingString = "."
            }
            newValue.append(addingString)
        }
        self.text = newValue
    }
    
    func clear() {
        self.text = ""
    }
    
    func addDoneOnKeyboard() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        self.inputAccessoryView = keyboardToolbar
    }
    
    @objc func dismissKeyboard() {
        self.resignFirstResponder()
    }
}
