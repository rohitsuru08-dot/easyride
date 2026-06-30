# 🔐 Google Sign-In (OAuth) Login — Implementation Guide for EasyRide

## What is "Google Sign-In"?

This is the **"Sign in with Google"** button — the standard OAuth login where users tap a button,
a Google account picker appears, they select their Gmail account, and they are immediately logged in.
**No OTP, no SMS, no password needed.** Firebase handles everything.

---

## 🔑 How It Works (the flow)

```
User taps "Sign in with Google"
        ↓
Google account picker appears (native popup)
        ↓
User selects their Gmail account
        ↓
Google sends ID token → Firebase verifies it
        ↓
User is logged in → Firestore user document created
```

---

## 📦 Step 1 — Add the google_sign_in Package

Your current `pubspec.yaml` does **not** have `google_sign_in`. You need to add it.

Open `pubspec.yaml` and add this line under `dependencies`:

```yaml
dependencies:
  # ... existing packages ...
  google_sign_in: ^6.2.1        # ← ADD THIS
  firebase_auth: ^5.5.0          # already exists
```

Then run:
```powershell
flutter pub get
```

---

## ✅ Step 2 — Enable Google Sign-In in Firebase Console

1. Go to [console.firebase.google.com](https://console.firebase.google.com)
2. Select your project **easyride-81df0**
3. Left sidebar → **Authentication** → **Sign-in method** tab
4. Find **Google** in the list → click it
5. Toggle **Enable** → ON
6. Set a **Project support email** (your Gmail) — this is required
7. Click **Save**

---

## 🔑 Step 3 — Add SHA Fingerprints for Android (CRITICAL)

Google Sign-In on Android **will not work** without SHA certificates registered.

```powershell
# Run this command inside your project:
cd android
./gradlew signingReport
```

Copy both the **SHA-1** and **SHA-256** values from the output, then:

1. Firebase Console → ⚙️ Project Settings
2. Scroll to **Your apps** → click your Android app
3. Click **Add fingerprint**
4. Paste SHA-1 → Save
5. Repeat for SHA-256 → Save
6. **Download the updated `google-services.json`** and replace:
   `android/app/google-services.json`

> [!IMPORTANT]
> This step is mandatory. If you skip it, Google Sign-In will fail with
> `PlatformException(sign_in_failed, ...)` on Android devices.

---

## 💻 Step 4 — Write the Google Sign-In Method

Add this method to your existing `lib/services/auth_service.dart`:

```dart
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn();

Future<UserCredential?> signInWithGoogle() async {
  try {
    // Trigger the Google account picker
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null; // user cancelled

    // Get auth tokens from Google
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create Firebase credential using Google tokens
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Sign in to Firebase with Google credential
    return await _auth.signInWithCredential(credential);
  } on FirebaseAuthException catch (e) {
    throw Exception('Google sign-in failed: ${e.message}');
  } catch (e) {
    throw Exception('Google sign-in error: $e');
  }
}

Future<void> signOutGoogle() async {
  await _googleSignIn.signOut();
  await _auth.signOut();
}
```

---

## 🎨 Step 5 — Add the Google Sign-In Button to Login Screen

In `lib/screens/auth/login_screen.dart`, add a Google button **below** your current
Sign In button inside `_buildFormCard()`:

```dart
// Divider
Row(children: [
  Expanded(child: Divider(color: Colors.white24)),
  Padding(
    padding: EdgeInsets.symmetric(horizontal: 12),
    child: Text('OR', style: TextStyle(color: Colors.white38, fontSize: 12)),
  ),
  Expanded(child: Divider(color: Colors.white24)),
]),
const SizedBox(height: 16),

// Google Sign-In Button
OutlinedButton.icon(
  onPressed: _signInWithGoogle,
  icon: Image.network(
    'https://developers.google.com/identity/images/g-logo.png',
    height: 20,
    width: 20,
  ),
  label: Text('Continue with Google'),
  style: OutlinedButton.styleFrom(
    foregroundColor: Colors.white,
    side: BorderSide(color: Colors.white24),
    padding: EdgeInsets.symmetric(vertical: 14),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
),
```

And add the handler method inside `_LoginScreenState`:

```dart
Future<void> _signInWithGoogle() async {
  setState(() => _isLoading = true);
  final authProvider = Provider.of<AuthProvider>(context, listen: false);
  final userProvider = Provider.of<UserProvider>(context, listen: false);

  final success = await authProvider.signInWithGoogle();

  if (!mounted) return;
  setState(() => _isLoading = false);

  if (!success) {
    MessageDialog.showError(context,
        message: authProvider.errorMessage ?? 'Google sign-in failed');
    return;
  }

  // Use user's Google display name and email
  final email = authProvider.currentUser?.email ?? '';
  await _loadUserAndNavigate(userProvider, authProvider, email);
}
```

---

## 🔄 Step 6 — Update AuthProvider

Add `signInWithGoogle()` to `lib/providers/auth_provider.dart`:

```dart
Future<bool> signInWithGoogle() async {
  try {
    _errorMessage = null;
    final credential = await _authService.signInWithGoogle();
    if (credential == null) return false;
    return true;
  } catch (e) {
    _errorMessage = e.toString().replaceFirst('Exception: ', '');
    notifyListeners();
    return false;
  }
}
```

---

## 🌐 Step 7 — Web Support (Optional)

For the Flutter Web version, add the Google client ID to `web/index.html`:

```html
<!-- Inside <head> tag -->
<meta name="google-signin-client_id"
      content="YOUR_GOOGLE_CLIENT_ID.apps.googleusercontent.com">
```

Get the client ID from:
Firebase Console → Project Settings → Your apps → Web app → `firebaseConfig` section.

---

## 📋 Files to Modify — Summary

| File | What to Do |
|---|---|
| `pubspec.yaml` | Add `google_sign_in: ^6.2.1` |
| `lib/services/auth_service.dart` | Add `signInWithGoogle()` method |
| `lib/providers/auth_provider.dart` | Add `signInWithGoogle()` wrapper |
| `lib/screens/auth/login_screen.dart` | Add Google button + `_signInWithGoogle()` handler |
| `android/app/google-services.json` | Re-download after adding SHA fingerprints |

---

## ✅ What the User Gets After Google Sign-In

When a user signs in with Google for the first time:
- Their **Google display name** is used as their name
- Their **Gmail address** is stored
- A Firestore `users` document is auto-created with `role: passenger`
- Next time they sign in, they skip the picker if already signed in on device

---

## ⚠️ Common Errors and Fixes

| Error | Cause | Fix |
|---|---|---|
| `sign_in_cancelled` | User tapped back on Google picker | Handle null return from `signIn()` |
| `sign_in_failed` | SHA fingerprint not registered | Do Step 3 — add SHA to Firebase |
| `network_error` | No internet connection | Show connectivity error |
| `ApiException: 10` | `google-services.json` outdated | Re-download from Firebase Console after adding SHA |
| Google button not visible on Web | Missing meta tag | Add client_id meta tag to `web/index.html` |

---

## ✅ Testing Checklist

- [ ] `flutter pub get` runs successfully after adding `google_sign_in`
- [ ] SHA fingerprints added to Firebase Console
- [ ] Updated `google-services.json` downloaded and replaced
- [ ] "Continue with Google" button appears on Login screen
- [ ] Tap button → Google account picker opens
- [ ] Select a Gmail account → logged in as passenger
- [ ] Second tap → same account, no picker (auto sign-in)
- [ ] Sign out → Google account cleared

---

## 📝 Summary of What You Need vs What's Done

| Task | Status |
|---|---|
| `firebase_auth` package | ✅ Already in `pubspec.yaml` |
| `google_sign_in` package | ❌ Need to add to `pubspec.yaml` |
| Firebase Google Sign-In enabled | ❌ Enable in Firebase Console |
| SHA fingerprint registered | ❌ Required for Android |
| `signInWithGoogle()` in AuthService | ❌ Need to add method |
| Google button in Login Screen | ❌ Need to add button |
| AuthProvider updated | ❌ Need to add wrapper |

> [!TIP]
> Tell the assistant: **"implement Google Sign-In login"** and it will make all the above
> code changes automatically.
