//
//  ViventivaApp.swift
//  Viventiva
//
//  Created on iOS
//

import SwiftUI

@main
struct ViventivaApp: App {
    @StateObject private var authManager = AuthenticationManager.shared
    @StateObject private var lifeStore = LifeStore.shared
    @StateObject private var milestoneStore = MilestoneStore.shared
    @StateObject private var uiStore = UIStore.shared
    @StateObject private var selectionStore = SelectionStore.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authManager)
                .environmentObject(lifeStore)
                .environmentObject(milestoneStore)
                .environmentObject(uiStore)
                .environmentObject(selectionStore)
                .preferredColorScheme(uiStore.darkMode ? .dark : .light)
        }
    }
}

