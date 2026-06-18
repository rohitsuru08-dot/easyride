# Firestore Data Setup Guide

## Step 6 — Add Firestore Data

### Open Firestore

1. Go to [console.firebase.google.com](https://console.firebase.google.com)
2. Click your project **easyride-81df0**
3. Left sidebar → **Firestore Database**
4. You should see an empty database with a **+ Start collection** button

---

## Create the `routes` collection

### Route 1

1. Click **+ Start collection**
2. Collection ID: `routes` → click **Next**
3. Document ID: type `route_001` (do NOT use Auto-ID)
4. Add these fields one by one:

| Field name | Type | Value |
|---|---|---|
| `routeId` | string | `route_001` |
| `routeName` | string | `MVP Colony to Gajuwaka` |
| `source` | string | `MVP Colony` |
| `destination` | string | `Gajuwaka` |
| `distance` | number | `15` |
| `active` | boolean | `true` |

5. For `stops` — click **Add field** → name it `stops` → change type to **array**
   - Click **Add value** → type: string → value: `MVP Colony`
   - Click **Add value** → type: string → value: `Madhurawada`
   - Click **Add value** → type: string → value: `Rushikonda`
   - Click **Add value** → type: string → value: `Gajuwaka`

6. Click **Save**

---

### Route 2

Click **+ Add document** (inside the `routes` collection)

Document ID: `route_002`

| Field name | Type | Value |
|---|---|---|
| `routeId` | string | `route_002` |
| `routeName` | string | `Visakhapatnam to Vijayawada` |
| `source` | string | `Visakhapatnam` |
| `destination` | string | `Vijayawada` |
| `distance` | number | `352` |
| `active` | boolean | `true` |

`stops` → array:
- `Visakhapatnam`
- `Rajam`
- `Srikakulam`
- `Vijayawada`

---

### Route 3

Document ID: `route_003`

| Field name | Type | Value |
|---|---|---|
| `routeId` | string | `route_003` |
| `routeName` | string | `Vijayawada to Tirupati` |
| `source` | string | `Vijayawada` |
| `destination` | string | `Tirupati` |
| `distance` | number | `280` |
| `active` | boolean | `true` |

`stops` → array:
- `Vijayawada`
- `Guntur`
- `Ongole`
- `Nellore`
- `Tirupati`

---

### Route 4

Document ID: `route_004`

| Field name | Type | Value |
|---|---|---|
| `routeId` | string | `route_004` |
| `routeName` | string | `Gajuwaka to MVP Colony` |
| `source` | string | `Gajuwaka` |
| `destination` | string | `MVP Colony` |
| `distance` | number | `15` |
| `active` | boolean | `true` |

`stops` → array:
- `Gajuwaka`
- `Rushikonda`
- `Madhurawada`
- `MVP Colony`

---

## Create the `buses` collection

> **Critical:** The `routeId` value in each bus document must exactly match the **document ID** of the route it belongs to (e.g., `route_001`).

1. Click **+ Start collection**
2. Collection ID: `buses` → click **Next**

---

### Bus 1 — route_001 (MVP Colony → Gajuwaka)

Document ID: `bus_001`

| Field name | Type | Value |
|---|---|---|
| `busId` | string | `bus_001` |
| `busNumber` | string | `AP31Z-1234` |
| `busType` | string | `Express` |
| `capacity` | number | `45` |
| `routeId` | string | `route_001` |
| `departureTime` | string | `07:00` |
| `arrivalTime` | string | `08:00` |
| `fare` | number | `30` |
| `active` | boolean | `true` |

---

### Bus 2 — route_001 (MVP Colony → Gajuwaka, different time)

Document ID: `bus_002`

| Field name | Type | Value |
|---|---|---|
| `busId` | string | `bus_002` |
| `busNumber` | string | `AP31Z-5678` |
| `busType` | string | `Ordinary` |
| `capacity` | number | `60` |
| `routeId` | string | `route_001` |
| `departureTime` | string | `09:30` |
| `arrivalTime` | string | `10:30` |
| `fare` | number | `20` |
| `active` | boolean | `true` |

---

### Bus 3 — route_002 (Visakhapatnam → Vijayawada)

Document ID: `bus_003`

| Field name | Type | Value |
|---|---|---|
| `busId` | string | `bus_003` |
| `busNumber` | string | `AP39X-4321` |
| `busType` | string | `Super Luxury` |
| `capacity` | number | `40` |
| `routeId` | string | `route_002` |
| `departureTime` | string | `06:00` |
| `arrivalTime` | string | `12:00` |
| `fare` | number | `550` |
| `active` | boolean | `true` |

---

### Bus 4 — route_002 (Visakhapatnam → Vijayawada, night bus)

Document ID: `bus_004`

| Field name | Type | Value |
|---|---|---|
| `busId` | string | `bus_004` |
| `busNumber` | string | `AP39X-8899` |
| `busType` | string | `Express` |
| `capacity` | number | `55` |
| `routeId` | string | `route_002` |
| `departureTime` | string | `22:00` |
| `arrivalTime` | string | `04:00` |
| `fare` | number | `400` |
| `active` | boolean | `true` |

---

### Bus 5 — route_003 (Vijayawada → Tirupati)

Document ID: `bus_005`

| Field name | Type | Value |
|---|---|---|
| `busId` | string | `bus_005` |
| `busNumber` | string | `AP16W-7777` |
| `busType` | string | `Metro Deluxe` |
| `capacity` | number | `45` |
| `routeId` | string | `route_003` |
| `departureTime` | string | `08:00` |
| `arrivalTime` | string | `14:00` |
| `fare` | number | `480` |
| `active` | boolean | `true` |

---

### Bus 6 — route_004 (Gajuwaka → MVP Colony)

Document ID: `bus_006`

| Field name | Type | Value |
|---|---|---|
| `busId` | string | `bus_006` |
| `busNumber` | string | `AP31Z-3322` |
| `busType` | string | `Ordinary` |
| `capacity` | number | `60` |
| `routeId` | string | `route_004` |
| `departureTime` | string | `08:00` |
| `arrivalTime` | string | `09:00` |
| `fare` | number | `20` |
| `active` | boolean | `true` |

---

## Assign Conductor and Admin Roles

The app creates every new login as `passenger` by default. To test conductor and admin dashboards, manually set roles after a user first logs in.

**After logging in with your conductor test phone:**

1. Firestore → `users` collection → find the document for that user
2. Click the `role` field → Edit → change value from `passenger` to `conductor`
3. Click **Update**

Repeat with value `admin` for your admin test phone.

---

## Step 7 — Set Firestore Security Rules

1. In Firebase Console, left sidebar → **Firestore Database**
2. Click the **Rules** tab (next to Data, Indexes)
3. Replace everything in the editor with:

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

4. Click **Publish**
5. Wait for the green **Rules published** confirmation toast

---

## Final Verification

After both steps, run:

```bash
flutter pub get
flutter run
```

**Test checklist:**
- [ ] App launches without errors (Firebase initialized)
- [ ] Login with a phone number → OTP received → logged in as passenger
- [ ] Passenger home → search `MVP Colony` → `Gajuwaka` → 2 buses appear
- [ ] Select a bus → confirm booking → QR code screen appears
- [ ] Change your Firestore `role` to `conductor` → re-login → conductor dashboard appears
- [ ] Conductor scans the passenger's QR → ticket verified
- [ ] Change role to `admin` → re-login → admin dashboard with analytics appears
