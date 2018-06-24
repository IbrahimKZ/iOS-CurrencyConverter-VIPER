//
//  Result.swift
//  IBRCurrencyConverter
//
//  Created by Lomiren on 6/20/18.
//  Copyright © 2018 Loftymoon. All rights reserved.
//

import Foundation

public enum Result<T> {
    case success(T)
    case failure(Error)
}
