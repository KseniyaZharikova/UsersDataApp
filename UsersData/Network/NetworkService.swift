//
//  NetworkService.swift
//  UsersData
//
//  Created by Kseniya Zharikova on 5/10/22.
//

import Foundation

protocol NetworkServiceProtocol {
    func request<Request: DataRequest>(_ request: Request, completion: @escaping (Result<Request.Response, Error>) -> Void) async
}

final class NetworkService: NetworkServiceProtocol {
    
    func request<Request: DataRequest>(_ request: Request, completion: @escaping (Result<Request.Response, Error>) -> Void) {
        
        guard var urlComponent = URLComponents(string: request.url) else {
            completion(.failure(AppError.wrongUrl))
            return
        }
        
        var queryItems: [URLQueryItem] = []
        
        request.queryItems.forEach {
            let urlQueryItem = URLQueryItem(name: $0.key, value: $0.value)
            urlComponent.queryItems?.append(urlQueryItem)
            queryItems.append(urlQueryItem)
        }
        
        urlComponent.queryItems = queryItems
        
        guard let url = urlComponent.url else {
            completion(.failure(AppError.invalidEndpoint))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue.capitalized
        urlRequest.allHTTPHeaderFields = request.headers
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let response = response as? HTTPURLResponse, 200..<300 ~= response.statusCode else {
                completion(.failure(AppError.unknown))
                return
            }
            
            guard let data = data else {
                completion(.failure(AppError.noData))
                return
            }
            
            do {
                try completion(.success(request.decode(data)))
            } catch let error as NSError {
                completion(.failure(error))
            }
        }
        .resume()
    }
}

enum HTTPMethod: String {
    case get
    case post
    case put
    case patch
    case delete
}
