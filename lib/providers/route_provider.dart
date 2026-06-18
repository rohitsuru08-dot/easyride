// Route and bus provider for managing routes and bus schedules
import 'package:flutter/foundation.dart';
import 'package:easy_ride/models/route_model.dart';
import 'package:easy_ride/models/bus_model.dart';
import 'package:easy_ride/services/firebase_service.dart';

class RouteProvider with ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  
  List<RouteModel> _routes = [];
  List<BusModel> _buses = [];
  List<BusModel> _searchResults = [];
  RouteModel? _selectedRoute;
  BusModel? _selectedBus;
  bool _isLoading = false;
  String? _errorMessage;

  // Search parameters
  String? _selectedSource;
  String? _selectedDestination;
  DateTime? _selectedDate;

  List<RouteModel> get routes => _routes;
  List<BusModel> get buses => _buses;
  List<BusModel> get searchResults => _searchResults;
  RouteModel? get selectedRoute => _selectedRoute;
  BusModel? get selectedBus => _selectedBus;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get selectedSource => _selectedSource;
  String? get selectedDestination => _selectedDestination;
  DateTime? get selectedDate => _selectedDate;

  // Load all routes
  Future<void> loadRoutes() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _routes = await _firebaseService.getRoutes();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Get all unique sources from routes
  List<String> get allSources {
    return _routes.map((route) => route.source).toSet().toList()..sort();
  }

  // Get all unique destinations from routes
  List<String> get allDestinations {
    return _routes.map((route) => route.destination).toSet().toList()..sort();
  }

  // Get destinations for selected source
  List<String> getDestinationsForSource(String source) {
    return _routes
        .where((route) => route.source == source)
        .map((route) => route.destination)
        .toSet()
        .toList()
      ..sort();
  }

  // Set search parameters — clears stale results so UI never shows
  // buses from a previous search while the user picks new criteria.
  void setSearchParameters({
    String? source,
    String? destination,
    DateTime? date,
  }) {
    _selectedSource = source;
    _selectedDestination = destination;
    _selectedDate = date;
    _searchResults = [];
    notifyListeners();
  }

  // Search buses by source and destination
  Future<void> searchBuses(String source, String destination) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      _searchResults = [];
      notifyListeners();

      _searchResults = await _firebaseService.searchBuses(source, destination);

      // Sort by departure time
      _searchResults.sort((a, b) => a.departureTime.compareTo(b.departureTime));

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Select a bus
  void selectBus(BusModel bus) {
    _selectedBus = bus;
    notifyListeners();
  }

  // Clear selection
  void clearSelection() {
    _selectedBus = null;
    _selectedRoute = null;
    notifyListeners();
  }

  // Clear search results
  void clearSearchResults() {
    _searchResults = [];
    _selectedSource = null;
    _selectedDestination = null;
    _selectedDate = null;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
