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
            List(viewModel.users, id:\.id) { user in
                DisclosureGroup {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(user.name)
                    }
                } label: {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("\(user.id)")
                    }
                }
            }
            .task {
                do {
                    viewModel.users = try await viewModel.getUsers()
                } catch {
                    print("Error", error)
                }
            }
        }
    }
}
