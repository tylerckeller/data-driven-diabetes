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
    @State private var highBloodSugar: String = ""
    @State private var lowBloodSugar: String = ""
    var onLogin: () -> Void // new closure parameter
    
    var body: some View {
        
        HStack {
            Spacer()
            VStack {
                VStack(alignment: .leading, spacing: 20) {
                    Text("What is your daily blood sugar goal?")
                        .font(.custom("IowanOldStyle-Bold", fixedSize: 32))
                        .foregroundColor(ant_ioColor.text(for: colorScheme))
                    

                        Text("High:")
                            .font(.custom("IowanOldStyle-Bold", fixedSize: 25))
                            .foregroundColor(ant_ioColor.text(for: colorScheme))
                        
                        TextField("mg/dL", text: $highBloodSugar)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.decimalPad)
                            .font(.custom("IowanOldStyle-Bold", fixedSize: 32))
                            .frame(width: 150, height: 80)
                    
                    
                        Text("Low:")
                            .font(.custom("IowanOldStyle-Bold", fixedSize: 25))
                            .foregroundColor(ant_ioColor.text(for: colorScheme))
                        TextField("mg/dL", text: $lowBloodSugar)
                    
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.decimalPad)
                            .frame(width: 150, height: 80)
                            .font(.custom("IowanOldStyle-Bold", fixedSize: 32))
                    
                }
                .padding()
            
                Spacer()

                Button(action: {
                    viewModel.connectToDexcom()
                    viewModel.getAllEGVs()
                    viewModel.preprocessGoalValues()
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

#Preview{
    Onboard(viewModel: UserViewModel(), onLogin: {})
}
