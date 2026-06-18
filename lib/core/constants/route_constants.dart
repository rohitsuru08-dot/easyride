// Route name constants for navigation
class RouteConstants {
  // Auth Routes
  static const String splash = '/';
  static const String login = '/login';
  static const String otpVerification = '/otp-verification';
  
  // Passenger Routes
  static const String passengerHome = '/passenger/home';
  static const String busList = '/passenger/bus-list';
  static const String bookingSummary = '/passenger/booking-summary';
  static const String qrTicket = '/passenger/qr-ticket';
  static const String myTickets = '/passenger/my-tickets';
  
  // Conductor Routes
  static const String conductorDashboard = '/conductor/dashboard';
  static const String qrScanner = '/conductor/qr-scanner';
  static const String ticketVerification = '/conductor/ticket-verification';
  static const String manualTicket = '/conductor/manual-ticket';
  
  // Admin Routes
  static const String adminDashboard = '/admin/dashboard';
  static const String routeAnalytics = '/admin/route-analytics';
  static const String ticketlessMonitor = '/admin/ticketless-monitor';
}
