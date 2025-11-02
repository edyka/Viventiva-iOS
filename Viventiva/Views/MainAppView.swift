//
//  MainAppView.swift
//  Viventiva
//
//  Main application view with tab navigation
//

import SwiftUI

struct MainAppView: View {
    @EnvironmentObject var lifeStore: LifeStore
    @EnvironmentObject var milestoneStore: MilestoneStore
    @EnvironmentObject var uiStore: UIStore
    @EnvironmentObject var selectionStore: SelectionStore
    
    var body: some View {
        TabView(selection: $uiStore.currentTab) {
            DashboardView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag("home")
            
            LifeGridView()
                .tabItem {
                    Label("Grid", systemImage: "square.grid.2x2.fill")
                }
                .tag("grid")
            
            GoalsView()
                .tabItem {
                    Label("Goals", systemImage: "target")
                }
                .tag("goals")
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag("settings")
        }
        .onAppear {
            setupAppearance()
        }
    }
    
    private func setupAppearance() {
        UITabBar.appearance().barTintColor = uiStore.darkMode ? .black : .white
    }
}

