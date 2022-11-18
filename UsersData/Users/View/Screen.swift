//
//  Screen.swift
//  UsersData
//
//  Created by Kseniya Zharikova on 27/9/22.
//

import Foundation
import SwiftUI
import UserNotifications

extension Users {
    struct Screen: View {
        
        @ObservedObject private var viewModel: ViewModel
        @Environment(\.managedObjectContext) var context
        @FetchRequest(sortDescriptors: []) private var cachedUsers: FetchedResults<User>
        
        init(viewModel: ViewModel) {
            self.viewModel = viewModel
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound]) { _, _ in }
            UNUserNotificationCenter.current().add(viewModel.getUNNotificationRequest())
        }
        
        var body: some View {
            NavigationView {
                userView
                    .navigationTitle("Users")
            }.alert(viewModel.error, isPresented: $viewModel.errorIsPresented) {
                Button("OK", role: .cancel, action: {})
            }
        }
        
        var userView: some View {
            List() {
                
                if viewModel.errorIsPresented && viewModel.users.isEmpty {
                    ForEach(cachedUsers, id: \.id) { user in
                        UserCell(viewModel: .init(user: user))
                    }
                } else {
                    ForEach(viewModel.users, id: \.id) { user in
                        UserCell(viewModel: .init(user: user))
                    }
                }
                
                if !viewModel.users.isEmpty {
                    ActivityIndicator(isAnimating: $viewModel.isLoading, style: .medium)
                        .onAppear {
                            Task {
                                await viewModel.getUsersAction(cachedUsers: cachedUsers, context: context)
                            }
                        }
                }
            }
            .overlay {
                if viewModel.users.isEmpty {
                    ActivityIndicator(isAnimating: $viewModel.isLoading, style: .large)
                }
            }
            .refreshable {
                Task {
                    await viewModel.getUsersAction(forceRefresh: true, cachedUsers: cachedUsers, context: context)
                }
            }
            .task {
                await viewModel.getUsers()
            }
        }
    }
}
