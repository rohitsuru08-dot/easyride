// Admin provider for managing analytics and dashboard data
import 'package:flutter/foundation.dart';
import 'package:easy_ride/models/ticket_model.dart';
import 'package:easy_ride/services/firebase_service.dart';

class AdminProvider with ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  
  // Dashboard statistics
  int _totalTickets = 0;
  double _totalRevenue = 0.0;
  int _totalPassengers = 0;
  int _totalTrips = 0;
  
  // Today's data
  List<TicketModel> _todayTickets = [];
  int _todayPassengers = 0;
  double _todayRevenue = 0.0;
  
  // Route analytics
  Map<String, int> _routeTicketCount = {};
  Map<String, double> _routeRevenue = {};
  
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  int get totalTickets => _totalTickets;
  double get totalRevenue => _totalRevenue;
  int get totalPassengers => _totalPassengers;
  int get totalTrips => _totalTrips;
  List<TicketModel> get todayTickets => _todayTickets;
  int get todayPassengers => _todayPassengers;
  double get todayRevenue => _todayRevenue;
  Map<String, int> get routeTicketCount => _routeTicketCount;
  Map<String, double> get routeRevenue => _routeRevenue;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Load dashboard statistics
  Future<void> loadDashboardStats() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Load total statistics
      _totalTickets = await _firebaseService.getTotalTicketCount();
      _totalRevenue = await _firebaseService.getTotalRevenue();
      _totalPassengers = _totalTickets; // Assuming 1 ticket = 1 passenger
      _totalTrips = (_totalTickets / 30).ceil(); // Estimated trips

      // Load today's tickets
      _todayTickets = await _firebaseService.getTodayTickets();
      _todayPassengers = _todayTickets.length;
      _todayRevenue = _todayTickets.fold(0.0, (sum, ticket) => sum + ticket.fare);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Load route analytics
  Future<void> loadRouteAnalytics() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Get all tickets
      final todayTickets = await _firebaseService.getTodayTickets();

      // Calculate route-wise statistics
      _routeTicketCount = {};
      _routeRevenue = {};

      for (final ticket in todayTickets) {
        final routeKey = '${ticket.source} → ${ticket.destination}';
        
        _routeTicketCount[routeKey] = (_routeTicketCount[routeKey] ?? 0) + 1;
        _routeRevenue[routeKey] = (_routeRevenue[routeKey] ?? 0.0) + ticket.fare;
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Get top performing routes
  List<MapEntry<String, int>> getTopRoutes({int limit = 5}) {
    final sortedRoutes = _routeTicketCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sortedRoutes.take(limit).toList();
  }

  // Get route revenue sorted
  List<MapEntry<String, double>> getTopRevenueRoutes({int limit = 5}) {
    final sortedRoutes = _routeRevenue.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sortedRoutes.take(limit).toList();
  }

  // Get peak hours (mock data for MVP)
  Map<String, int> getPeakHours() {
    // This is mock data - in production, analyze ticket departure times
    return {
      '06:00-09:00': (_todayPassengers * 0.25).round(),
      '09:00-12:00': (_todayPassengers * 0.15).round(),
      '12:00-15:00': (_todayPassengers * 0.10).round(),
      '15:00-18:00': (_todayPassengers * 0.20).round(),
      '18:00-21:00': (_todayPassengers * 0.25).round(),
      '21:00-00:00': (_todayPassengers * 0.05).round(),
    };
  }

  // Get ticketless travel detection (mock data for MVP)
  Map<String, dynamic> getTicketlessDetection() {
    // Mock data - in production, this would come from conductor reports
    return {
      'highRiskRoutes': [
        {'route': 'Visakhapatnam → Bhimavaram', 'riskPercentage': 12},
        {'route': 'Vijayawada → Guntur', 'riskPercentage': 8},
        {'route': 'Tirupati → Chennai', 'riskPercentage': 15},
      ],
      'averageDetectionRate': 8.5,
      'totalReported': (_todayTickets.length * 0.08).round(),
    };
  }

  // Refresh all data
  Future<void> refreshAllData() async {
    await Future.wait([
      loadDashboardStats(),
      loadRouteAnalytics(),
    ]);
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
