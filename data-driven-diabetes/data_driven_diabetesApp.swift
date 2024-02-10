//
//  data_driven_diabetesApp.swift
//  data-driven-diabetes
//
//  Created by Tyler Keller on 2/10/24.
//

import SwiftUI
import FirebaseCore
import OAuthSwift


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb, let incomingURL = userActivity.webpageURL {
            // Handle the URL if it's your OAuth redirect
            OAuthSwift.handle(url: incomingURL)
            return true
        }
        return false
    }

    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }
        if url.host == "oauth-callback" {
            OAuthSwift.handle(url: url)
        }
    }
}

@main
struct data_driven_diabetesApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
