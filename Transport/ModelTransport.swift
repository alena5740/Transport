//
//  TransportModel.swift
//  Transport
//
//  Created by Алена on 24.02.2022.
//

import Foundation

struct TransportModel {
    let transportType: String?
    let transportNumbers: String?
    let timeArrival: String?
}

struct TransportModelListed: Codable {
    let name: String
    let routePath: [RoutePath]
}

struct RoutePath: Codable {
    let type: String
    let number: String
    let timeArrival: [String]
}
