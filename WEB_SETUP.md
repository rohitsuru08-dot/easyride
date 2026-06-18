# EasyRide — Web Setup Guide

This document covers everything needed to run EasyRide on both **mobile (Android/iOS)** and **web (Chrome/browser)**.

---

## What Was Changed

| File | Change |
|---|---|
| `lib/firebase_options.dart` | New file — platform-specific Firebase config (Android, iOS, Web) |
| `lib/main.dart` | Uses `DefaultFirebaseOptions.currentPlatform`; portrait lock skipped on web |
| `lib/services/auth_service.dart` | Web uses `signInWithPhoneNumber` + `ConfirmationResult`; mobile path unchanged |
| `web/index.html` | Updated title and description |

---

## Firebase Blaze Plan (Required for Web Phone Auth)

Phone authentication via SMS on web requires the **Firebase Blaze (pay-as-you-go)** plan.  
On Android/iOS it works on the free Spark plan, but on web all SMS go through Firebase Identity Toolkit which requires billing.

> **Cost:** The first **10,000 SMS verifications/month are free**. No actual cost for development or normal usage.

### Upgrade Steps

1. Go to [Firebase Console](https://console.firebase.google.com/) → select **EasyRide** project
2. In the **bottom-left corner**, click the **"Spark"** plan badge → **"Upgrade"**
3. Select **Blaze (Pay as you go)** → click **"Continue"**
4. Add a billing account (Google account + credit/debit card)
5. Set a **budget alert** (e.g. ₹100) to get notified if costs spike
6. Confirm the upgrade

---

## Firebase Console Setup

### 1. Enable Phone Sign-in
1. Firebase Console → **Authentication** → **Sign-in method**
2. Click **Phone** → toggle **Enabled** → **Save**

### 2. Add Web App (already done)
1. Firebase Console → **Project Settings** → **Your apps** → **Add app → Web**
2. The `apiKey` and `appId` from the web app config go into `lib/firebase_options.dart`

### 3. Authorized Domains
Firebase Console → **Authentication** → **Settings** → **Authorized domains**

These must be present:

| Domain | Purpose |
|---|---|
| `localhost` | Local development |
| `easyride-81df0.firebaseapp.com` | Firebase hosting |
| `easyride-81df0.web.app` | Firebase hosting |

---

## Running the App

### Mobile (Android)
```bash
flutter run -d <android-device-id>
```

### Web (Chrome)
```bash
flutter run -d chrome
```

### Build for Web (production)
```bash
flutter build web --release
```

---

## How Web Phone Auth Works

On **mobile**, Firebase uses the native SMS auto-detection SDK (`verifyPhoneNumber`).  
On **web**, Firebase uses `signInWithPhoneNumber` which triggers an **invisible reCAPTCHA** in the browser (the Google badge in the bottom-right corner). The user does not need to solve a CAPTCHA puzzle — it completes automatically.

Flow:
1. User enters phone number → taps **Send OTP**
2. reCAPTCHA completes silently in the background
3. Firebase sends SMS to the phone number
4. User enters the 6-digit OTP → taps **Verify**
5. App navigates to the appropriate dashboard based on user role

---

## QR Scanner on Web

`mobile_scanner` v3.5.5 supports web via the **browser's camera API**.  
When the conductor opens the QR Scanner screen in a browser, Chrome will ask for **camera permission** — allow it and the scanner works the same as on mobile.

---

## Known Limitations on Web

| Feature | Status |
|---|---|
| Phone OTP auth | Works (requires Blaze plan) |
| QR code scanning | Works (browser camera permission required) |
| QR code display | Works |
| Admin dashboard / analytics | Works |
| Passenger ticket booking | Works |
| Portrait-only lock | Not applied (web is free to resize) |

---

## Troubleshooting

| Error | Cause | Fix |
|---|---|---|
| `[billing-not-enabled]` | Firebase project on Spark plan | Upgrade to Blaze plan |
| `[operation-not-allowed]` | Phone sign-in disabled | Enable Phone in Firebase Auth → Sign-in method |
| `[invalid-phone-number]` | Wrong format | App auto-adds `+91` — enter 10-digit number only |
| `[too-many-requests]` | SMS quota hit | Wait and retry, or check Firebase quotas |
| reCAPTCHA not appearing | `localhost` not in authorized domains | Add `localhost` in Firebase Auth → Settings → Authorized domains |