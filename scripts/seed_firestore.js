const admin = require('firebase-admin');
const serviceAccount = require('./serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

// ─── DATA ────────────────────────────────────────────────────────────────────

const routes = [
  {
    id: 'route_001',
    routeId: 'route_001',
    routeName: 'MVP Colony to Gajuwaka',
    source: 'MVP Colony',
    destination: 'Gajuwaka',
    distance: 15,
    stops: ['MVP Colony', 'Madhurawada', 'Rushikonda', 'Gajuwaka'],
    active: true,
  },
  {
    id: 'route_002',
    routeId: 'route_002',
    routeName: 'Visakhapatnam to Vijayawada',
    source: 'Visakhapatnam',
    destination: 'Vijayawada',
    distance: 352,
    stops: ['Visakhapatnam', 'Rajam', 'Srikakulam', 'Vijayawada'],
    active: true,
  },
  {
    id: 'route_003',
    routeId: 'route_003',
    routeName: 'Vijayawada to Tirupati',
    source: 'Vijayawada',
    destination: 'Tirupati',
    distance: 280,
    stops: ['Vijayawada', 'Guntur', 'Ongole', 'Nellore', 'Tirupati'],
    active: true,
  },
  {
    id: 'route_004',
    routeId: 'route_004',
    routeName: 'Gajuwaka to MVP Colony',
    source: 'Gajuwaka',
    destination: 'MVP Colony',
    distance: 15,
    stops: ['Gajuwaka', 'Rushikonda', 'Madhurawada', 'MVP Colony'],
    active: true,
  },
];

const buses = [
  {
    id: 'bus_001',
    busId: 'bus_001',
    busNumber: 'AP31Z-1234',
    busType: 'Express',
    capacity: 45,
    routeId: 'route_001',
    departureTime: '07:00',
    arrivalTime: '08:00',
    fare: 30,
    active: true,
  },
  {
    id: 'bus_002',
    busId: 'bus_002',
    busNumber: 'AP31Z-5678',
    busType: 'Ordinary',
    capacity: 60,
    routeId: 'route_001',
    departureTime: '09:30',
    arrivalTime: '10:30',
    fare: 20,
    active: true,
  },
  {
    id: 'bus_003',
    busId: 'bus_003',
    busNumber: 'AP39X-4321',
    busType: 'Super Luxury',
    capacity: 40,
    routeId: 'route_002',
    departureTime: '06:00',
    arrivalTime: '12:00',
    fare: 550,
    active: true,
  },
  {
    id: 'bus_004',
    busId: 'bus_004',
    busNumber: 'AP39X-8899',
    busType: 'Express',
    capacity: 55,
    routeId: 'route_002',
    departureTime: '22:00',
    arrivalTime: '04:00',
    fare: 400,
    active: true,
  },
  {
    id: 'bus_005',
    busId: 'bus_005',
    busNumber: 'AP16W-7777',
    busType: 'Metro Deluxe',
    capacity: 45,
    routeId: 'route_003',
    departureTime: '08:00',
    arrivalTime: '14:00',
    fare: 480,
    active: true,
  },
  {
    id: 'bus_006',
    busId: 'bus_006',
    busNumber: 'AP31Z-3322',
    busType: 'Ordinary',
    capacity: 60,
    routeId: 'route_004',
    departureTime: '08:00',
    arrivalTime: '09:00',
    fare: 20,
    active: true,
  },
];

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
