//
//  HomePageView.swift
//  Viventiva
//
//  Landing page with authentication options
//

import SwiftUI

struct HomePageView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @EnvironmentObject var uiStore: UIStore
    @State private var showingEmailLogin = false
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    uiStore.darkMode ? Color.black : Color.white,
                    uiStore.themePreset.color.opacity(0.1)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 40) {
                    // Logo and Title
                    VStack(spacing: 20) {
                        Image(systemName: "calendar.badge.clock")
                            .font(.system(size: 80))
                            .foregroundColor(uiStore.themePreset.color)
                        
                        Text("Viventiva")
                            .font(.system(size: 48, weight: .black))
                            .foregroundColor(uiStore.darkMode ? .white : .primary)
                        
                        Text("Visualize your finite weeks with intention and meaning")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding(.top, 60)
                    
                    // Auth Buttons
                    VStack(spacing: 16) {
                        // Google Sign In
                        Button(action: {
                            Task {
                                try? await authManager.signInWithGoogle()
                            }
                        }) {
                            HStack {
                                Image(systemName: "globe")
                                    .font(.system(size: 20))
                                Text("Continue with Google")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .foregroundColor(.black)
                            .cornerRadius(12)
                        }
                        
                        // Email Sign In
                        Button(action: {
                            showingEmailLogin = true
                        }) {
                            HStack {
                                Image(systemName: "envelope")
                                    .font(.system(size: 20))
                                Text("Continue with Email")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(uiStore.themePreset.color)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal, 32)
                    
                    // Privacy Note
                    Text("Your data is stored securely and never shared")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.top, 20)
                }
                .padding()
            }
        }
        .sheet(isPresented: $showingEmailLogin) {
            EmailLoginView()
        }
        .alert("Error", isPresented: .constant(authManager.errorMessage != nil)) {
            Button("OK") {
                authManager.errorMessage = nil
            }
        } message: {
            Text(authManager.errorMessage ?? "")
        }
    }
}

struct EmailLoginView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var email = ""
    @State private var password = ""
    @State private var isSignUp = false
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    SecureField("Password", text: $password)
                }
                
                Section {
                    Button(isSignUp ? "Sign Up" : "Sign In") {
                        Task {
                            do {
                                if isSignUp {
                                    try await authManager.signUpWithEmail(email: email, password: password)
                                } else {
                                    try await authManager.signInWithEmail(email: email, password: password)
                                }
                                dismiss()
                            } catch {
                                // Error handled by authManager
                            }
                        }
                    }
                    .disabled(email.isEmpty || password.isEmpty || authManager.isLoading)
                }
            }
            .navigationTitle(isSignUp ? "Sign Up" : "Sign In")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button(isSignUp ? "Sign In" : "Sign Up") {
                        isSignUp.toggle()
                    }
                }
            }
        }
    }
}

