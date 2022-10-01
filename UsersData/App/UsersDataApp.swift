//
//  UsersDataApp.swift
//  UsersData
//
//  Created by Kseniya Zharikova on 23/9/22.
//

import SwiftUI

@main
struct UsersDataApp: App {
    var body: some Scene {
        WindowGroup {
            Users.Screen(viewModel: .init())
        }
    }
}
