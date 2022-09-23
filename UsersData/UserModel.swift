//
//  UserModel.swift
//  UsersData
//
//  Created by Kseniya Zharikova on 23/9/22.
//

import Foundation

struct UserModel: Identifiable {
    var id: Int
    var lang: String
    var os: String
    var playedDemo: Bool
    
    static var userExamples: [UserModel] {
        return [UserModel(id: 1, lang: "English", os: "MacOs", playedDemo: false),
                UserModel(id: 2, lang: "Russian", os: "Windows", playedDemo: true),
                UserModel(id: 3, lang: "Hindi", os: "MacOs", playedDemo: false),
                UserModel(id: 4, lang: "Spanish", os: "Windows", playedDemo: true)]
    }
    
    var playedDemoText: String {
        return playedDemo ? "Yes" : "No"
    }
}
