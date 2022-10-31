//
//  UserRequest.swift
//  UsersData
//
//  Created by Kseniya Zharikova on 28/10/22.
//

import Foundation

struct UserRequest: DataRequest {
    var page: Int
    var amountPerPage: Int
    
    init(page: Int, amountPerPage: Int) {
        self.page = page
        self.amountPerPage = amountPerPage
    }
    
    var url: String {
        let path: String = "users/all/paginated"
        return Constants.baseURL + path
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var queryItems: [String : String] {
        return ["page": String(page),"amountPerPage": String(amountPerPage)]
    }
    
    func decode(_ data: Data) throws -> PaginatedUsersResponse {
        let decoder = JSONDecoder()
        let response = try decoder.decode(PaginatedUsersResponse.self, from: data)
        return response
    }
}
