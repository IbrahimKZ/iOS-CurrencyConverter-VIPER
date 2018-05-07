//
//  ServerService.swift
//  IBRCurrencyConverter
//
//  Created by Ibrakhim Nikishin on 02.05.2018.
//  Copyright © 2018 Loftymoon. All rights reserved.
//

import Foundation
import UIKit // for UIApplication

class ServerService {
    
    let urlRatesSource = "https://free.currencyconverterapi.com"
    
    func openUrl(with urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    func getAllCurrencies(completion: @escaping ([String: Any]?, Error?) -> Swift.Void) {
        
        if let URL = URL(string: URLAllCurrencies) {
            getJSON(URL: URL, completion: completion)
        }
    }
    
    func getRatio(inputCurrencyShortName: String, outputCurrencyShortName: String, completion: @escaping ([String: Any]?, Error?) -> Swift.Void) {
        
        let URLString = URLGetRatio(inputCurrencyShortName: inputCurrencyShortName, outputCurrencyShortName: outputCurrencyShortName)
        
        if let URL = URL(string: URLString) {
            getJSON(URL: URL, completion: completion)
        }
    }
    
    // MARK: - Private methods
        
    private func getJSON(URL: URL, completion: @escaping ([String: Any]?, Error?) -> Swift.Void) {
        
        let sharedSession = URLSession.shared
        
        let dataTask = sharedSession.dataTask(with: URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print("Error to load: \(String(describing: error?.localizedDescription))")
                completion(nil, error)
                return
            }
            
            if let dataResponse = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: dataResponse, options: []) as! [String: AnyObject]
                    
                    print("json: \(json), error: \(String(describing: error))")
                    completion(json, nil)
                    return
                    
                } catch let error as NSError {
                    
                    print("Failed to load: \(error.localizedDescription)")
                    completion(nil, error)
                }
            }
        })
        dataTask.resume()
    }
    
    private let URLAllCurrencies = "https://free.currencyconverterapi.com/api/v5/currencies"
    
    private func URLGetRatio(inputCurrencyShortName: String, outputCurrencyShortName: String) -> String {
        return "https://free.currencyconverterapi.com/api/v5/convert?q=\(inputCurrencyShortName)_\(outputCurrencyShortName)&compact=y"
    }
    
}
