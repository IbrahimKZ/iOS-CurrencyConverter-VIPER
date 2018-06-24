//
//  ServerService.swift
//  IBRCurrencyConverter
//
//  Created by Ibrakhim Nikishin on 02.05.2018.
//  Copyright © 2018 Loftymoon. All rights reserved.
//

import Foundation
import UIKit // for UIApplication

//TODO: Подобие сетевого слоя
protocol ServerServiceProtocol: class {
    //TODO: Это где то в презентере должно быть
    func openUrl(with urlString: String)
    func getJSON<T: Decodable>(URL: URL, completion: @escaping (Result<T>) -> Void)
}

class ServerService: ServerServiceProtocol {
 
    // MARK: - ServerServiceProtocol methods
    
    func openUrl(with urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    // MARK: - Private methods
        
    func getJSON<T: Decodable>(URL: URL, completion: @escaping (Result<T>) -> Void) {
        let sharedSession = URLSession.shared
        
        let dataTask = sharedSession.dataTask(with: URL, completionHandler: { (data, response, error) -> Void in
            if let error = error {
                print("Error to load: \(String(describing: error.localizedDescription))")
                completion(Result.failure(error))
                return
            }
            
            if let dataResponse = data {
                do {
                    let decoded = try JSONDecoder().decode(T.self, from: dataResponse)
                    completion(.success(decoded))
                } catch {
                    print("Failed to load: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
        })
        dataTask.resume()
    }
}
