//
//  MoodPaletteView.swift
//  Viventiva
//
//  Color/mood selection palette
//

import SwiftUI

struct MoodPaletteView: View {
    @Binding var selectedColor: String?
    @EnvironmentObject var milestoneStore: MilestoneStore
    @EnvironmentObject var uiStore: UIStore
    
    private var colorOptions: [String: MoodCategory] {
        milestoneStore.getColorOptions()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Select a Mood")
                .font(.headline)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(Array(colorOptions.keys.sorted()), id: \.self) { key in
                        if let category = colorOptions[key] {
                            MoodButton(
                                key: key,
                                category: category,
                                isSelected: selectedColor == key
                            ) {
                                if selectedColor == key {
                                    selectedColor = nil
                                } else {
                                    selectedColor = key
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(uiStore.darkMode ? Color(.systemGray6) : Color(.systemBackground))
        )
    }
}

struct MoodButton: View {
    let key: String
    let category: MoodCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Circle()
                    .fill(category.swiftUIColor)
                    .frame(width: 44, height: 44)
                    .overlay(
                        Circle()
                            .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 3)
                    )
                
                Text(category.label)
                    .font(.caption)
                    .foregroundColor(.primary)
            }
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.blue.opacity(0.1) : Color.clear)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

