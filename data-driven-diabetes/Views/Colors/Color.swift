//
//  Color.swift
//  data-driven-diabetes
//
//  Created by Tyler Keller on 2/10/24.
//

import Foundation
import SwiftUI

struct Deal_ioColor {
    @ObservedObject var userManager = UserManager.shared
    
    static func accent(for colorScheme: ColorScheme) -> Color {
        switch colorScheme {
        case .light:
            return Color(red: 230/255, green: 230/255, blue: 230/255)
        case .dark:
            return Color(red: 25/255, green: 25/255, blue: 25/255)
        }
    }
    static func background(for colorScheme: ColorScheme) -> Color {
        switch colorScheme {
        case .light:
            return Color(red: 225/255, green: 225/255, blue: 225/255)
        case .dark:
            return Color(red: 30/255, green: 30/255, blue: 30/255)
        }
    }
    static func unselected(for colorScheme: ColorScheme) -> Color {
        switch colorScheme {
        case .light:
            return Color(red: 220/255, green: 220/255, blue: 220/255)
        case .dark:
            return Color(red: 35/255, green: 35/255, blue: 35/255)
        }
    }
    static func selected(for colorScheme: ColorScheme) -> Color {
        switch colorScheme {
        case .light:
            return Color(red: 170/255, green: 170/255, blue: 170/255)
        case .dark:
            return Color(red: 85/255, green: 85/255, blue: 85/255)
        }
    }
    static func lightShadow(for colorScheme: ColorScheme) -> Color {
        switch colorScheme {
        case .light:
            return Color(red: 255/255, green: 255/255, blue: 255/255)
        case .dark:
            return Color(red: 255/255, green: 255/255, blue: 255/255)
        }
    }
    static func darkShadow(for colorScheme: ColorScheme) -> Color {
        switch colorScheme {
        case .light:
            return Color(red: 163/255, green: 177/255, blue: 198/255)
        case .dark:
            return Color(red: 163/255, green: 177/255, blue: 198/255)
        }
    }
    static func tabColor(for colorScheme: ColorScheme) -> Color {
        switch colorScheme {
        case .light:
            return Color(red: 225/255, green: 225/255, blue: 225/255)
        case .dark:
            return Color(red: 30/255, green: 30/255, blue: 30/255)
        }
    }
    static func text(for colorScheme: ColorScheme) -> Color {
        switch colorScheme {
        case .light:
            return Color(red: 0/255, green: 0/255, blue: 0/255)
        case .dark:
            return Color(red: 255/255, green: 255/255, blue: 255/255)
        }
    }
    static func symbol(for colorScheme: ColorScheme) -> Color {
        switch colorScheme {
        case .light:
            return Color(red: 0/255, green: 0/255, blue: 0/255)
        case .dark:
            return Color(red: 255/255, green: 255/255, blue: 255/255)
        }
    }
    static func logo(for colorScheme: ColorScheme) -> String {
        switch colorScheme {
        case .light:
            return "dealio_light"
        case .dark:
            return "dealio_dark"
        }
    }
}

enum ColorScheme: String, CaseIterable {
    case dark
    case light
}

