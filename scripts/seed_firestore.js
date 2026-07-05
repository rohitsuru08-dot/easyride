const admin = require('firebase-admin');
const serviceAccount = require('./serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

// ─── DATA ────────────────────────────────────────────────────────────────────
// All routes are local Visakhapatnam (Vizag) city routes.
// Fares: APSRTC ordinary ~₹1.3/km, Express ~₹1.7/km

const routes = [

  // ════════════════════════════════════════════════════════
  //  CITY ROUTES — within Visakhapatnam city limits
  // ════════════════════════════════════════════════════════

  {
    id: 'route_001',
    routeId: 'route_001',
    routeName: 'MVP Colony to Gajuwaka',
    source: 'MVP Colony',
    destination: 'Gajuwaka',
    distance: 15,
    stops: ['MVP Colony', 'Madhurawada', 'Kommadi', 'Rushikonda', 'Bheemunipatnam Bypass', 'Gajuwaka'],
    active: true,
  },
  {
    id: 'route_002',
    routeId: 'route_002',
    routeName: 'Gajuwaka to MVP Colony',
    source: 'Gajuwaka',
    destination: 'MVP Colony',
    distance: 15,
    stops: ['Gajuwaka', 'Bheemunipatnam Bypass', 'Rushikonda', 'Kommadi', 'Madhurawada', 'MVP Colony'],
    active: true,
  },
  {
    id: 'route_003',
    routeId: 'route_003',
    routeName: 'RTC Complex to Steel Plant',
    source: 'RTC Complex',
    destination: 'Steel Plant',
    distance: 14,
    stops: ['RTC Complex', 'Jagadamba Junction', 'Dwaraka Nagar', 'NAD Junction', 'Gajuwaka', 'Steel Plant'],
    active: true,
  },
  {
    id: 'route_004',
    routeId: 'route_004',
    routeName: 'Steel Plant to RTC Complex',
    source: 'Steel Plant',
    destination: 'RTC Complex',
    distance: 14,
    stops: ['Steel Plant', 'Gajuwaka', 'NAD Junction', 'Dwaraka Nagar', 'Jagadamba Junction', 'RTC Complex'],
    active: true,
  },
  {
    id: 'route_005',
    routeId: 'route_005',
    routeName: 'RTC Complex to Bheemunipatnam',
    source: 'RTC Complex',
    destination: 'Bheemunipatnam',
    distance: 26,
    stops: ['RTC Complex', 'Waltair Junction', 'Beach Road', 'Lawsons Bay Colony', 'Rushikonda', 'Kommadi', 'Madhurawada', 'Bheemunipatnam'],
    active: true,
  },
  {
    id: 'route_006',
    routeId: 'route_006',
    routeName: 'Bheemunipatnam to RTC Complex',
    source: 'Bheemunipatnam',
    destination: 'RTC Complex',
    distance: 26,
    stops: ['Bheemunipatnam', 'Madhurawada', 'Kommadi', 'Rushikonda', 'Lawsons Bay Colony', 'Beach Road', 'Waltair Junction', 'RTC Complex'],
    active: true,
  },
  {
    id: 'route_007',
    routeId: 'route_007',
    routeName: 'RTC Complex to Kommadi',
    source: 'RTC Complex',
    destination: 'Kommadi',
    distance: 20,
    stops: ['RTC Complex', 'Waltair Junction', 'Beach Road', 'Lawsons Bay Colony', 'Rushikonda', 'Kommadi'],
    active: true,
  },
  {
    id: 'route_008',
    routeId: 'route_008',
    routeName: 'Kommadi to RTC Complex',
    source: 'Kommadi',
    destination: 'RTC Complex',
    distance: 20,
    stops: ['Kommadi', 'Rushikonda', 'Lawsons Bay Colony', 'Beach Road', 'Waltair Junction', 'RTC Complex'],
    active: true,
  },
  {
    id: 'route_009',
    routeId: 'route_009',
    routeName: 'Pendurthi to Gajuwaka',
    source: 'Pendurthi',
    destination: 'Gajuwaka',
    distance: 28,
    stops: ['Pendurthi', 'Gopalapatnam', 'Simhachalam', 'NAD Junction', 'Dwaraka Nagar', 'Jagadamba Junction', 'Gajuwaka'],
    active: true,
  },
  {
    id: 'route_010',
    routeId: 'route_010',
    routeName: 'Gajuwaka to Pendurthi',
    source: 'Gajuwaka',
    destination: 'Pendurthi',
    distance: 28,
    stops: ['Gajuwaka', 'Jagadamba Junction', 'Dwaraka Nagar', 'NAD Junction', 'Simhachalam', 'Gopalapatnam', 'Pendurthi'],
    active: true,
  },
  {
    id: 'route_011',
    routeId: 'route_011',
    routeName: 'MVP Colony to Steel Plant',
    source: 'MVP Colony',
    destination: 'Steel Plant',
    distance: 22,
    stops: ['MVP Colony', 'Madhurawada', 'NAD Junction', 'Dwaraka Nagar', 'Gajuwaka', 'Steel Plant'],
    active: true,
  },
  {
    id: 'route_012',
    routeId: 'route_012',
    routeName: 'Steel Plant to MVP Colony',
    source: 'Steel Plant',
    destination: 'MVP Colony',
    distance: 22,
    stops: ['Steel Plant', 'Gajuwaka', 'Dwaraka Nagar', 'NAD Junction', 'Madhurawada', 'MVP Colony'],
    active: true,
  },
  {
    id: 'route_013',
    routeId: 'route_013',
    routeName: 'RTC Complex to Simhachalam',
    source: 'RTC Complex',
    destination: 'Simhachalam',
    distance: 18,
    stops: ['RTC Complex', 'Dwaraka Nagar', 'NAD Junction', 'Gopalapatnam', 'Simhachalam'],
    active: true,
  },
  {
    id: 'route_014',
    routeId: 'route_014',
    routeName: 'Simhachalam to RTC Complex',
    source: 'Simhachalam',
    destination: 'RTC Complex',
    distance: 18,
    stops: ['Simhachalam', 'Gopalapatnam', 'NAD Junction', 'Dwaraka Nagar', 'RTC Complex'],
    active: true,
  },
  {
    id: 'route_015',
    routeId: 'route_015',
    routeName: 'Dwaraka Nagar to Bheemunipatnam',
    source: 'Dwaraka Nagar',
    destination: 'Bheemunipatnam',
    distance: 22,
    stops: ['Dwaraka Nagar', 'Jagadamba Junction', 'Beach Road', 'Rushikonda', 'Kommadi', 'Madhurawada', 'Bheemunipatnam'],
    active: true,
  },
  {
    id: 'route_016',
    routeId: 'route_016',
    routeName: 'Bheemunipatnam to Dwaraka Nagar',
    source: 'Bheemunipatnam',
    destination: 'Dwaraka Nagar',
    distance: 22,
    stops: ['Bheemunipatnam', 'Madhurawada', 'Kommadi', 'Rushikonda', 'Beach Road', 'Jagadamba Junction', 'Dwaraka Nagar'],
    active: true,
  },

  // ════════════════════════════════════════════════════════
  //  NEAR-CITY ROUTES — Vizag to nearby towns
  // ════════════════════════════════════════════════════════

  {
    id: 'route_017',
    routeId: 'route_017',
    routeName: 'RTC Complex to Anakapalle',
    source: 'RTC Complex',
    destination: 'Anakapalle',
    distance: 50,
    stops: ['RTC Complex', 'Gopalapatnam', 'Pendurthi', 'Atchutapuram', 'Anakapalle'],
    active: true,
  },
  {
    id: 'route_018',
    routeId: 'route_018',
    routeName: 'Anakapalle to RTC Complex',
    source: 'Anakapalle',
    destination: 'RTC Complex',
    distance: 50,
    stops: ['Anakapalle', 'Atchutapuram', 'Pendurthi', 'Gopalapatnam', 'RTC Complex'],
    active: true,
  },
  {
    id: 'route_019',
    routeId: 'route_019',
    routeName: 'RTC Complex to Bhimili',
    source: 'RTC Complex',
    destination: 'Bhimili',
    distance: 24,
    stops: ['RTC Complex', 'Beach Road', 'Rushikonda', 'Kommadi', 'Madhurawada', 'Bhimili'],
    active: true,
  },
  {
    id: 'route_020',
    routeId: 'route_020',
    routeName: 'Bhimili to RTC Complex',
    source: 'Bhimili',
    destination: 'RTC Complex',
    distance: 24,
    stops: ['Bhimili', 'Madhurawada', 'Kommadi', 'Rushikonda', 'Beach Road', 'RTC Complex'],
    active: true,
  },
  {
    id: 'route_021',
    routeId: 'route_021',
    routeName: 'Gajuwaka to Anakapalle',
    source: 'Gajuwaka',
    destination: 'Anakapalle',
    distance: 40,
    stops: ['Gajuwaka', 'NAD Junction', 'Gopalapatnam', 'Pendurthi', 'Atchutapuram', 'Anakapalle'],
    active: true,
  },

];

const buses = [];
routes.forEach((route) => {
  let startHour = 5 + Math.floor(Math.random() * 3);
  for (let b = 1; b <= 10; b++) {
    let currentHour = startHour + Math.floor(b * 1.5);
    let currentMinute = Math.random() > 0.5 ? 0 : 30;
    if (currentHour >= 24) currentHour = currentHour % 24;
    const departureTime = currentHour.toString().padStart(2, '0') + ':' + currentMinute.toString().padStart(2, '0');
    const arrivalHour = (currentHour + 1 + Math.floor(Math.random() * 2)) % 24;
    const arrivalTime = arrivalHour.toString().padStart(2, '0') + ':' + currentMinute.toString().padStart(2, '0');
    const busNumStr = (1000 + Math.floor(Math.random() * 9000)).toString();
    const busId = `${route.routeId}_bus_${b}`;
    buses.push({
      id: busId,
      busId: busId,
      busNumber: `AP39Z-${busNumStr}`,
      busType: Math.random() > 0.5 ? 'Ordinary' : 'Express',
      capacity: 40,
      routeId: route.routeId,
      departureTime: departureTime,
      arrivalTime: arrivalTime,
      fare: 30 + Math.floor(Math.random() * 30),
      active: true,
    });
  }
});

// ─── SEED ─────────────────────────────────────────────────────────────────────

async function seedCollection(collectionName, items) {
  console.log(`\nSeeding ${collectionName}...`);
  for (const item of items) {
    const { id, ...data } = item;
    await db.collection(collectionName).doc(id).set(data);
    console.log(`  ✓ ${id}`);
  }
}

async function main() {
  try {
    await seedCollection('routes', routes);
    await seedCollection('buses', buses);
    console.log('\nDone! All data added to Firestore.');
    process.exit(0);
  } catch (err) {
    console.error('\nError:', err.message);
    process.exit(1);
  }
}

main();
