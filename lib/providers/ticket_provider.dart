// Ticket provider for managing ticket bookings and history
import 'package:flutter/foundation.dart';
import 'package:easy_ride/models/ticket_model.dart';
import 'package:easy_ride/models/bus_model.dart';
import 'package:easy_ride/services/firebase_service.dart';
import 'package:easy_ride/services/local_storage_service.dart';

class TicketProvider with ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  
  List<TicketModel> _tickets = [];
  List<TicketModel> _upcomingTickets = [];
  List<TicketModel> _historyTickets = [];
  TicketModel? _currentTicket;
  bool _isLoading = false;
  String? _errorMessage;

  List<TicketModel> get tickets => _tickets;
  List<TicketModel> get upcomingTickets => _upcomingTickets;
  List<TicketModel> get historyTickets => _historyTickets;
  TicketModel? get currentTicket => _currentTicket;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _categorizeTickets() {
    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    _upcomingTickets = _tickets.where((t) {
      final d = DateTime(t.journeyDate.year, t.journeyDate.month, t.journeyDate.day);
      return !d.isBefore(today) && !t.verified;
    }).toList();
    _historyTickets = _tickets.where((t) {
      final d = DateTime(t.journeyDate.year, t.journeyDate.month, t.journeyDate.day);
      return d.isBefore(today) || t.verified;
    }).toList();
  }

  // Load user tickets
  Future<void> loadUserTickets(String userId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _tickets = await _firebaseService.getUserTickets(userId);
      _categorizeTickets();

      // Cache tickets for offline access
      await LocalStorageService.cacheTickets(_tickets);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      // ignore: avoid_print
      print('[TicketProvider] loadUserTickets error: $e');

      // Try to load from cache
      await loadCachedTickets();
      notifyListeners();
    }
  }

  // Book a ticket
  Future<TicketModel?> bookTicket({
    required String passengerId,
    required String passengerName,
    required BusModel bus,
    required String source,
    required String destination,
    required DateTime journeyDate,
    String passengerType = 'Adult',
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Generate ticket ID (timestamp-based)
      final ticketId = 'BMT${DateTime.now().millisecondsSinceEpoch}';

      final ticket = TicketModel(
        ticketId: ticketId,
        passengerName: passengerName,
        passengerId: passengerId,
        source: source,
        destination: destination,
        fare: bus.fare,
        busType: bus.busType,
        busNumber: bus.busNumber,
        routeId: bus.routeId,
        departureTime: bus.departureTime,
        arrivalTime: bus.arrivalTime,
        bookingTime: DateTime.now(),
        journeyDate: journeyDate,
        passengerType: passengerType,
        paymentMode: 'Online',
      );

      await _firebaseService.createTicket(ticket);
      _currentTicket = ticket;

      // Add directly to local state — avoids a second Firestore round-trip
      // that can fail independently and leave tickets appearing blank.
      _tickets = [ticket, ..._tickets];
      _categorizeTickets();

      _isLoading = false;
      notifyListeners();

      return ticket;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return null;
    }
  }

  // Load cached tickets (offline fallback)
  Future<void> loadCachedTickets() async {
    try {
      _tickets = await LocalStorageService.getCachedTickets();
      _categorizeTickets();
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load cached tickets';
    }
  }

  // Set current ticket (for viewing QR)
  void setCurrentTicket(TicketModel? ticket) {
    _currentTicket = ticket;
    notifyListeners();
  }

  // Get ticket by ID
  Future<TicketModel?> getTicket(String ticketId) async {
    try {
      return await _firebaseService.getTicket(ticketId);
    } catch (e) {
      _errorMessage = e.toString();
      return null;
    }
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Clear tickets
  void clearTickets() {
    _tickets = [];
    _upcomingTickets = [];
    _historyTickets = [];
    _currentTicket = null;
    notifyListeners();
  }
}
