# EasyRide — Testing & QA Guide

> Run on both **mobile (Android)** and **web (Chrome)** unless noted otherwise.

---

## 1. Before You Start

### Firestore seed data required
The app reads routes and buses from Firestore. Without seed data most passenger screens will be empty.

Add at least one document to each collection:

**`routes` collection**
```json
{
  "routeId": "R001",
  "routeName": "Hyderabad–Vijayawada",
  "source": "Hyderabad",
  "destination": "Vijayawada",
  "distance": 275,
  "stops": ["Nalgonda", "Miryalaguda"],
  "active": true
}
```

**`buses` collection**
```json
{
  "busId": "B001",
  "busNumber": "AP39Z1234",
  "busType": "Express",
  "capacity": 50,
  "routeId": "R001",
  "departureTime": "06:00",
  "arrivalTime": "11:00",
  "fare": 250,
  "active": true
}
```

**`users` collection** — create conductor and admin accounts manually after they register, then update their `role` field:
```
passenger  → role: "passenger"   (default on registration)
conductor  → role: "conductor"
admin      → role: "admin"
```

---

## 2. Auth Flow

### 2a. Register (new user)
| Step | Action | Expected |
|---|---|---|
| 1 | Open app → Login screen | Welcome screen with Email + Password fields |
| 2 | Tap **"Don't have an account? Register"** | Button changes to "Create Account" |
| 3 | Enter a valid email + 6-char password | — |
| 4 | Tap **Create Account** | Navigates to Passenger Home |
| 5 | Check Firestore `users` collection | Document created with `role: "passenger"` |

### 2b. Login (existing user)
| Step | Action | Expected |
|---|---|---|
| 1 | Enter registered email + correct password | Navigates to home based on role |
| 2 | Enter wrong password | Error: "Incorrect password. Please try again." |
| 3 | Enter unregistered email in Login mode | Error: "No account found for this email." |

### 2c. Auto-login (splash screen)
| Step | Action | Expected |
|---|---|---|
| 1 | Close and reopen app while logged in | Splash → navigates directly to correct dashboard (no login screen) |

### 2d. Language toggle
| Step | Action | Expected |
|---|---|---|
| 1 | On login screen, tap **తెలుగు** | UI text switches to Telugu |
| 2 | Tap **English** | Switches back |

---

## 3. Passenger Flow

### 3a. Search buses
| Step | Action | Expected |
|---|---|---|
| 1 | Log in as passenger → Home screen | Search form with From / To dropdowns |
| 2 | Select source "Hyderabad", destination "Vijayawada" | — |
| 3 | Pick today's or tomorrow's date | — |
| 4 | Tap **Search** | Bus list screen shows AP39Z1234 Express |
| 5 | Change source/destination | Bus list clears (no stale results) |

### 3b. Book a ticket
| Step | Action | Expected |
|---|---|---|
| 1 | Tap a bus in the list | Booking Summary screen |
| 2 | Verify route, times, fare are correct | — |
| 3 | Choose Passenger Type (Adult/Child/Senior Citizen) | — |
| 4 | Tap **Confirm Booking** | Success dialog → QR Ticket screen |
| 5 | Check Firestore `tickets` collection | Document exists with `ticketId` matching what's shown |
| 6 | Check QR code is rendered | QR code image appears on screen |

### 3c. My Tickets
| Step | Action | Expected |
|---|---|---|
| 1 | Navigate to My Tickets | Upcoming and History tabs |
| 2 | Upcoming tab | Shows tickets with journey date ≥ today |
| 3 | History tab | Shows past tickets |
| 4 | Tap a ticket | QR Ticket screen opens with correct ticket |

---

## 4. Conductor Flow

> Create a conductor account, then set `role: "conductor"` in Firestore before testing.

### 4a. Dashboard
| Step | Action | Expected |
|---|---|---|
| 1 | Log in as conductor | Conductor Dashboard with stats (0 passengers, ₹0 revenue) |
| 2 | Verify today's date shown | Correct |

