# How to Import CSV Data to Firebase using Rowy

Rowy is a free, open-source tool that gives you an Excel/Airtable-like interface for your Firebase Firestore database. It is the easiest way to import your CSV files into Firestore without writing any code or changing security rules.

## Step 1: Connect Rowy to your Firebase Project
1. Go to [Rowy.io](https://www.rowy.io/) and click **Start for Free** / **Login**.
2. Create a new Workspace.
3. Click **Add Project** and follow the guided setup to connect Rowy to your existing Firebase project (`easyride-81df0`).
   * *Note: Rowy will ask you to deploy "Rowy Run" to your Google Cloud / Firebase project. This is completely normal and safe; it is the backend service that allows Rowy to read/write to your database.*

## Step 2: Import the Routes Data
Once your project is connected and you are in the Rowy dashboard:
1. Click **Create Table**.
2. Select **Existing Collection** and type in exactly `routes` (all lowercase). Click Create.
3. You will now see a spreadsheet view of your `routes` collection.
4. In the top right of the table, click the **Import** button (usually an arrow pointing down into a box).
5. Upload your `routes.csv` file.
6. **Map the Columns**: Rowy will ask you to match your CSV columns to Firestore fields. Set them up like this:
   * `route_no` -> Document ID (Very important! This makes the Route ID the actual document ID)
   * `route_no` -> `routeId` (String)
   * `source` -> `source` (String)
   * `destination` -> `destination` (String)
   * `distance` -> `distance` (Number - you can set a default of 15 if missing)
   * `active` -> `active` (Boolean - set to `true`)
7. Click **Import**. Your routes are now instantly live in your Firebase Database!

## Step 3: Import the Buses (Schedules) Data
1. Go back to your Rowy dashboard homepage.
2. Click **Create Table** again.
3. Select **Existing Collection** and type in exactly `buses` (all lowercase). Click Create.
4. Click the **Import** button in the top right.
5. Upload your `schedules.csv` file.
6. **Map the Columns**:
   * `route_no` -> `routeId` (String)
   * `departure_time` -> `departureTime` (String)
   * `source` / `destination` -> (You can ignore these if they are already in the Routes table, or import them if you want them on the Bus document too).
   * **Missing Fields:** You can use Rowy's default value feature during import to automatically set:
      * `capacity` -> `40` (Number)
      * `busType` -> `Ordinary` (String)
      * `active` -> `true` (Boolean)
      * `fare` -> `30` (Number)
7. **Document ID**: You can let Rowy automatically generate random Document IDs for the buses, or you can map a combination column if you have one.
8. Click **Import**.

## Step 4: You're Done!
Open your EasyRide app. The app reads directly from Firebase, so the moment Rowy finishes the import, your app will immediately display all 2700+ real-world bus schedules and routes. You do not need to restart or change any code in the app.
