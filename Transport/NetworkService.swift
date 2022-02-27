//
//  NetworkService.swift
//  Transport
//
//  Created by Алена on 24.02.2022.
//

import Foundation

// Сервис для работы с сетью
final class NetworkService {
    
    private let urlSession = URLSession(configuration: .default)
    private let decoder = JSONDecoder()
    
    typealias Handler = (Data?, URLResponse?, Error?) -> Void
    
    func baseRequest<T: Decodable>(request: URLRequest,
                                   completion: @escaping (Result<T, Error>) -> Void) {
        
        let handler: Handler = { [weak self] data, response, error in
            guard let self = self else { return }
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(print("data nil") as! Error))
                return
            }
            
            do {
                let resultData = try self.decoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(resultData))
                }
            } catch {
                completion(.failure(error))
            }
        }
        urlSession.dataTask(with: request, completionHandler: handler).resume()
    }
}
