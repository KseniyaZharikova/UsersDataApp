//
//  User.swift
//  UsersData
//
//  Created by Kseniya Zharikova on 23/9/22.
//

import Foundation

struct UserResponse: Identifiable, Decodable {
    let id: String
    let language: String // russian, english
    let os: String // macos, window, linux, ios, android
    let hasPlayedDemo: Bool
    let firstLaunchDate: Double // timestamp
}
