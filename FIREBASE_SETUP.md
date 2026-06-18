# FIREBASE SETUP CHECKLIST

## ✅ Step-by-Step Firebase Configuration

### 1. Create Firebase Project
- [ ] Go to https://console.firebase.google.com/
- [ ] Click "Add project"
- [ ] Name: "EasyRide"
- [ ] Disable Google Analytics (optional for MVP)
- [ ] Click "Create project"

### 2. Enable Authentication
- [ ] Go to Firebase Console → Authentication
- [ ] Click "Get started"
- [ ] Select "Phone" sign-in method
- [ ] Enable it
- [ ] Save

### 3. Create Firestore Database
- [ ] Go to Firebase Console → Firestore Database
- [ ] Click "Create database"
- [ ] Select "Start in test mode" (for development)
- [ ] Choose location (preferably closest to users)
- [ ] Click "Enable"

### 4. Add Android App
- [ ] Go to Project Settings
- [ ] Click "Add app" → Android
- [ ] Package name: `com.apsrtc.easyride`
- [ ] App nickname: "EasyRide Android"
- [ ] Click "Register app"
- [ ] Download `google-services.json`
- [ ] Place in: `android/app/google-services.json`

### 5. Update Android Build Files
- [ ] Add to `android/build.gradle`:
  ```gradle
  dependencies {
      classpath 'com.google.gms:google-services:4.4.0'
  }
  ```
- [ ] Add to `android/app/build.gradle`:
  ```gradle
  apply plugin: 'com.google.gms.google-services'
  ```

### 6. Create Firestore Collections
Create these collections with sample data:

**users/** (auto-created on first login)

**routes/**
```json
{
  "routeId": "route_001",
  "routeName": "MVP Colony to Gajuwaka",
  "source": "MVP Colony",
  "destination": "Gajuwaka",
  "distance": 15,
  "stops": ["MVP Colony", "Madhurawada", "Rushikonda", "Gajuwaka"],
  "active": true
}
```

**buses/**
```json
{
  "busId": "bus_001",
  "busNumber": "AP31Z-1234",
  "busType": "Express",
  "capacity": 45,
  "routeId": "route_001",
  "departureTime": "07:00",
  "arrivalTime": "08:00",
  "fare": 30,
  "active": true
}
```

### 7. Set Firestore Rules
Go to Firestore → Rules and paste:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    match /tickets/{ticketId} {
      allow read, create, update: if request.auth != null;
    }
    match /routes/{routeId} {
      allow read: if true;
    }
    match /buses/{busId} {
      allow read: if true;
    }
  }
}
```

### 8. Initialize Firebase in App
In `lib/main.dart`, uncomment:
```dart
await Firebase.initializeApp();
```

### 9. Test the App
- [ ] Run `flutter pub get`
- [ ] Run `flutter run`
- [ ] Test phone authentication
- [ ] Test ticket booking
- [ ] Test QR scanning

## 🔐 Security Notes
- Never commit `google-services.json` to public repositories
- Update Firestore rules before production
- Enable App Check for production apps

## 📞 Test Phone Numbers (Optional)
For testing without real SMS, add test phone numbers in Firebase:
- Go to Authentication → Sign-in method → Phone
- Scroll to "Phone numbers for testing"
- Add: `+91 9999999999` with code `123456`

## ✅ Verification
After setup, test:
1. App launches without errors
2. Login with phone number works
3. OTP is received/verified
4. Bus search shows results
5. Ticket booking works
6. QR code generates
7. Conductor can scan QR

## 🆘 Common Issues
- **Firebase not initialized**: Check main.dart initialization
- **No routes found**: Add sample data to Firestore
- **OTP not received**: Enable phone auth in Firebase Console
- **Build failed**: Run `flutter clean && flutter pub get`
