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

enum Method {
    case GET
    case POST
}
