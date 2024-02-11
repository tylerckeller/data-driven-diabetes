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
    
    @ObservedObject var viewModel: UserViewModel
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var userManager = UserManager.shared
    
    // Example data points for the scatter plot
    private var dataPoints: [DataPoint] {
        let maxValue = viewModel.glucoseRecords.map { $0.value }.max() ?? 1
        let currentDayRecords = viewModel.getCurrentDateData()
        return currentDayRecords.enumerated().map { index, record in
            let scaledX = CGFloat(index) / CGFloat(currentDayRecords.count - 1)
            let scaledY = -1 * ((CGFloat(record.value) / CGFloat(maxValue) - 1))
            print("X: \(scaledX), Y: \(scaledY)")
            return DataPoint(x: scaledX, y: scaledY)
        }
    }
    
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
        formatter.dateFormat = "MM/dd" // Day and month
        return formatter.string(from: currentDate)
    }
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                ZStack(alignment:.center){
                    RoundedRectangle(cornerRadius: 38.5)
                        .fill(ant_ioColor.homepage_header(for: colorScheme))
                        .ignoresSafeArea()
                        .frame(width: geometry.size.width, height: 130)
                    HStack{
                        Text(greetingBasedOnTimeOfDay+",\n"+"Blaster")
                            .font(.custom("IowanOldStyle-Bold", fixedSize: 25))
                            .padding(.leading, 30)
                            .foregroundColor(ant_ioColor.homepage_header_text(for: colorScheme))
                        Spacer()

                        Text(date)
                            .font(.custom("IowanOldStyle-Bold", fixedSize: 25))
                            .foregroundColor(ant_ioColor.date_text(for: colorScheme))
                            .padding(.trailing, 30)
                    }
                }
            }
            .frame(height: 130)
            
            ScatterPlotView(dataPoints: dataPoints)
                .frame(width: .infinity, height: 210)
                .padding(20)
            HStack{
                Spacer()
                    .frame(width: 20)
                VStack (alignment: .leading){
                    VStack {
                        Text(String(format: "%.2f", viewModel.getCurrentDateInRangePercentage()) + "%")
                            .font(.custom("IowanOldStyle-Bold", fixedSize: 32))
                            .foregroundColor(ant_ioColor.text(for: colorScheme))
                        Text("  in range")
                            .font(.custom("IowanOldStyle-Bold", fixedSize: 25))
                            .foregroundColor(ant_ioColor.text(for: colorScheme))
                        Color.clear
                                .frame(height: 1)
                        HStack {
                            Text(String(format: "%.2f", viewModel.getCurrentDateAverageGlucoseValue()))
                                .font(.custom("IowanOldStyle-Bold", fixedSize: 32)) // Larger font for the number
                                .foregroundColor(ant_ioColor.text(for: colorScheme))
                            Text(" mg/dl")
                                .font(.custom("IowanOldStyle-Bold", fixedSize: 25)) // Smaller font for the unit
                                .foregroundColor(ant_ioColor.text(for: colorScheme))
                            Text("  average")
                                .font(.custom("IowanOldStyle-Bold", fixedSize: 25))
                                .foregroundColor(ant_ioColor.text(for: colorScheme))
                        }
                        Color.clear
                                .frame(height: 1)
                        HStack {
                            Text("11")
                                .font(.custom("IowanOldStyle-Bold", fixedSize: 32))
                                .foregroundColor(ant_ioColor.text(for: colorScheme))
                            Text("  day streak")
                                .font(.custom("IowanOldStyle-Bold", fixedSize: 25))
                                .foregroundColor(ant_ioColor.text(for: colorScheme))
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            Spacer()
        }
        .background(ant_ioColor.homepage_background(for: colorScheme))
    }
}
