# ⚠️ IMPORTANT: This is NOT a Swift Package

This repository contains **Swift files for an iOS App project**, NOT a Swift Package Manager project.

## ✅ Correct Setup Process

**You MUST create a new Xcode iOS App project** and add these Swift files to it.

### Quick Setup:

1. **Open Xcode**
2. **File → New → Project**
3. **iOS → App**
4. Product Name: `Viventiva`
5. Interface: **SwiftUI**
6. Language: **Swift**
7. **Save the project**

8. **Drag the `Viventiva` folder** from this repo into your Xcode project
   - Check "Copy items if needed"
   - Choose "Create groups"
   - Add to target: Viventiva

9. **Add Supabase Dependency:**
   - File → Add Package Dependencies
   - URL: `https://github.com/supabase/supabase-swift`
   - Version: `2.0.0` or latest
   - Add to target: Viventiva

10. **Configure Info.plist** (see `Info.plist.example`)

11. **Build (⌘B)** and fix any remaining errors

## ❌ Do NOT:

- ❌ Open this folder directly in Xcode (it will try to use Package.swift)
- ❌ Use `swift package` commands
- ❌ Treat this as a Swift Package Manager project

## ✅ Do:

- ✅ Create a new Xcode iOS App project
- ✅ Add these Swift files to that project
- ✅ Follow the setup instructions in `SETUP_XCODE.md`

See `SETUP_XCODE.md` or `BUILD_CHECKLIST.md` for detailed instructions.

