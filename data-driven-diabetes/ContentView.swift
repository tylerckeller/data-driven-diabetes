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
    @ObservedObject var userManager: UserManager
    @State var isLoggedIn = UserManager.shared.isLoggedIn
    

    var body: some View {
        Group {
            if isLoggedIn {
                Home(viewModel: UserViewModel())
            } else {
                Onboard(viewModel: UserViewModel()) {
                    userManager.isLoggedIn = true
                }
            }
        }
    }
}

