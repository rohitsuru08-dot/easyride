// Firestore collection and field name constants
class FirestoreConstants {
  // Collection Names
  static const String usersCollection = 'users';
  static const String ticketsCollection = 'tickets';
  static const String routesCollection = 'routes';
  static const String busesCollection = 'buses';
  static const String tripsCollection = 'trips';
  static const String analyticsCollection = 'analytics';
  
  // User Fields
  static const String userId = 'userId';
  static const String userName = 'name';
  static const String userPhone = 'phone';
  static const String userRole = 'role';
  static const String userCreatedAt = 'createdAt';
  static const String userLanguage = 'language';
  
  // Ticket Fields
  static const String ticketId = 'ticketId';
  static const String ticketPassengerName = 'passengerName';
  static const String ticketPassengerId = 'passengerId';
  static const String ticketSource = 'source';
  static const String ticketDestination = 'destination';
  static const String ticketFare = 'fare';
  static const String ticketBusType = 'busType';
  static const String ticketBusNumber = 'busNumber';
  static const String ticketRouteId = 'routeId';
  static const String ticketDepartureTime = 'departureTime';
  static const String ticketArrivalTime = 'arrivalTime';
  static const String ticketBookingTime = 'bookingTime';
  static const String ticketJourneyDate = 'journeyDate';
  static const String ticketStatus = 'status';
  static const String ticketVerified = 'verified';
  static const String ticketVerifiedBy = 'verifiedBy';
  static const String ticketVerifiedAt = 'verifiedAt';
  static const String ticketPassengerType = 'passengerType';
  static const String ticketPaymentMode = 'paymentMode';
  
  // Route Fields
  static const String routeId = 'routeId';
  static const String routeName = 'routeName';
  static const String routeSource = 'source';
  static const String routeDestination = 'destination';
  static const String routeDistance = 'distance';
  static const String routeStops = 'stops';
  static const String routeActive = 'active';
  
  // Bus Fields
  static const String busId = 'busId';
  static const String busNumber = 'busNumber';
  static const String busType = 'busType';
  static const String busCapacity = 'capacity';
  static const String busRouteId = 'routeId';
  static const String busDepartureTime = 'departureTime';
  static const String busArrivalTime = 'arrivalTime';
  static const String busActive = 'active';
  
  // User Roles
  static const String rolePassenger = 'passenger';
  static const String roleConductor = 'conductor';
  static const String roleAdmin = 'admin';
  
  // Ticket Status
  static const String statusBooked = 'booked';
  static const String statusVerified = 'verified';
  static const String statusCancelled = 'cancelled';
  static const String statusExpired = 'expired';
  
  // Bus Types
  static const String busTypeExpress = 'Express';
  static const String busTypeOrdinary = 'Ordinary';
  static const String busTypeSuperLuxury = 'Super Luxury';
  static const String busTypeMetroDeluxe = 'Metro Deluxe';
  
  // Passenger Types
  static const String passengerTypeAdult = 'Adult';
  static const String passengerTypeChild = 'Child';
  static const String passengerTypeSenior = 'Senior Citizen';
  
  // Payment Modes
  static const String paymentModeOnline = 'Online';
  static const String paymentModeCash = 'Cash';
}
