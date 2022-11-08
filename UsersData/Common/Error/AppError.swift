//
//  AppError.swift
//  UsersData
//
//  Created by Kseniya Zharikova on 8/11/22.
//

import Foundation

enum AppError: Error {
    case wrongUrl
    case invalidEndpoint
    case noData
    case unknown
}
