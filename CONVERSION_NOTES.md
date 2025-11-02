# React to iOS Conversion Notes

This document outlines the conversion from the React web app to the native iOS SwiftUI app.

## Architecture Changes

### State Management
- **React**: Zustand stores with localStorage persistence
- **iOS**: ObservableObject classes with Combine publishers and UserDefaults

### UI Framework
- **React**: React components with Tailwind CSS
- **iOS**: SwiftUI views with native styling

### Backend Integration
- **React**: `@supabase/supabase-js` JavaScript SDK
- **iOS**: `supabase-swift` native Swift SDK

## Key Conversions

### Stores
1. `useLifeStore` → `LifeStore` (ObservableObject)
2. `useMilestoneStore` → `MilestoneStore` (ObservableObject)
3. `useSelectionStore` → `SelectionStore` (ObservableObject)
4. `useUIStore` → `UIStore` (ObservableObject)

### Components
1. `App.jsx` → `ViventivaApp.swift` + `ContentView.swift`
2. `MainApp.jsx` → `MainAppView.swift`
3. `HomePage.jsx` → `HomePageView.swift`
4. `CompleteProfile.jsx` → `CompleteProfileView.swift`
5. `ClearLifeGrid.jsx` → `LifeGridView.swift`
6. `WeekBox.jsx` → `WeekBoxView.swift`
7. `Dashboard.jsx` → `DashboardView.swift`

### Utilities
1. `dateUtils.js` → `DateUtils.swift`
2. `constants.js` → `MoodCategory.swift` (integrated)

## iOS-Specific Optimizations

### Performance
- **LazyVGrid/LazyHGrid**: Efficient grid rendering (replaces react-window)
- **Virtual Scrolling**: Built into SwiftUI LazyVStack/LazyHStack
- **State Updates**: Combine publishers for optimized re-renders

### User Experience
- **Haptic Feedback**: Native iOS haptics for interactions
- **Native Gestures**: Long press, drag, multi-touch support
- **Animations**: SwiftUI native animations (replaces framer-motion)

### Data Persistence
- **UserDefaults**: Replaces localStorage
- **Supabase Sync**: Automatic cloud sync (same backend)
- **Core Data Ready**: Structure allows for Core Data migration if needed

## Differences from Web Version

### Authentication
- **Web**: OAuth redirects through browser
- **iOS**: OAuth through Safari, callback via URL scheme

### Grid Rendering
- **Web**: react-window for virtualization
- **iOS**: SwiftUI LazyVGrid (built-in virtualization)

### Styling
- **Web**: Tailwind CSS classes
- **iOS**: SwiftUI modifiers and native colors

### Touch Interactions
- **Web**: Mouse/touch events with polyfills
- **iOS**: Native gesture recognizers with haptic feedback

## Migration Path

### Data Migration
If users need to migrate data from web to iOS:
1. Export data from web app (JSON)
2. Import in iOS app (JSON parsing)
3. Sync with Supabase for cloud backup

### Feature Parity
All core features from the web app are implemented:
- ✅ Life visualization grid
- ✅ Week painting/coloring
- ✅ Milestone tracking
- ✅ Goals tracking
- ✅ Settings and preferences
- ✅ Authentication (Google, Email)
- ✅ Cloud sync with Supabase

## Future Enhancements

### iOS-Exclusive Features
- Widget support for home screen
- Shortcuts integration
- Apple Watch companion app
- Share extension for milestones
- Notification reminders

### Performance Improvements
- Core Data for large datasets
- Background sync
- Offline-first architecture

## Testing Checklist

- [ ] Authentication flow (Google, Email)
- [ ] Profile setup and editing
- [ ] Week grid rendering and interaction
- [ ] Milestone creation and editing
- [ ] Goal tracking
- [ ] Settings persistence
- [ ] Cloud sync (Supabase)
- [ ] Dark mode
- [ ] Theme switching
- [ ] Grid layout options

