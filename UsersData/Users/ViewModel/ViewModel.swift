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
        @Published var isAnimating: Bool = false
        @Published var isPresented: Bool = false
        
        init(service: UserService) {
            self.service = service
        }
        
        func getUsers(context: NSManagedObjectContext) async {
            isAnimating = true
            await service?.getUsers(path: "users/all") { result in
                DispatchQueue.main.async { [weak self] in
                    self?.isAnimating = false
                    switch result {
                    case .success(let users):
                        self?.saveData(users: users, context: context)
                    case .failure(let error):
                        self?.error = error.localizedDescription
                        self?.isPresented = true
                    }
                }
            }
        }
        
        private func saveData(users: [UserResponse] , context: NSManagedObjectContext) {
            for user in users {
                let entity = User(context: context)
                entity.id = user.id
                entity.language = user.language
                entity.os = user.os
                entity.language = user.language
                entity.hasPlayedDemo = user.hasPlayedDemo
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
