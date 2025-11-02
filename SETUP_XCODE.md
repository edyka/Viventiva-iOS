# Setting Up Xcode Project

## Option 1: Create New Xcode Project (Recommended)

### Step 1: Create New Project
1. Open Xcode
2. File → New → Project
3. Choose **iOS** → **App**
4. Product Name: `Viventiva`
5. Interface: **SwiftUI**
6. Language: **Swift**
7. Storage: **None** (we'll use UserDefaults)
8. Click Next and save

### Step 2: Add Swift Files
1. Delete the default `ContentView.swift` if it exists
2. Drag the entire `Viventiva` folder into Xcode project
   - Check "Copy items if needed"
   - Choose "Create groups"
   - Add to target: Viventiva

### Step 3: Add Supabase Dependency
1. File → Add Package Dependencies
2. Enter URL: `https://github.com/supabase/supabase-swift`
3. Version: Latest (2.0.0 or newer)
4. Add to target: Viventiva

### Step 4: Configure Info.plist
1. Right-click `Info.plist` → Open As → Source Code
2. Add these keys:
```xml
<key>SUPABASE_URL</key>
<string>YOUR_SUPABASE_URL</string>
<key>SUPABASE_ANON_KEY</key>
<string>YOUR_SUPABASE_ANON_KEY</string>
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>viventiva</string>
        </array>
    </dict>
</array>
```

### Step 5: Fix Compilation Errors

#### Fix 1: Add UIKit Import to UIStore
Edit `Viventiva/Models/UIStore.swift`, add at top:
```swift
import UIKit
```

#### Fix 2: Update Supabase API Calls
Based on actual Supabase Swift SDK version, adjust:
- `AuthenticationManager.swift` - Auth API calls
- `SupabaseService.swift` - Database API calls

Common fixes:
```swift
// Instead of:
let response = try await client.database.from("table").select().execute()
let data: [Model] = try JSONDecoder().decode([Model].self, from: response.data)

// May need:
let response: [Model] = try await client.database
    .from("table")
    .select()
    .execute()
    .value  // or .decode(type: [Model].self)
```

### Step 6: Build and Run
1. Select your target device/simulator
2. Press ⌘B to build
3. Fix any errors
4. Press ⌘R to run

## Option 2: Use Swift Package Manager

The project includes `Package.swift`, but for iOS app you need an Xcode project.

1. Create Xcode project as above
2. Use the Package.swift as reference for dependencies
3. Add packages via Xcode instead of SPM command line

## Common Issues and Fixes

### Issue: "Cannot find type 'SupabaseClient'"
**Fix:** Make sure Supabase package is added and imported

### Issue: "Value of type has no member 'data'"
**Fix:** Check Supabase SDK documentation for correct response handling

### Issue: "UIKit not available"
**Fix:** Add `import UIKit` to files using UIApplication

### Issue: "Type 'User' is ambiguous"
**Fix:** Replace custom User struct with Supabase AuthUser type

## Next Steps After Setup

1. ✅ Build successfully
2. Configure Supabase credentials
3. Test authentication
4. Test data persistence
5. Add any missing features

