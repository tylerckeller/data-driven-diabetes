//
//  ContentView.swift
//  data-driven-diabetes
//
//  Created by Tyler Keller on 2/10/24.
//

import SwiftUI
import Firebase

struct ContentView: View {
    @ObservedObject var viewModel = UserViewModel()
    @State var loggedIn = UserManager.shared.isLoggedIn
    

    var body: some View {
        Group {
            if loggedIn {
                Homepage(viewModel: viewModel)
            } else {
                Onboard(viewModel: viewModel, onLogin: { loggedIn = true })
            }
        }
    }
}

