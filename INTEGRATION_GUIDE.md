# iOS Integration Guide

This guide helps you integrate the converted iOS app into your Xcode project.

## Quick Start

1. **Create New Xcode Project**
   - Open Xcode
   - Create new iOS App project
   - Name it "Viventiva"
   - Choose SwiftUI as interface

2. **Copy Files**
   - Copy all files from `iOS/Viventiva/` to your Xcode project
   - Maintain the folder structure (Models, Views, Services, Utilities)

3. **Add Swift Package Dependency**
   - File → Add Package Dependencies
   - Add: `https://github.com/supabase/supabase-swift`
   - Version: 2.0.0 or later

4. **Configure Info.plist**
   - Copy `Info.plist.template` content to your `Info.plist`
   - Replace `YOUR_SUPABASE_URL_HERE` with your Supabase URL
   - Replace `YOUR_SUPABASE_ANON_KEY_HERE` with your Supabase anon key

5. **Configure URL Scheme**
   - Ensure `viventiva://` is registered in Info.plist (already in template)
   - Configure redirect URL in Supabase dashboard as `viventiva://auth-callback`

6. **Build and Run**
   - Select target device
   - Press ⌘R to build and run

## Project Structure in Xcode

```
Viventiva/
├── ViventivaApp.swift          [Root]
├── ContentView.swift            [Main Router]
├── Models/
│   ├── LifeStore.swift
│   ├── MilestoneStore.swift
│   ├── SelectionStore.swift
│   ├── UIStore.swift
│   └── MoodCategory.swift
├── Services/
│   ├── AuthenticationManager.swift
│   └── SupabaseService.swift
├── Views/
│   ├── MainAppView.swift
│   ├── HomePageView.swift
│   ├── CompleteProfileView.swift
│   ├── LifeGridView.swift
│   ├── WeekBoxView.swift
│   ├── DashboardView.swift
│   ├── MoodPaletteView.swift
│   ├── GoalsView.swift
│   └── SettingsView.swift
├── Utilities/
│   ├── DateUtils.swift
│   └── HapticFeedback.swift
└── Info.plist
```

## Dependencies

### Required
- **Supabase Swift SDK**: `https://github.com/supabase/supabase-swift`

### Optional (if adding tests)
- XCTest (built-in)

## Configuration

### Supabase Setup
1. Create account at https://supabase.com
2. Create new project
3. Get URL and anon key from Project Settings → API
4. Add to Info.plist or environment variables

### OAuth Configuration
1. In Supabase dashboard:
   - Go to Authentication → Providers
   - Enable Google OAuth
   - Add redirect URL: `viventiva://auth-callback`
   - Configure OAuth credentials

## Common Issues

### Build Errors
- **Supabase SDK not found**: Make sure package is added and resolved
- **Missing Info.plist keys**: Add SUPABASE_URL and SUPABASE_ANON_KEY
- **Type errors**: Update Supabase SDK API calls based on actual SDK version

### Runtime Errors
- **OAuth not working**: Check URL scheme and redirect URL configuration
- **No data sync**: Verify Supabase credentials and network connectivity
- **Crash on launch**: Check all required stores are injected via @EnvironmentObject

## Testing

### Unit Tests
Create test target and test stores:
```swift
import XCTest
@testable import Viventiva

class LifeStoreTests: XCTestCase {
    func testCalculateCurrentWeek() {
        let store = LifeStore.shared
        store.setBirthData(day: 1, month: 1, year: 2000)
        XCTAssertGreaterThan(store.currentWeek, 1)
    }
}
```

### UI Tests
Test critical user flows:
- Authentication
- Profile setup
- Week painting
- Milestone creation

## Deployment

### TestFlight
1. Archive in Xcode (Product → Archive)
2. Distribute to App Store Connect
3. Add to TestFlight
4. Invite testers

### App Store
1. Complete App Store Connect listing
2. Submit for review
3. Wait for approval

## Performance Tips

1. **Enable Virtualization**: Already enabled in LifeGridView using LazyVGrid
2. **Optimize Images**: Use SF Symbols where possible
3. **Reduce Animations**: Can disable in settings if needed
4. **Background Sync**: Implement background tasks for Supabase sync

## Next Steps

1. Customize app icon and launch screen
2. Add App Store screenshots and description
3. Set up analytics (optional)
4. Configure push notifications (optional)
5. Add widget support (optional)

