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
    static func fromTailwind(_ tailwind: String) -> Color {
        // Convert Tailwind color classes to SwiftUI colors
        if tailwind.contains("green") {
            if tailwind.contains("400") { return .green.opacity(0.7) }
            if tailwind.contains("500") { return .green }
            return .green
        }
        if tailwind.contains("blue") {
            if tailwind.contains("300") { return .blue.opacity(0.5) }
            if tailwind.contains("400") { return .blue.opacity(0.7) }
            if tailwind.contains("500") { return .blue }
            return .blue
        }
        if tailwind.contains("pink") {
            if tailwind.contains("400") { return .pink.opacity(0.7) }
            if tailwind.contains("500") { return .pink }
            return .pink
        }
        if tailwind.contains("yellow") {
            if tailwind.contains("400") { return .yellow.opacity(0.7) }
            return .yellow
        }
        if tailwind.contains("red") {
            if tailwind.contains("400") { return .red.opacity(0.7) }
            return .red
        }
        if tailwind.contains("purple") {
            if tailwind.contains("400") { return .purple.opacity(0.7) }
            if tailwind.contains("500") { return .purple }
            return .purple
        }
        if tailwind.contains("orange") {
            if tailwind.contains("400") { return .orange.opacity(0.7) }
            if tailwind.contains("500") { return .orange }
            return .orange
        }
        if tailwind.contains("teal") {
            if tailwind.contains("400") { return .teal.opacity(0.7) }
            if tailwind.contains("500") { return .teal }
            return .teal
        }
        if tailwind.contains("gray") {
            if tailwind.contains("400") { return .gray.opacity(0.7) }
            return .gray
        }
        if tailwind.contains("white") {
            return .white
        }
        return .gray
    }
}

