//
//  TitleScreen.swift
//  data-driven-diabetes
//
//  Created by Colton Morris on 2/10/24.
//

import SwiftUI

struct TitleScreen: View {
    
    @ObservedObject var viewModel: UserViewModel
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack{
            Text("ANT.IO")
            
        }
        .frame(width: 20, alignment: .center)
        .background(ant_ioColor.homepage_background(for: colorScheme))
    }
        
        
}

#Preview {
    TitleScreen(viewModel: UserViewModel())
}
