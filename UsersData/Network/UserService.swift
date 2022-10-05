//
//  UserService.swift
//  UsersData
//
//  Created by Kseniya Zharikova on 5/10/22.
//

import Foundation

struct UserService {
    func getUsers(path: String, _ completion: @escaping (Result<[User], Error>) -> Void) async {
        
        let task = Task { () -> [User] in
            let url = URL(string: Constants.baseURL + path)
            let (data, _) = try await URLSession.shared.data(from: url!)
            let users = try JSONDecoder().decode([User].self, from: data)
            return users
        }
        
        await completion(task.result)
    }
}

