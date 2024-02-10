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
    @State private var email = ""
    @State private var password = ""
    @State private var showInvalidAlert = false
    var onLogin: () -> Void // new closure parameter
    
    var body: some View {
        VStack {
            Spacer()
            Button(action: {
                viewModel.connectToDexcom()
                showInvalidAlert = false
                onLogin()
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.blue)
                        .frame(width: 160, height: 80)
                    Text("Connect to Dexcom")
                        .font(.title)
                        .foregroundColor(.white)
                }
            }
            Text("*Your email is only required to verify that you are a student.\n\nYou will not recieve any marketing or promotional materials at this email address.")
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(16)
                .font(.footnote)
        }
        .background(ant_ioColor.login_background(for: UserManager.shared.colorScheme))
        .alert(isPresented: $showInvalidAlert) {
            Alert(title: Text("Invalid Login"), message: Text("Please enter an @mines.edu email"), dismissButton: .default(Text("OK")))
        }
    }
}

struct EmailTextField: View {
    @Binding var email: String
    
    var body: some View {
        TextField("Email", text: $email)
            .textContentType(.emailAddress)
            .keyboardType(.emailAddress)
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .multilineTextAlignment(.center)
            .background()
            .padding(12)
            .textFieldStyle(RoundedBorderTextFieldStyle())
    }
}


struct PasswordTextField: View {
    @Binding var password: String
    
    var body: some View {
        TextField("Password", text: $password)
            .textContentType(.password)
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .multilineTextAlignment(.center)
            .background()
            .padding(12)
            .textFieldStyle(RoundedBorderTextFieldStyle())
    }
}

