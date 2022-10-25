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
                    .toolbar {
                        ToolbarItem(placement:  .navigationBarTrailing) {
                            Button  {
                                Task {
                                    cachedUsers.forEach { (user) in
                                        context.delete(user)
                                    }
                                    try context.save()
                                    await viewModel.getUsers(context: context)
                                }
                            } label: {
                                Image(systemName: "arrow.clockwise.circle")
                                    .font(.headline)
                            }
                        }
                    }
            }.alert(viewModel.error, isPresented: $viewModel.isPresented) {
                Button("OK", role: .cancel, action: {})
            }
        }
        
        var userView: some View {
            List(cachedUsers, id: \.id) { user in
                DisclosureGroup {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("**Language:** \(user.language ?? "")")
                        Text("**OS:** \(user.os ?? "")")
                        Text("**Played Demo:** \(user.playedDemoText)")
                        Text("**First Launch Date:** \(user.firstLaunchDateText)")
                    }
                } label: {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("**ID:** \(user.id ?? "")")
                    }
                }
            }
            .overlay {
                ActivityIndicator(isAnimating: $viewModel.isAnimating, style: .large)
            }
            .task {
                if cachedUsers.isEmpty {
                    await viewModel.getUsers(context: context)
                }
            }
        }
    }
}

private extension User {
    var playedDemoText: String {
        hasPlayedDemo ? "Yes" : "No"
    }
    
    var firstLaunchDateText: String {
        let date = Date(timeIntervalSince1970: firstLaunchDate)
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .short
        dateFormatter.timeZone = .current
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
}
