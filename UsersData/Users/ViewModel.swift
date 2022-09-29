//
//  ViewModel.swift
//  UsersData
//
//  Created by Kseniya Zharikova on 23/9/22.
//

import Foundation
import SwiftUI

enum Users {}

extension Users  {
    @MainActor class ViewModel: ObservableObject {
        @Published var users: [User] = []
        
        init() {}
        
        func getUsers() async throws -> [User] {
            guard let url = URL(string: "https://project-vostok-analytics.herokuapp.com/users/all") else {
                fatalError("Invalid URL")
            }
            let (data, _) = try await URLSession.shared.data(from: url)
            let users = try JSONDecoder().decode([User].self, from: data)
            return users
        }
    }
}
