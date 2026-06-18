import 'package:flutter/foundation.dart';
import 'package:easy_ride/models/ticket_model.dart';
import 'package:easy_ride/services/firebase_service.dart';
import 'package:easy_ride/services/qr_service.dart';
import 'package:easy_ride/services/local_storage_service.dart';

class ConductorProvider with ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();

  List<TicketModel> _verifiedTickets = [];
  TicketModel? _currentTicket;
  bool _isLoading = false;
  String? _errorMessage;
  bool _statsLoaded = false;

  int _totalPassengers = 0;
  double _totalRevenue = 0.0;
  int _ticketsVerifiedCount = 0;

  List<TicketModel> get verifiedTickets => _verifiedTickets;
  TicketModel? get currentTicket => _currentTicket;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get totalPassengers => _totalPassengers;
  double get totalRevenue => _totalRevenue;
  int get ticketsVerifiedCount => _ticketsVerifiedCount;

  // ─── Load stats from Firestore ─────────────────────────────────────────────
  //
  // Passenger app bookings should be immediately reflected here.
  // • totalPassengers = ALL tickets booked/created for today.
  // • totalRevenue    = Total fare of ALL tickets for today.
  // • ticketsVerifiedCount = Only tickets successfully scanned/verified by this conductor.
  Future<void> loadStats({String conductorId = ''}) async {
    if (_statsLoaded) return;

    if (conductorId.isEmpty) {
      final stats = await LocalStorageService.loadConductorStats();
      _totalPassengers = stats['passengers'] as int;
      _totalRevenue = stats['revenue'] as double;
      _ticketsVerifiedCount = stats['verified'] as int;
      _statsLoaded = true;
      notifyListeners();
      return;
    }

    try {
      // 1) Fetch ALL tickets for today (includes both booked and verified)
      final allTodayTickets = await _firebaseService.getTodayTickets();

      int passengers = 0;
      double revenue = 0.0;
      int verifiedCount = 0;

      for (final ticket in allTodayTickets) {
        // Every ticket booked for today counts as a passenger and revenue
        passengers++;
        revenue += ticket.fare;

        // Only tickets verified by this conductor count towards the verified stat
        if (ticket.verified == true && ticket.verifiedBy == conductorId) {
          verifiedCount++;
        }
      }

      _totalPassengers = passengers;
      _totalRevenue = revenue;
      _ticketsVerifiedCount = verifiedCount;
      _statsLoaded = true;

      await _saveStats();
      notifyListeners();
    } catch (_) {
      final stats = await LocalStorageService.loadConductorStats();
      _totalPassengers = stats['passengers'] as int;
      _totalRevenue = stats['revenue'] as double;
      _ticketsVerifiedCount = stats['verified'] as int;
      _statsLoaded = true;
      notifyListeners();
    }
  }

  Future<void> refreshStats({required String conductorId}) async {
    _statsLoaded = false;
    await loadStats(conductorId: conductorId);
  }

  Future<void> _saveStats() async {
    await LocalStorageService.saveConductorStats(
      totalPassengers: _totalPassengers,
      totalRevenue: _totalRevenue,
      ticketsVerified: _ticketsVerifiedCount,
    );
  }

  // ─── Scan and verify ticket from QR code ─────────────────────────────────
  //
  // Since the ticket was already counted in passengers & revenue when it
  // was booked, scanning it now ONLY increments the verified count.
  Future<bool> verifyTicketFromQR(String qrData, String conductorId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      if (!QRService.validateQRData(qrData)) {
        _errorMessage = 'Invalid or expired ticket';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      if (!QRService.isValidForToday(qrData)) {
        _errorMessage = 'Ticket not valid for today';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final ticketId = QRService.getTicketIdFromQR(qrData);
      if (ticketId == null) {
        _errorMessage = 'Invalid ticket ID';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final alreadyVerified = await LocalStorageService.isTicketVerified(ticketId);
      if (alreadyVerified) {
        _errorMessage = 'Ticket already verified';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final ticket = await _firebaseService.getTicket(ticketId);
      if (ticket == null) {
        _errorMessage = 'Ticket not found';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      if (ticket.verified) {
        _errorMessage = 'Ticket already verified';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Verify the ticket in Firestore
      await _firebaseService.verifyTicket(ticketId, conductorId);
      await LocalStorageService.saveVerifiedTicket(ticketId);

      _currentTicket = ticket.copyWith(verified: true, verifiedBy: conductorId);
      _verifiedTickets.add(_currentTicket!);

      // Refresh stats to include the newly verified ticket and any recently booked tickets
      await refreshStats(conductorId: conductorId);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // ─── Generate manual ticket (cash payment) ───────────────────────────────
  //
  // A manual ticket is a brand-new passenger who didn't book online.
  // Because this is a new ticket being created, it increments ALL three stats.
  Future<TicketModel?> generateManualTicket({
    required String conductorId,
    required String source,
    required String destination,
    required double fare,
    required String busType,
    required String busNumber,
    required String routeId,
    required String departureTime,
    required String arrivalTime,
    String passengerType = 'Adult',
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final ticketId = 'BMT${DateTime.now().millisecondsSinceEpoch}';

      final ticket = TicketModel(
        ticketId: ticketId,
        passengerName: 'Walk-in Passenger',
        passengerId: conductorId,
        source: source,
        destination: destination,
        fare: fare,
        busType: busType,
        busNumber: busNumber,
        routeId: routeId,
        departureTime: departureTime,
        arrivalTime: arrivalTime,
        bookingTime: DateTime.now(),
        journeyDate: DateTime.now(),
        passengerType: passengerType,
        paymentMode: 'Cash',
        verified: true,
        verifiedBy: conductorId,
        verifiedAt: DateTime.now(),
      );

      // Save new ticket to Firestore
      await _firebaseService.createTicket(ticket);

      _currentTicket = ticket;
      _verifiedTickets.add(ticket);

      // New walk-in passenger → increment all three counters
      _totalPassengers++;
      _totalRevenue += fare;
      _ticketsVerifiedCount++;
      await _saveStats();

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

  Future<void> resetTripStatistics() async {
    _verifiedTickets = [];
    _currentTicket = null;
    _totalPassengers = 0;
    _totalRevenue = 0.0;
    _ticketsVerifiedCount = 0;
    await LocalStorageService.clearConductorStats();
    notifyListeners();
  }

  void setCurrentTicket(TicketModel? ticket) {
    _currentTicket = ticket;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
