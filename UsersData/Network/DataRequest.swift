//
//  DataRequest.swift
//  UsersData
//
//  Created by Kseniya Zharikova on 8/11/22.
//

import Foundation

protocol DataRequest {
    associatedtype Response
    
    var url: String { get }
    var method: HTTPMethod { get }
    var headers: [String : String] { get }
    var queryItems: [String : String] { get }
    
    func decode(_ data: Data) throws -> Response
}

extension DataRequest {
    var headers: [String : String] {
        [:]
    }
    
    var queryItems: [URLQueryItem] {
        []
    }
}

extension DataRequest where Response: Decodable {
    func decode(_ data: Data) throws -> Response {
        let decoder = JSONDecoder()
        return try decoder.decode(Response.self, from: data)
    }
}
