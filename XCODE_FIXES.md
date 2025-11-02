# Xcode Compatibility Fixes

The code needs several fixes before it can compile in Xcode. Here are the issues and fixes:

## Required Fixes

### 1. Add UIKit Import to UIStore

**File:** `Viventiva/Models/UIStore.swift`

Add at the top:
```swift
import UIKit
```

### 2. Fix Supabase SDK API Calls

The Supabase Swift SDK API may differ from what's implemented. You'll need to check the actual SDK documentation and adjust:

**Files to review:**
- `Viventiva/Services/AuthenticationManager.swift`
- `Viventiva/Services/SupabaseService.swift`

**Common issues:**
- `client.auth.session` → may need to be `client.auth.session` or different API
- `response.data` → may need `response.value` or different property
- Database queries may need different syntax

### 3. Fix User Type

**File:** `Viventiva/Services/AuthenticationManager.swift`

The `User` struct is a placeholder. Replace with actual Supabase AuthUser type:
```swift
import Supabase
// Use AuthUser from Supabase SDK instead of custom User struct
```

### 4. Xcode Project Setup Required

You need to:
1. Create an Xcode project (or use the Package.swift)
2. Add Supabase Swift SDK dependency
3. Configure Info.plist with Supabase credentials
4. Set up URL scheme for OAuth callbacks

## Quick Fix Script

See `SETUP_XCODE.md` for step-by-step Xcode setup instructions.

## Testing After Fixes

1. Build in Xcode (⌘B)
2. Fix any compilation errors
3. Adjust Supabase SDK calls based on actual API
4. Test authentication flow
5. Test data sync

