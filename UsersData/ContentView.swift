//
//  ContentView.swift
//  UsersData
//
//  Created by Kseniya Zharikova on 23/9/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        NavigationView {
            userView
         .navigationTitle("Users")
        }
    }
    
    var userView: some View {
        List(viewModel.users, id:\.id) { user in
            DisclosureGroup {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Language: \(user.lang)")
                    Text("Os: \(user.os)")
                    Text("Played Demo: \(user.playedDemoText)")
                }
            } label: {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Id: \(user.id)")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
