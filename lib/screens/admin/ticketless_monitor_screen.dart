// Ticketless monitor screen — Premium dark design with risk alert cards
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_ride/core/constants/app_constants.dart';
import 'package:easy_ride/core/theme/app_design_system.dart';
import 'package:easy_ride/providers/admin_provider.dart';
import 'package:easy_ride/localization/localization_service.dart';
import 'package:easy_ride/widgets/modern_app_bar.dart';

class TicketlessMonitorScreen extends StatefulWidget {
  const TicketlessMonitorScreen({Key? key}) : super(key: key);

  @override
  State<TicketlessMonitorScreen> createState() =>
      _TicketlessMonitorScreenState();
}

class _TicketlessMonitorScreenState extends State<TicketlessMonitorScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
    _fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
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

  Color _getRiskColor(num riskPct) {
    if (riskPct > 15) return AppColors.error;
    if (riskPct > 10) return AppColors.warning;
    return const Color(0xFF2563EB);
  }

  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context);
    final detectionData = adminProvider.getTicketlessDetection();

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: ModernAppBar(
        title: 'ticketless_monitor'.tr(context),
        isGlass: true,
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
          opacity: _fade,
          child: RefreshIndicator(
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
                  // Summary stat cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Detection Rate',
                          '${detectionData['averageDetectionRate']}%',
                          Icons.radar_rounded,
                          const Color(0xFFF59E0B),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          'Total Reported',
                          detectionData['totalReported'].toString(),
                          Icons.report_rounded,
                          AppColors.error,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // High risk routes
                  _buildSectionHeader(
                    'high_risk_routes'.tr(context),
                    Icons.warning_amber_rounded,
                    AppColors.error,
                  ),
                  const SizedBox(height: 14),
                  _buildHighRiskRoutes(detectionData),
                  const SizedBox(height: 24),

                  // Daily report
                  _buildSectionHeader(
                    'daily_report'.tr(context),
                    Icons.summarize_rounded,
                    AppColors.liquidCyan,
                  ),
                  const SizedBox(height: 14),
                  _buildDailyReport(detectionData, adminProvider),
                  const SizedBox(height: 24),

                  // Info card
                  _buildInfoBanner(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 16),
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
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF192134),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: AppTypography.titleLarge.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: AppTypography.captionSmall.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHighRiskRoutes(Map<String, dynamic> detectionData) {
    final routes = detectionData['highRiskRoutes'] as List;
    if (routes.isEmpty) {
      return _buildEmptyCard('No high-risk routes detected');
    }

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
        children: routes.asMap().entries.map((entry) {
          final index = entry.key;
          final route = entry.value;
          final routeName = route['route'] as String;
          final riskPercentage = route['riskPercentage'] as num;
          final riskColor = _getRiskColor(riskPercentage);
          final isLast = index == routes.length - 1;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: riskColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.warning_amber_rounded,
                              color: riskColor, size: 14),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            routeName,
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: riskColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: riskColor.withValues(alpha: 0.25),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            '$riskPercentage%',
                            style: AppTypography.labelSmall.copyWith(
                              color: riskColor,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: riskPercentage / 100,
                        minHeight: 4,
                        backgroundColor:
                            Colors.white.withValues(alpha: 0.06),
                        valueColor:
                            AlwaysStoppedAnimation<Color>(riskColor),
                      ),
                    ),
                  ],
                ),
              ),
              if (!isLast)
                Container(
                  height: 1,
                  color: Colors.white.withValues(alpha: 0.04),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDailyReport(
      Map<String, dynamic> detectionData, AdminProvider adminProvider) {
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
          _buildReportRow(
            Icons.confirmation_number_rounded,
            'Total Tickets',
            '${adminProvider.todayTickets.length}',
            AppColors.liquidCyan,
            false,
          ),
          _buildReportRow(
            Icons.report_problem_rounded,
            'Reported Cases',
            detectionData['totalReported'].toString(),
            AppColors.error,
            false,
          ),
          _buildReportRow(
            Icons.radar_rounded,
            'Detection Rate',
            '${detectionData['averageDetectionRate']}%',
            AppColors.warning,
            false,
          ),
          _buildReportRow(
            Icons.monitor_heart_rounded,
            'Status',
            'Active Monitoring',
            AppColors.success,
            true,
          ),
        ],
      ),
    );
  }

  Widget _buildReportRow(
      IconData icon, String label, String value, Color color, bool isLast) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
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
          ),
        ),
        if (!isLast)
          Container(height: 1, color: Colors.white.withValues(alpha: 0.04)),
      ],
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2563EB).withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF2563EB).withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB).withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.info_rounded,
                color: Color(0xFF2563EB), size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Data is updated in real-time based on conductor reports',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCard(String message) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF192134),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
          width: 1,
        ),
      ),
      child: Center(
        child: Text(
          message,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textTertiary,
          ),
        ),
      ),
    );
  }
}
