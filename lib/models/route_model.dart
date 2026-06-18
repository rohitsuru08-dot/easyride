// Route model with Firestore serialization
class RouteModel {
  final String routeId;
  final String routeName;
  final String source;
  final String destination;
  final double distance; // in kilometers
  final List<String> stops; // List of stop names
  final bool active;

  RouteModel({
    required this.routeId,
    required this.routeName,
    required this.source,
    required this.destination,
    required this.distance,
    required this.stops,
    this.active = true,
  });

  // Create RouteModel from Firestore document
  factory RouteModel.fromMap(Map<String, dynamic> map) {
    return RouteModel(
      routeId: map['routeId'] ?? '',
      routeName: map['routeName'] ?? '',
      source: map['source'] ?? '',
      destination: map['destination'] ?? '',
      distance: (map['distance'] ?? 0).toDouble(),
      stops: List<String>.from(map['stops'] ?? []),
      active: map['active'] ?? true,
    );
  }

  // Convert RouteModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'routeId': routeId,
      'routeName': routeName,
      'source': source,
      'destination': destination,
      'distance': distance,
      'stops': stops,
      'active': active,
    };
  }

  // Create a copy with updated fields
  RouteModel copyWith({
    String? routeId,
    String? routeName,
    String? source,
    String? destination,
    double? distance,
    List<String>? stops,
    bool? active,
  }) {
    return RouteModel(
      routeId: routeId ?? this.routeId,
      routeName: routeName ?? this.routeName,
      source: source ?? this.source,
      destination: destination ?? this.destination,
      distance: distance ?? this.distance,
      stops: stops ?? this.stops,
      active: active ?? this.active,
    );
  }

  @override
  String toString() {
    return 'RouteModel(routeId: $routeId, routeName: $routeName, source: $source, destination: $destination)';
  }
}
