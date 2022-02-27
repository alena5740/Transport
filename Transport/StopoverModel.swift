//
//  StopoverModel.swift
//  Transport
//
//  Created by Алена on 24.02.2022.
//

import Foundation

// Модель с информацией о остановке
struct StopoverModel {
    var id: String?
    var lat: Double?
    var lon: Double?
    var stopoverName: String?
}

// Декодируемая модель
struct StopoverModelListed: Codable {
    let data: [Datum]
}

struct Datum: Codable {
    let id: String
    let lat: Double
    let lon: Double
    let name: String
}
