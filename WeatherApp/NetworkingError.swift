//
//  NetworkingError.swift
//  WeatherApp
//
//  Created by Oskar Biwejnis on 17/07/2023.
//

import Foundation

enum NetworkingError: Error {
    case invalidResponse
    case decodingError
}
