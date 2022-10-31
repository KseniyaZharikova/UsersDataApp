//
//  User.swift
//  UsersData
//
//  Created by Kseniya Zharikova on 23/9/22.
//

import Foundation
import CoreData

struct PaginatedUsersResponse: Decodable {
    let pageNumber: Int
    let isLast: Bool
    let results: [UserResponse]
}

struct UserResponse: Identifiable, Decodable {
    let id: String
    let language: String // russian, english
    let os: String // macos, window, linux, ios, android
    let hasPlayedDemo: Bool
    let firstLaunchDate: Double // timestamp
}

extension UserResponse {
    func save(context: NSManagedObjectContext) {
        let entity = User(context: context)
        entity.id = id
        entity.language = language
        entity.os = os
        entity.language = language
        entity.hasPlayedDemo = hasPlayedDemo
    }
}
