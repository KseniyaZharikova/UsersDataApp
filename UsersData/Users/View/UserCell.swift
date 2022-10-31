//
//  UserCell.swift
//  UsersData
//
//  Created by Kseniya Zharikova on 31/10/22.
//

import Foundation
import SwiftUI
import CoreData

struct UserCell: View {
    var user: UserResponse?
    var cachedUser: User?
    
    var body: some View {
        DisclosureGroup {
            VStack(alignment: .leading, spacing: 10) {
                Text("**Language:** \(language)")
                Text("**OS:** \(os)")
                Text("**Played Demo:** \(playedDemoText)")
                Text("**First Launch Date:** \(firstLaunchDateText)")
            }
        } label: {
            VStack(alignment: .leading, spacing: 1) {
                Text("**ID:** \(id)")
            }
        }
    }
}

private extension UserCell {
    var id: String {
        return (user?.id ?? cachedUser?.id) ?? ""
    }
    
    var language: String {
        return (user?.language ?? cachedUser?.language) ?? ""
    }

    var os: String {
        return (user?.os ?? cachedUser?.os) ?? ""
    }
    
    var playedDemoText: String {
        return (user?.playedDemoText ?? cachedUser?.playedDemoText) ?? ""
    }
    
    var firstLaunchDateText: String {
        return (user?.firstLaunchDateText ?? cachedUser?.firstLaunchDateText) ?? ""
    }
}


private extension UserResponse {
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
