//
//  UserService.swift
//  UsersData
//
//  Created by Kseniya Zharikova on 5/10/22.
//

import Foundation

struct UserService {
    func getUsers(path: String, _ completion: @escaping (Result<[UserResponse], Error>) -> Void) async {
        
        let task = Task { () -> [UserResponse] in
            let url = URL(string: Constants.baseURL + path)
            let (data, _) = try await URLSession.shared.data(from: url!)
            let users = try JSONDecoder().decode([UserResponse].self, from: data)
            return users
        }
        
        await completion(task.result)
    }
}

