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
    @State var loggedIn = UserManager.shared.loggedIn
    

    var body: some View {
        Group {
//            if loggedIn {
            Home(viewModel: UserViewModel())
//            } else {
//                Onboard(viewModel: UserViewModel(), onLogin: { loggedIn = true })
//            }
        }
    }
}

