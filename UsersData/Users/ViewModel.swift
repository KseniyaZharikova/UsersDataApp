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
        var service: UserService?
        
        @Published var users: [User] = []
        @Published var error: String = ""
        
        @Published var isAnimating: Bool = false
        @Published var isPresented: Bool = false
        
        init(service:UserService = .init()) {
            self.service = service
        }
        
        func getUsers() async {
            self.isAnimating = true
            await service?.getUsers(path: "users/all", { result in
                DispatchQueue.main.async {
                    self.isAnimating = false
                    switch result {
                    case .success(let users):
                        self.users = users
                    case .failure(let error):
                        self.error = error.localizedDescription
                        self.isPresented = true
                    }
                }
            })
        }
    }
}
