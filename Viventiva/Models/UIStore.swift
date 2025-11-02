//
//  UIStore.swift
//  Viventiva
//
//  Manages user interface state: theme, layout, navigation
//

import Foundation
import Combine
import SwiftUI

enum GridLayout {
    case standard
    case compact
    case quarterly
}

enum PastWeekStyle {
    case none
    case hatch
    case corner
}

enum ThemePreset: String, CaseIterable {
    case emerald = "emerald"
    case ocean = "ocean"
    case sunset = "sunset"
    case purple = "purple"
    
    var gradient: String {
        switch self {
        case .emerald: return "from-emerald-500 to-teal-600"
        case .ocean: return "from-blue-500 to-cyan-600"
        case .sunset: return "from-orange-500 to-red-600"
        case .purple: return "from-purple-500 to-violet-600"
        }
    }
    
    var color: Color {
        switch self {
        case .emerald: return .green
        case .ocean: return .blue
        case .sunset: return .orange
        case .purple: return .purple
        }
    }
}

class UIStore: ObservableObject {
    static let shared = UIStore()
    
    @Published var darkMode: Bool = false
    @Published var currentTab: String = "home"
    @Published var currentPage: String = "main"
    @Published var showWeeks: Bool = true
    @Published var isMobile: Bool = false
    
    @Published var showMobileColorSelection: Bool = false
    @Published var showLifeInsights: Bool = false
    @Published var showSettingsModal: Bool = false
    @Published var showGoalModal: Bool = false
    
    @Published var enableAnimations: Bool = true
    @Published var enableVirtualization: Bool = true
    
    @Published var gridLayout: GridLayout = .standard
    @Published var pastWeekStyle: PastWeekStyle = .hatch
    @Published var themePreset: ThemePreset = .emerald
    
    @Published var showCurrentWeekIndicator: Bool = true
    @Published var showMilestoneIndicators: Bool = true
    @Published var showAgeLabels: Bool = true
    
    private let defaults = UserDefaults.standard
    private let storeKey = "memento-vivere-ui"
    
    private init() {
        loadFromDefaults()
        initializeTheme()
        initializeDeviceDetection()
    }
    
    // MARK: - Theme Actions
    
    func setDarkMode(_ mode: Bool) {
        darkMode = mode
        saveToDefaults()
    }
    
    func toggleDarkMode() {
        darkMode.toggle()
        saveToDefaults()
    }
    
    // MARK: - Navigation Actions
    
    func setCurrentTab(_ tab: String) {
        currentTab = tab
        saveToDefaults()
    }
    
    func setCurrentPage(_ page: String) {
        currentPage = page
        saveToDefaults()
    }
    
    func setShowWeeks(_ show: Bool) {
        showWeeks = show
        saveToDefaults()
    }
    
    // MARK: - Modal Actions
    
    func setShowMobileColorSelection(_ show: Bool) {
        showMobileColorSelection = show
    }
    
    func setShowLifeInsights(_ show: Bool) {
        showLifeInsights = show
    }
    
    func setShowSettingsModal(_ show: Bool) {
        showSettingsModal = show
    }
    
    func setShowGoalModal(_ show: Bool) {
        showGoalModal = show
    }
    
    // MARK: - Preference Actions
    
    func setEnableAnimations(_ enable: Bool) {
        enableAnimations = enable
        saveToDefaults()
    }
    
    func setEnableVirtualization(_ enable: Bool) {
        enableVirtualization = enable
        saveToDefaults()
    }
    
    func setGridLayout(_ layout: GridLayout) {
        gridLayout = layout
        saveToDefaults()
    }
    
    func setPastWeekStyle(_ style: PastWeekStyle) {
        pastWeekStyle = style
        saveToDefaults()
    }
    
    func setThemePreset(_ preset: ThemePreset) {
        themePreset = preset
        saveToDefaults()
    }
    
    func closeAllModals() {
        showMobileColorSelection = false
        showLifeInsights = false
        showSettingsModal = false
        showGoalModal = false
    }
    
    // MARK: - Initialization
    
    private func initializeTheme() {
        // Check system theme preference if not set
        if defaults.object(forKey: "\(storeKey)_darkMode") == nil {
            // Use UITraitCollection to detect system theme
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                darkMode = window.traitCollection.userInterfaceStyle == .dark
            }
        }
    }
    
    private func initializeDeviceDetection() {
        isMobile = UIDevice.current.userInterfaceIdiom == .phone
    }
    
    // MARK: - Persistence
    
    private func saveToDefaults() {
        var gridLayoutRaw: String = "standard"
        switch gridLayout {
        case .standard: gridLayoutRaw = "standard"
        case .compact: gridLayoutRaw = "compact"
        case .quarterly: gridLayoutRaw = "quarterly"
        }
        
        var pastWeekStyleRaw: String = "hatch"
        switch pastWeekStyle {
        case .none: pastWeekStyleRaw = "none"
        case .hatch: pastWeekStyleRaw = "hatch"
        case .corner: pastWeekStyleRaw = "corner"
        }
        
        let data: [String: Any] = [
            "darkMode": darkMode,
            "currentPage": currentPage,
            "currentTab": currentTab,
            "showWeeks": showWeeks,
            "enableAnimations": enableAnimations,
            "enableVirtualization": enableVirtualization,
            "gridLayout": gridLayoutRaw,
            "pastWeekStyle": pastWeekStyleRaw,
            "themePreset": themePreset.rawValue,
            "showCurrentWeekIndicator": showCurrentWeekIndicator,
            "showMilestoneIndicators": showMilestoneIndicators,
            "showAgeLabels": showAgeLabels
        ]
        defaults.set(data, forKey: storeKey)
    }
    
    private func loadFromDefaults() {
        guard let data = defaults.dictionary(forKey: storeKey) else { return }
        
        if let mode = data["darkMode"] as? Bool { darkMode = mode }
        if let page = data["currentPage"] as? String { currentPage = page }
        if let tab = data["currentTab"] as? String { currentTab = tab }
        if let show = data["showWeeks"] as? Bool { showWeeks = show }
        if let enable = data["enableAnimations"] as? Bool { enableAnimations = enable }
        if let enable = data["enableVirtualization"] as? Bool { enableVirtualization = enable }
        
        if let layout = data["gridLayout"] as? String {
            switch layout {
            case "compact": gridLayout = .compact
            case "quarterly": gridLayout = .quarterly
            default: gridLayout = .standard
            }
        }
        
        if let style = data["pastWeekStyle"] as? String {
            switch style {
            case "none": pastWeekStyle = .none
            case "corner": pastWeekStyle = .corner
            default: pastWeekStyle = .hatch
            }
        }
        
        if let preset = data["themePreset"] as? String,
           let theme = ThemePreset(rawValue: preset) {
            themePreset = theme
        }
        
        if let show = data["showCurrentWeekIndicator"] as? Bool { showCurrentWeekIndicator = show }
        if let show = data["showMilestoneIndicators"] as? Bool { showMilestoneIndicators = show }
        if let show = data["showAgeLabels"] as? Bool { showAgeLabels = show }
    }
}

