//
//  WeekBoxView.swift
//  Viventiva
//
//  Individual week box component with interactions
//  Optimized with Equatable for better performance
//

import SwiftUI

struct WeekBoxView: View {
    let weekNumber: Int
    @EnvironmentObject var lifeStore: LifeStore
    @EnvironmentObject var milestoneStore: MilestoneStore
    @EnvironmentObject var uiStore: UIStore
    @EnvironmentObject var selectionStore: SelectionStore
    
    @State private var isPressed = false
    
    private var isCurrentWeek: Bool {
        weekNumber == lifeStore.currentWeek
    }
    
    private var isPast: Bool {
        weekNumber < lifeStore.currentWeek
    }
    
    private var milestone: Milestone? {
        milestoneStore.getMilestoneByWeek("\(weekNumber)")
    }
    
    private var isSelected: Bool {
        selectionStore.isWeekSelected(weekNumber)
    }
    
    private var weekColor: Color {
        if let milestone = milestone,
           let category = milestone.category,
           let mood = MoodCategory.allCategories[category] {
            return mood.swiftUIColor
        }
        
        if selectionStore.selectedColor != nil,
           let mood = MoodCategory.allCategories[selectionStore.selectedColor!] {
            return mood.swiftUIColor
        }
        
        return uiStore.darkMode ? Color.gray.opacity(0.3) : Color.gray.opacity(0.1)
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 2)
                .fill(weekColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 2)
                        .stroke(
                            isCurrentWeek ? Color.blue : Color.clear,
                            lineWidth: isCurrentWeek ? 2 : 0
                        )
                )
                .overlay(
                    // Past week indicator
                    Group {
                        if isPast && uiStore.pastWeekStyle != .none {
                            PastWeekIndicator(style: uiStore.pastWeekStyle)
                        }
                    }
                )
            
            // Milestone indicator
            if milestone != nil && uiStore.showMilestoneIndicators {
                Circle()
                    .fill(Color.white)
                    .frame(width: 4, height: 4)
            }
        }
        .scaleEffect(isPressed ? 0.9 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .onTapGesture {
            handleTap()
        }
        .onLongPressGesture(minimumDuration: 0.1) {
            handleLongPress()
        } onPressingChanged: { pressing in
            isPressed = pressing
        }
    }
    
    private func handleTap() {
        // Optimized haptic feedback
        HapticFeedback.light()
        
        // Handle week selection
        if let selectedColor = selectionStore.selectedColor {
            // Paint week with selected color
            let milestone = Milestone(
                weekNumber: "\(weekNumber)",
                category: selectedColor,
                color: selectedColor,
                title: nil,
                description: nil,
                date: nil
            )
            milestoneStore.updateMilestone(weekNumber: "\(weekNumber)", milestone: milestone)
            selectionStore.addToSelectedWeeks(weekNumber)
        } else {
            // Select week
            selectionStore.toggleWeekSelection(weekNumber)
        }
    }
    
    private func handleLongPress() {
        // Show milestone details or menu
    }
}

struct PastWeekIndicator: View {
    let style: PastWeekStyle
    
    var body: some View {
        Group {
            switch style {
            case .hatch:
                Path { path in
                    path.move(to: CGPoint(x: 0, y: 0))
                    path.addLine(to: CGPoint(x: 8, y: 8))
                }
                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
            case .corner:
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 3, height: 3)
                    .offset(x: -3, y: -3)
            case .none:
                EmptyView()
            }
        }
    }
}

