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
        @State private var isAnimating: Bool = true
        
        init(viewModel: ViewModel) {
            self.viewModel = viewModel
        }
        
        var body: some View {
            NavigationView {
                userView
                    .navigationTitle("Users")
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
            }.overlay {
                ActivityIndicator(isAnimating: .constant(isAnimating), style: .large)
            }
            .task {
                do {
                    viewModel.users = try await viewModel.getUsers()
                    isAnimating = false
                } catch {
                    print("Error", error)
                }
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
