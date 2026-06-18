# EasyRide - Hybrid Bus Ticketing System for APSRTC

**Smart. Inclusive. Reliable.**

EasyRide is a comprehensive mobile application for APSRTC bus ticketing in Visakhapatnam, featuring digital tickets, QR-based verification, and multi-role dashboards for passengers, conductors, and administrators.

## 🚀 Features

### Passenger App
- 📱 Phone OTP Authentication
- 🔍 Bus Search (Source, Destination, Date)
- 🎫 Digital Ticket Booking
- 📲 QR Code Ticket Generation
- 📋 Ticket History (Upcoming & Past)
- 🌐 English & Telugu Language Support

### Conductor App
- 📸 QR Code Scanner for Ticket Verification
- ✅ Real-time Ticket Validation
- 💵 Manual Cash Ticket Generation
- 📊 Trip Statistics & Revenue Tracking
- 📴 Offline Verification Support

### Admin Dashboard
- 📈 Revenue & Ticket Analytics
- 📊 Route Performance Charts
- 🕐 Peak Hour Analysis
- ⚠️ Ticketless Travel Monitoring
- 📉 Real-time Statistics

## 🛠 Tech Stack

- **Framework:** Flutter (Dart)
- **Backend:** Firebase (Firestore, Authentication)
- **State Management:** Provider
- **QR Generation:** qr_flutter
- **QR Scanning:** mobile_scanner
- **Local Storage:** SharedPreferences
- **Charts:** fl_chart
- **Localization:** intl

## 📁 Project Structure

```
lib/
├── core/
│   ├── constants/           # App constants (colors, strings, Firestore fields)
│   ├── theme/               # App theme configuration
│   └── utils/               # Validators, date helpers
├── models/                  # Data models (User, Ticket, Route, Bus)
├── services/                # Firebase, Auth, QR, Local Storage services
├── providers/               # State management (Provider pattern)
├── screens/
│   ├── auth/                # Splash, Login, OTP screens
│   ├── passenger/           # 5 passenger screens
│   ├── conductor/           # 4 conductor screens
│   └── admin/               # 3 admin screens
├── widgets/
│   ├── common/              # Reusable widgets (buttons, dialogs)
│   ├── passenger/           # Passenger-specific widgets
│   ├── conductor/           # Conductor-specific widgets
│   └── admin/               # Admin-specific widgets
├── localization/            # English & Telugu translations
├── navigation/              # App routing
└── main.dart                # App entry point
```

## 🔧 Setup Instructions

### Prerequisites

1. **Flutter SDK** (3.0.0 or higher)
   ```bash
   flutter --version
   ```

2. **Android Studio** or **VS Code** with Flutter plugin

3. **Firebase Account** (for backend services)

4. **Android Device/Emulator** (for testing QR scanner)

### Step 1: Clone the Repository

```bash
cd d:\Projects\sample\easy-ride
```

### Step 2: Install Dependencies

```bash
flutter pub get
```

### Step 3: Firebase Configuration

#### Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project named "EasyRide"
3. Enable **Authentication** → **Phone** sign-in method
4. Enable **Cloud Firestore** database

#### Android Configuration

1. In Firebase Console, add an Android app
2. Package name: `com.apsrtc.easyride`
3. Download `google-services.json`
4. Place it in: `android/app/google-services.json`

5. Update `android/build.gradle`:
   ```gradle
   dependencies {
       classpath 'com.google.gms:google-services:4.4.0'
   }
   ```

6. Update `android/app/build.gradle`:
   ```gradle
   apply plugin: 'com.google.gms.google-services'
   
   defaultConfig {
       minSdkVersion 21
   }
   ```

#### iOS Configuration (Optional)

1. In Firebase Console, add an iOS app
2. Bundle ID: `com.apsrtc.easyride`
3. Download `GoogleService-Info.plist`
4. Place it in: `ios/Runner/GoogleService-Info.plist`

#### Initialize Firebase in App

Uncomment in `lib/main.dart`:
```dart
await Firebase.initializeApp();
```

### Step 4: Firestore Database Setup

Create the following collections in Firestore:

