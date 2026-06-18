// QR Ticket screen with digital ticket display - redesigned with premium design system
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:easy_ride/core/constants/app_constants.dart';
import 'package:easy_ride/core/utils/date_time_helper.dart';
import 'package:easy_ride/providers/ticket_provider.dart';
import 'package:easy_ride/services/qr_service.dart';
import 'package:easy_ride/localization/localization_service.dart';
import 'package:easy_ride/widgets/design_system.dart';

class QRTicketScreen extends StatelessWidget {
  const QRTicketScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ticketProvider = Provider.of<TicketProvider>(context);
    final ticket = ticketProvider.currentTicket;

    if (ticket == null) {
      return Scaffold(
        appBar: ModernAppBar(title: 'ticket'.tr(context)),
        body: const Center(child: Text('No ticket selected')),
      );
    }

    final qrData = QRService.generateQRData(ticket);

    return Scaffold(
      appBar: ModernAppBar(
        title: 'ticket'.tr(context),
        height: 64,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppConstants.backgroundLight,
              AppConstants.backgroundLight.withValues(alpha: 0.7),
              AppConstants.surfaceLight,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacing16,
            vertical: AppConstants.spacing12,
          ),
          child: Column(
            children: [
              // Success icon with animation
              ScaleInAnimation(
                duration: const Duration(milliseconds: 600),
                child: Container(
                  padding: const EdgeInsets.all(AppConstants.spacing20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppConstants.successColor.withValues(alpha: 0.2),
                        AppConstants.successColor.withValues(alpha: 0.05),
                      ],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppConstants.successColor.withValues(alpha: 0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    size: 72,
                    color: AppConstants.successColor,
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.spacing16),

              // Confirmation text with animation
              FadeInAnimation(
                duration: const Duration(milliseconds: 700),
                child: Column(
                  children: [
                    Text(
                      'booking_confirmed'.tr(context),
                      style: AppConstants.displayMedium.copyWith(
                        color: AppConstants.successColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacing8),
                    Text(
                      'Your digital ticket is ready',
                      style: AppConstants.bodyMedium.copyWith(
                        color: AppConstants.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.spacing24),

              // Premium Ticket Card
              SlideInAnimation(
                duration: const Duration(milliseconds: 800),
                direction: SlideDirection.down,
                child: PremiumCard(
                  style: PremiumCardStyle.elevated,
                  child: Padding(
                    padding: const EdgeInsets.all(AppConstants.spacing16),
                    child: Column(
                      children: [
                        // Header with APSRTC branding
                        Container(
                          padding: const EdgeInsets.all(AppConstants.spacing12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppConstants.primaryBlue.withValues(alpha: 0.1),
                                AppConstants.primaryBlue.withValues(alpha: 0.05),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(
                              AppConstants.borderRadius12,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(AppConstants.spacing8),
                                decoration: BoxDecoration(
                                  color: AppConstants.primaryBlue
                                      .withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(
                                    AppConstants.borderRadius8,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.directions_bus_rounded,
                                  color: AppConstants.primaryBlue,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: AppConstants.spacing12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppConstants.appName,
                                    style: AppConstants.headingMedium.copyWith(
                                      color: AppConstants.primaryBlue,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    AppConstants.apsrtcName,
                                    style: AppConstants.labelSmall.copyWith(
                                      color: AppConstants.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppConstants.spacing16),

                        // Gradient divider
                        Container(
                          height: 1,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppConstants.primaryBlue.withValues(alpha: 0.3),
                                AppConstants.primaryBlue.withValues(alpha: 0.0),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: AppConstants.spacing16),

                        // Ticket ID
                        _buildDetailRow(
                          'ticket_id'.tr(context),
                          ticket.ticketId,
                          Icons.confirmation_number_rounded,
                          AppConstants.primaryBlue,
                        ),
                        const SizedBox(height: AppConstants.spacing12),

                        // Route with animated arrow
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppConstants.spacing12,
                            horizontal: AppConstants.spacing12,
                          ),
                          decoration: BoxDecoration(
                            color: AppConstants.primaryBlue.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(
                              AppConstants.borderRadius12,
                            ),
                            border: Border.all(
                              color: AppConstants.primaryBlue
                                  .withValues(alpha: 0.2),
                              width: 1.0,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'From',
                                      style: AppConstants.labelSmall.copyWith(
                                        color: AppConstants.textSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: AppConstants.spacing4),
                                    Text(
                                      ticket.source,
                                      style: AppConstants.headingSmall.copyWith(
                                        color: AppConstants.textPrimary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: AppConstants.spacing4),
                                    Text(
                                      DateTimeHelper.formatTimeString(
                                        ticket.departureTime,
                                      ),
                                      style: AppConstants.labelSmall.copyWith(
                                        color: AppConstants.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppConstants.spacing12,
                                ),
                                child: Icon(
                                  Icons.arrow_forward_rounded,
                                  color: AppConstants.primaryBlue,
                                  size: 24,
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'To',
                                      style: AppConstants.labelSmall.copyWith(
                                        color: AppConstants.textSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: AppConstants.spacing4),
                                    Text(
                                      ticket.destination,
                                      style: AppConstants.headingSmall.copyWith(
                                        color: AppConstants.textPrimary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: AppConstants.spacing4),
                                    Text(
                                      DateTimeHelper.formatTimeString(
                                        ticket.arrivalTime,
                                      ),
                                      style: AppConstants.labelSmall.copyWith(
                                        color: AppConstants.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppConstants.spacing16),

                        // Journey details grid
                        Row(
                          children: [
                            Expanded(
                              child: _buildDetailRow(
                                'journey_date'.tr(context),
                                DateTimeHelper.formatDate(ticket.journeyDate),
                                Icons.calendar_today_rounded,
                                AppConstants.secondaryGreen,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppConstants.spacing12),

                        Row(
                          children: [
                            Expanded(
                              child: _buildDetailRow(
                                'bus_type'.tr(context),
                                ticket.busType,
                                Icons.airport_shuttle_rounded,
                                AppConstants.accentOrange,
                              ),
                            ),
                            const SizedBox(width: AppConstants.spacing12),
                            Expanded(
                              child: _buildDetailRow(
                                'bus_number'.tr(context),
                                ticket.busNumber,
                                Icons.badge_rounded,
                                AppConstants.accentPurple,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppConstants.spacing12),

                        // Passenger details
                        _buildDetailRow(
                          'passenger_name'.tr(context),
                          ticket.passengerName,
                          Icons.person_rounded,
                          AppConstants.primaryBlue,
                        ),
                        const SizedBox(height: AppConstants.spacing12),

                        // Fare display
                        Container(
                          padding: const EdgeInsets.all(AppConstants.spacing12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppConstants.secondaryGreen.withValues(alpha: 0.15),
                                AppConstants.secondaryGreen.withValues(alpha: 0.05),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(
                              AppConstants.borderRadius12,
                            ),
                            border: Border.all(
                              color: AppConstants.secondaryGreen
                                  .withValues(alpha: 0.3),
                              width: 1.0,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'fare'.tr(context),
                                style: AppConstants.labelMedium.copyWith(
                                  color: AppConstants.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.currency_rupee_rounded,
                                    color: AppConstants.secondaryGreen,
                                    size: 18,
                                  ),
                                  Text(
                                    ticket.fare.toStringAsFixed(0),
                                    style: AppConstants.headingSmall.copyWith(
                                      color: AppConstants.secondaryGreen,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppConstants.spacing20),

                        // Divider
                        Container(
                          height: 1,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppConstants.primaryBlue.withValues(alpha: 0.3),
                                AppConstants.primaryBlue.withValues(alpha: 0.0),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: AppConstants.spacing20),

                        // QR Code with glassmorphism
                        FadeInAnimation(
                          duration: const Duration(milliseconds: 1000),
                          child: GlassmorphismCard(
                            child: Container(
                              padding: const EdgeInsets.all(AppConstants.spacing16),
                              child: Column(
                                children: [
                                  Text(
                                    'Digital Ticket',
                                    style: AppConstants.labelMedium.copyWith(
                                      color: AppConstants.textSecondary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: AppConstants.spacing12),
                                  Container(
                                    padding: const EdgeInsets.all(
                                      AppConstants.spacing12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(
                                        AppConstants.borderRadius12,
                                      ),
                                      border: Border.all(
                                        color: AppConstants.primaryBlue
                                            .withValues(alpha: 0.3),
                                        width: 2.0,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppConstants.primaryBlue
                                              .withValues(alpha: 0.1),
                                          blurRadius: 15,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: QrImageView(
                                      data: qrData,
                                      version: QrVersions.auto,
                                      size: AppConstants.qrCodeSize,
                                    ),
                                  ),
                                  const SizedBox(height: AppConstants.spacing12),
                                  Text(
                                    'Show this QR code to conductor',
                                    style: AppConstants.labelSmall.copyWith(
                                      color: AppConstants.textSecondary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.spacing16),

              // Status indicator with animation
              ScaleInAnimation(
                duration: const Duration(milliseconds: 1100),
                child: Container(
                  padding: const EdgeInsets.all(AppConstants.spacing16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: ticket.verified
                          ? [
                              AppConstants.successColor.withValues(alpha: 0.15),
                              AppConstants.successColor.withValues(alpha: 0.05),
                            ]
                          : [
                              AppConstants.primaryBlue.withValues(alpha: 0.15),
                              AppConstants.primaryBlue.withValues(alpha: 0.05),
                            ],
                    ),
                    borderRadius: BorderRadius.circular(AppConstants.borderRadius12),
                    border: Border.all(
                      color: ticket.verified
                          ? AppConstants.successColor.withValues(alpha: 0.3)
                          : AppConstants.primaryBlue.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (ticket.verified
                                ? AppConstants.successColor
                                : AppConstants.primaryBlue)
                            .withValues(alpha: 0.1),
                        blurRadius: 15,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppConstants.spacing8),
                        decoration: BoxDecoration(
                          color: (ticket.verified
                                  ? AppConstants.successColor
                                  : AppConstants.primaryBlue)
                              .withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          ticket.verified
                              ? Icons.verified_user_rounded
                              : Icons.pending_actions_rounded,
                          color: ticket.verified
                              ? AppConstants.successColor
                              : AppConstants.primaryBlue,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: AppConstants.spacing12),
                      Text(
                        ticket.verified
                            ? 'verified'.tr(context)
                            : 'booked'.tr(context),
                        style: AppConstants.labelMedium.copyWith(
                          color: ticket.verified
                              ? AppConstants.successColor
                              : AppConstants.primaryBlue,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.spacing32),
            ],
          ),
        ),
      ),
    );
  }

  // ...existing code...

  Widget _buildDetailRow(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.spacing8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppConstants.spacing6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppConstants.borderRadius6),
            ),
            child: Icon(
              icon,
              color: color,
              size: 16,
            ),
          ),
          const SizedBox(width: AppConstants.spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppConstants.labelSmall.copyWith(
                    color: AppConstants.textTertiary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppConstants.spacing2),
                Text(
                  value,
                  style: AppConstants.bodyMedium.copyWith(
                    color: AppConstants.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}