//
//  Screen.swift
//  UsersData
//
//  Created by Kseniya Zharikova on 27/9/22.
//

import Foundation
import SwiftUI

extension Users {
    struct Screen: View {
        @ObservedObject private var viewModel: ViewModel
        @Environment(\.managedObjectContext) var context
        
        init(viewModel: ViewModel) {
            self.viewModel = viewModel
        }
        
        var body: some View {
            NavigationView {
                userView
                    .navigationTitle("Users")
            }.alert(viewModel.error, isPresented: $viewModel.isPresented) {
                Button("Retry", role: .cancel, action: {
                    Task {
                        await viewModel.getUsers(context: context)
                    }
                })
            }
        }
        
        var userView: some View {
            List(viewModel.users, id: \.id) { user in
                DisclosureGroup {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("**Language:** \(user.language)")
                        Text("**OS:** \(user.os)")
                        Text("**Played Demo:** \(user.playedDemoText)")
                        Text("**First Launch Date:** \(user.firstLaunchDateText)")
                    }
                } label: {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("**ID:** \(user.id)")
                    }
                }
            }
            .overlay {
                ActivityIndicator(isAnimating: $viewModel.isAnimating, style: .large)
            }
            .task {
                await viewModel.getUsers(context: context)
            }
        }
    }
}

private extension User {
    var playedDemoText: String {
        hasPlayedDemo ? "Yes" : "No"
    }
    
    var firstLaunchDateText:String {
        let date = Date(timeIntervalSince1970: firstLaunchDate)
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .short
        dateFormatter.timeZone = .current
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
}
