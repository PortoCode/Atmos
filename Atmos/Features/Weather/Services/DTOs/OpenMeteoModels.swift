//
//  OpenMeteoModels.swift
//  Atmos
//
//  Created by Rodrigo Porto on 11/01/26.
//

import Foundation

struct OpenMeteoResponse: Decodable {
    let current: OpenMeteoCurrentDTO
}

struct OpenMeteoCurrentDTO: Decodable {
    let temperature_2m: Double
    let relative_humidity_2m: Int
    let weathercode: Int
}
