# Flutter Installation Guide for Windows

## Step 1: Download Flutter SDK

1. Open your browser: https://docs.flutter.dev/get-started/install/windows
2. Click "Download Flutter SDK" button
3. Save the ZIP file (approximately 1.5 GB)

**Direct Download Link:**
https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_latest-stable.zip

## Step 2: Extract Flutter

1. Create a folder: `C:\src` (recommended location)
2. Extract the downloaded ZIP to this folder
3. Final path should be: `C:\src\flutter\`
4. **IMPORTANT:** Do NOT extract to:
   - `C:\Program Files\` (requires admin privileges)
   - Folders with spaces in the path
   - Network drives

## Step 3: Add Flutter to PATH

### Option A: Using Windows Settings
1. Press `Win + X` → Select "System"
2. Click "Advanced system settings"
3. Click "Environment Variables"
4. Under "User variables", select "Path" → Click "Edit"
5. Click "New" → Add: `C:\src\flutter\bin`
6. Click "OK" on all dialogs

### Option B: Using PowerShell
Run PowerShell as Administrator:
```powershell
[System.Environment]::SetEnvironmentVariable('Path', $env:Path + ';C:\src\flutter\bin', [System.EnvironmentVariableTarget]::User)
```

## Step 4: Verify Installation

Close and reopen PowerShell/Terminal, then run:
```powershell
flutter --version
```

Expected output:
```
Flutter 3.x.x • channel stable • https://github.com/flutter/flutter.git
Framework • revision xxxxx
Engine • revision xxxxx
Tools • Dart 3.x.x
```

## Step 5: Run Flutter Doctor

```powershell
flutter doctor
```

This checks for required dependencies:
- ✅ Flutter SDK
- ✅ Android toolchain
- ✅ VS Code (already installed)
- ✅ Connected devices

**Common Issues:**
- ❌ Android SDK not found → Install Android Studio
- ❌ cmdline-tools not found → Install via Android Studio SDK Manager
- ⚠️ Some warnings are OK for now

## Step 6: Accept Android Licenses

```powershell
flutter doctor --android-licenses
```

Type 'y' to accept all licenses.

## Step 7: Install Dependencies in EasyRide Project

```powershell
cd D:\Projects\sample\easy-ride
flutter pub get
```

## Troubleshooting

### "flutter: command not found"
- Restart your terminal/PowerShell
- Verify PATH is set correctly
- Check `C:\src\flutter\bin` exists

### "Git not found"
Download and install Git:
https://git-scm.com/download/win

### "Android SDK not found"
Install Android Studio:
https://developer.android.com/studio

## Next Steps After Installation

1. Run `flutter doctor` and fix any issues
2. Run `flutter pub get` in the EasyRide project
3. Follow FIREBASE_SETUP.md for Firebase configuration
4. Run `flutter run` to launch the app

## Quick Commands Reference

```powershell
# Check Flutter version
flutter --version

# Check for issues
flutter doctor -v

# Install dependencies
flutter pub get

# Clean build
flutter clean

# Run app
flutter run

# List connected devices
flutter devices
```

## System Requirements

- **OS:** Windows 10 or later (64-bit)
- **Disk Space:** 3-4 GB (Flutter SDK + Android SDK)
- **Tools:** PowerShell 5.0 or later
- **RAM:** 8 GB minimum (16 GB recommended)

---

**Need Help?**
- Flutter Documentation: https://docs.flutter.dev
- Flutter Discord: https://discord.gg/flutter
