// Firebase Firestore service for CRUD operations
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_ride/core/constants/firestore_constants.dart';
import 'package:easy_ride/models/user_model.dart';
import 'package:easy_ride/models/ticket_model.dart';
import 'package:easy_ride/models/route_model.dart';
import 'package:easy_ride/models/bus_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ============ USER OPERATIONS ============

  // Create or update user
  Future<void> saveUser(UserModel user) async {
    try {
      await _firestore
          .collection(FirestoreConstants.usersCollection)
          .doc(user.userId)
          .set(user.toMap());
    } catch (e) {
      throw Exception('Failed to save user: $e');
    }
  }

  // Get user by ID
  Future<UserModel?> getUser(String userId) async {
    try {
      final doc = await _firestore
          .collection(FirestoreConstants.usersCollection)
          .doc(userId)
          .get();

      if (doc.exists) {
        return UserModel.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  // Update user language
  Future<void> updateUserLanguage(String userId, String language) async {
    try {
      await _firestore
          .collection(FirestoreConstants.usersCollection)
          .doc(userId)
          .update({'language': language});
    } catch (e) {
      throw Exception('Failed to update language: $e');
    }
  }

  // ============ TICKET OPERATIONS ============

  // Create new ticket — use ticketId as document ID so getTicket/verifyTicket
  // can look it up directly with .doc(ticketId).
  Future<String> createTicket(TicketModel ticket) async {
    try {
      await _firestore
          .collection(FirestoreConstants.ticketsCollection)
          .doc(ticket.ticketId)
          .set(ticket.toMap());
      return ticket.ticketId;
    } catch (e) {
      throw Exception('Failed to create ticket: $e');
    }
  }

  // Get ticket by ID
  Future<TicketModel?> getTicket(String ticketId) async {
    try {
      final doc = await _firestore
          .collection(FirestoreConstants.ticketsCollection)
          .doc(ticketId)
          .get();

      if (doc.exists) {
        return TicketModel.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get ticket: $e');
    }
  }

  // Get user's tickets — no orderBy so no composite index is required;
  // sorting is done client-side after fetch.
  Future<List<TicketModel>> getUserTickets(String userId, {bool upcomingOnly = false}) async {
    try {
      // ignore: avoid_print
      print('[FirebaseService] getUserTickets — querying passengerId == "$userId"');
      Query query = _firestore
          .collection(FirestoreConstants.ticketsCollection)
          .where(FirestoreConstants.ticketPassengerId, isEqualTo: userId);

      final snapshot = await query.get();
      // ignore: avoid_print
      print('[FirebaseService] getUserTickets — got ${snapshot.docs.length} doc(s)');
      for (final doc in snapshot.docs) {
        // ignore: avoid_print
        print('[FirebaseService]   doc ${doc.id}: passengerId=${doc.data()}');
      }
      final tickets = snapshot.docs
          .map((doc) => TicketModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      if (upcomingOnly) {
        final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
        tickets.retainWhere((t) => !t.journeyDate.isBefore(today));
      }

      // Sort newest journey date first
      tickets.sort((a, b) => b.journeyDate.compareTo(a.journeyDate));
      return tickets;
    } catch (e) {
      throw Exception('Failed to get user tickets: $e');
    }
  }

  // Verify ticket
  Future<void> verifyTicket(String ticketId, String conductorId) async {
    try {
      await _firestore
          .collection(FirestoreConstants.ticketsCollection)
          .doc(ticketId)
          .update({
        FirestoreConstants.ticketVerified: true,
        FirestoreConstants.ticketVerifiedBy: conductorId,
        FirestoreConstants.ticketVerifiedAt: Timestamp.now(),
        FirestoreConstants.ticketStatus: FirestoreConstants.statusVerified,
      });
    } catch (e) {
      throw Exception('Failed to verify ticket: $e');
    }
  }

  // Get all tickets verified by a specific conductor
  Future<List<TicketModel>> getTicketsByConductor(String conductorId) async {
    try {
      final snapshot = await _firestore
          .collection(FirestoreConstants.ticketsCollection)
          .where(FirestoreConstants.ticketVerifiedBy, isEqualTo: conductorId)
          .get();

      return snapshot.docs
          .map((doc) => TicketModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get tickets for conductor: $e');
    }
  }

  // Get unverified tickets
  Future<List<TicketModel>> getUnverifiedTickets() async {
    try {
      final snapshot = await _firestore
          .collection(FirestoreConstants.ticketsCollection)
          .where('verified', isEqualTo: false)
          .where('status', isEqualTo: 'booked')
          .get();

      return snapshot.docs
          .map((doc) => TicketModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get unverified tickets: $e');
    }
  }

  // ============ ROUTE OPERATIONS ============

  // Get all active routes
  Future<List<RouteModel>> getRoutes() async {
    try {
      final snapshot = await _firestore
          .collection(FirestoreConstants.routesCollection)
          .where(FirestoreConstants.routeActive, isEqualTo: true)
          .get();

      return snapshot.docs
          .map((doc) => RouteModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to get routes: $e');
    }
  }

  // Get route by ID
  Future<RouteModel?> getRoute(String routeId) async {
    try {
      final doc = await _firestore
          .collection(FirestoreConstants.routesCollection)
          .doc(routeId)
          .get();

      if (doc.exists) {
        return RouteModel.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get route: $e');
    }
  }

  // ============ BUS OPERATIONS ============

  // Get buses by route
  Future<List<BusModel>> getBusesByRoute(String routeId) async {
    try {
      final snapshot = await _firestore
          .collection(FirestoreConstants.busesCollection)
          .where(FirestoreConstants.busRouteId, isEqualTo: routeId)
          .where(FirestoreConstants.busActive, isEqualTo: true)
          .get();

      return snapshot.docs
          .map((doc) => BusModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to get buses: $e');
    }
  }

  // Search buses by source and destination
  Future<List<BusModel>> searchBuses(String source, String destination) async {
    try {
      // First, get routes matching source and destination
      final routesSnapshot = await _firestore
          .collection(FirestoreConstants.routesCollection)
          .where(FirestoreConstants.routeSource, isEqualTo: source)
          .where(FirestoreConstants.routeDestination, isEqualTo: destination)
          .where(FirestoreConstants.routeActive, isEqualTo: true)
          .get();

      if (routesSnapshot.docs.isEmpty) {
        return [];
      }

      // Get all buses for the matching routes
      final routeIds = routesSnapshot.docs.map((doc) => doc.id).toList();
      final List<BusModel> allBuses = [];

      for (final routeId in routeIds) {
        final buses = await getBusesByRoute(routeId);
        allBuses.addAll(buses);
      }

      return allBuses;
    } catch (e) {
      throw Exception('Failed to search buses: $e');
    }
  }

  // ============ ANALYTICS OPERATIONS ============

  // Get total ticket count
  Future<int> getTotalTicketCount() async {
    try {
      final snapshot = await _firestore
          .collection(FirestoreConstants.ticketsCollection)
          .count()
          .get();
      return snapshot.count ?? 0;
    } catch (e) {
      return 0;
    }
  }

  // Get total verified ticket count
  Future<int> getTotalVerifiedTicketCount() async {
    try {
      final snapshot = await _firestore
          .collection(FirestoreConstants.ticketsCollection)
          .where('verified', isEqualTo: true)
          .count()
          .get();
      return snapshot.count ?? 0;
    } catch (e) {
      return 0;
    }
  }


  // Get total revenue
  Future<double> getTotalRevenue() async {
    try {
      final snapshot = await _firestore
          .collection(FirestoreConstants.ticketsCollection)
          .get();

      double total = 0;
      for (final doc in snapshot.docs) {
        final data = doc.data();
        total += (data[FirestoreConstants.ticketFare] ?? 0).toDouble();
      }
      return total;
    } catch (e) {
      return 0;
    }
  }

  // Get tickets for today — fetches all and filters client-side to avoid
  // needing a Firestore range-query index.
  Future<List<TicketModel>> getTodayTickets() async {
    try {
      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final snapshot = await _firestore
          .collection(FirestoreConstants.ticketsCollection)
          .get();

      return snapshot.docs
          .map((doc) => TicketModel.fromMap(doc.data()))
          .where((t) =>
              !t.journeyDate.isBefore(startOfDay) &&
              t.journeyDate.isBefore(endOfDay),)
          .toList();
    } catch (e) {
      throw Exception('Failed to get today\'s tickets: $e');
    }
  }
}
