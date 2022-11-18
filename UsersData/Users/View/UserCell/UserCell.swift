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
    private let viewModel: UserCellViewModel
    
    init(viewModel: UserCellViewModel) {
        self.viewModel = viewModel
    }
    
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
        return viewModel.id ?? ""
    }
    
    var language: String {
        return viewModel.language ?? ""
    }
    
    var os: String {
        return viewModel.os ?? ""
    }
    
    var playedDemoText: String {
        return (viewModel.hasPlayedDemo) ? "Yes" : "No"
    }
    
    var firstLaunchDateText: String {
        let date = Date(timeIntervalSince1970: viewModel.firstLaunchDate)
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .short
        dateFormatter.timeZone = .current
        return dateFormatter.string(from: date)
    }
}