### 4b. QR Scan verification
| Step | Action | Expected |
|---|---|---|
| 1 | Tap **Scan QR** | Camera opens (browser requests permission on web) |
| 2 | Scan a valid QR code from a passenger's ticket | Ticket details shown → navigate to Verification screen |
| 3 | Verify ticket status in Firestore | `verified: true`, `verifiedBy: <conductorId>`, `status: "verified"` |
| 4 | Scan same QR again | Error: "Ticket already verified" |
| 5 | Scan QR from yesterday's ticket | Error: "Ticket not valid for today" |

### 4c. Manual ticket (cash)
| Step | Action | Expected |
|---|---|---|
| 1 | Tap **Manual Ticket** | Form with Source / Destination dropdowns |
| 2 | Select source and destination | Fare auto-populates from matched bus |
| 3 | Tap **Issue Ticket** | Success: Ticket ID shown (e.g. BMT1716…) |
| 4 | Check Firestore | Ticket exists with `paymentMode: "Cash"`, `verified: true` |
| 5 | Check departure/arrival times | Format is `HH:mm` (24-hour), e.g. "06:00" not "6:00 AM" |

---

## 5. Admin Flow

> Set `role: "admin"` in Firestore for the test account.

### 5a. Dashboard stats
| Step | Action | Expected |
|---|---|---|
| 1 | Log in as admin | Admin Dashboard with Total Tickets, Revenue, Today's Passengers |
| 2 | Book a ticket as passenger | Stats update after refresh |

### 5b. Route analytics
| Step | Action | Expected |
|---|---|---|
| 1 | Tap **Route Analytics** | Bar chart and top routes list |
| 2 | Pull to refresh | Data reloads without crash |
| 3 | If no tickets exist | "No data available" shown (no crash) |

### 5c. Ticketless monitor
| Step | Action | Expected |
|---|---|---|
| 1 | Tap **Ticketless Monitor** | Monitor screen loads |

---

## 6. Cross-Platform Checks

| Feature | Mobile (Android) | Web (Chrome) |
|---|---|---|
| Login / Register | ✓ | ✓ |
| Splash auto-login | ✓ | ✓ |
| Search buses | ✓ | ✓ |
| Book ticket + QR | ✓ | ✓ |
| QR Scanner | Camera (native) | Camera (browser permission popup) |
| Manual ticket | ✓ | ✓ |
| Admin dashboard | ✓ | ✓ |
| Language switch | ✓ | ✓ |
| Portrait lock | ✓ (portrait only) | Not applied (web is free to resize) |

---

## 7. Edge Cases

| Scenario | Expected Behaviour |
|---|---|
| Search with no matching buses | "No buses found" / empty list |
| Book ticket when not logged in | Can't reach screen (splash redirects to login) |
| Conductor scans expired ticket | "Invalid or expired ticket" error |
| Register with password < 6 chars | Inline validation: "Password must be at least 6 characters" |
| Register with invalid email | Inline validation: "Enter a valid email address" |
| Network offline during booking | Firestore error surfaced via error dialog |
| Admin analytics with empty Firestore | Charts show "No data available" (no crash) |

---

## 8. Firestore Index Requirements

Some queries require composite indexes. If you see a Firestore index error in the console, click the link in the error — Firebase auto-generates the index.

Queries that need indexes:
- `tickets` where `passengerId == X` order by `journeyDate` desc
- `tickets` where `journeyDate >= startOfDay` and `journeyDate < endOfDay`

---

## 9. Known Limitations (by design)

| Item | Notes |
|---|---|
| Phone OTP auth | Temporarily disabled (email/password active). See `auth_service.dart` comments to restore. |
| Conductor trip stats | Reset when app is closed — not persisted to Firestore. |
| Admin ticketless data | Shows real routes from Firestore but detection logic is placeholder. |
| Multi-day journeys > 24h | Duration display may be incorrect. |

---

## 10. Running the App

```bash
# Mobile
flutter run -d <android-device-id>

# Web
flutter run -d chrome

# Build web release
flutter build web --release
```
