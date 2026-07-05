// Conductor dashboard screen — Premium dark design with gradient stat cards
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_ride/core/constants/app_constants.dart';
import 'package:easy_ride/core/constants/route_constants.dart';
import 'package:easy_ride/core/theme/app_design_system.dart';
import 'package:easy_ride/providers/conductor_provider.dart';
import 'package:easy_ride/providers/auth_provider.dart';
import 'package:easy_ride/providers/user_provider.dart';
import 'package:easy_ride/localization/localization_service.dart';
import 'package:easy_ride/widgets/common/message_dialog.dart';
import 'package:easy_ride/widgets/animations/parallax_header.dart';
import 'package:easy_ride/widgets/animations/portal_lottie_header.dart';

class ConductorDashboardScreen extends StatefulWidget {
  const ConductorDashboardScreen({Key? key}) : super(key: key);

  @override
  State<ConductorDashboardScreen> createState() =>
      _ConductorDashboardScreenState();
}

class _ConductorDashboardScreenState extends State<ConductorDashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _cardFades;
  late List<Animation<Offset>> _cardSlides;
  
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();

    _cardFades = List.generate(6, (i) {
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(i * 0.1, (i * 0.1) + 0.5, curve: Curves.easeOut),
        ),
      );
    });

    _cardSlides = List.generate(6, (i) {
      return Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
          .animate(
        CurvedAnimation(
          parent: _controller,
          curve:
              Interval(i * 0.1, (i * 0.1) + 0.5, curve: Curves.easeOutCubic),
        ),
      );
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        final conductorId = userProvider.currentUser?.userId ?? '';
        Provider.of<ConductorProvider>(context, listen: false).loadStats(conductorId: conductorId);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _logout(BuildContext context) async {
    final confirmed = await MessageDialog.showConfirmation(
      context,
      message: 'Are you sure you want to logout?',
      title: 'Logout',
    );

    if (confirmed) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.signOut();
      if (context.mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          RouteConstants.login,
          (route) => false,
        );
      }
    }
  }

  Widget _animated(int index, Widget child) {
    return FadeTransition(
      opacity: _cardFades[index],
      child: SlideTransition(position: _cardSlides[index], child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    final conductorProvider = Provider.of<ConductorProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F172A), Color(0xFF080812)],
          ),
        ),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              final userProvider = Provider.of<UserProvider>(context, listen: false);
              final conductorId = userProvider.currentUser?.userId ?? '';
              await Provider.of<ConductorProvider>(context, listen: false)
                  .refreshStats(conductorId: conductorId);
            },
            color: AppColors.liquidCyan,
            backgroundColor: const Color(0xFF192134),
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top bar
                _animated(0, _buildTopBar(context)),
                const SizedBox(height: 24),

                // Lottie & Parallax Header
                _animated(0, 
                  ParallaxHeader(
                    scrollController: _scrollController,
                    height: 180,
                    background: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1E3A8A), Color(0xFF0F172A)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                    content: const PortalAnimatedHeader(
                      icon: Icons.qr_code_scanner_rounded,
                      height: 180,
                      title: 'Verify\nTickets',
                      subtitle: 'Scan QR codes quickly.',
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Welcome
                _animated(1, _buildWelcomeSection()),
                const SizedBox(height: 24),

                // Stats grid
                _animated(2, _buildStatsGrid(conductorProvider)),
                const SizedBox(height: 24),

                // Section header
                _animated(3, _buildSectionHeader('Actions', Icons.grid_view_rounded)),
                const SizedBox(height: 14),

                // Action cards
                _animated(4, _buildActionGrid(context)),
                const SizedBox(height: 24),

                // Trip summary
                _animated(5, _buildTripSummary(context, conductorProvider)),
              ],
            ),
          ),
        ),
      ),
    ),
  );
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: AppGradients.premium,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.liquidCyan.withValues(alpha: 0.3),
                blurRadius: 12,
                spreadRadius: 1,
              ),
            ],
          ),
          child: const Icon(Icons.directions_bus_filled_rounded,
              size: 22, color: Colors.white),
        ),
        const SizedBox(width: 12),
        Text(
          'conductor_dashboard'.tr(context),
          style: AppTypography.titleMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () => _logout(context),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.error.withValues(alpha: 0.1),
              border: Border.all(
                color: AppColors.error.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Icon(Icons.logout_rounded, size: 18, color: AppColors.error),
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A2340), Color(0xFF0F1929)],
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2563EB).withValues(alpha: 0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.person_rounded,
                color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good Day, Conductor!',
                  style: AppTypography.titleSmall.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Manage tickets and passengers',
                  style: AppTypography.captionMedium.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 2,
                  width: 40,
                  decoration: const BoxDecoration(
                    gradient: AppGradients.liquidCyan,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(ConductorProvider conductorProvider) {
    final stats = [
      _StatItem(
        label: 'passengers'.tr(context),
        value: conductorProvider.totalPassengers.toString(),
        icon: Icons.people_rounded,
        gradientColors: const [Color(0xFF2563EB), Color(0xFF1D4ED8)],
        glowColor: const Color(0xFF2563EB),
      ),
      _StatItem(
        label: 'Revenue',
        value: '₹${conductorProvider.totalRevenue.toStringAsFixed(0)}',
        icon: Icons.currency_rupee_rounded,
        gradientColors: const [Color(0xFF10B981), Color(0xFF059669)],
        glowColor: const Color(0xFF10B981),
      ),
      _StatItem(
        label: 'Verified',
        value: conductorProvider.ticketsVerifiedCount.toString(),
        icon: Icons.verified_rounded,
        gradientColors: const [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
        glowColor: const Color(0xFF8B5CF6),
      ),
      _StatItem(
        label: 'offline_mode'.tr(context),
        value: 'online'.tr(context),
        icon: Icons.wifi_rounded,
        gradientColors: const [Color(0xFFF59E0B), Color(0xFFD97706)],
        glowColor: const Color(0xFFF59E0B),
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.15,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) => _buildStatCard(stats[index]),
    );
  }

  Widget _buildStatCard(_StatItem stat) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF192134),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: stat.glowColor.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: stat.gradientColors),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: stat.glowColor.withValues(alpha: 0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(stat.icon, color: Colors.white, size: 18),
          ),
          const SizedBox(height: 8),
          Text(
            stat.value,
            style: AppTypography.titleLarge.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            stat.label,
            style: AppTypography.captionSmall.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.textSecondary, size: 16),
        const SizedBox(width: 8),
        Text(
          title,
          style: AppTypography.titleSmall.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildActionGrid(BuildContext context) {
    final actions = [
      _ActionItem(
        label: 'scan_ticket'.tr(context),
        icon: Icons.qr_code_scanner_rounded,
        gradientColors: const [Color(0xFF2563EB), Color(0xFF1D4ED8)],
        glowColor: const Color(0xFF2563EB),
        subtitle: 'Verify QR code',
        onTap: () => Navigator.of(context).pushNamed(RouteConstants.qrScanner),
      ),
      _ActionItem(
        label: 'manual_ticket'.tr(context),
        icon: Icons.confirmation_number_rounded,
        gradientColors: const [Color(0xFF10B981), Color(0xFF059669)],
        glowColor: const Color(0xFF10B981),
        subtitle: 'Cash payment',
        onTap: () =>
            Navigator.of(context).pushNamed(RouteConstants.manualTicket),
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.95,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) => _buildActionCard(actions[index]),
    );
  }

  Widget _buildActionCard(_ActionItem action) {
    return GestureDetector(
      onTap: action.onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF192134),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.06),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: action.glowColor.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: action.gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: action.glowColor.withValues(alpha: 0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Icon(action.icon, color: Colors.white, size: 28),
            ),
            const SizedBox(height: 14),
            Text(
              action.label,
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              action.subtitle,
              style: AppTypography.captionSmall.copyWith(
                color: AppColors.textTertiary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTripSummary(
      BuildContext context, ConductorProvider conductorProvider) {
    return Container(
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
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.electricPurple.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.summarize_rounded,
                      color: AppColors.electricPurple, size: 16),
                ),
                const SizedBox(width: 10),
                Text(
                  'trip_summary'.tr(context),
                  style: AppTypography.titleSmall.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    MessageDialog.showConfirmation(
                      context,
                      message: 'Reset trip statistics?',
                      title: 'Reset Trip',
                    ).then((confirmed) {
                      if (confirmed) {
                        conductorProvider.resetTripStatistics();
                        MessageDialog.showSuccess(
                          context,
                          message: 'Trip statistics reset successfully',
                        );
                      }
                    });
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.error.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'Reset',
                      style: AppTypography.captionSmall.copyWith(
                        color: AppColors.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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
                _buildSummaryRow(
                  Icons.people_rounded,
                  'Total Passengers',
                  conductorProvider.totalPassengers.toString(),
                  AppColors.liquidCyan,
                ),
                const SizedBox(height: 12),
                _buildSummaryRow(
                  Icons.verified_rounded,
                  'Tickets Verified',
                  conductorProvider.ticketsVerifiedCount.toString(),
                  AppColors.success,
                ),
                const SizedBox(height: 12),
                _buildSummaryRow(
                  Icons.currency_rupee_rounded,
                  'Total Collection',
                  '₹${conductorProvider.totalRevenue.toStringAsFixed(2)}',
                  const Color(0xFFF59E0B),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
      IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Text(
          value,
          style: AppTypography.titleSmall.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _StatItem {
  final String label;
  final String value;
  final IconData icon;
  final List<Color> gradientColors;
  final Color glowColor;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.gradientColors,
    required this.glowColor,
  });
}

class _ActionItem {
  final String label;
  final String subtitle;
  final IconData icon;
  final List<Color> gradientColors;
  final Color glowColor;
  final VoidCallback onTap;

  const _ActionItem({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.gradientColors,
    required this.glowColor,
    required this.onTap,
  });
}
