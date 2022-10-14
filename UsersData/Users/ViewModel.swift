//
//  ViewModel.swift
//  UsersData
//
//  Created by Kseniya Zharikova on 23/9/22.
//

import Foundation
import SwiftUI
import CoreData

enum Users {}

extension Users  {
    @MainActor class ViewModel: ObservableObject {
        
        @FetchRequest(sortDescriptors: []) private var cachedUsers: FetchedResults<UserData>
        @Published var users: [User] = []
        
        var service: UserService?
        
        @Published var error: String = ""
        @Published var isAnimating: Bool = false
        @Published var isPresented: Bool = false
        
        init(service:UserService = .init()) {
            self.service = service
        }
        
        func getUsers(context: NSManagedObjectContext) async {
            self.isAnimating = true
            await service?.getUsers(path: "users/all", { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let users):
                        self.users = users
                        self.isAnimating = false
                        self.saveData(users: users, context: context)
                    case .failure(let error):
                        self.error = error.localizedDescription
                        self.users = self.getCachedUsers()
                        self.isPresented = true
                    }
                }
            })
        }
        
        private func getCachedUsers () -> [User] {
            return cachedUsers.compactMap({ User(id: $0.id ?? "",
                                                 language: $0.language ?? "",
                                                 os: $0.os ?? "",
                                                 hasPlayedDemo: $0.hasPlayedDemo,
                                                 firstLaunchDate: $0.firstLaunchDate)})
        }
        
        private func saveData(users: [User] , context: NSManagedObjectContext) {
            for user in users {
                let entity = UserData(context: context)
                entity.id = user.id
                entity.language = user.language
                entity.os = user.os
                entity.language = user.language
                entity.hasPlayedDemo = user.hasPlayedDemo
            }
            try? context.save()
        }
    }
}
