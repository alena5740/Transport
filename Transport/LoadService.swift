//
//  LoadService.swift
//  Transport
//
//  Created by Алена on 24.02.2022.
//

import Foundation

// Протокол сервиса для загрузки данных
protocol LoadServiceProtocol {
    func loadStopover(completion: @escaping (Result<StopoverModelListed, Error>) -> Void)
    func loadStopoverInfo(id: String, completion: @escaping (Result<TransportModelListed, Error>) -> Void)
}

// Сервис для загрузки данных
final class LoadService: LoadServiceProtocol {
    
    private let networkService = NetworkService()
    
    func loadStopover(completion: @escaping (Result<StopoverModelListed, Error>) -> Void) {
        let urlString = "https://api.mosgorpass.ru/v8.2/stop"
        makeRequest(url: urlString, completion: completion)
    }
    
    func loadStopoverInfo(id: String,
                          completion: @escaping (Result<TransportModelListed, Error>) -> Void) {
        let urlString = "https://api.mosgorpass.ru/v8.2/stop/\(id)"
        makeRequest(url: urlString, completion: completion)
    }
    
    private func makeRequest<T: Decodable>(url: String,
                                           completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: url) else { return }
        let request = URLRequest(url: url)
        networkService.baseRequest(request: request, completion: completion)
    }
}
