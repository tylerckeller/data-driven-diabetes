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
    

    var body: some View {
        Group {
            if UserManager.shared.checkLoginStatus() {
                Home(viewModel: UserViewModel())
            } else {
                Onboard(viewModel: UserViewModel())
            }
        }
    }
}

