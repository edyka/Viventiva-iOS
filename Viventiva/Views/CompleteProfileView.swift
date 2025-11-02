//
//  CompleteProfileView.swift
//  Viventiva
//
//  Profile setup for new users
//

import SwiftUI

struct CompleteProfileView: View {
    @EnvironmentObject var lifeStore: LifeStore
    @EnvironmentObject var uiStore: UIStore
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var birthDay = 1
    @State private var birthMonth = 1
    @State private var birthYear = 2000
    @State private var lifeExpectancy = 80
    @State private var name = ""
    @State private var isSaving = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Information")) {
                    TextField("Your Name", text: $name)
                    
                    Picker("Birth Day", selection: $birthDay) {
                        ForEach(1...31, id: \.self) { day in
                            Text("\(day)").tag(day)
                        }
                    }
                    
                    Picker("Birth Month", selection: $birthMonth) {
                        ForEach(1...12, id: \.self) { month in
                            Text(monthName(month)).tag(month)
                        }
                    }
                    
                    Picker("Birth Year", selection: $birthYear) {
                        ForEach(1900...Date().year, id: \.self) { year in
                            Text("\(year)").tag(year)
                        }
                    }
                }
                
                Section(header: Text("Life Expectancy")) {
                    Stepper("\(lifeExpectancy) years", value: $lifeExpectancy, in: 50...120)
                }
                
                Section {
                    Button("Complete Setup") {
                        saveProfile()
                    }
                    .disabled(isSaving)
                }
            }
            .navigationTitle("Complete Your Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func monthName(_ month: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        let date = Calendar.current.date(from: DateComponents(month: month))!
        return formatter.string(from: date)
    }
    
    private func saveProfile() {
        isSaving = true
        
        lifeStore.setBirthData(day: birthDay, month: birthMonth, year: birthYear)
        lifeStore.setLifeExpectancy(lifeExpectancy)
        if !name.isEmpty {
            lifeStore.setUserName(name)
        }
        
        // Save to Supabase if authenticated
        if authManager.isAuthenticated, let userId = authManager.currentUser?.id {
            Task {
                do {
                    let profileData = UserProfileData(
                        name: name.isEmpty ? nil : name,
                        birthDay: birthDay,
                        birthMonth: birthMonth,
                        birthYear: birthYear,
                        lifeExpectancy: lifeExpectancy
                    )
                    try await SupabaseService.shared.saveUserProfile(userId: userId, profileData: profileData)
                } catch {
                    print("Error saving profile: \(error)")
                }
                isSaving = false
            }
        } else {
            isSaving = false
        }
    }
}

extension Date {
    var year: Int {
        Calendar.current.component(.year, from: self)
    }
}

