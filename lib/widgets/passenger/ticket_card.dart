// Ticket card widget for displaying passenger tickets - redesigned with premium design system
import 'package:flutter/material.dart';
import 'package:easy_ride/core/constants/app_constants.dart';
import 'package:easy_ride/core/utils/date_time_helper.dart';
import 'package:easy_ride/models/ticket_model.dart';
import 'package:easy_ride/widgets/design_system.dart';

class TicketCard extends StatelessWidget {
  final TicketModel ticket;
  final VoidCallback? onTap;

  const TicketCard({
    Key? key,
    required this.ticket,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isPastTicket = DateTimeHelper.isPast(ticket.journeyDate);
    final isToday = DateTimeHelper.isToday(ticket.journeyDate);

    return FadeInAnimation(
      duration: const Duration(milliseconds: 500),
      child: GestureDetector(
        onTap: onTap,
        child: PremiumCard(
          style: PremiumCardStyle.elevated,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.spacing16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with route and status
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${ticket.source} → ${ticket.destination}',
                            style: AppConstants.headingMedium.copyWith(
                              color: AppConstants.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: AppConstants.spacing4),
                          Row(
                            children: [
                              Icon(
                                Icons.directions_bus_rounded,
                                size: 14,
                                color: AppConstants.textSecondary,
                              ),
                              const SizedBox(width: AppConstants.spacing4),
                              Text(
                                ticket.busType,
                                style: AppConstants.labelSmall.copyWith(
                                  color: AppConstants.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    _buildStatusBadge(isPastTicket, isToday),
                  ],
                ),
                const SizedBox(height: AppConstants.spacing16),

                // Divider with gradient
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

                // Ticket details grid
                Column(
                  children: [
                    // Row 1: Bus details
                    Row(
                      children: [
                        Expanded(
                          child: _buildDetailItem(
                            Icons.confirmation_number_rounded,
                            'Bus No.',
                            ticket.busNumber,
                            AppConstants.primaryBlue,
                          ),
                        ),
                        Expanded(
                          child: _buildDetailItem(
                            Icons.calendar_today_rounded,
                            'Journey Date',
                            DateTimeHelper.formatDate(ticket.journeyDate),
                            AppConstants.secondaryGreen,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.spacing12),

                    // Row 2: Timing
                    Row(
                      children: [
                        Expanded(
                          child: _buildDetailItem(
                            Icons.schedule_rounded,
                            'Departure',
                            DateTimeHelper.formatTimeString(ticket.departureTime),
                            AppConstants.accentOrange,
                          ),
                        ),
                        Expanded(
                          child: _buildDetailItem(
                            Icons.currency_rupee_rounded,
                            'Fare',
                            '${ticket.fare.toStringAsFixed(0)}',
                            AppConstants.secondaryGreen,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.spacing16),

                // Passenger type indicator
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.spacing12,
                    vertical: AppConstants.spacing8,
                  ),
                  decoration: BoxDecoration(
                    color: AppConstants.accentPurple.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(
                      AppConstants.borderRadius8,
                    ),
                    border: Border.all(
                      color: AppConstants.accentPurple.withValues(alpha: 0.3),
                      width: 1.0,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.person_rounded,
                        size: 14,
                        color: AppConstants.accentPurple,
                      ),
                      const SizedBox(width: AppConstants.spacing8),
                      Text(
                        'Passenger: ${ticket.passengerType}',
                        style: AppConstants.labelSmall.copyWith(
                          color: AppConstants.accentPurple,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppConstants.spacing6),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppConstants.borderRadius8),
              ),
              child: Icon(
                icon,
                size: 14,
                color: color,
              ),
            ),
            const SizedBox(width: AppConstants.spacing8),
            Text(
              label,
              style: AppConstants.labelSmall.copyWith(
                color: AppConstants.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.spacing4),
        Padding(
          padding: const EdgeInsets.only(left: AppConstants.spacing28),
          child: Text(
            value,
            style: AppConstants.bodyMedium.copyWith(
              color: AppConstants.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(bool isPast, bool isToday) {
    Color badgeColor;
    Color textColor;
    String statusText;
    IconData statusIcon;

    if (isPast) {
      badgeColor = AppConstants.textSecondary;
      textColor = Colors.white;
      statusText = 'Completed';
      statusIcon = Icons.check_circle_rounded;
    } else if (isToday) {
      badgeColor = AppConstants.secondaryGreen;
      textColor = Colors.white;
      statusText = 'Today';
      statusIcon = Icons.access_time_rounded;
    } else {
      badgeColor = AppConstants.primaryBlue;
      textColor = Colors.white;
      statusText = 'Upcoming';
      statusIcon = Icons.arrow_forward_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacing12,
        vertical: AppConstants.spacing8,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [badgeColor, badgeColor.withValues(alpha: 0.8)],
        ),
        borderRadius: BorderRadius.circular(AppConstants.borderRadius8),
        boxShadow: [
          BoxShadow(
            color: badgeColor.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            statusIcon,
            color: textColor,
            size: 14,
          ),
          const SizedBox(width: AppConstants.spacing4),
          Text(
            statusText,
            style: AppConstants.labelSmall.copyWith(
              color: textColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
