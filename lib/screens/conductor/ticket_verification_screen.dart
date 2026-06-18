// Ticket verification result screen — Premium dark design with status animation
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_ride/core/constants/app_constants.dart';
import 'package:easy_ride/core/theme/app_design_system.dart';
import 'package:easy_ride/core/utils/date_time_helper.dart';
import 'package:easy_ride/providers/conductor_provider.dart';
import 'package:easy_ride/localization/localization_service.dart';
import 'package:easy_ride/widgets/modern_app_bar.dart';

class TicketVerificationScreen extends StatefulWidget {
  const TicketVerificationScreen({Key? key}) : super(key: key);

  @override
  State<TicketVerificationScreen> createState() =>
      _TicketVerificationScreenState();
}

class _TicketVerificationScreenState extends State<TicketVerificationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _iconScale;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
    _iconScale = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final conductorProvider = Provider.of<ConductorProvider>(context);
    final ticket = conductorProvider.currentTicket;

    if (ticket == null) {
      return Scaffold(
        backgroundColor: AppColors.bgPrimary,
        appBar: ModernAppBar(title: 'ticket_verification'.tr(context)),
        body: Center(
          child: Text('No ticket data',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              )),
        ),
      );
    }

    final isValid = ticket.verified;
    final statusColor = isValid ? AppColors.success : AppColors.error;
    final statusGradient = isValid
        ? const LinearGradient(
            colors: [Color(0xFF10B981), Color(0xFF059669)],
          )
        : const LinearGradient(
            colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
          );

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: ModernAppBar(title: 'ticket_verification'.tr(context)),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F172A), Color(0xFF080812)],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
          child: Column(
            children: [
              // Status icon
              AnimatedBuilder(
                animation: _iconScale,
                builder: (context, child) => Transform.scale(
                  scale: _iconScale.value,
                  child: Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: statusGradient,
                      boxShadow: [
                        BoxShadow(
                          color: statusColor.withValues(alpha: 0.4),
                          blurRadius: 32,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: Icon(
                      isValid ? Icons.verified_rounded : Icons.cancel_rounded,
                      size: 56,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Status text
              FadeTransition(
                opacity: _fade,
                child: Column(
                  children: [
                    Text(
                      isValid
                          ? 'valid_ticket'.tr(context)
                          : 'invalid_ticket'.tr(context),
                      style: AppTypography.headlineSmall.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: statusColor.withValues(alpha: 0.25),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        isValid
                            ? 'Verified Successfully'
                            : 'Verification Failed',
                        style: AppTypography.labelSmall.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Ticket details
              FadeTransition(
                opacity: _fade,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF192134),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.06),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                color: AppColors.liquidCyan.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(Icons.receipt_long_rounded,
                                  color: AppColors.liquidCyan, size: 14),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Ticket Details',
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
                        child: Column(
                          children: [
                            _buildDetailRow(
                              'ticket_id'.tr(context),
                              ticket.ticketId,
                              Icons.tag_rounded,
                              AppColors.liquidCyan,
                            ),
                            _buildDetailRow(
                              'passenger_name'.tr(context),
                              ticket.passengerName,
                              Icons.person_rounded,
                              AppColors.electricPurple,
                            ),
                            _buildDetailRow(
                              'Route',
                              '${ticket.source} → ${ticket.destination}',
                              Icons.route_rounded,
                              AppColors.liquidCyan,
                            ),
                            _buildDetailRow(
                              'bus_type'.tr(context),
                              ticket.busType,
                              Icons.airport_shuttle_rounded,
                              const Color(0xFF10B981),
                            ),
                            _buildDetailRow(
                              'bus_number'.tr(context),
                              ticket.busNumber,
                              Icons.badge_rounded,
                              const Color(0xFFF59E0B),
                            ),
                            _buildDetailRow(
                              'departure'.tr(context),
                              DateTimeHelper.formatTimeString(
                                  ticket.departureTime),
                              Icons.schedule_rounded,
                              const Color(0xFF2563EB),
                            ),
                            _buildDetailRow(
                              'journey_date'.tr(context),
                              DateTimeHelper.formatDate(ticket.journeyDate),
                              Icons.calendar_today_rounded,
                              AppColors.electricPurple,
                            ),
                            _buildDetailRow(
                              'fare'.tr(context),
                              '₹${ticket.fare.toStringAsFixed(0)}',
                              Icons.currency_rupee_rounded,
                              const Color(0xFF10B981),
                            ),
                            _buildDetailRow(
                              'Payment Mode',
                              ticket.paymentMode,
                              Icons.payment_rounded,
                              const Color(0xFFF59E0B),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Action buttons
              FadeTransition(
                opacity: _fade,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: double.infinity,
                        height: 52,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF2563EB).withValues(alpha: 0.4),
                              blurRadius: 14,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.qr_code_scanner_rounded,
                                color: Colors.white, size: 20),
                            const SizedBox(width: 10),
                            Text(
                              'Scan Another Ticket',
                              style: AppTypography.labelLarge.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () => Navigator.of(context).popUntil(
                        (route) => route.isFirst,
                      ),
                      child: Container(
                        width: double.infinity,
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.1),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.home_rounded,
                                color: AppColors.textSecondary, size: 20),
                            const SizedBox(width: 10),
                            Text(
                              'Back to Dashboard',
                              style: AppTypography.labelLarge.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
      String label, String value, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 14, color: color),
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
          Flexible(
            child: Text(
              value,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
