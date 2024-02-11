//
//  Home.swift
//  data-driven-diabetes
//
//  Created by Tyler Keller on 2/10/24.
//

import SwiftUI

struct Home: View {
    @ObservedObject var viewModel: UserViewModel
    @ObservedObject var userManager = UserManager.shared
    
    var body: some View {
        Button(action: {
            viewModel.getAllEGVs()
        }, label: {
            Text("Fetch EGV Values")
        })
    }
}
