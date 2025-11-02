//
//  AuthenticationManager.swift
//  Viventiva
//
//  Manages authentication with Supabase
//

import Foundation
import Combine
import Supabase
import UIKit

class AuthenticationManager: ObservableObject {
    static let shared = AuthenticationManager()
    
    @Published var isAuthenticated: Bool = false
    @Published var currentUser: AuthUser?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private var supabaseClient: SupabaseClient?
    private let defaults = UserDefaults.standard
    
    private init() {
        setupSupabase()
    }
    
    // MARK: - Setup
    
    private func setupSupabase() {
        // Get Supabase URL and key from Info.plist or environment
        guard let urlString = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_URL") as? String,
              let key = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_ANON_KEY") as? String,
              let url = URL(string: urlString) else {
            print("Warning: Supabase credentials not found. Please add SUPABASE_URL and SUPABASE_ANON_KEY to Info.plist")
            return
        }
        
        supabaseClient = SupabaseClient(supabaseURL: url, supabaseKey: key)
    }
    
    // MARK: - Authentication Methods
    
    func checkExistingSession() async {
        guard let client = supabaseClient else { return }
        
        do {
            // Try to get current session - may throw if no session exists
            let session = try await client.auth.session
            
            await MainActor.run {
                self.currentUser = session.user
                self.isAuthenticated = true
            }
            await loadUserData(user: session.user)
        } catch {
            // No session found or error getting session
            await MainActor.run {
                self.isAuthenticated = false
                self.currentUser = nil
            }
        }
    }
    
    func signInWithGoogle() async throws {
        guard let client = supabaseClient else {
            throw AuthError.supabaseNotConfigured
        }
        
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        do {
            let url = try await client.auth.signInWithOAuth(
                provider: .google,
                options: OpenURLParams(
                    redirectTo: URL(string: "viventiva://auth-callback")!
                )
            )
            
            // Open URL in Safari for OAuth
            if await UIApplication.shared.canOpenURL(url) {
                await UIApplication.shared.open(url)
            }
        } catch {
            await MainActor.run {
                isLoading = false
                errorMessage = error.localizedDescription
            }
            throw error
        }
    }
    
    func signInWithEmail(email: String, password: String) async throws {
        guard let client = supabaseClient else {
            throw AuthError.supabaseNotConfigured
        }
        
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        do {
            let session = try await client.auth.signIn(email: email, password: password)
            await MainActor.run {
                self.currentUser = session.user
                self.isAuthenticated = true
                self.isLoading = false
            }
            await loadUserData(user: session.user)
        } catch {
            await MainActor.run {
                isLoading = false
                errorMessage = error.localizedDescription
            }
            throw error
        }
    }
    
    func signUpWithEmail(email: String, password: String) async throws {
        guard let client = supabaseClient else {
            throw AuthError.supabaseNotConfigured
        }
        
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        do {
            let session = try await client.auth.signUp(email: email, password: password)
            await MainActor.run {
                self.currentUser = session.user
                self.isAuthenticated = true
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                isLoading = false
                errorMessage = error.localizedDescription
            }
            throw error
        }
    }
    
    func signOut() async throws {
        guard let client = supabaseClient else { return }
        
        try await client.auth.signOut()
        
        await MainActor.run {
            isAuthenticated = false
            currentUser = nil
        }
        
        // Clear local data
        defaults.removeObject(forKey: "viventiva_authenticated")
        defaults.removeObject(forKey: "viventiva_profile_complete")
    }
    
    // MARK: - User Data Loading
    
    private func loadUserData(user: AuthUser) async {
        // Load user profile and data from Supabase
        // This will be handled by the SupabaseService
        do {
            // Use helper extension to get user ID as string
            let userId = user.userIdString
            
            // Load profile and sync data
            if let profile = try await SupabaseService.shared.getUserProfile(userId: userId) {
                await MainActor.run {
                    // Update life store with profile data
                    if let birthDay = profile.birthDay,
                       let birthMonth = profile.birthMonth,
                       let birthYear = profile.birthYear {
                        LifeStore.shared.setBirthData(day: birthDay, month: birthMonth, year: birthYear)
                    }
                    if let expectancy = profile.lifeExpectancy {
                        LifeStore.shared.setLifeExpectancy(expectancy)
                    }
                    if let name = profile.name {
                        LifeStore.shared.setUserName(name)
                    }
                }
            }
        } catch {
            print("Error loading user data: \(error)")
        }
    }
    
    func handleAuthCallback(url: URL) async {
        guard let client = supabaseClient else { return }
        
        do {
            // Handle OAuth callback URL - this should exchange the code for a session
            let session = try await client.auth.session(from: url)
            
            await MainActor.run {
                self.currentUser = session.user
                self.isAuthenticated = true
                self.isLoading = false
            }
            await loadUserData(user: session.user)
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
}

enum AuthError: LocalizedError {
    case supabaseNotConfigured
    case invalidCredentials
    case networkError
    
    var errorDescription: String? {
        switch self {
        case .supabaseNotConfigured:
            return "Supabase is not properly configured"
        case .invalidCredentials:
            return "Invalid email or password"
        case .networkError:
            return "Network error. Please check your connection."
        }
    }
}

// Using Supabase AuthUser type from the SDK