**1. users/**
```
- userId (string)
- name (string)
- phone (string)
- role (string): "passenger", "conductor", "admin"
- language (string): "en", "te"
- createdAt (timestamp)
```

**2. tickets/**
```
- ticketId (string)
- passengerName (string)
- passengerId (string)
- source (string)
- destination (string)
- fare (number)
- busType (string)
- busNumber (string)
- routeId (string)
- departureTime (string)
- arrivalTime (string)
- bookingTime (timestamp)
- journeyDate (timestamp)
- status (string)
- verified (boolean)
- verifiedBy (string)
- verifiedAt (timestamp)
- passengerType (string)
- paymentMode (string)
```

**3. routes/**
```
- routeId (string)
- routeName (string)
- source (string)
- destination (string)
- distance (number)
- stops (array)
- active (boolean)
```

**4. buses/**
```
- busId (string)
- busNumber (string)
- busType (string)
- capacity (number)
- routeId (string)
- departureTime (string)
- arrivalTime (string)
- fare (number)
- active (boolean)
```

#### Sample Data

Add sample routes (Go to Firestore Console → routes collection):

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

Add sample buses:

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

### Step 5: Run the App

```bash
flutter run
```

Or for specific device:
```bash
flutter devices
flutter run -d <device-id>
```

## 📱 User Roles & Testing

### Test as Passenger
1. Open app → Login with phone number
2. Receive OTP → Verify
3. Default role: **Passenger**
4. Search buses → Book ticket → View QR code

### Test as Conductor
1. Change user role in Firestore to `"conductor"`
2. Reopen app
3. Scan passenger QR tickets
4. Generate manual cash tickets

### Test as Admin
1. Change user role in Firestore to `"admin"`
2. Reopen app
3. View analytics dashboard
4. Check route performance

## 🔥 Firestore Security Rules

Add these rules in Firebase Console → Firestore → Rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Tickets collection
    match /tickets/{ticketId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update: if request.auth != null;
    }
    
    // Routes collection
    match /routes/{routeId} {
      allow read: if true;
      allow write: if false;
    }
    
    // Buses collection
    match /buses/{busId} {
      allow read: if true;
      allow write: if false;
    }
  }
}
```

## 🐛 Troubleshooting

### Firebase Not Initialized
```
Error: Firebase not initialized
Solution: Uncomment Firebase.initializeApp() in main.dart
```

### QR Scanner Not Working
```
Error: Camera permission denied
Solution: Add permissions in AndroidManifest.xml:
<uses-permission android:name="android.permission.CAMERA"/>
<uses-feature android:name="android.hardware.camera"/>
```

### Phone Authentication Failed
```
Error: Phone authentication not enabled
Solution: Enable Phone sign-in in Firebase Console
```

### Build Failed
```bash
flutter clean
flutter pub get
flutter run
```

## 📝 Important Notes

- **MVP Scope:** This is a prototype application with essential features only
- **No Payment Integration:** Booking confirmations are simulated
- **No Real-time GPS:** Bus tracking is not implemented
- **Mock Data:** Some analytics use generated data for demonstration
- **Firebase Required:** App will not work without Firebase configuration

## 📚 Dependencies

Key packages used (see `pubspec.yaml` for versions):
- `firebase_core` - Firebase initialization
- `firebase_auth` - Phone authentication
- `cloud_firestore` - Database
- `provider` - State management
- `qr_flutter` - QR code generation
- `mobile_scanner` - QR code scanning
- `shared_preferences` - Local storage
- `fl_chart` - Charts & graphs
- `intl` - Internationalization

## 🤝 Contributing

This is an MVP prototype for APSRTC. For production use:
1. Add proper error handling
2. Implement payment gateway
3. Add real-time bus tracking
4. Implement push notifications
5. Add comprehensive testing
6. Optimize performance

## 📄 License

This project is created for demonstration purposes.

## 📧 Support

For issues or questions:
- Create an issue in the repository
- Contact: support@apsrtc.in (example)

---

**Built with ❤️ for APSRTC Visakhapatnam**

**Version:** 1.0.0 (MVP)
