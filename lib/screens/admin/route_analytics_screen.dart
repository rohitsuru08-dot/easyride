// Route analytics screen — Premium dark design with styled bar chart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:easy_ride/core/constants/app_constants.dart';
import 'package:easy_ride/core/theme/app_design_system.dart';
import 'package:easy_ride/providers/admin_provider.dart';
import 'package:easy_ride/localization/localization_service.dart';
import 'package:easy_ride/widgets/modern_app_bar.dart';

class RouteAnalyticsScreen extends StatefulWidget {
  const RouteAnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<RouteAnalyticsScreen> createState() => _RouteAnalyticsScreenState();
}

class _RouteAnalyticsScreenState extends State<RouteAnalyticsScreen>
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
    await adminProvider.loadRouteAnalytics();
  }

  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context);
    final topRoutes = adminProvider.getTopRoutes(limit: 5);
    final peakHours = adminProvider.getPeakHours();

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: ModernAppBar(title: 'route_analytics'.tr(context)),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F172A), Color(0xFF080812)],
          ),
        ),
        child: adminProvider.isLoading
            ? _buildLoadingState()
            : FadeTransition(
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
                        // Top routes
                        _buildSectionHeader(
                            'top_routes'.tr(context), Icons.emoji_events_rounded,
                            const Color(0xFFF59E0B)),
                        const SizedBox(height: 14),
                        _buildTopRoutes(topRoutes),
                        const SizedBox(height: 24),

                        // Peak hours chart
                        _buildSectionHeader(
                            'peak_hours'.tr(context), Icons.bar_chart_rounded,
                            const Color(0xFF2563EB)),
                        const SizedBox(height: 14),
                        _buildPeakHoursChart(peakHours),
                        const SizedBox(height: 24),

                        // Trends card
                        _buildTrendsCard(adminProvider),
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
            width: 36,
            height: 36,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.liquidCyan),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading analytics...',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
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

  Widget _buildTopRoutes(List<MapEntry<String, int>> topRoutes) {
    if (topRoutes.isEmpty) {
      return _buildEmptyCard('No route data available');
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
        children: topRoutes.asMap().entries.map((entry) {
          final index = entry.key;
          final routeEntry = entry.value;
          final routeName = routeEntry.key;
          final count = routeEntry.value;
          final isLast = index == topRoutes.length - 1;

          final rankColors = [
            const Color(0xFFF59E0B),
            const Color(0xFF9CA3AF),
            const Color(0xFFCD7C3F),
            AppColors.textTertiary,
            AppColors.textTertiary,
          ];
          final color = index < rankColors.length
              ? rankColors[index]
              : AppColors.textTertiary;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                child: Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '#${index + 1}',
                          style: AppTypography.labelSmall.copyWith(
                            color: color,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            routeName,
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Progress bar
                          ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: LinearProgressIndicator(
                              value: topRoutes.isNotEmpty
                                  ? count / topRoutes.first.value
                                  : 0,
                              minHeight: 3,
                              backgroundColor:
                                  Colors.white.withValues(alpha: 0.06),
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(color),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.success.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        '$count',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.w800,
                        ),
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

  Widget _buildPeakHoursChart(Map<String, int> peakHours) {
    if (peakHours.isEmpty) {
      return _buildEmptyCard('No peak hour data available');
    }

    final maxVal = peakHours.values.reduce((a, b) => a > b ? a : b).toDouble();

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF192134),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        height: 220,
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: maxVal * 1.25 + 1,
            barTouchData: BarTouchData(
              enabled: true,
              touchTooltipData: BarTouchTooltipData(
                tooltipBgColor: const Color(0xFF192134),
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  final keys = peakHours.keys.toList();
                  return BarTooltipItem(
                    '${keys[groupIndex]}\n${rod.toY.toInt()} trips',
                    AppTypography.captionSmall.copyWith(
                      color: AppColors.liquidCyan,
                      fontWeight: FontWeight.w700,
                    ),
                  );
                },
              ),
            ),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final keys = peakHours.keys.toList();
                    if (value.toInt() >= 0 && value.toInt() < keys.length) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          keys[value.toInt()].split('-')[0],
                          style: AppTypography.captionSmall.copyWith(
                            color: AppColors.textQuaternary,
                          ),
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 28,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      value.toInt().toString(),
                      style: AppTypography.captionSmall.copyWith(
                        color: AppColors.textQuaternary,
                      ),
                    );
                  },
                ),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            borderData: FlBorderData(show: false),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              getDrawingHorizontalLine: (_) => FlLine(
                color: Colors.white.withValues(alpha: 0.05),
                strokeWidth: 1,
              ),
            ),
            barGroups: peakHours.entries
                .toList()
                .asMap()
                .entries
                .map((entry) {
              return BarChartGroupData(
                x: entry.key,
                barRods: [
                  BarChartRodData(
                    toY: entry.value.value.toDouble(),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00E5FF), Color(0xFF2563EB)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    width: 14,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(6),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildTrendsCard(AdminProvider adminProvider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF192134),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.trending_up_rounded,
                    color: Color(0xFF2563EB), size: 16),
              ),
              const SizedBox(width: 10),
              Text(
                'passenger_trends'.tr(context),
                style: AppTypography.titleSmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(height: 1, color: Colors.white.withValues(alpha: 0.05)),
          const SizedBox(height: 16),
          _buildTrendRow(
            Icons.access_time_rounded,
            'Peak travel times: 6-9 AM and 6-9 PM',
            AppColors.liquidCyan,
          ),
          const SizedBox(height: 12),
          _buildTrendRow(
            Icons.people_rounded,
            'Avg passengers per day: ${adminProvider.todayPassengers}',
            AppColors.success,
          ),
        ],
      ),
    );
  }

  Widget _buildTrendRow(IconData icon, String text, Color color) {
    return Row(
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
            text,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
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
