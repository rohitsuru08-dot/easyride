// Analytics card widget for admin dashboard
import 'package:flutter/material.dart';
import 'package:easy_ride/core/constants/app_constants.dart';

class AnalyticsCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color? iconColor;
  final Color? backgroundColor;

  const AnalyticsCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.value,
    this.iconColor,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cardIconColor = iconColor ?? AppConstants.primaryBlue;
    final cardBgColor = backgroundColor ?? cardIconColor.withValues(alpha:0.1);

    return Container(
      decoration: BoxDecoration(
        color: AppConstants.cardBackground,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppConstants.spacing12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon container
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: cardBgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 22,
              color: cardIconColor,
            ),
          ),
          const SizedBox(height: AppConstants.spacingSmall),

          // Title
          Text(
            title,
            style: AppConstants.captionStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),

          // Value
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: AppConstants.headingStyle.copyWith(
                fontSize: 22,
                color: cardIconColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Compact analytics card for smaller displays
class CompactAnalyticsCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color? color;

  const CompactAnalyticsCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.value,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cardColor = color ?? AppConstants.primaryBlue;

    return Container(
      decoration: BoxDecoration(
        color: AppConstants.cardBackground,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppConstants.spacing),
      child: Row(
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: cardColor.withValues(alpha:0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 24,
              color: cardColor,
            ),
          ),
          const SizedBox(width: AppConstants.spacing),

          // Title and value
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppConstants.captionStyle,
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: AppConstants.subheadingStyle.copyWith(
                    color: cardColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
