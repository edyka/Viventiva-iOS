//
//  MoodCategory.swift
//  Viventiva
//
//  Defines mood categories and color options
//

import Foundation
import SwiftUI

struct MoodCategory: Codable {
    let color: String
    let label: String
    let icon: String?
    
    var swiftUIColor: Color {
        return Color.fromTailwind(color)
    }
    
    static let allCategories: [String: MoodCategory] = [
        // Essential Emotional States
        "happy": MoodCategory(color: "bg-green-400", label: "Happy", icon: "smile"),
        "sad": MoodCategory(color: "bg-blue-400", label: "Sad", icon: "frown"),
        "love": MoodCategory(color: "bg-pink-400", label: "Love", icon: "heart"),
        "energetic": MoodCategory(color: "bg-yellow-400", label: "Energetic", icon: "bolt"),
        "difficult": MoodCategory(color: "bg-red-400", label: "Difficult", icon: "cloud.rain"),
        
        // Core Life Experiences
        "growth": MoodCategory(color: "bg-purple-500", label: "Growth", icon: "tree"),
        "creative": MoodCategory(color: "bg-orange-500", label: "Creative", icon: "lightbulb"),
        "peaceful": MoodCategory(color: "bg-teal-400", label: "Peaceful", icon: "leaf"),
        
        // Modern Moods
        "inlove": MoodCategory(color: "bg-pink-500", label: "In Love", icon: "heart.fill"),
        "focused": MoodCategory(color: "bg-blue-500", label: "Focused", icon: "target"),
        "grateful": MoodCategory(color: "bg-orange-500", label: "Grateful", icon: "wind"),
        
        // Emotional Categories
        "excited": MoodCategory(color: "bg-orange-400", label: "Excited", icon: "sun.max"),
        "calm": MoodCategory(color: "bg-blue-300", label: "Calm", icon: "moon"),
        "neutral": MoodCategory(color: "bg-gray-400", label: "Neutral", icon: "circle"),
        "social": MoodCategory(color: "bg-purple-400", label: "Social", icon: "person.2"),
    ]
}

extension Color {
    // Cache for color conversions - significant performance optimization
    private static var colorCache: [String: Color] = [:]
    private static let cacheQueue = DispatchQueue(label: "com.viventiva.colorCache")
    
    static func fromTailwind(_ tailwind: String) -> Color {
        // Check cache first
        if let cachedColor = cacheQueue.sync(execute: { colorCache[tailwind] }) {
            return cachedColor
        }
        
        // Convert Tailwind color classes to SwiftUI colors
        let color: Color
        
        if tailwind.contains("green") {
            if tailwind.contains("400") { color = .green.opacity(0.7) }
            else if tailwind.contains("500") { color = .green }
            else { color = .green }
        } else if tailwind.contains("blue") {
            if tailwind.contains("300") { color = .blue.opacity(0.5) }
            else if tailwind.contains("400") { color = .blue.opacity(0.7) }
            else if tailwind.contains("500") { color = .blue }
            else { color = .blue }
        } else if tailwind.contains("pink") {
            if tailwind.contains("400") { color = .pink.opacity(0.7) }
            else if tailwind.contains("500") { color = .pink }
            else { color = .pink }
        } else if tailwind.contains("yellow") {
            if tailwind.contains("400") { color = .yellow.opacity(0.7) }
            else { color = .yellow }
        } else if tailwind.contains("red") {
            if tailwind.contains("400") { color = .red.opacity(0.7) }
            else { color = .red }
        } else if tailwind.contains("purple") {
            if tailwind.contains("400") { color = .purple.opacity(0.7) }
            else if tailwind.contains("500") { color = .purple }
            else { color = .purple }
        } else if tailwind.contains("orange") {
            if tailwind.contains("400") { color = .orange.opacity(0.7) }
            else if tailwind.contains("500") { color = .orange }
            else { color = .orange }
        } else if tailwind.contains("teal") {
            if tailwind.contains("400") { color = .teal.opacity(0.7) }
            else if tailwind.contains("500") { color = .teal }
            else { color = .teal }
        } else if tailwind.contains("gray") {
            if tailwind.contains("400") { color = .gray.opacity(0.7) }
            else { color = .gray }
        } else if tailwind.contains("white") {
            color = .white
        } else {
            color = .gray
        }
        
        // Cache the result
        cacheQueue.sync {
            colorCache[tailwind] = color
        }
        
        return color
    }
}

