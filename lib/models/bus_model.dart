// Bus model with Firestore serialization
class BusModel {
  final String busId;
  final String busNumber;
  final String busType; // 'Express', 'Ordinary', 'Super Luxury', 'Metro Deluxe'
  final int capacity;
  final String routeId;
  final String departureTime; // Format: HH:mm
  final String arrivalTime; // Format: HH:mm
  final double fare;
  final bool active;

  BusModel({
    required this.busId,
    required this.busNumber,
    required this.busType,
    required this.capacity,
    required this.routeId,
    required this.departureTime,
    required this.arrivalTime,
    required this.fare,
    this.active = true,
  });

  // Create BusModel from Firestore document
  factory BusModel.fromMap(Map<String, dynamic> map) {
    return BusModel(
      busId: map['busId'] ?? '',
      busNumber: map['busNumber'] ?? '',
      busType: map['busType'] ?? '',
      capacity: map['capacity'] ?? 0,
      routeId: map['routeId'] ?? '',
      departureTime: map['departureTime'] ?? '',
      arrivalTime: map['arrivalTime'] ?? '',
      fare: (map['fare'] ?? 0).toDouble(),
      active: map['active'] ?? true,
    );
  }

  // Convert BusModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'busId': busId,
      'busNumber': busNumber,
      'busType': busType,
      'capacity': capacity,
      'routeId': routeId,
      'departureTime': departureTime,
      'arrivalTime': arrivalTime,
      'fare': fare,
      'active': active,
    };
  }

  // Create a copy with updated fields
  BusModel copyWith({
    String? busId,
    String? busNumber,
    String? busType,
    int? capacity,
    String? routeId,
    String? departureTime,
    String? arrivalTime,
    double? fare,
    bool? active,
  }) {
    return BusModel(
      busId: busId ?? this.busId,
      busNumber: busNumber ?? this.busNumber,
      busType: busType ?? this.busType,
      capacity: capacity ?? this.capacity,
      routeId: routeId ?? this.routeId,
      departureTime: departureTime ?? this.departureTime,
      arrivalTime: arrivalTime ?? this.arrivalTime,
      fare: fare ?? this.fare,
      active: active ?? this.active,
    );
  }

  @override
  String toString() {
    return 'BusModel(busId: $busId, busNumber: $busNumber, busType: $busType, fare: $fare)';
  }
}
