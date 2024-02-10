//
//  Homepage.swift
//  data-driven-diabetes
//
//  Created by Colton Morris on 2/10/24.
//

import SwiftUI

struct DataPoint: Identifiable {
    let id = UUID() // Unique identifier
    let x: CGFloat
    let y: CGFloat
}

struct ScatterPlotView: View {
    let dataPoints: [DataPoint] // Use DataPoint structs
    let bar3: CGFloat = 1
    let bar2: CGFloat = 0.7
    let bar1: CGFloat = 0.25
    let bar0: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack (){
                // Drawing bars
                barView(yPosition: bar3, in: geometry.size)
                barView(yPosition: bar2, in: geometry.size)
                barView(yPosition: bar0, in: geometry.size)
                barView(yPosition: bar1, in: geometry.size)
                
                // Plotting points
                ForEach(dataPoints) { point in
                    Circle()
                        .frame(width: 3, height: 3)
                        .position(x: point.x * geometry.size.width, y: point.y * geometry.size.height)
                }
            }
            .background()
            .cornerRadius(38.5)
            .shadow(color: .brown, radius: 2.5, x: 0, y: 4)
        }
    }
    
    private func barView(yPosition: CGFloat, in size: CGSize) -> some View {
        Rectangle()
            .fill(Color.gray.opacity(0.5))
            .frame(width: size.width, height: 1)
            .position(x: size.width / 2, y: size.height * yPosition)
    }
}

struct Homepage: View {
    
    // Example data points for the scatter plot
    private let dataPoints = [
        DataPoint(x: 0.2, y: 0.8),
        DataPoint(x: 0.5, y: 0.5),
        DataPoint(x: 0.8, y: 0.2)
    ]
    
    @ObservedObject var userManager = UserManager.shared
    
    // Define your data points using the DataPoint struct
    
    
    var greetingBasedOnTimeOfDay: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 6..<12: return "Good\nMorning"
        case 12..<17: return "Good\nAfternoon"
        case 17..<22: return "Good\nEvening"
        default: return "Good\nNight"
        }
    }
    
    var date: String {
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM" // Day and month
        return formatter.string(from: currentDate)
    }
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                ZStack(alignment:.center){
                    RoundedRectangle(cornerRadius: 38.5)
                        .fill(ant_ioColor.homepage_header(for: UserManager.shared.colorScheme))
                        .ignoresSafeArea()
                        .frame(width: geometry.size.width, height: 130)
                    HStack{
                        Text(greetingBasedOnTimeOfDay+",\n"+"Blaster")
                            .font(.custom("IowanOldStyle-Bold", fixedSize: 25))
                            .padding(.leading, 30)
                            .foregroundColor(ant_ioColor.homepage_header_text(for: UserManager.shared.colorScheme))
                        Spacer()
                        Text(date)
                            .font(.custom("IowanOldStyle-Bold", fixedSize: 25))
                            .padding(.trailing, 30)
                            .foregroundColor(ant_ioColor.date_text(for: UserManager.shared.colorScheme))
                        
                    }
                }
            }
            .frame(height: 130)
            
            ScatterPlotView(dataPoints: dataPoints)
                .frame(width:.infinity-40, height: 180)
                .padding(20)
            HStack{
                Spacer()
                    .frame(width: 20)
                VStack (alignment: .leading){
                    
                    Text("88%")
                        .font(.custom("IowanOldStyle-Bold", fixedSize: 32))
                        .foregroundColor(ant_ioColor.text(for: UserManager.shared.colorScheme))
                    Text("in range")
                        .font(.custom("IowanOldStyle-Bold", fixedSize: 25))
                        .foregroundColor(ant_ioColor.text(for: UserManager.shared.colorScheme))
                    Color.clear
                            .frame(height: 1)
                    Text("70")
                        .font(.custom("IowanOldStyle-Bold", fixedSize: 32)) // Larger font for the number
                        .foregroundColor(ant_ioColor.text(for: UserManager.shared.colorScheme)) +
                    Text(" mg/dl")
                        .font(.custom("IowanOldStyle-Bold", fixedSize: 25)) // Smaller font for the unit
                        .foregroundColor(ant_ioColor.text(for: UserManager.shared.colorScheme))
                    Text("average")
                        .font(.custom("IowanOldStyle-Bold", fixedSize: 25))
                        .foregroundColor(ant_ioColor.text(for: UserManager.shared.colorScheme))
                    Color.clear
                            .frame(height: 1)
                    Text("11")
                        .font(.custom("IowanOldStyle-Bold", fixedSize: 32))
                        .foregroundColor(ant_ioColor.text(for: UserManager.shared.colorScheme))
                    Text("day streak")
                        .font(.custom("IowanOldStyle-Bold", fixedSize: 25))
                        .foregroundColor(ant_ioColor.text(for: UserManager.shared.colorScheme))
                    Color.clear
                            .frame(height: 1)
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading) // Ensure alignment is leading here
            }
            
            
            
            
            
            
            

            
            
            Spacer()
            
            
        }
        .background(ant_ioColor.homepage_background(for: UserManager.shared.colorScheme))
        
    }
}

#Preview {
    Homepage()
}
