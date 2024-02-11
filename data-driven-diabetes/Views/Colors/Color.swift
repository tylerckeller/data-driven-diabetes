//
//  Color.swift
//  data-driven-diabetes
//
//  Created by Tyler Keller on 2/10/24.
//

import Foundation
import SwiftUI

struct ant_ioColor {
    @ObservedObject var userManager = UserManager.shared
    
    // colors related to login screens
    // no light and dark modes for these (because they are one time pages)
    static func login_background(for colorScheme: SwiftUI.ColorScheme) -> Color{
        return Color(red: 0.941, green: 0.667, blue: 0.345) // #f0aa58
    }
    
    // used for the title page of the app
    static func title(for colorScheme: SwiftUI.ColorScheme) -> Color{
        return Color(red: 0.596, green: 0.322, blue: 0.114) // #98521d
    }
    
    // green dexcom box
    static func dexcom_box(for colorScheme: SwiftUI.ColorScheme) -> Color{
        return Color(red: 0.2, green: 0.651, blue: 0.192) // #33a631
    }
    
    // main text of the app
    // black and white
    static func text(for colorScheme: SwiftUI.ColorScheme) -> Color {
        switch colorScheme {
        case .light:
            return Color(red: 0/255, green: 0/255, blue: 0/255)
        case .dark:
            return Color(red: 255/255, green: 255/255, blue: 255/255)
        }
    }
    
    // this is the actual color of the bubble at the top
    // orange and then dark brown
    static func homepage_header(for colorScheme: SwiftUI.ColorScheme) -> Color {
        print("Current color scheme for text color: \(colorScheme)")
        switch colorScheme {
        case .light:
            return Color(red: 0.941, green: 0.667, blue: 0.345) // #f0aa58
        case .dark:
            return Color(red: 0.361, green: 0.298, blue: 0.227) // #5c4c3a
        }
    }
    
    // the "Hello, Blaster"
    // has a light and dark
    static func homepage_header_text(for colorScheme: SwiftUI.ColorScheme) -> Color {
        switch colorScheme {
        case .light:
            return Color(red: 0.227, green: 0.125, blue: 0.047) // #3a200c
        case .dark:
            return Color(red: 1, green: 0.847, blue: 0.729) // #ffd8ba
        }
    }
    
    // homepage background, either white or dark blue/ gray
    static func homepage_background(for colorScheme: SwiftUI.ColorScheme) -> Color {
        switch colorScheme {
        case .light:
            return Color(red: 1, green: 1, blue: 1) // #ffffff
        case .dark:
            return Color(red: 0.196, green: 0.196, blue: 0.216) // #323237
        }
    }
    
    // changes the color of the date text only
    static func date_text(for colorScheme: SwiftUI.ColorScheme) -> Color {
        switch colorScheme{
        case .light:
            return Color(red: 0.596, green: 0.322, blue: 0.114) // #98521d
        case .dark:
            return Color(red: 0.776, green: 0.655, blue: 0.565) // #c6a790
        }
    }
    
    // arrows so you can tab through the days
    static func arrows(for colorScheme: SwiftUI.ColorScheme) -> Color {
        switch colorScheme{
        case .light:
            return Color(red: 0.765, green: 0.443, blue: 0.196) // #c37132
        case .dark:
            return Color(red: 0.584, green: 0.455, blue: 0.357) // #95745b
        }
    }

    static func notes_box(for colorScheme: SwiftUI.ColorScheme) -> Color {
        switch colorScheme{
        case .light:
            return Color(red: 0.851, green: 0.851, blue: 0.851) // #d9d9d9
        case .dark:
            return Color(red: 0.271, green: 0.271, blue: 0.271) // #454545
        }
    }
    
    // colors related to the bars of the graph, might be unnecessary
    static func graph_red(for colorScheme: SwiftUI.ColorScheme) -> Color {
        return Color(red: 0.925, green: 0.729, blue: 0.729) // #ecbaba
    }
    static func graph_green(for colorScheme: SwiftUI.ColorScheme) -> Color {
        return Color(red: 0.796, green: 0.886, blue: 0.773) // #cbe2c5
    }
    static func graph_yellow(for colorScheme: SwiftUI.ColorScheme) -> Color {
        return Color(red: 0.961, green: 0.855, blue: 0.647) // #f5daa5
    }
}

enum ColorScheme: String, CaseIterable {
    case dark
    case light
}

