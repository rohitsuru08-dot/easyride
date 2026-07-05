# Implementing Firebase Email Verification in Flutter

This guide explains how to use Firebase's built-in email verification (using a magic link) to prevent users from accessing the app until they confirm their email address.

## Step 1: Send the Verification Email upon Signup

When the user signs up, Firebase will create their account. Immediately after creating the account, you should trigger the verification email.

Modify your signup logic (likely inside your `AuthProvider` or signup screen) to look like this:

```dart
Future<void> signUpWithEmailAndPassword(String email, String password) async {
  try {
    // 1. Create the user in Firebase Auth
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    
    User? user = userCredential.user;

    if (user != null && !user.emailVerified) {
      // 2. Send the verification email
      await user.sendEmailVerification();
      
      // 3. (Optional) You can save the user to your Firestore database here as well
      // await _firebaseService.saveUser(UserModel(...));
    }
  } catch (e) {
    // Handle errors (e.g., email already in use, weak password)
    print(e.toString());
  }
}
```

## Step 2: Create an Email Verification Screen

Create a new Flutter screen (e.g., `EmailVerificationScreen`). The user should be redirected here immediately after signing up or if they try to log in without a verified email.

This screen should:
1. Tell the user to check their email for a link.
2. Have a "Resend Email" button.
3. Have a "I've Verified My Email" button (or constantly poll to check if they clicked it).

### Example `EmailVerificationScreen`:

```dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class EmailVerificationScreen extends StatefulWidget {
  @override
  _EmailVerificationScreenState createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool isEmailVerified = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    
    // Check if email is already verified
    isEmailVerified = FirebaseAuth.instance.currentUser?.emailVerified ?? false;

    if (!isEmailVerified) {
      // Set up a timer to automatically check every 3 seconds if the user clicked the link
      timer = Timer.periodic(
        Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> checkEmailVerified() async {
    // Reload the user to get the latest status from Firebase
    await FirebaseAuth.instance.currentUser?.reload();
    
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser?.emailVerified ?? false;
    });

    if (isEmailVerified) {
      timer?.cancel();
      // Navigate to your Home Screen!
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  Future<void> resendVerificationEmail() async {
    try {
      await FirebaseAuth.instance.currentUser?.sendEmailVerification();
      // Show a snackbar saying "Email Resent!"
    } catch (e) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Verify Email')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'A verification email has been sent to your email address.',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: resendVerificationEmail,
              child: Text('Resend Email'),
            ),
            TextButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                // Navigate back to Login Screen
              },
              child: Text('Cancel / Logout'),
            )
          ],
        ),
      ),
    );
  }
}
```

## Step 3: Update your Authentication Routing

You need to act as a "bouncer" at the front door of your app. When the app launches, or when a user logs in, you must check `user.emailVerified`.

Typically, in your app's main router or `StreamBuilder` that listens to `FirebaseAuth.instance.authStateChanges()`:

```dart
Widget build(BuildContext context) {
  return StreamBuilder<User?>(
    stream: FirebaseAuth.instance.authStateChanges(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator();
      }
      
      final user = snapshot.data;
      
      if (user == null) {
        // User is not logged in
        return LoginScreen();
      } else if (!user.emailVerified) {
        // User IS logged in, but has NOT verified their email
        return EmailVerificationScreen();
      } else {
        // User is logged in AND verified
        return PassengerHomeScreen();
      }
    },
  );
}
```

## Step 4: Customize the Email Template (Optional)

You can change what the verification email looks like (Subject line, sender name, etc.) by going to the **Firebase Console**:
1. Go to **Authentication**.
2. Click the **Templates** tab.
3. Click on **Email address verification**.
4. Customize the text and sender details to match EasyRide's branding.

---
> **Note:** Because this uses a magic link, the user must open the email on the same device to automatically trigger the app to update, or you must rely on the 3-second polling timer shown in Step 2 to detect when they click the link on a different device (like their laptop).
