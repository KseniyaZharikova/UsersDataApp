//
//  User.swift
//  UsersData
//
//  Created by Kseniya Zharikova on 23/9/22.
//

import Foundation

struct User: Identifiable, Decodable {
    let id: String
    let language: String // russian, english
    let os: String // macos, window, linux, ios, android
    let hasPlayedDemo: Bool
    let firstLaunchDate: Double // timestamp
    
    var idText: String {
        return "ID: \(id)"
    }
    
    var playedDemoText: String {
        return hasPlayedDemo ? "Played Demo: Yes" : "Played Demo: No"
    }
    
    var langText: String {
        return "Language: \(language)"
    }
    
    var osText: String {
        return "OS: \(os)"
    }
}
