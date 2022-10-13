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
        @FetchRequest(sortDescriptors: []) var users: FetchedResults<UserData>
        
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
                        self.saveData(users: users, context: context)
                        self.isAnimating = false
                    case .failure(let error):
                        self.error = error.localizedDescription
                        self.isPresented = true
                    }
                }
            })
        }
        
        func saveData(users: [User] , context: NSManagedObjectContext) {
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
