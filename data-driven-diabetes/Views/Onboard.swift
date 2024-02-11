//
//  Onboard.swift
//  data-driven-diabetes
//
//  Created by Tyler Keller on 2/10/24.
//

import SwiftUI

struct Onboard: View {
    @ObservedObject var viewModel: UserViewModel
    @ObservedObject var userManager = UserManager.shared
    @Environment(\.colorScheme) var colorScheme
    @State private var email = ""
    @State private var password = ""
    @State private var showInvalidAlert = false
    var onLogin: () -> Void // new closure parameter
    
    var body: some View {
        VStack {
            Spacer()
            Button(action: {
                viewModel.connectToDexcom()
                viewModel.getAllEGVs()
                onLogin()
            }) {
                ZStack {
                    Text("Connect to Dexcom")
                        .font(.title3)
                        .foregroundColor(.white)
                        .background(Color.green)
                }
            }
            Spacer()
        }
            background(ant_ioColor.login_background(for: colorScheme))
    }
}
