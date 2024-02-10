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
    var onLogin: () -> Void // new closure parameter
    
    var body: some View {
        VStack {
            Spacer()
            Button(action: {
                viewModel.connectToDexcom()
                onLogin()
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.green)
                        .frame(width: 160, height: 80)
                    Text("Connect to Dexcom")
                        .font(.title)
                        .foregroundColor(.white)
                }
            }
            Spacer()
        }
        .background(ant_ioColor.background(for: UserManager.shared.colorScheme))
    }
}

