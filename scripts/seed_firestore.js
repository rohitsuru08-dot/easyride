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

const buses = [

  // ── route_001: MVP Colony → Gajuwaka (15 km) ─────────────────────────────
  {
    id: 'bus_001', busId: 'bus_001', busNumber: 'AP39Z-1234',
    busType: 'Ordinary', capacity: 60, routeId: 'route_001',
    departureTime: '06:30', arrivalTime: '07:30', fare: 20, active: true,
  },
  {
    id: 'bus_002', busId: 'bus_002', busNumber: 'AP39Z-5678',
    busType: 'Express', capacity: 45, routeId: 'route_001',
    departureTime: '09:00', arrivalTime: '09:45', fare: 30, active: true,
  },
  {
    id: 'bus_003', busId: 'bus_003', busNumber: 'AP39Z-9012',
    busType: 'Ordinary', capacity: 60, routeId: 'route_001',
    departureTime: '17:30', arrivalTime: '18:30', fare: 20, active: true,
  },

  // ── route_002: Gajuwaka → MVP Colony (15 km) ─────────────────────────────
  {
    id: 'bus_004', busId: 'bus_004', busNumber: 'AP39Z-2211',
    busType: 'Ordinary', capacity: 60, routeId: 'route_002',
    departureTime: '07:00', arrivalTime: '08:00', fare: 20, active: true,
  },
  {
    id: 'bus_005', busId: 'bus_005', busNumber: 'AP39Z-4433',
    busType: 'Express', capacity: 45, routeId: 'route_002',
    departureTime: '18:00', arrivalTime: '18:45', fare: 30, active: true,
  },

  // ── route_003: RTC Complex → Steel Plant (14 km) ─────────────────────────
  {
    id: 'bus_006', busId: 'bus_006', busNumber: 'AP39W-1122',
    busType: 'Ordinary', capacity: 60, routeId: 'route_003',
    departureTime: '07:30', arrivalTime: '08:30', fare: 20, active: true,
  },
  {
    id: 'bus_007', busId: 'bus_007', busNumber: 'AP39W-3344',
    busType: 'Express', capacity: 45, routeId: 'route_003',
    departureTime: '17:00', arrivalTime: '17:50', fare: 25, active: true,
  },

  // ── route_004: Steel Plant → RTC Complex (14 km) ─────────────────────────
  {
    id: 'bus_008', busId: 'bus_008', busNumber: 'AP39W-5566',
    busType: 'Ordinary', capacity: 60, routeId: 'route_004',
    departureTime: '06:00', arrivalTime: '07:00', fare: 20, active: true,
  },
  {
    id: 'bus_009', busId: 'bus_009', busNumber: 'AP39W-7788',
    busType: 'Express', capacity: 45, routeId: 'route_004',
    departureTime: '16:30', arrivalTime: '17:20', fare: 25, active: true,
  },

  // ── route_005: RTC Complex → Bheemunipatnam (26 km) ──────────────────────
  {
    id: 'bus_010', busId: 'bus_010', busNumber: 'AP39Z-9900',
    busType: 'Ordinary', capacity: 60, routeId: 'route_005',
    departureTime: '08:00', arrivalTime: '09:15', fare: 35, active: true,
  },
  {
    id: 'bus_011', busId: 'bus_011', busNumber: 'AP39Z-1010',
    busType: 'Express', capacity: 45, routeId: 'route_005',
    departureTime: '14:00', arrivalTime: '15:00', fare: 45, active: true,
  },

  // ── route_006: Bheemunipatnam → RTC Complex (26 km) ──────────────────────
  {
    id: 'bus_012', busId: 'bus_012', busNumber: 'AP39Z-2020',
    busType: 'Ordinary', capacity: 60, routeId: 'route_006',
    departureTime: '06:30', arrivalTime: '07:45', fare: 35, active: true,
  },
  {
    id: 'bus_013', busId: 'bus_013', busNumber: 'AP39Z-3030',
    busType: 'Express', capacity: 45, routeId: 'route_006',
    departureTime: '17:30', arrivalTime: '18:30', fare: 45, active: true,
  },

  // ── route_007: RTC Complex → Kommadi (20 km) ─────────────────────────────
  {
    id: 'bus_014', busId: 'bus_014', busNumber: 'AP39W-4040',
    busType: 'Ordinary', capacity: 60, routeId: 'route_007',
    departureTime: '07:00', arrivalTime: '08:00', fare: 25, active: true,
  },
  {
    id: 'bus_015', busId: 'bus_015', busNumber: 'AP39W-5050',
    busType: 'Express', capacity: 45, routeId: 'route_007',
    departureTime: '16:00', arrivalTime: '16:50', fare: 35, active: true,
  },

  // ── route_008: Kommadi → RTC Complex (20 km) ─────────────────────────────
  {
    id: 'bus_016', busId: 'bus_016', busNumber: 'AP39W-6060',
    busType: 'Ordinary', capacity: 60, routeId: 'route_008',
    departureTime: '08:30', arrivalTime: '09:30', fare: 25, active: true,
  },
  {
    id: 'bus_017', busId: 'bus_017', busNumber: 'AP39W-7070',
    busType: 'Express', capacity: 45, routeId: 'route_008',
    departureTime: '18:00', arrivalTime: '18:50', fare: 35, active: true,
  },

  // ── route_009: Pendurthi → Gajuwaka (28 km) ──────────────────────────────
  {
    id: 'bus_018', busId: 'bus_018', busNumber: 'AP39X-1111',
    busType: 'Ordinary', capacity: 60, routeId: 'route_009',
    departureTime: '06:00', arrivalTime: '07:20', fare: 40, active: true,
  },
  {
    id: 'bus_019', busId: 'bus_019', busNumber: 'AP39X-2222',
    busType: 'Express', capacity: 45, routeId: 'route_009',
    departureTime: '09:00', arrivalTime: '10:05', fare: 50, active: true,
  },

  // ── route_010: Gajuwaka → Pendurthi (28 km) ──────────────────────────────
  {
    id: 'bus_020', busId: 'bus_020', busNumber: 'AP39X-3333',
    busType: 'Ordinary', capacity: 60, routeId: 'route_010',
    departureTime: '07:30', arrivalTime: '08:50', fare: 40, active: true,
  },
  {
    id: 'bus_021', busId: 'bus_021', busNumber: 'AP39X-4444',
    busType: 'Express', capacity: 45, routeId: 'route_010',
    departureTime: '17:00', arrivalTime: '18:05', fare: 50, active: true,
  },

  // ── route_011: MVP Colony → Steel Plant (22 km) ───────────────────────────
  {
    id: 'bus_022', busId: 'bus_022', busNumber: 'AP39Z-5555',
    busType: 'Ordinary', capacity: 60, routeId: 'route_011',
    departureTime: '07:00', arrivalTime: '08:10', fare: 30, active: true,
  },
  {
    id: 'bus_023', busId: 'bus_023', busNumber: 'AP39Z-6666',
    busType: 'Express', capacity: 45, routeId: 'route_011',
    departureTime: '16:00', arrivalTime: '17:00', fare: 40, active: true,
  },

  // ── route_012: Steel Plant → MVP Colony (22 km) ───────────────────────────
  {
    id: 'bus_024', busId: 'bus_024', busNumber: 'AP39Z-7777',
    busType: 'Ordinary', capacity: 60, routeId: 'route_012',
    departureTime: '08:00', arrivalTime: '09:10', fare: 30, active: true,
  },
  {
    id: 'bus_025', busId: 'bus_025', busNumber: 'AP39Z-8888',
    busType: 'Express', capacity: 45, routeId: 'route_012',
    departureTime: '17:30', arrivalTime: '18:30', fare: 40, active: true,
  },

  // ── route_013: RTC Complex → Simhachalam (18 km) ─────────────────────────
  {
    id: 'bus_026', busId: 'bus_026', busNumber: 'AP39X-5555',
    busType: 'Ordinary', capacity: 60, routeId: 'route_013',
    departureTime: '06:00', arrivalTime: '06:55', fare: 20, active: true,
  },
  {
    id: 'bus_027', busId: 'bus_027', busNumber: 'AP39X-6666',
    busType: 'Express', capacity: 45, routeId: 'route_013',
    departureTime: '14:30', arrivalTime: '15:15', fare: 30, active: true,
  },

  // ── route_014: Simhachalam → RTC Complex (18 km) ─────────────────────────
  {
    id: 'bus_028', busId: 'bus_028', busNumber: 'AP39X-7777',
    busType: 'Ordinary', capacity: 60, routeId: 'route_014',
    departureTime: '07:00', arrivalTime: '07:55', fare: 20, active: true,
  },
  {
    id: 'bus_029', busId: 'bus_029', busNumber: 'AP39X-8888',
    busType: 'Express', capacity: 45, routeId: 'route_014',
    departureTime: '16:00', arrivalTime: '16:45', fare: 30, active: true,
  },

  // ── route_015: Dwaraka Nagar → Bheemunipatnam (22 km) ────────────────────
  {
    id: 'bus_030', busId: 'bus_030', busNumber: 'AP39W-8080',
    busType: 'Ordinary', capacity: 60, routeId: 'route_015',
    departureTime: '08:00', arrivalTime: '09:05', fare: 30, active: true,
  },
  {
    id: 'bus_031', busId: 'bus_031', busNumber: 'AP39W-9090',
    busType: 'Express', capacity: 45, routeId: 'route_015',
    departureTime: '15:00', arrivalTime: '15:55', fare: 40, active: true,
  },

  // ── route_016: Bheemunipatnam → Dwaraka Nagar (22 km) ────────────────────
  {
    id: 'bus_032', busId: 'bus_032', busNumber: 'AP39W-1234',
    busType: 'Ordinary', capacity: 60, routeId: 'route_016',
    departureTime: '07:00', arrivalTime: '08:05', fare: 30, active: true,
  },
  {
    id: 'bus_033', busId: 'bus_033', busNumber: 'AP39W-5678',
    busType: 'Express', capacity: 45, routeId: 'route_016',
    departureTime: '17:00', arrivalTime: '17:55', fare: 40, active: true,
  },

  // ── route_017: RTC Complex → Anakapalle (50 km) ───────────────────────────
  {
    id: 'bus_034', busId: 'bus_034', busNumber: 'AP39V-1111',
    busType: 'Ordinary', capacity: 55, routeId: 'route_017',
    departureTime: '07:00', arrivalTime: '08:30', fare: 60, active: true,
  },
  {
    id: 'bus_035', busId: 'bus_035', busNumber: 'AP39V-2222',
    busType: 'Express', capacity: 45, routeId: 'route_017',
    departureTime: '13:00', arrivalTime: '14:15', fare: 80, active: true,
  },

  // ── route_018: Anakapalle → RTC Complex (50 km) ───────────────────────────
  {
    id: 'bus_036', busId: 'bus_036', busNumber: 'AP39V-3333',
    busType: 'Ordinary', capacity: 55, routeId: 'route_018',
    departureTime: '06:00', arrivalTime: '07:30', fare: 60, active: true,
  },
  {
    id: 'bus_037', busId: 'bus_037', busNumber: 'AP39V-4444',
    busType: 'Express', capacity: 45, routeId: 'route_018',
    departureTime: '17:00', arrivalTime: '18:15', fare: 80, active: true,
  },

  // ── route_019: RTC Complex → Bhimili (24 km) ─────────────────────────────
  {
    id: 'bus_038', busId: 'bus_038', busNumber: 'AP39Z-0011',
    busType: 'Ordinary', capacity: 60, routeId: 'route_019',
    departureTime: '08:30', arrivalTime: '09:35', fare: 30, active: true,
  },
  {
    id: 'bus_039', busId: 'bus_039', busNumber: 'AP39Z-0022',
    busType: 'Express', capacity: 45, routeId: 'route_019',
    departureTime: '14:00', arrivalTime: '14:55', fare: 40, active: true,
  },

  // ── route_020: Bhimili → RTC Complex (24 km) ─────────────────────────────
  {
    id: 'bus_040', busId: 'bus_040', busNumber: 'AP39Z-0033',
    busType: 'Ordinary', capacity: 60, routeId: 'route_020',
    departureTime: '07:00', arrivalTime: '08:05', fare: 30, active: true,
  },
  {
    id: 'bus_041', busId: 'bus_041', busNumber: 'AP39Z-0044',
    busType: 'Express', capacity: 45, routeId: 'route_020',
    departureTime: '17:00', arrivalTime: '17:55', fare: 40, active: true,
  },

  // ── route_021: Gajuwaka → Anakapalle (40 km) ─────────────────────────────
  {
    id: 'bus_042', busId: 'bus_042', busNumber: 'AP39X-9999',
    busType: 'Ordinary', capacity: 55, routeId: 'route_021',
    departureTime: '07:30', arrivalTime: '08:45', fare: 50, active: true,
  },
  {
    id: 'bus_043', busId: 'bus_043', busNumber: 'AP39X-0001',
    busType: 'Express', capacity: 45, routeId: 'route_021',
    departureTime: '16:00', arrivalTime: '17:05', fare: 65, active: true,
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
