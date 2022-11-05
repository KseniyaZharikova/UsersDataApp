//
//  UserCellViewModel.swift
//  UsersData
//
//  Created by Kseniya Zharikova on 5/11/22.
//

import Foundation
import CoreData

struct UserCellViewModel {
    let id: String?
    let language: String?
    let os: String?
    let hasPlayedDemo: Bool
    let firstLaunchDate: Double
    
    init(user: User) {
        id = user.id
        language = user.language
        os = user.os
        hasPlayedDemo = user.hasPlayedDemo
        firstLaunchDate = user.firstLaunchDate
    }
    
    init(user: UserResponse) {
        id = user.id
        language = user.language
        os = user.os
        hasPlayedDemo = user.hasPlayedDemo
        firstLaunchDate = user.firstLaunchDate
    }
}
