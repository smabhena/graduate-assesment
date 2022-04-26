//
//  SearchModel.swift
//  Weather App
//
//  Created by Sinothando Mabhena on 2022/04/26.
//

import Foundation

// MARK: - Search
struct Search: Codable {
    let coord: Coord?
    let weather: [Weather]?
    let base: String?
    let main: Main?
    let visibility: Int?
    let wind: Wind?
    let clouds: Clouds?
    let dt: Int?
    let sys: Sys?
    let timezone, id: Int?
    let name: String?
    let cod: Int?
}
