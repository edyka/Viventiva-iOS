//
//  AppDelegate.swift
//  Viventiva
//
//  Handles app lifecycle and URL callbacks for OAuth
//

import SwiftUI
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {
        // Handle OAuth callback
        Task {
            await AuthenticationManager.shared.handleAuthCallback(url: url)
        }
        return true
    }
}

