//
//  ContentView.swift
//  Viventiva
//
//  Main content view with authentication flow
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @EnvironmentObject var lifeStore: LifeStore
    @State private var isCheckingAuth = true
    
    var body: some View {
        Group {
            if isCheckingAuth {
                LoadingView(message: "Checking authentication...")
                    .onAppear {
                        checkAuth()
                    }
            } else if authManager.isAuthenticated {
                if lifeStore.birthYear == nil || lifeStore.birthDay == nil {
                    CompleteProfileView()
                } else {
                    MainAppView()
                }
            } else {
                HomePageView()
            }
        }
    }
    
    private func checkAuth() {
        Task {
            await authManager.checkExistingSession()
            isCheckingAuth = false
        }
    }
}

struct LoadingView: View {
    let message: String
    
    var body: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

