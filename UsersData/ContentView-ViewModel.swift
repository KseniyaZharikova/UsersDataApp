//
//  ContentView-ViewModel.swift
//  UsersData
//
//  Created by Kseniya Zharikova on 23/9/22.
//

import Foundation
import SwiftUI

extension ContentView  {
   @MainActor class ViewModel: ObservableObject {
       @Published private (set) var users = UserModel.userExamples
    }
}
