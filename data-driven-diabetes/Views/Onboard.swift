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
    @State private var showInvalidAlert = false
    @State private var highBloodSugar: String = "180"
    @State private var lowBloodSugar: String = "70"
    @State private var firstName: String = ""
    var onLogin: () -> Void
    
    var body: some View {
        
        HStack {
            Spacer()
            VStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text("What is your first name?")
                        .font(.custom("IowanOldStyle-Bold", fixedSize: 32))
                        .foregroundColor(ant_ioColor.text(for: colorScheme))
                    TextField("Name", text: $firstName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.default)
                        .font(.custom("IowanOldStyle-Bold", fixedSize: 25))
                        .frame(width: 225, height: 80)
                    
                    Text("What is your daily blood sugar goal?")
                        .font(.custom("IowanOldStyle-Bold", fixedSize: 32))
                        .foregroundColor(ant_ioColor.text(for: colorScheme))
                    

                        Text("High:")
                            .font(.custom("IowanOldStyle-Bold", fixedSize:30))
                            .foregroundColor(ant_ioColor.text(for: colorScheme))
                        
                        TextField("mg/dL", text: $highBloodSugar)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.decimalPad)
                            .font(.custom("IowanOldStyle-Bold", fixedSize: 25))
                            .frame(width: 150, height: 80)
                    
                        Text("Low:")
                            .font(.custom("IowanOldStyle-Bold", fixedSize: 30))
                            .foregroundColor(ant_ioColor.text(for: colorScheme))
                        TextField("mg/dL", text: $lowBloodSugar)
                    
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.decimalPad)
                            .frame(width: 150, height: 80)
                            .font(.custom("IowanOldStyle-Bold", fixedSize: 25))
                    
                }
                .padding()
            
                Spacer()

                Button(action: {
                    viewModel.connectToDexcom()
                    viewModel.getAllEGVs()
                    viewModel.preprocessGoalValues()
                    onLogin()
                    viewModel.low = Int(highBloodSugar) ?? 180
                    viewModel.high = Int(lowBloodSugar) ?? 70
                    viewModel.name = firstName
                }) {
                    ZStack {
                        Text("Connect to Dexcom")
                            .font(.custom("IowanOldStyle-Bold", fixedSize: 25))
                            .foregroundColor(.white)
                            .frame(width: 190, height: 80)
                            .background(ant_ioColor.title(for: colorScheme))
                    }
                    .cornerRadius(10.5)
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
