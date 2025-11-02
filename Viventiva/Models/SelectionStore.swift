//
//  SelectionStore.swift
//  Viventiva
//
//  Manages week selection and painting interactions
//

import Foundation
import Combine

enum SelectionMode {
    case single
    case range
    case rectangular
}

class SelectionStore: ObservableObject {
    static let shared = SelectionStore()
    
    @Published var selectedWeek: Int? = nil
    @Published var selectedColor: String? = nil
    @Published var selectedWeeks: Set<Int> = []
    @Published var pinnedWeeks: Set<Int> = []
    
    @Published var isDragging: Bool = false
    @Published var draggedWeeks: Set<Int> = []
    @Published var dragStartWeek: Int? = nil
    
    @Published var selectionMode: SelectionMode = .single
    @Published var rangeStart: Int? = nil
    @Published var isInRangeMode: Bool = false
    @Published var selectionPreview: Set<Int> = []
    
    private let defaults = UserDefaults.standard
    private let storeKey = "memento-vivere-selections"
    
    private init() {
        loadFromDefaults()
    }
    
    // MARK: - Basic Selection Actions
    
    func setSelectedWeek(_ week: Int?) {
        selectedWeek = week
    }
    
    func setSelectedColor(_ color: String?) {
        selectedColor = color
        saveToDefaults()
    }
    
    func setSelectionMode(_ mode: SelectionMode) {
        selectionMode = mode
    }
    
    // MARK: - Week Selection Management
    
    func setSelectedWeeks(_ weeks: Set<Int>) {
        selectedWeeks = weeks
        saveToDefaults()
    }
    
    func addToSelectedWeeks(_ week: Int) {
        selectedWeeks.insert(week)
        saveToDefaults()
    }
    
    func removeFromSelectedWeeks(_ week: Int) {
        selectedWeeks.remove(week)
        saveToDefaults()
    }
    
    func toggleWeekSelection(_ week: Int) {
        if selectedWeeks.contains(week) {
            selectedWeeks.remove(week)
        } else {
            selectedWeeks.insert(week)
        }
        saveToDefaults()
    }
    
    func clearSelectedWeeks() {
        selectedWeeks = []
        saveToDefaults()
    }
    
    // MARK: - Pinned Weeks Management
    
    func setPinnedWeeks(_ weeks: Set<Int>) {
        pinnedWeeks = weeks
        saveToDefaults()
    }
    
    func addToPinnedWeeks(_ week: Int) {
        pinnedWeeks.insert(week)
        saveToDefaults()
    }
    
    func removeFromPinnedWeeks(_ week: Int) {
        pinnedWeeks.remove(week)
        saveToDefaults()
    }
    
    func clearPinnedWeeks() {
        pinnedWeeks = []
        saveToDefaults()
    }
    
    // MARK: - Range Selection
    
    func startRangeSelection(_ week: Int) {
        rangeStart = week
        isInRangeMode = true
        selectedWeeks = [week]
        saveToDefaults()
    }
    
    func completeRangeSelection(_ endWeek: Int) {
        guard let start = rangeStart else { return }
        
        let startWeek = min(start, endWeek)
        let end = max(start, endWeek)
        
        var rangeWeeks = Set<Int>()
        for week in startWeek...end {
            rangeWeeks.insert(week)
        }
        
        selectedWeeks = rangeWeeks
        pinnedWeeks = rangeWeeks
        rangeStart = nil
        isInRangeMode = false
        saveToDefaults()
    }
    
    func resetRangeSelection() {
        rangeStart = nil
        isInRangeMode = false
        selectedWeeks = []
        saveToDefaults()
    }
    
    // MARK: - Dragging
    
    func setIsDragging(_ dragging: Bool) {
        isDragging = dragging
    }
    
    func setDraggedWeeks(_ weeks: Set<Int>) {
        draggedWeeks = weeks
    }
    
    func setDragStartWeek(_ week: Int?) {
        dragStartWeek = week
    }
    
    // MARK: - Utility Functions
    
    func isWeekSelected(_ week: Int) -> Bool {
        return selectedWeeks.contains(week) || pinnedWeeks.contains(week)
    }
    
    func getSelectionCount() -> Int {
        return Set(selectedWeeks.union(pinnedWeeks)).count
    }
    
    func clearAllSelections() {
        selectedWeek = nil
        selectedColor = nil
        selectedWeeks = []
        pinnedWeeks = []
        rangeStart = nil
        isInRangeMode = false
        selectionPreview = []
        isDragging = false
        draggedWeeks = []
        dragStartWeek = nil
        saveToDefaults()
    }
    
    // MARK: - Persistence
    
    private func saveToDefaults() {
        let data: [String: Any] = [
            "selectedWeeks": Array(selectedWeeks),
            "pinnedWeeks": Array(pinnedWeeks),
            "selectedColor": selectedColor as Any
        ]
        defaults.set(data, forKey: storeKey)
    }
    
    private func loadFromDefaults() {
        guard let data = defaults.dictionary(forKey: storeKey) else { return }
        
        if let weeks = data["selectedWeeks"] as? [Int] {
            selectedWeeks = Set(weeks)
        }
        if let weeks = data["pinnedWeeks"] as? [Int] {
            pinnedWeeks = Set(weeks)
        }
        if let color = data["selectedColor"] as? String {
            selectedColor = color
        }
    }
}

