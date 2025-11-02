//
//  DashboardView.swift
//  Viventiva
//
//  Dashboard with stats and overview
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var lifeStore: LifeStore
    @EnvironmentObject var milestoneStore: MilestoneStore
    @EnvironmentObject var uiStore: UIStore
    
    private var stats: LifeStats {
        calculateStats()
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Welcome Section
                VStack(spacing: 8) {
                    Text("Welcome, \(lifeStore.userName.isEmpty ? "Friend" : lifeStore.userName)!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Week \(lifeStore.currentWeek) of your journey")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding()
                
                // Stats Cards
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 16) {
                    StatCard(
                        title: "Weeks Lived",
                        value: "\(lifeStore.currentWeek)",
                        color: .blue
                    )
                    
                    StatCard(
                        title: "Weeks Remaining",
                        value: "\(stats.remainingWeeks)",
                        color: .green
                    )
                    
                    StatCard(
                        title: "Life Progress",
                        value: "\(String(format: "%.1f", stats.lifeProgress))%",
                        color: .purple
                    )
                    
                    StatCard(
                        title: "Milestones",
                        value: "\(stats.milestoneCount)",
                        color: .orange
                    )
                }
                .padding()
                
                // Progress Bar
                VStack(alignment: .leading, spacing: 8) {
                    Text("Your Life Journey")
                        .font(.headline)
                    
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                            
                            Rectangle()
                                .fill(uiStore.themePreset.color)
                                .frame(width: geometry.size.width * CGFloat(stats.lifeProgress / 100))
                        }
                    }
                    .frame(height: 20)
                    .cornerRadius(10)
                }
                .padding()
                
                // Insights Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Insights")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    InsightCard(
                        title: "Current Age",
                        value: "\(lifeStore.getAgeFromWeek(lifeStore.currentWeek)) years"
                    )
                    
                    InsightCard(
                        title: "Total Weeks",
                        value: "\(stats.totalWeeks)"
                    )
                }
                .padding()
            }
        }
        .navigationTitle("Dashboard")
    }
    
    private func calculateStats() -> LifeStats {
        let totalWeeks = lifeStore.totalWeeks
        let remainingWeeks = max(0, totalWeeks - lifeStore.currentWeek)
        let lifeProgress = totalWeeks > 0 ? (Double(lifeStore.currentWeek) / Double(totalWeeks)) * 100 : 0
        let milestoneCount = milestoneStore.milestones.count
        
        return LifeStats(
            totalWeeks: totalWeeks,
            remainingWeeks: remainingWeeks,
            lifeProgress: lifeProgress,
            milestoneCount: milestoneCount
        )
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct InsightCard: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .fontWeight(.semibold)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

struct LifeStats {
    let totalWeeks: Int
    let remainingWeeks: Int
    let lifeProgress: Double
    let milestoneCount: Int
}

