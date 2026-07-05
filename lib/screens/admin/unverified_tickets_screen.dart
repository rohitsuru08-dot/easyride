// Unverified tickets monitor screen
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_ride/core/constants/app_constants.dart';
import 'package:easy_ride/core/theme/app_design_system.dart';
import 'package:easy_ride/core/utils/date_time_helper.dart';
import 'package:easy_ride/providers/admin_provider.dart';
import 'package:easy_ride/widgets/modern_app_bar.dart';
import 'package:easy_ride/widgets/glass/liquid_glass_card.dart';

class UnverifiedTicketsScreen extends StatefulWidget {
  const UnverifiedTicketsScreen({Key? key}) : super(key: key);

  @override
  State<UnverifiedTicketsScreen> createState() => _UnverifiedTicketsScreenState();
}

class _UnverifiedTicketsScreenState extends State<UnverifiedTicketsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  bool _isLoading = true;
  List<Map<String, dynamic>> _data = [];
  String? _error;

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
    setState(() {
      _isLoading = true;
      _error = null;
    });
    
    try {
      final adminProvider = Provider.of<AdminProvider>(context, listen: false);
      final results = await adminProvider.getUnverifiedTicketsSummary();
      if (!mounted) return;
      setState(() {
        _data = results;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: const ModernAppBar(title: 'Tickets Unverified'),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F172A), Color(0xFF080812)],
          ),
        ),
        child: _isLoading
            ? _buildLoadingState()
            : _error != null
                ? _buildErrorState()
                : _data.isEmpty
                    ? _buildEmptyState()
                    : FadeTransition(
                        opacity: _fade,
                        child: RefreshIndicator(
                          onRefresh: _loadData,
                          color: AppColors.liquidCyan,
                          backgroundColor: AppColors.bgSecondary,
                          child: ListView.builder(
                            padding: EdgeInsets.fromLTRB(
                              16, 16, 16,
                              16 + MediaQuery.of(context).padding.bottom + 16,
                            ),
                            itemCount: _data.length,
                            itemBuilder: (context, index) {
                              return _buildBusCard(_data[index]);
                            },
                          ),
                        ),
                      ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.liquidCyan),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: AppColors.error, size: 48),
          const SizedBox(height: 16),
          Text(
            'Failed to load data',
            style: AppTypography.titleMedium.copyWith(color: AppColors.error),
          ),
          const SizedBox(height: 8),
          Text(
            _error ?? 'Unknown error',
            style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadData,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.liquidCyan,
              foregroundColor: Colors.black,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_outline, color: AppColors.success, size: 64),
          const SizedBox(height: 16),
          Text(
            'All tickets verified!',
            style: AppTypography.titleMedium.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            'No unverified tickets found.',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildBusCard(Map<String, dynamic> item) {
    final DateTime date = item['journeyDate'];
    final String busNumber = item['busNumber'];
    final String source = item['source'];
    final String destination = item['destination'];
    final int count = item['count'];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.bgSecondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: PremiumGlassCard(
          gradient: AppGradients.glassDark,
          blurAmount: 15.0,
          padding: const EdgeInsets.all(16),
          isHoverable: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.directions_bus_rounded, color: AppColors.liquidCyan, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        busNumber,
                        style: AppTypography.titleMedium.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.error.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.warning_rounded, color: AppColors.error, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          '$count unverified',
                          style: AppTypography.labelMedium.copyWith(
                            color: AppColors.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Divider(color: Colors.white.withValues(alpha: 0.05), height: 1),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.calendar_month_rounded, color: AppColors.textTertiary, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    DateTimeHelper.formatDate(date),
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(Icons.route_rounded, color: AppColors.textTertiary, size: 16),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '$source → $destination',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
