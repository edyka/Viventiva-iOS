//
//  LifeGridView.swift
//  Viventiva
//
//  Optimized life grid view with LazyVGrid for performance
//

import SwiftUI

struct LifeGridView: View {
    @EnvironmentObject var lifeStore: LifeStore
    @EnvironmentObject var milestoneStore: MilestoneStore
    @EnvironmentObject var uiStore: UIStore
    @EnvironmentObject var selectionStore: SelectionStore
    
    @State private var selectedColor: String? = nil
    @State private var isDragging = false
    @State private var dragStartWeek: Int? = nil
    
    private let columns = 52
    private var weekSize: CGFloat {
        uiStore.isMobile ? 6 : 8
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Mood Palette
                    MoodPaletteView(selectedColor: $selectedColor)
                        .padding()
                    
                    // Life Grid
                    LazyVStack(spacing: 2) {
                        ForEach(0..<lifeStore.lifeExpectancy, id: \.self) { yearIndex in
                            HStack(spacing: 2) {
                                // Year label
                                if yearIndex % 5 == 0 {
                                    Text("\(yearIndex)")
                                        .font(.system(size: 10))
                                        .foregroundColor(.secondary)
                                        .frame(width: 30)
                                } else {
                                    Spacer()
                                        .frame(width: 30)
                                }
                                
                                // Weeks row
                                LazyHGrid(rows: [GridItem(.fixed(weekSize))], spacing: 2) {
                                    ForEach(1...columns, id: \.self) { col in
                                        let weekNumber = yearIndex * columns + col
                                        WeekBoxView(weekNumber: weekNumber)
                                            .frame(width: weekSize, height: weekSize)
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Your Life")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        scrollToCurrentWeek()
                    }) {
                        Image(systemName: "location.fill")
                    }
                }
            }
        }
    }
    
    private func scrollToCurrentWeek() {
        // Scroll to current week - implementation depends on ScrollViewReader
    }
}

