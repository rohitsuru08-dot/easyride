import 'dart:math';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_ride/core/constants/firestore_constants.dart';
import 'package:easy_ride/models/route_model.dart';
import 'package:easy_ride/models/bus_model.dart';

class DataSeeder {
  static Future<void> seed() async {
    print('--- Starting Data Seeder ---');
    final firestore = FirebaseFirestore.instance;
    final random = Random();

    // 1. Delete existing routes and buses
    print('Deleting existing data...');
    var routesSnap = await firestore.collection(FirestoreConstants.routesCollection).get();
    var batch = firestore.batch();
    int batchCount = 0;
    
    for (var doc in routesSnap.docs) {
      batch.delete(doc.reference);
      batchCount++;
      if (batchCount >= 400) {
        await batch.commit();
        batch = firestore.batch();
        batchCount = 0;
      }
    }
    
    var busesSnap = await firestore.collection(FirestoreConstants.busesCollection).get();
    for (var doc in busesSnap.docs) {
      batch.delete(doc.reference);
      batchCount++;
      if (batchCount >= 400) {
        await batch.commit();
        batch = firestore.batch();
        batchCount = 0;
      }
    }
    if (batchCount > 0) {
      await batch.commit();
    }

    // 2. Read routes.csv to get fares
    print('Reading routes.csv...');
    final routesCsvString = await rootBundle.loadString('assets/data/routes.csv');
    final routesLines = routesCsvString.split('\n');
    
    final Map<String, double> routeFares = {};
    for (int i = 1; i < routesLines.length; i++) {
      final line = routesLines[i];
      if (line.trim().isEmpty) continue;
      final parts = line.split(',');
      if (parts.length >= 5) {
        final routeNo = parts[0].trim();
        final fare = double.tryParse(parts[4].trim()) ?? 0.0;
        routeFares[routeNo] = fare;
      }
    }

    // 3. Read routes1.csv to create routes
    print('Reading routes1.csv...');
    final routes1CsvString = await rootBundle.loadString('assets/data/routes1.csv');
    final routes1Lines = routes1CsvString.split('\n');
    
    final List<RouteModel> createdRoutes = [];
    final Map<String, RouteModel> routeMap = {}; // routeNo -> RouteModel

    for (int i = 1; i < routes1Lines.length; i++) {
      final line = routes1Lines[i];
      if (line.trim().isEmpty) continue;
      final parts = line.split(',');
      if (parts.length >= 3) {
        final routeNo = parts[0].trim();
        final source = parts[1].trim();
        final destination = parts[2].trim();
        
        final routeId = routeNo;
        final routeName = '$source - $destination';
        
        final route = RouteModel(
          routeId: routeId,
          routeName: routeName,
          source: source,
          destination: destination,
          distance: 15.0, // Default distance
          stops: [source, destination], // Default stops
          active: true,
        );
        
        createdRoutes.add(route);
        routeMap[routeNo] = route;
      }
    }

    print('Uploading ${createdRoutes.length} routes...');
    batch = firestore.batch();
    batchCount = 0;
    for (var route in createdRoutes) {
      batch.set(
        firestore.collection(FirestoreConstants.routesCollection).doc(route.routeId),
        route.toMap(),
      );
      batchCount++;
      if (batchCount >= 400) {
        await batch.commit();
        batch = firestore.batch();
        batchCount = 0;
      }
    }
    if (batchCount > 0) {
      await batch.commit();
    }

    // 4. Generate 10 buses for each route with time gaps
    print('Generating 10 buses per route...');
    int busesCreated = 0;
    batch = firestore.batch();
    batchCount = 0;
    
    for (var route in createdRoutes) {
      final fare = routeFares[route.routeId] ?? 30.0;
      final int numBuses = 10;
      
      // Start time between 5 AM and 7 AM
      int currentHour = 5 + random.nextInt(3); 
      int currentMinute = random.nextBool() ? 0 : 30;
      
      for (int b = 0; b < numBuses; b++) {
        // Time gap of 1 to 2 hours between buses
        if (b > 0) {
          currentHour += 1 + random.nextInt(2);
          if (random.nextBool()) currentMinute = (currentMinute + 30) % 60;
          if (currentHour >= 24) currentHour = currentHour % 24;
        }
        
        String departureTime = '${currentHour.toString().padLeft(2, '0')}:${currentMinute.toString().padLeft(2, '0')}';
        
        // Arrival time is 1 to 2 hours after departure
        int arrivalHour = (currentHour + 1 + random.nextInt(2)) % 24;
        String arrivalTime = '${arrivalHour.toString().padLeft(2, '0')}:${currentMinute.toString().padLeft(2, '0')}';
        
        final randomNum = 1000 + random.nextInt(9000);
        final busNumber = 'AP 31 Z $randomNum';
        
        final safeRouteNo = route.routeId.replaceAll('/', '-');
        final busId = '${safeRouteNo}_${departureTime.replaceAll(':', '')}';
        
        final bus = BusModel(
          busId: busId,
          busNumber: busNumber,
          busType: 'Ordinary',
          capacity: 40,
          routeId: route.routeId,
          departureTime: departureTime,
          arrivalTime: arrivalTime,
          fare: fare,
          active: true,
        );
        
        batch.set(
          firestore.collection(FirestoreConstants.busesCollection).doc(busId),
          bus.toMap(),
        );
        batchCount++;
        busesCreated++;
        
        if (batchCount >= 400) {
          await batch.commit();
          batch = firestore.batch();
          batchCount = 0;
        }
      }
    }
    
    if (batchCount > 0) {
      await batch.commit();
    }
    
    print('Created $busesCreated buses.');
    print('--- Data Seeder Completed ---');
  }
}
