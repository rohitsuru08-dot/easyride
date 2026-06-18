// Date and time formatting utility functions
import 'package:intl/intl.dart';

class DateTimeHelper {
  // Format date to 'dd MMM yyyy' (e.g., 17 May 2025)
  static String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }
  
  // Format time to 'hh:mm a' (e.g., 08:00 AM)
  static String formatTime(DateTime time) {
    return DateFormat('hh:mm a').format(time);
  }
  
  // Format date and time to 'dd MMM yyyy, hh:mm a' (e.g., 17 May 2025, 08:00 AM)
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
  }
  
  // Format time from string (HH:mm) to readable format
  static String formatTimeString(String timeString) {
    try {
      final parts = timeString.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      final time = DateTime(2000, 1, 1, hour, minute);
      return formatTime(time);
    } catch (e) {
      return timeString;
    }
  }
  
  // Calculate journey duration
  static String calculateDuration(String departureTime, String arrivalTime) {
    try {
      final depParts = departureTime.split(':');
      final arrParts = arrivalTime.split(':');
      
      final depHour = int.parse(depParts[0]);
      final depMinute = int.parse(depParts[1]);
      final arrHour = int.parse(arrParts[0]);
      final arrMinute = int.parse(arrParts[1]);
      
      final depDateTime = DateTime(2000, 1, 1, depHour, depMinute);
      var arrDateTime = DateTime(2000, 1, 1, arrHour, arrMinute);
      
      // Handle next day arrival
      if (arrDateTime.isBefore(depDateTime)) {
        arrDateTime = arrDateTime.add(const Duration(days: 1));
      }
      
      final duration = arrDateTime.difference(depDateTime);
      final hours = duration.inHours;
      final minutes = duration.inMinutes % 60;
      
      if (hours > 0) {
        return '${hours}h ${minutes}m';
      } else {
        return '${minutes}m';
      }
    } catch (e) {
      return 'N/A';
    }
  }
  
  // Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && 
           date.month == now.month && 
           date.day == now.day;
  }
  
  // Check if date is in the past
  static bool isPast(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final checkDate = DateTime(date.year, date.month, date.day);
    return checkDate.isBefore(today);
  }
}
