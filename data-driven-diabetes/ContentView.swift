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
    @State var loggedIn = false
    @State var welcomed = false

    var body: some View {
        Group {
            if loggedIn && welcomed {
                Homepage(viewModel: viewModel)
            } else if !welcomed && !loggedIn {
                TitleScreen(viewModel: viewModel, onWelcome: { welcomed = true })
            } else {
                Onboard(viewModel: viewModel, onLogin: { loggedIn = true })
            }
        }
    }
}

