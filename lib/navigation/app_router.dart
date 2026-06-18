// App routing configuration
import 'package:flutter/material.dart';
import 'package:easy_ride/core/constants/route_constants.dart';
import 'package:easy_ride/screens/auth/splash_screen.dart';
import 'package:easy_ride/screens/auth/login_screen.dart';
import 'package:easy_ride/screens/auth/otp_verification_screen.dart';
import 'package:easy_ride/screens/passenger/home_screen.dart';
import 'package:easy_ride/screens/passenger/bus_list_screen.dart';
import 'package:easy_ride/screens/passenger/booking_summary_screen.dart';
import 'package:easy_ride/screens/passenger/qr_ticket_screen.dart';
import 'package:easy_ride/screens/passenger/my_tickets_screen.dart';
import 'package:easy_ride/screens/conductor/dashboard_screen.dart';
import 'package:easy_ride/screens/conductor/qr_scanner_screen.dart';
import 'package:easy_ride/screens/conductor/ticket_verification_screen.dart';
import 'package:easy_ride/screens/conductor/manual_ticket_screen.dart';
import 'package:easy_ride/screens/admin/dashboard_screen.dart';
import 'package:easy_ride/screens/admin/route_analytics_screen.dart';
import 'package:easy_ride/screens/admin/ticketless_monitor_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // Auth routes
      case RouteConstants.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case RouteConstants.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case RouteConstants.otpVerification:
        final phoneNumber = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => OtpVerificationScreen(phoneNumber: phoneNumber),
        );

      // Passenger routes
      case RouteConstants.passengerHome:
        return MaterialPageRoute(builder: (_) => const PassengerHomeScreen());

      case RouteConstants.busList:
        return MaterialPageRoute(builder: (_) => const BusListScreen());

      case RouteConstants.bookingSummary:
        return MaterialPageRoute(builder: (_) => const BookingSummaryScreen());

      case RouteConstants.qrTicket:
        return MaterialPageRoute(builder: (_) => const QRTicketScreen());

      case RouteConstants.myTickets:
        return MaterialPageRoute(builder: (_) => const MyTicketsScreen());

      // Conductor routes
      case RouteConstants.conductorDashboard:
        return MaterialPageRoute(
            builder: (_) => const ConductorDashboardScreen());

      case RouteConstants.qrScanner:
        return MaterialPageRoute(builder: (_) => const QRScannerScreen());

      case RouteConstants.ticketVerification:
        return MaterialPageRoute(
            builder: (_) => const TicketVerificationScreen());

      case RouteConstants.manualTicket:
        return MaterialPageRoute(builder: (_) => const ManualTicketScreen());

      // Admin routes
      case RouteConstants.adminDashboard:
        return MaterialPageRoute(builder: (_) => const AdminDashboardScreen());

      case RouteConstants.routeAnalytics:
        return MaterialPageRoute(builder: (_) => const RouteAnalyticsScreen());

      case RouteConstants.ticketlessMonitor:
        return MaterialPageRoute(
            builder: (_) => const TicketlessMonitorScreen());

      // Default route
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
