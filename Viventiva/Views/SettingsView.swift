//
//  SettingsView.swift
//  Viventiva
//
//  Settings and preferences view
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var lifeStore: LifeStore
    @EnvironmentObject var uiStore: UIStore
    @EnvironmentObject var authManager: AuthenticationManager
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Appearance")) {
                    Toggle("Dark Mode", isOn: Binding(
                        get: { uiStore.darkMode },
                        set: { uiStore.setDarkMode($0) }
                    ))
                    
                    Picker("Theme Color", selection: Binding(
                        get: { uiStore.themePreset },
                        set: { uiStore.setThemePreset($0) }
                    )) {
                        ForEach(ThemePreset.allCases, id: \.self) { preset in
                            Text(preset.rawValue.capitalized).tag(preset)
                        }
                    }
                }
                
                Section(header: Text("Grid")) {
                    Picker("Layout", selection: Binding(
                        get: { uiStore.gridLayout },
                        set: { uiStore.setGridLayout($0) }
                    )) {
                        Text("Standard").tag(GridLayout.standard)
                        Text("Compact").tag(GridLayout.compact)
                        Text("Quarterly").tag(GridLayout.quarterly)
                    }
                    
                    Picker("Past Week Style", selection: Binding(
                        get: { uiStore.pastWeekStyle },
                        set: { uiStore.setPastWeekStyle($0) }
                    )) {
                        Text("None").tag(PastWeekStyle.none)
                        Text("Hatch").tag(PastWeekStyle.hatch)
                        Text("Corner").tag(PastWeekStyle.corner)
                    }
                }
                
                Section(header: Text("Profile")) {
                    HStack {
                        Text("Current Age")
                        Spacer()
                        Text("\(lifeStore.getAgeFromWeek(lifeStore.currentWeek))y")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Current Week")
                        Spacer()
                        Text("\(lifeStore.currentWeek)")
                            .foregroundColor(.secondary)
                    }
                    
                    NavigationLink("Edit Profile", destination: CompleteProfileView())
                }
                
                Section(header: Text("Account")) {
                    Button("Sign Out") {
                        Task {
                            try? await authManager.signOut()
                        }
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("Settings")
        }
    }
}

