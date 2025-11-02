//
//  DateUtils.swift
//  Viventiva
//
//  Date and week calculation utilities
//

import Foundation

struct DateUtils {
    static func getCurrentWeek(birthYear: Int?, birthMonth: Int?, birthDay: Int?) -> Int {
        guard let year = birthYear,
              let month = birthMonth,
              let day = birthDay else {
            return 1
        }
        
        let calendar = Calendar.current
        guard let birthDate = calendar.date(from: DateComponents(year: year, month: month, day: day)) else {
            return 1
        }
        
        let now = Date()
        let components = calendar.dateComponents([.weekOfYear], from: birthDate, to: now)
        
        guard let weeks = components.weekOfYear else {
            return 1
        }
        
        return max(1, weeks + 1)
    }
    
    static func getTotalWeeks(lifeExpectancy: Int) -> Int {
        guard lifeExpectancy >= 1 && lifeExpectancy <= 150 else {
            return 4160 // Default 80 years
        }
        return lifeExpectancy * 52
    }
    
    static func getQuarterFromWeek(_ weekNum: Int) -> Int {
        guard weekNum >= 1 else { return 1 }
        
        let weekInYear = ((weekNum - 1) % 52) + 1
        return Int((Double(weekInYear - 1) / 13.0).rounded(.up)) + 1
    }
    
    static func getYearFromWeek(_ weekNum: Int) -> Int {
        guard weekNum >= 1 else { return 0 }
        return Int((Double(weekNum - 1) / 52.0).rounded(.down))
    }
}

struct LifeStatsCalculator {
    static func calculate(
        birthYear: Int?,
        birthMonth: Int?,
        birthDay: Int?,
        lifeExpectancy: Int,
        milestones: [String: Milestone]
    ) -> LifeStats {
        let currentWeek = DateUtils.getCurrentWeek(birthYear: birthYear, birthMonth: birthMonth, birthDay: birthDay)
        let totalWeeks = DateUtils.getTotalWeeks(lifeExpectancy: lifeExpectancy)
        let remainingWeeks = max(0, totalWeeks - currentWeek + 1)
        let lifeProgress = totalWeeks > 0 ? (Double(currentWeek) / Double(totalWeeks)) * 100 : 0
        let milestoneCount = milestones.count
        
        return LifeStats(
            totalWeeks: totalWeeks,
            remainingWeeks: remainingWeeks,
            lifeProgress: lifeProgress,
            milestoneCount: milestoneCount
        )
    }
}

