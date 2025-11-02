//
//  MilestoneStore.swift
//  Viventiva
//
//  Manages milestones, categories, and goals
//

import Foundation
import Combine

struct Milestone: Codable, Identifiable {
    var id: String { weekNumber }
    let weekNumber: String
    var category: String?
    var color: String?
    var title: String?
    var description: String?
    var date: Date?
}

struct Goal: Codable, Identifiable {
    var id: UUID = UUID()
    var title: String
    var description: String?
    var targetWeek: Int?
    var completed: Bool = false
    var createdAt: Date = Date()
}

class MilestoneStore: ObservableObject {
    static let shared = MilestoneStore()
    
    @Published var milestones: [String: Milestone] = [:]
    @Published var customCategories: [String: MoodCategory] = [:]
    @Published var customMoods: [String: MoodCategory] = [:]
    @Published var goals: [Goal] = []
    
    private let defaults = UserDefaults.standard
    private let storeKey = "memento-vivere-milestones"
    
    private init() {
        loadFromDefaults()
    }
    
    // MARK: - Milestone Actions
    
    func setMilestones(_ newMilestones: [String: Milestone]) {
        milestones = newMilestones
        saveToDefaults()
    }
    
    func updateMilestone(weekNumber: String, milestone: Milestone) {
        milestones[weekNumber] = milestone
        saveToDefaults()
    }
    
    func deleteMilestone(weekNumber: String) {
        milestones.removeValue(forKey: weekNumber)
        saveToDefaults()
    }
    
    func clearMilestones() {
        milestones = [:]
        saveToDefaults()
    }
    
    func getMilestoneByWeek(_ weekNumber: String) -> Milestone? {
        return milestones[weekNumber]
    }
    
    func getMilestonesByCategory(_ category: String) -> [String: Milestone] {
        return milestones.filter { $0.value.category == category }
    }
    
    func getMilestonesInRange(startWeek: Int, endWeek: Int) -> [String: Milestone] {
        return milestones.filter { week, _ in
            guard let weekNum = Int(week) else { return false }
            return weekNum >= startWeek && weekNum <= endWeek
        }
    }
    
    // MARK: - Custom Categories & Moods
    
    func setCustomCategories(_ categories: [String: MoodCategory]) {
        customCategories = categories
        saveToDefaults()
    }
    
    func setCustomMoods(_ moods: [String: MoodCategory]) {
        customMoods = moods
        saveToDefaults()
    }
    
    func addCustomCategory(key: String, category: MoodCategory) {
        customCategories[key] = category
        saveToDefaults()
    }
    
    func removeCustomCategory(key: String) {
        customCategories.removeValue(forKey: key)
        saveToDefaults()
    }
    
    // MARK: - Goals
    
    func setGoals(_ newGoals: [Goal]) {
        goals = newGoals
        saveToDefaults()
    }
    
    func addGoal(_ goal: Goal) {
        goals.append(goal)
        saveToDefaults()
    }
    
    func updateGoal(at index: Int, with goal: Goal) {
        guard index < goals.count else { return }
        goals[index] = goal
        saveToDefaults()
    }
    
    func deleteGoal(at index: Int) {
        guard index < goals.count else { return }
        goals.remove(at: index)
        saveToDefaults()
    }
    
    // MARK: - Computed Properties
    
    func getColorOptions() -> [String: MoodCategory] {
        return MoodCategory.allCategories.merging(customCategories) { _, custom in custom }
    }
    
    func getAllCategories() -> [String: MoodCategory] {
        return MoodCategory.allCategories.merging(customCategories) { _, custom in custom }
    }
    
    // MARK: - Persistence
    
    private let saveQueue = DispatchQueue(label: "com.viventiva.milestoneStore", qos: .utility)
    
    private func saveToDefaults() {
        // Save on background queue to prevent UI blocking
        let dataToSave = MilestoneData(
            milestones: milestones,
            customCategories: customCategories,
            customMoods: customMoods,
            goals: goals
        )
        
        saveQueue.async { [weak self] in
            guard let self = self else { return }
            let encoder = JSONEncoder()
            do {
                let encoded = try encoder.encode(dataToSave)
                self.defaults.set(encoded, forKey: self.storeKey)
            } catch {
                print("Error saving milestones: \(error)")
            }
        }
    }
    
    private func loadFromDefaults() {
        guard let data = defaults.data(forKey: storeKey) else { return }
        
        let decoder = JSONDecoder()
        do {
            let decoded = try decoder.decode(MilestoneData.self, from: data)
            milestones = decoded.milestones
            customCategories = decoded.customCategories
            customMoods = decoded.customMoods
            goals = decoded.goals
        } catch {
            print("Error loading milestones: \(error)")
        }
    }
}

private struct MilestoneData: Codable {
    var milestones: [String: Milestone]
    var customCategories: [String: MoodCategory]
    var customMoods: [String: MoodCategory]
    var goals: [Goal]
    
    init(milestones: [String: Milestone] = [:],
         customCategories: [String: MoodCategory] = [:],
         customMoods: [String: MoodCategory] = [:],
         goals: [Goal] = []) {
        self.milestones = milestones
        self.customCategories = customCategories
        self.customMoods = customMoods
        self.goals = goals
    }
}

