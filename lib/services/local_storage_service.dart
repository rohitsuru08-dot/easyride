// Local storage service using SharedPreferences
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_ride/models/ticket_model.dart';

class LocalStorageService {
  static const String _keyLanguage = 'language';
  static const String _keyUserId = 'user_id';
  static const String _keyUserRole = 'user_role';
  static const String _keyUserName = 'user_name';
  static const String _keyUserPhone = 'user_phone';
  static const String _keyCachedTickets = 'cached_tickets';
  static const String _keyVerifiedTickets = 'verified_tickets';
  static const String _keyIsFirstTime = 'is_first_time';

  // Get SharedPreferences instance
  static Future<SharedPreferences> get _prefs async {
    return await SharedPreferences.getInstance();
  }

  // ============ LANGUAGE SETTINGS ============

  // Save language preference
  static Future<void> saveLanguage(String language) async {
    final prefs = await _prefs;
    await prefs.setString(_keyLanguage, language);
  }

  // Get language preference
  static Future<String> getLanguage() async {
    final prefs = await _prefs;
    return prefs.getString(_keyLanguage) ?? 'en';
  }

  // ============ USER DATA ============

  // Save user data
  static Future<void> saveUserData({
    required String userId,
    required String role,
    required String name,
    required String phone,
  }) async {
    final prefs = await _prefs;
    await prefs.setString(_keyUserId, userId);
    await prefs.setString(_keyUserRole, role);
    await prefs.setString(_keyUserName, name);
    await prefs.setString(_keyUserPhone, phone);
  }

  // Get user ID
  static Future<String?> getUserId() async {
    final prefs = await _prefs;
    return prefs.getString(_keyUserId);
  }

  // Get user role
  static Future<String?> getUserRole() async {
    final prefs = await _prefs;
    return prefs.getString(_keyUserRole);
  }

  // Get user name
  static Future<String?> getUserName() async {
    final prefs = await _prefs;
    return prefs.getString(_keyUserName);
  }

  // Get user phone
  static Future<String?> getUserPhone() async {
    final prefs = await _prefs;
    return prefs.getString(_keyUserPhone);
  }

  // Clear user data (logout)
  static Future<void> clearUserData() async {
    final prefs = await _prefs;
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyUserRole);
    await prefs.remove(_keyUserName);
    await prefs.remove(_keyUserPhone);
  }

  // ============ TICKET CACHING ============

  // Cache tickets for offline access
  static Future<void> cacheTickets(List<TicketModel> tickets) async {
    try {
      final prefs = await _prefs;
      final ticketMaps = tickets.map((ticket) => ticket.toLocalJson()).toList();
      final jsonString = jsonEncode(ticketMaps);
      await prefs.setString(_keyCachedTickets, jsonString);
    } catch (e) {
      // Silently fail if caching fails
    }
  }

  // Get cached tickets
  static Future<List<TicketModel>> getCachedTickets() async {
    try {
      final prefs = await _prefs;
      final jsonString = prefs.getString(_keyCachedTickets);

      if (jsonString == null) return [];

      final List<dynamic> ticketMaps = jsonDecode(jsonString);
      return ticketMaps
          .map((map) => TicketModel.fromLocalJson(map as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // ============ CONDUCTOR OFFLINE VERIFICATION ============

  // Save verified ticket (for offline conductor use)
  static Future<void> saveVerifiedTicket(String ticketId) async {
    try {
      final prefs = await _prefs;
      final verifiedTickets = await getVerifiedTickets();
      
      if (!verifiedTickets.contains(ticketId)) {
        verifiedTickets.add(ticketId);
        await prefs.setStringList(_keyVerifiedTickets, verifiedTickets);
      }
    } catch (e) {
      // Silently fail
    }
  }

  // Get list of verified tickets
  static Future<List<String>> getVerifiedTickets() async {
    final prefs = await _prefs;
    return prefs.getStringList(_keyVerifiedTickets) ?? [];
  }

  // Check if ticket is already verified offline
  static Future<bool> isTicketVerified(String ticketId) async {
    final verifiedTickets = await getVerifiedTickets();
    return verifiedTickets.contains(ticketId);
  }

  // Clear verified tickets cache
  static Future<void> clearVerifiedTickets() async {
    final prefs = await _prefs;
    await prefs.remove(_keyVerifiedTickets);
  }

  // ============ APP STATE ============

  // Check if first time user
  static Future<bool> isFirstTime() async {
    final prefs = await _prefs;
    return prefs.getBool(_keyIsFirstTime) ?? true;
  }

  // Set first time flag
  static Future<void> setNotFirstTime() async {
    final prefs = await _prefs;
    await prefs.setBool(_keyIsFirstTime, false);
  }

  // ============ CONDUCTOR TRIP STATISTICS ============

  static const String _keyConductorPassengers = 'conductor_total_passengers';
  static const String _keyConductorRevenue = 'conductor_total_revenue';
  static const String _keyConductorVerified = 'conductor_tickets_verified';
  static const String _keyConductorDate = 'conductor_stats_date';

  /// Save trip stats and the date they belong to (auto-resets on new day).
  static Future<void> saveConductorStats({
    required int totalPassengers,
    required double totalRevenue,
    required int ticketsVerified,
  }) async {
    try {
      final prefs = await _prefs;
      final today = DateTime.now().toIso8601String().substring(0, 10);
      await prefs.setInt(_keyConductorPassengers, totalPassengers);
      await prefs.setDouble(_keyConductorRevenue, totalRevenue);
      await prefs.setInt(_keyConductorVerified, ticketsVerified);
      await prefs.setString(_keyConductorDate, today);
    } catch (_) {}
  }

  /// Load today's trip stats. Returns zeros if it's a new day or no data.
  static Future<Map<String, dynamic>> loadConductorStats() async {
    try {
      final prefs = await _prefs;
      final today = DateTime.now().toIso8601String().substring(0, 10);
      final savedDate = prefs.getString(_keyConductorDate);

      // Auto-reset on new day
      if (savedDate != today) {
        await clearConductorStats();
        return {'passengers': 0, 'revenue': 0.0, 'verified': 0};
      }

      return {
        'passengers': prefs.getInt(_keyConductorPassengers) ?? 0,
        'revenue': prefs.getDouble(_keyConductorRevenue) ?? 0.0,
        'verified': prefs.getInt(_keyConductorVerified) ?? 0,
      };
    } catch (_) {
      return {'passengers': 0, 'revenue': 0.0, 'verified': 0};
    }
  }

  /// Clear conductor trip stats (called on manual reset or new-day auto-reset).
  static Future<void> clearConductorStats() async {
    final prefs = await _prefs;
    await prefs.remove(_keyConductorPassengers);
    await prefs.remove(_keyConductorRevenue);
    await prefs.remove(_keyConductorVerified);
    await prefs.remove(_keyConductorDate);
  }

  static Future<void> clearAll() async {
    final prefs = await _prefs;
    await prefs.clear();
  }

  // Clear cache only (keep user data)
  static Future<void> clearCache() async {
    final prefs = await _prefs;
    await prefs.remove(_keyCachedTickets);
    await prefs.remove(_keyVerifiedTickets);
  }
}

