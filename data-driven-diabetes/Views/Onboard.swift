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
        HStack {
            Spacer()
            VStack {
                Spacer()
                Button(action: {
                    viewModel.connectToDexcom()
                    viewModel.getAllEGVs()
                    onLogin()
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.green)
                            .frame(width: 190, height: 80)
                        Text("Connect to Dexcom")
                            .font(.title3)
                            .foregroundColor(.white)
                    }
                }
                Spacer()
            }
            Spacer()
        }
        .background(ant_ioColor.login_background(for: colorScheme))
    }
}

