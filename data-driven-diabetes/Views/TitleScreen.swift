import SwiftUI

struct TitleScreen: View {
    
    @ObservedObject var viewModel: UserViewModel
    @Environment(\.colorScheme) var colorScheme
    
    @State var loggedIn: Bool = false
    
    var body: some View {
        NavigationView {
            NavigationLink(destination: Onboard(viewModel: viewModel, onLogin: { loggedIn = true })) {
                ZStack {
                    Spacer()
                    Color(ant_ioColor.login_background(for: colorScheme))
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack(spacing: -20) {
                        Text("A")
                        Text("N")
                        Text("T")
                        Circle()
                            .frame(width: 15, height: 15)
                            .padding(20)
                        Text("I")
                        Text("O")
                        
                    }
                    
                    
                    .frame(width: 100, alignment: .center) 
                    .background(ant_ioColor.login_background(for: colorScheme))
                    .font(.custom("IowanOldStyle-Bold", fixedSize: 100))
                    .foregroundColor(ant_ioColor.title(for: colorScheme))
                    
                }
            }
        }
    }
}

#Preview {
    TitleScreen(viewModel: UserViewModel())
}
