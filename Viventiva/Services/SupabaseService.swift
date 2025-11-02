//
//  SupabaseService.swift
//  Viventiva
//
//  Handles all Supabase database operations
//

import Foundation
import Supabase

class SupabaseService {
    static let shared = SupabaseService()
    
    private var client: SupabaseClient?
    
    private init() {
        if let urlString = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_URL") as? String,
           let key = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_ANON_KEY") as? String,
           let url = URL(string: urlString) {
            client = SupabaseClient(supabaseURL: url, supabaseKey: key)
        }
    }
    
    // MARK: - User Profile
    
    func saveUserProfile(userId: String, profileData: UserProfileData) async throws {
        guard let client = client else { throw SupabaseError.notConfigured }
        
        let profile = UserProfile(
            userId: userId,
            name: profileData.name,
            birthDay: profileData.birthDay,
            birthMonth: profileData.birthMonth,
            birthYear: profileData.birthYear,
            lifeExpectancy: profileData.lifeExpectancy,
            updatedAt: Date()
        )
        
        // Supabase Swift SDK upsert - using proper API
        try await client.database
            .from("user_profiles")
            .upsert(profile)
            .execute()
    }
    
    func getUserProfile(userId: String) async throws -> UserProfile? {
        guard let client = client else { throw SupabaseError.notConfigured }
        
        // Supabase Swift SDK select with decode
        let response: [UserProfile] = try await client.database
            .from("user_profiles")
            .select()
            .eq("user_id", value: userId)
            .execute()
            .value
        
        return response.first
    }
    
    // MARK: - Milestones
    
    func saveMilestones(userId: String, milestoneData: MilestoneSyncData) async throws {
        guard let client = client else { throw SupabaseError.notConfigured }
        
        let sync = UserMilestones(
            userId: userId,
            milestonesData: milestoneData,
            updatedAt: Date()
        )
        
        try await client.database
            .from("user_milestones")
            .upsert(sync)
            .execute()
    }
    
    func getMilestones(userId: String) async throws -> MilestoneSyncData? {
        guard let client = client else { throw SupabaseError.notConfigured }
        
        let response: [UserMilestones] = try await client.database
            .from("user_milestones")
            .select()
            .eq("user_id", value: userId)
            .execute()
            .value
        
        return response.first?.milestonesData
    }
    
    // MARK: - Selections
    
    func saveSelections(userId: String, selectionsData: SelectionSyncData) async throws {
        guard let client = client else { throw SupabaseError.notConfigured }
        
        let sync = UserSelections(
            userId: userId,
            selectionsData: selectionsData,
            updatedAt: Date()
        )
        
        try await client.database
            .from("user_selections")
            .upsert(sync)
            .execute()
    }
    
    func getSelections(userId: String) async throws -> SelectionSyncData? {
        guard let client = client else { throw SupabaseError.notConfigured }
        
        let response: [UserSelections] = try await client.database
            .from("user_selections")
            .select()
            .eq("user_id", value: userId)
            .execute()
            .value
        
        return response.first?.selectionsData
    }
}

// MARK: - Data Models

struct UserProfile: Codable {
    let userId: String
    var name: String?
    var birthDay: Int?
    var birthMonth: Int?
    var birthYear: Int?
    var lifeExpectancy: Int?
    var updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case name
        case birthDay = "birth_day"
        case birthMonth = "birth_month"
        case birthYear = "birth_year"
        case lifeExpectancy = "life_expectancy"
        case updatedAt = "updated_at"
    }
}

struct UserProfileData {
    let name: String?
    let birthDay: Int
    let birthMonth: Int
    let birthYear: Int
    let lifeExpectancy: Int
}

struct UserMilestones: Codable {
    let userId: String
    var milestonesData: MilestoneSyncData
    var updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case milestonesData = "milestones_data"
        case updatedAt = "updated_at"
    }
}

struct MilestoneSyncData: Codable {
    var milestones: [String: Milestone]?
    var customMoods: [String: MoodCategory]?
    var customCategories: [String: MoodCategory]?
}

struct UserSelections: Codable {
    let userId: String
    var selectionsData: SelectionSyncData
    var updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case selectionsData = "selections_data"
        case updatedAt = "updated_at"
    }
}

struct SelectionSyncData: Codable {
    var selectedWeeks: [Int]?
    var pinnedWeeks: [Int]?
    var selectedColor: String?
}

enum SupabaseError: LocalizedError {
    case notConfigured
    case networkError
    case invalidResponse
    
    var errorDescription: String? {
        switch self {
        case .notConfigured:
            return "Supabase is not properly configured"
        case .networkError:
            return "Network error occurred"
        case .invalidResponse:
            return "Invalid response from server"
        }
    }
}

