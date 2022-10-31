//
//  ContentView.swift
//  UsersData
//
//  Created by Kseniya Zharikova on 23/9/22.
//

import SwiftUI

struct Users_Previews: PreviewProvider {
    static var previews: some View {
        Users.Screen(viewModel: .init(service: .init()))
    }
}
