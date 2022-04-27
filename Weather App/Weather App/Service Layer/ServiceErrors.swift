//
//  ServiceErrors.swift
//  Weather App
//
//  Created by Sinothando Mabhena on 2022/04/21.
//

import Foundation

enum APIError: String, Error {
    case internalError
    case serverError
    case parsingError
}

enum CoreDataError: String, Error {
    case deleteError
    case saveError
    case fetchError
    case createError
}
