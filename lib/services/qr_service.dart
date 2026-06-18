// QR code generation and validation service
import 'dart:convert';
import 'package:easy_ride/models/ticket_model.dart';

class QRService {
  // Generate QR data string from ticket
  static String generateQRData(TicketModel ticket) {
    final qrData = {
      'ticketId': ticket.ticketId,
      'passengerName': ticket.passengerName,
      'source': ticket.source,
      'destination': ticket.destination,
      'fare': ticket.fare,
      'busType': ticket.busType,
      'busNumber': ticket.busNumber,
      'departureTime': ticket.departureTime,
      'arrivalTime': ticket.arrivalTime,
      'journeyDate': ticket.journeyDate.toIso8601String(),
      'status': ticket.status,
    };

    // Convert to JSON string for QR code
    return jsonEncode(qrData);
  }

  // Parse QR data string to map
  static Map<String, dynamic>? parseQRData(String qrData) {
    try {
      return jsonDecode(qrData) as Map<String, dynamic>;
    } catch (e) {
      // Invalid QR data
      return null;
    }
  }

  // Validate QR data
  static bool validateQRData(String qrData) {
    try {
      final data = parseQRData(qrData);
      if (data == null) return false;

      // Check if all required fields are present
      final requiredFields = [
        'ticketId',
        'passengerName',
        'source',
        'destination',
        'fare',
        'busType',
        'busNumber',
        'departureTime',
        'arrivalTime',
        'journeyDate',
        'status',
      ];

      for (final field in requiredFields) {
        if (!data.containsKey(field)) {
          return false;
        }
      }

      // Check if journey date is valid (not expired)
      final journeyDate = DateTime.parse(data['journeyDate']);
      final today = DateTime.now();
      final todayDate = DateTime(today.year, today.month, today.day);
      final journeyDateOnly = DateTime(
        journeyDate.year,
        journeyDate.month,
        journeyDate.day,
      );

      // Ticket should not be expired (allow same day)
      if (journeyDateOnly.isBefore(todayDate)) {
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  // Get ticket ID from QR data
  static String? getTicketIdFromQR(String qrData) {
    try {
      final data = parseQRData(qrData);
      return data?['ticketId'];
    } catch (e) {
      return null;
    }
  }

  // Check if ticket is valid for today
  static bool isValidForToday(String qrData) {
    try {
      final data = parseQRData(qrData);
      if (data == null) return false;

      final journeyDate = DateTime.parse(data['journeyDate']);
      final today = DateTime.now();

      return journeyDate.year == today.year &&
          journeyDate.month == today.month &&
          journeyDate.day == today.day;
    } catch (e) {
      return false;
    }
  }

  // Get verification message
  static String getVerificationMessage(String qrData) {
    if (!validateQRData(qrData)) {
      return 'Invalid or expired ticket';
    }

    if (!isValidForToday(qrData)) {
      return 'Ticket not valid for today';
    }

    return 'Valid ticket';
  }

  // Create ticket display info from QR data
  static Map<String, String> getTicketInfo(String qrData) {
    try {
      final data = parseQRData(qrData);
      if (data == null) return {};

      return {
        'Ticket ID': data['ticketId'] ?? 'N/A',
        'Passenger': data['passengerName'] ?? 'N/A',
        'Route': '${data['source']} → ${data['destination']}',
        'Bus': '${data['busType']} (${data['busNumber']})',
        'Departure': data['departureTime'] ?? 'N/A',
        'Arrival': data['arrivalTime'] ?? 'N/A',
        'Fare': '₹${data['fare']}',
        'Status': data['status'] ?? 'N/A',
      };
    } catch (e) {
      return {};
    }
  }
}
