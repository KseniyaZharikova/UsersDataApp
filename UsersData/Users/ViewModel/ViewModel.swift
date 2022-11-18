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
        
        var cachedUsers: FetchedResults<User>?
        var context: NSManagedObjectContext?
        let service: NetworkServiceProtocol!
        
        @Published var error: String = ""
        @Published var isLoading: Bool = false
        @Published var errorIsPresented: Bool = false
        @Published var users: [UserResponse] = []
        
        var isLast: Bool = false
        var page = 0
        var forceRefresh = false
        let amountPerPage = 15
        
        init(service: NetworkService) {
            self.service = service
        }
        
        func getUsersAction(forceRefresh: Bool = false, cachedUsers: FetchedResults<User>?,context: NSManagedObjectContext) async {
            self.forceRefresh = forceRefresh
            self.cachedUsers = cachedUsers
            self.context = context
            
            if forceRefresh {
                page = 0
            }
            guard !isLast else { return }
            
            await getUsers()
        }
        
        func getUsers() async{
            isLoading = true
            let request = UserRequest(page: page, amountPerPage: amountPerPage)
            await service.request(request) { [weak self] result in
                guard let self  = self else { return }
                DispatchQueue.main.async {
                    self.isLoading = false
                    switch result {
                    case .success(let reponse):
                        self.updateUserList(reponse: reponse)
                        self.updateCachedUsers(reponse: reponse)
                    case .failure(let error):
                        self.error = error.localizedDescription
                        self.errorIsPresented = true
                    }
                }
            }
        }
        
        func updateUserList(reponse: PaginatedUsersResponse) {
            if forceRefresh {
                self.users.removeAll()
            }
            self.users.append(contentsOf: reponse.results)
            self.isLast = reponse.isLast
            self.page += 1
        }
        
        func updateCachedUsers(reponse: PaginatedUsersResponse) {
            guard let context = context else { return }
            
            if forceRefresh {
                deleteCachedUsers(cachedUsers: cachedUsers, context: context)
            }
            saveNewUsers(users: reponse.results, context: context)
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
            content.title = "Application works even without internet"
            content.subtitle = "We store data that has already been uploaded"
            content.sound = UNNotificationSound.default
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 15, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString , content: content, trigger: trigger)
            return request
        }
    }
}
