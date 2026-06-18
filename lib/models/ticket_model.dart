// Ticket model with Firestore serialization
import 'package:cloud_firestore/cloud_firestore.dart';

class TicketModel {
  final String ticketId;
  final String passengerName;
  final String passengerId;
  final String source;
  final String destination;
  final double fare;
  final String busType;
  final String busNumber;
  final String routeId;
  final String departureTime; // Format: HH:mm
  final String arrivalTime; // Format: HH:mm
  final DateTime bookingTime;
  final DateTime journeyDate;
  final String status; // 'booked', 'verified', 'cancelled', 'expired'
  final bool verified;
  final String? verifiedBy;
  final DateTime? verifiedAt;
  final String passengerType; // 'Adult', 'Child', 'Senior Citizen'
  final String paymentMode; // 'Online', 'Cash'

  TicketModel({
    required this.ticketId,
    required this.passengerName,
    required this.passengerId,
    required this.source,
    required this.destination,
    required this.fare,
    required this.busType,
    required this.busNumber,
    required this.routeId,
    required this.departureTime,
    required this.arrivalTime,
    required this.bookingTime,
    required this.journeyDate,
    this.status = 'booked',
    this.verified = false,
    this.verifiedBy,
    this.verifiedAt,
    this.passengerType = 'Adult',
    this.paymentMode = 'Online',
  });

  // Create TicketModel from Firestore document
  factory TicketModel.fromMap(Map<String, dynamic> map) {
    return TicketModel(
      ticketId: map['ticketId'] ?? '',
      passengerName: map['passengerName'] ?? '',
      passengerId: map['passengerId'] ?? '',
      source: map['source'] ?? '',
      destination: map['destination'] ?? '',
      fare: (map['fare'] ?? 0).toDouble(),
      busType: map['busType'] ?? '',
      busNumber: map['busNumber'] ?? '',
      routeId: map['routeId'] ?? '',
      departureTime: map['departureTime'] ?? '',
      arrivalTime: map['arrivalTime'] ?? '',
      bookingTime: (map['bookingTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      journeyDate: (map['journeyDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      status: map['status'] ?? 'booked',
      verified: map['verified'] ?? false,
      verifiedBy: map['verifiedBy'],
      verifiedAt: (map['verifiedAt'] as Timestamp?)?.toDate(),
      passengerType: map['passengerType'] ?? 'Adult',
      paymentMode: map['paymentMode'] ?? 'Online',
    );
  }

  // Convert TicketModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'ticketId': ticketId,
      'passengerName': passengerName,
      'passengerId': passengerId,
      'source': source,
      'destination': destination,
      'fare': fare,
      'busType': busType,
      'busNumber': busNumber,
      'routeId': routeId,
      'departureTime': departureTime,
      'arrivalTime': arrivalTime,
      'bookingTime': Timestamp.fromDate(bookingTime),
      'journeyDate': Timestamp.fromDate(journeyDate),
      'status': status,
      'verified': verified,
      'verifiedBy': verifiedBy,
      'verifiedAt': verifiedAt != null ? Timestamp.fromDate(verifiedAt!) : null,
      'passengerType': passengerType,
      'paymentMode': paymentMode,
    };
  }

  // Create a copy with updated fields
  TicketModel copyWith({
    String? ticketId,
    String? passengerName,
    String? passengerId,
    String? source,
    String? destination,
    double? fare,
    String? busType,
    String? busNumber,
    String? routeId,
    String? departureTime,
    String? arrivalTime,
    DateTime? bookingTime,
    DateTime? journeyDate,
    String? status,
    bool? verified,
    String? verifiedBy,
    DateTime? verifiedAt,
    String? passengerType,
    String? paymentMode,
  }) {
    return TicketModel(
      ticketId: ticketId ?? this.ticketId,
      passengerName: passengerName ?? this.passengerName,
      passengerId: passengerId ?? this.passengerId,
      source: source ?? this.source,
      destination: destination ?? this.destination,
      fare: fare ?? this.fare,
      busType: busType ?? this.busType,
      busNumber: busNumber ?? this.busNumber,
      routeId: routeId ?? this.routeId,
      departureTime: departureTime ?? this.departureTime,
      arrivalTime: arrivalTime ?? this.arrivalTime,
      bookingTime: bookingTime ?? this.bookingTime,
      journeyDate: journeyDate ?? this.journeyDate,
      status: status ?? this.status,
      verified: verified ?? this.verified,
      verifiedBy: verifiedBy ?? this.verifiedBy,
      verifiedAt: verifiedAt ?? this.verifiedAt,
      passengerType: passengerType ?? this.passengerType,
      paymentMode: paymentMode ?? this.paymentMode,
    );
  }

  Map<String, dynamic> toLocalJson() {
    return {
      'ticketId': ticketId,
      'passengerName': passengerName,
      'passengerId': passengerId,
      'source': source,
      'destination': destination,
      'fare': fare,
      'busType': busType,
      'busNumber': busNumber,
      'routeId': routeId,
      'departureTime': departureTime,
      'arrivalTime': arrivalTime,
      'bookingTime': bookingTime.toIso8601String(),
      'journeyDate': journeyDate.toIso8601String(),
      'status': status,
      'verified': verified,
      'verifiedBy': verifiedBy,
      'verifiedAt': verifiedAt?.toIso8601String(),
      'passengerType': passengerType,
      'paymentMode': paymentMode,
    };
  }

  factory TicketModel.fromLocalJson(Map<String, dynamic> map) {
    return TicketModel(
      ticketId: map['ticketId'] ?? '',
      passengerName: map['passengerName'] ?? '',
      passengerId: map['passengerId'] ?? '',
      source: map['source'] ?? '',
      destination: map['destination'] ?? '',
      fare: (map['fare'] ?? 0).toDouble(),
      busType: map['busType'] ?? '',
      busNumber: map['busNumber'] ?? '',
      routeId: map['routeId'] ?? '',
      departureTime: map['departureTime'] ?? '',
      arrivalTime: map['arrivalTime'] ?? '',
      bookingTime: map['bookingTime'] != null
          ? DateTime.parse(map['bookingTime'] as String)
          : DateTime.now(),
      journeyDate: map['journeyDate'] != null
          ? DateTime.parse(map['journeyDate'] as String)
          : DateTime.now(),
      status: map['status'] ?? 'booked',
      verified: map['verified'] ?? false,
      verifiedBy: map['verifiedBy'],
      verifiedAt: map['verifiedAt'] != null
          ? DateTime.parse(map['verifiedAt'] as String)
          : null,
      passengerType: map['passengerType'] ?? 'Adult',
      paymentMode: map['paymentMode'] ?? 'Online',
    );
  }

  @override
  String toString() {
    return 'TicketModel(ticketId: $ticketId, source: $source, destination: $destination, fare: $fare)';
  }
}
