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
        var service: UserService?
        
        @Published var error: String = ""
        @Published var isLoading: Bool = false
        @Published var errorIsPresented: Bool = false
        
        init(service: UserService) {
            self.service = service
        }
        
        func getUsers(cachedUsers: FetchedResults<User>?,context: NSManagedObjectContext) async {
            isLoading = true
            await service?.getUsers(path: "users/all") { result in
                DispatchQueue.main.async { [weak self] in
                    self?.isLoading = false
                    switch result {
                    case .success(let users):
                        self?.deleteCachedUsers(cachedUsers: cachedUsers, context: context)
                        self?.saveNewUsers(users: users, context: context)
                    case .failure(let error):
                        self?.error = error.localizedDescription
                        self?.errorIsPresented = true
                    }
                }
            }
        }
        
        private func deleteCachedUsers(cachedUsers: FetchedResults<User>?, context: NSManagedObjectContext) {
            guard let cachedUsers = cachedUsers else { return }
            
            cachedUsers.forEach { (user) in
                context.delete(user)
            }
            try? context.save()
        }
        
        private func saveNewUsers(users: [UserResponse], context: NSManagedObjectContext) {
            users.forEach { user in
                user.save(context: context)
            }
            try? context.save()
        }
        
        func getUNNotificationRequest() -> UNNotificationRequest {
            let content = UNMutableNotificationContent()
            content.title = "You can update users"
            content.subtitle = "Just tap on reload buuton"
            content.sound = UNNotificationSound.default
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 15, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString , content: content, trigger: trigger)
            return request
        }
    }
}
