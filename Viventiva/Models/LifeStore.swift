//
//  LifeStore.swift
//  Viventiva
//
//  Manages core life data: birth information, life expectancy, current week calculations
//

import Foundation
import Combine

class LifeStore: ObservableObject {
    static let shared = LifeStore()
    
    @Published var birthDay: Int?
    @Published var birthMonth: Int?
    @Published var birthYear: Int?
    @Published var lifeExpectancy: Int = 80
    @Published var userName: String = ""
    @Published var currentWeek: Int = 1
    
    private let defaults = UserDefaults.standard
    private let storeKey = "memento-vivere-life"
    
    private init() {
        loadFromDefaults()
        calculateCurrentWeek()
    }
    
    // MARK: - Actions
    
    func setBirthData(day: Int, month: Int, year: Int) {
        birthDay = day
        birthMonth = month
        birthYear = year
        calculateCurrentWeek()
        saveToDefaults()
    }
    
    func setLifeExpectancy(_ expectancy: Int) {
        lifeExpectancy = expectancy
        saveToDefaults()
    }
    
    func setUserName(_ name: String) {
        userName = name
        saveToDefaults()
    }
    
    func initialize() {
        calculateCurrentWeek()
    }
    
    // MARK: - Computed Properties
    
    var totalWeeks: Int {
        return lifeExpectancy * 52
    }
    
    func getAgeFromWeek(_ weekNumber: Int) -> Int {
        return Int((Double(weekNumber - 1) / 52.0).rounded(.down))
    }
    
    func getQuarterFromWeek(_ weekNumber: Int) -> Int {
        let weekInYear = ((weekNumber - 1) % 52) + 1
        return Int((Double(weekInYear - 1) / 13.0).rounded(.up)) + 1
    }
    
    // MARK: - Current Week Calculation
    
    private func calculateCurrentWeek() {
        guard let birthYear = birthYear,
              let birthMonth = birthMonth,
              let birthDay = birthDay else {
            currentWeek = 1
            return
        }
        
        let calendar = Calendar.current
        guard let birthDate = calendar.date(from: DateComponents(year: birthYear, month: birthMonth, day: birthDay)) else {
            currentWeek = 1
            return
        }
        
        let now = Date()
        let components = calendar.dateComponents([.weekOfYear], from: birthDate, to: now)
        
        guard let weeks = components.weekOfYear else {
            currentWeek = 1
            return
        }
        
        currentWeek = max(1, weeks + 1)
        saveToDefaults()
    }
    
    // MARK: - Persistence
    
    private func saveToDefaults() {
        let data: [String: Any] = [
            "birthDay": birthDay as Any,
            "birthMonth": birthMonth as Any,
            "birthYear": birthYear as Any,
            "lifeExpectancy": lifeExpectancy,
            "userName": userName,
            "currentWeek": currentWeek
        ]
        defaults.set(data, forKey: storeKey)
    }
    
    private func loadFromDefaults() {
        guard let data = defaults.dictionary(forKey: storeKey) else { return }
        
        if let day = data["birthDay"] as? Int { birthDay = day }
        if let month = data["birthMonth"] as? Int { birthMonth = month }
        if let year = data["birthYear"] as? Int { birthYear = year }
        if let expectancy = data["lifeExpectancy"] as? Int { lifeExpectancy = expectancy }
        if let name = data["userName"] as? String { userName = name }
        if let week = data["currentWeek"] as? Int { currentWeek = week }
    }
}

