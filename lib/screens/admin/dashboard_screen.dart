// Admin dashboard screen — Premium dark bento grid design
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_ride/core/constants/app_constants.dart';
import 'package:easy_ride/core/constants/route_constants.dart';
import 'package:easy_ride/core/theme/app_design_system.dart';
import 'package:easy_ride/providers/admin_provider.dart';
import 'package:easy_ride/providers/auth_provider.dart';
import 'package:easy_ride/localization/localization_service.dart';
import 'package:easy_ride/widgets/common/message_dialog.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _fades;
  late List<Animation<Offset>> _slides;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();

    _fades = List.generate(5, (i) {
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(i * 0.12, (i * 0.12) + 0.5, curve: Curves.easeOut),
        ),
      );
    });
    _slides = List.generate(5, (i) {
      return Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero)
          .animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(i * 0.12, (i * 0.12) + 0.5, curve: Curves.easeOutCubic),
        ),
      );
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);
    await adminProvider.loadDashboardStats();
  }

  Future<void> _logout() async {
    final confirmed = await MessageDialog.showConfirmation(
      context,
      message: 'Are you sure you want to logout?',
      title: 'Logout',
    );

    if (confirmed) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.signOut();
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          RouteConstants.login,
          (route) => false,
        );
      }
    }
  }

  Widget _animated(int index, Widget child) {
    return FadeTransition(
      opacity: _fades[index],
      child: SlideTransition(position: _slides[index], child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context);

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
          child: adminProvider.isLoading
              ? _buildLoadingState()
              : RefreshIndicator(
                  onRefresh: _loadData,
                  color: AppColors.liquidCyan,
                  backgroundColor: AppColors.bgSecondary,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(
                      16, 16, 16,
                      16 + MediaQuery.of(context).padding.bottom + 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Top bar
                        _animated(0, _buildTopBar()),
                        const SizedBox(height: 24),

                        // Hero summary
                        _animated(1, _buildHeroSummary(adminProvider)),
                        const SizedBox(height: 20),

                        // Stats bento grid
                        _animated(2, _buildStatsGrid(adminProvider)),
                        const SizedBox(height: 24),

                        // Today's summary
                        _animated(3, _buildTodaySummary(adminProvider)),
                        const SizedBox(height: 24),

                        // Analytics nav cards
                        _animated(4, _buildAnalyticsNav(context)),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.liquidCyan),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading dashboard...',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
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
          child: const Icon(Icons.admin_panel_settings_rounded,
              size: 22, color: Colors.white),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Admin Dashboard',
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              'Overview & Analytics',
              style: AppTypography.captionSmall.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
        const Spacer(),
        GestureDetector(
          onTap: _loadData,
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.liquidCyan.withValues(alpha: 0.08),
              border: Border.all(
                color: AppColors.liquidCyan.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Icon(Icons.refresh_rounded,
                color: AppColors.liquidCyan, size: 16),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: _logout,
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.error.withValues(alpha: 0.08),
              border: Border.all(
                color: AppColors.error.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Icon(Icons.logout_rounded,
                color: AppColors.error, size: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroSummary(AdminProvider adminProvider) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0D3320), Color(0xFF0A2518)],
        ),
        border: Border.all(
          color: const Color(0xFF10B981).withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF10B981).withValues(alpha: 0.12),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Revenue',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
                const SizedBox(height: 6),
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
                      adminProvider.totalRevenue.toStringAsFixed(0),
                      style: AppTypography.displaySmall.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.success.withValues(alpha: 0.25),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    'All Time',
                    style: AppTypography.captionSmall.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: AppGradients.success,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.success.withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(Icons.trending_up_rounded,
                color: Colors.white, size: 32),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(AdminProvider adminProvider) {
    final stats = [
      _StatData(
        label: 'total_tickets'.tr(context),
        value: adminProvider.totalTickets.toString(),
        icon: Icons.confirmation_number_rounded,
        colors: const [Color(0xFF2563EB), Color(0xFF1D4ED8)],
        glow: const Color(0xFF2563EB),
      ),
      _StatData(
        label: 'total_passengers'.tr(context),
        value: adminProvider.totalPassengers.toString(),
        icon: Icons.people_rounded,
        colors: const [Color(0xFFF59E0B), Color(0xFFD97706)],
        glow: const Color(0xFFF59E0B),
      ),
      _StatData(
        label: 'total_trips'.tr(context),
        value: adminProvider.totalTrips.toString(),
        icon: Icons.directions_bus_rounded,
        colors: const [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
        glow: const Color(0xFF8B5CF6),
      ),
      _StatData(
        label: 'Today Tickets',
        value: adminProvider.todayTickets.length.toString(),
        icon: Icons.today_rounded,
        colors: const [Color(0xFF06B6D4), Color(0xFF0891B2)],
        glow: const Color(0xFF06B6D4),
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
      itemBuilder: (context, i) => _buildStatCard(stats[i]),
    );
  }

  Widget _buildStatCard(_StatData stat) {
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
            color: stat.glow.withValues(alpha: 0.06),
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
              gradient: LinearGradient(colors: stat.colors),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: stat.glow.withValues(alpha: 0.4),
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
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildTodaySummary(AdminProvider adminProvider) {
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
                    color: const Color(0xFF2563EB).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.today_rounded,
                      color: Color(0xFF2563EB), size: 16),
                ),
                const SizedBox(width: 10),
                Text(
                  "Today's Summary",
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
                _buildSummaryRow(
                  Icons.people_rounded,
                  'Passengers',
                  adminProvider.todayPassengers.toString(),
                  const Color(0xFFF59E0B),
                ),
                const SizedBox(height: 14),
                _buildSummaryRow(
                  Icons.currency_rupee_rounded,
                  'Revenue',
                  '₹${adminProvider.todayRevenue.toStringAsFixed(2)}',
                  AppColors.success,
                ),
                const SizedBox(height: 14),
                _buildSummaryRow(
                  Icons.confirmation_number_rounded,
                  'Tickets',
                  adminProvider.todayTickets.length.toString(),
                  const Color(0xFF2563EB),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Text(
          value,
          style: AppTypography.titleSmall.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  Widget _buildAnalyticsNav(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.analytics_rounded,
                color: Color(0xFF9CA3AF), size: 16),
            const SizedBox(width: 8),
            Text(
              'Analytics',
              style: AppTypography.titleSmall.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.9,
          children: [
            _buildNavCard(
              context,
              label: 'route_analytics'.tr(context),
              subtitle: 'Top routes & trends',
              icon: Icons.route_rounded,
              gradientColors: const [Color(0xFF2563EB), Color(0xFF1D4ED8)],
              glowColor: const Color(0xFF2563EB),
              onTap: () =>
                  Navigator.of(context).pushNamed(RouteConstants.routeAnalytics),
            ),
            _buildNavCard(
              context,
              label: 'ticketless_monitor'.tr(context),
              subtitle: 'Risk detection',
              icon: Icons.warning_amber_rounded,
              gradientColors: const [Color(0xFFEF4444), Color(0xFFDC2626)],
              glowColor: const Color(0xFFEF4444),
              onTap: () =>
                  Navigator.of(context).pushNamed(RouteConstants.ticketlessMonitor),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNavCard(
    BuildContext context, {
    required String label,
    required String subtitle,
    required IconData icon,
    required List<Color> gradientColors,
    required Color glowColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF192134),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.06),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: glowColor.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: glowColor.withValues(alpha: 0.4),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 26),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
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
}

class _StatData {
  final String label;
  final String value;
  final IconData icon;
  final List<Color> colors;
  final Color glow;

  const _StatData({
    required this.label,
    required this.value,
    required this.icon,
    required this.colors,
    required this.glow,
  });
}
