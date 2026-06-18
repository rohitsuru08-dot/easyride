// Booking summary and confirmation screen — Premium dark design with timeline view
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_ride/core/constants/app_constants.dart';
import 'package:easy_ride/core/constants/route_constants.dart';
import 'package:easy_ride/core/theme/app_design_system.dart';
import 'package:easy_ride/core/utils/date_time_helper.dart';
import 'package:easy_ride/providers/route_provider.dart';
import 'package:easy_ride/providers/ticket_provider.dart';
import 'package:easy_ride/providers/user_provider.dart';
import 'package:easy_ride/localization/localization_service.dart';
import 'package:easy_ride/widgets/design_system.dart';
import 'package:easy_ride/widgets/glass/glass_components.dart';
import 'package:easy_ride/widgets/common/message_dialog.dart';

class BookingSummaryScreen extends StatefulWidget {
  const BookingSummaryScreen({Key? key}) : super(key: key);

  @override
  State<BookingSummaryScreen> createState() => _BookingSummaryScreenState();
}

class _BookingSummaryScreenState extends State<BookingSummaryScreen>
    with SingleTickerProviderStateMixin {
  String _selectedPassengerType = 'Adult';
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideUp;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
    _fadeIn = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _confirmBooking() async {
    final routeProvider = Provider.of<RouteProvider>(context, listen: false);
    final ticketProvider = Provider.of<TicketProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (routeProvider.selectedBus == null ||
        routeProvider.selectedSource == null ||
        routeProvider.selectedDestination == null ||
        routeProvider.selectedDate == null) {
      MessageDialog.showError(context, message: 'Invalid booking details');
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.liquidCyan),
          ),
        ),
      ),
    );

    final ticket = await ticketProvider.bookTicket(
      passengerId: userProvider.currentUser!.userId,
      passengerName: userProvider.currentUser!.name,
      bus: routeProvider.selectedBus!,
      source: routeProvider.selectedSource!,
      destination: routeProvider.selectedDestination!,
      journeyDate: routeProvider.selectedDate!,
      passengerType: _selectedPassengerType,
    );

    if (!mounted) return;
    Navigator.of(context).pop(); // Close loading dialog

    if (ticket != null) {
      MessageDialog.showSuccess(
        context,
        title: 'booking_confirmed'.tr(context),
        message: 'your_ticket_is_ready'.tr(context),
        onClose: () {
          Navigator.of(context).pushReplacementNamed(
            RouteConstants.qrTicket,
          );
        },
      );
    } else {
      MessageDialog.showError(
        context,
        message: ticketProvider.errorMessage ?? 'booking_failed'.tr(context),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final routeProvider = Provider.of<RouteProvider>(context);
    final bus = routeProvider.selectedBus;

    if (bus == null) {
      return Scaffold(
        backgroundColor: AppColors.bgPrimary,
        appBar: ModernAppBar(title: 'booking_summary'.tr(context)),
        body: const Center(child: Text('No bus selected')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: ModernAppBar(
        title: 'booking_summary'.tr(context),
        height: 64,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F172A), Color(0xFF080812)],
          ),
        ),
        child: FadeTransition(
          opacity: _fadeIn,
          child: SlideTransition(
            position: _slideUp,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Journey timeline card
                        _buildJourneyTimeline(routeProvider, bus),
                        const SizedBox(height: 16),

                        // Bus details card
                        _buildBusDetailsCard(bus),
                        const SizedBox(height: 16),

                        // Passenger type
                        _buildPassengerTypeCard(),
                        const SizedBox(height: 16),

                        // Fare summary
                        _buildFareCard(bus),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),

                // Bottom CTA
                _buildBottomBar(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required IconData icon,
      required Color accentColor, required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF192134),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: accentColor, size: 18),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: AppTypography.titleSmall.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Container(height: 1, color: Colors.white.withValues(alpha: 0.05)),
          Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildJourneyTimeline(RouteProvider routeProvider, dynamic bus) {
    return _buildSectionCard(
      title: 'Trip Details',
      icon: Icons.route_rounded,
      accentColor: AppColors.liquidCyan,
      child: Column(
        children: [
          // From → To visual
          Row(
            children: [
              // From column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateTimeHelper.formatTimeString(bus.departureTime),
                      style: AppTypography.titleLarge.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.trip_origin_rounded,
                            color: AppColors.liquidCyan, size: 12),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            routeProvider.selectedSource ?? '',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Duration connector
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    Text(
                      DateTimeHelper.calculateDuration(
                        bus.departureTime,
                        bus.arrivalTime,
                      ),
                      style: AppTypography.captionSmall.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      width: 60,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: 1.5,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFF00E5FF), Color(0xFF10B981)],
                              ),
                            ),
                          ),
                          Icon(
                            Icons.directions_bus_rounded,
                            color: AppColors.liquidCyan,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // To column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      DateTimeHelper.formatTimeString(bus.arrivalTime),
                      style: AppTypography.titleLarge.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Flexible(
                          child: Text(
                            routeProvider.selectedDestination ?? '',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.right,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(Icons.location_on_rounded,
                            color: const Color(0xFF10B981), size: 12),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(height: 1, color: Colors.white.withValues(alpha: 0.06)),
          const SizedBox(height: 16),

          // Date
          _buildDetailRow(
            'journey_date'.tr(context),
            routeProvider.selectedDate != null
                ? DateTimeHelper.formatDate(routeProvider.selectedDate!)
                : '',
            Icons.calendar_today_rounded,
            AppColors.electricPurple,
          ),
        ],
      ),
    );
  }

  Widget _buildBusDetailsCard(dynamic bus) {
    return _buildSectionCard(
      title: 'Bus Details',
      icon: Icons.directions_bus_filled_rounded,
      accentColor: const Color(0xFF10B981),
      child: Column(
        children: [
          _buildDetailRow(
            'bus_type'.tr(context),
            bus.busType,
            Icons.airport_shuttle_rounded,
            const Color(0xFF10B981),
          ),
          _buildDetailRow(
            'bus_number'.tr(context),
            bus.busNumber,
            Icons.badge_rounded,
            const Color(0xFFF59E0B),
          ),
        ],
      ),
    );
  }

  Widget _buildPassengerTypeCard() {
    return _buildSectionCard(
      title: 'passenger_type'.tr(context),
      icon: Icons.person_rounded,
      accentColor: AppColors.electricPurple,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.08),
            width: 1,
          ),
        ),
        child: DropdownButtonFormField<String>(
          value: _selectedPassengerType,
          isExpanded: true,
          dropdownColor: const Color(0xFF1E2942),
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.person_outline_rounded,
                color: AppColors.electricPurple, size: 20),
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          ),
          items: ['Adult', 'Child', 'Senior Citizen'].map((type) {
            return DropdownMenuItem(
              value: type,
              child: Text(
                type,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _selectedPassengerType = value;
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildFareCard(dynamic bus) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0D3320),
            Color(0xFF0A2518),
          ],
        ),
        border: Border.all(
          color: const Color(0xFF10B981).withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF10B981).withValues(alpha: 0.15),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Fare',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '₹',
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    bus.fare.toStringAsFixed(0),
                    style: AppTypography.headlineLarge.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.success.withValues(alpha: 0.25),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.verified_rounded,
                    color: AppColors.success, size: 16),
                const SizedBox(width: 6),
                Text(
                  'Best Price',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1929),
        border: Border(
          top: BorderSide(
            color: Colors.white.withValues(alpha: 0.06),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: GestureDetector(
          onTap: _confirmBooking,
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF10B981), Color(0xFF059669)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF10B981).withValues(alpha: 0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle_rounded,
                    color: Colors.white, size: 22),
                const SizedBox(width: 10),
                Text(
                  'confirm_booking'.tr(context),
                  style: AppTypography.labelLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
      String label, String value, IconData icon, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 14),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ),
          Text(
            value,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
