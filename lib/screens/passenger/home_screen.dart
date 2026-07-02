// Passenger home screen — World-class ride-sharing UI with premium dark design
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_ride/core/constants/app_constants.dart';
import 'package:easy_ride/core/constants/route_constants.dart';
import 'package:easy_ride/core/theme/app_design_system.dart';
import 'package:easy_ride/providers/route_provider.dart';
import 'package:easy_ride/providers/user_provider.dart';
import 'package:easy_ride/providers/auth_provider.dart';
import 'package:easy_ride/localization/localization_service.dart';
import 'package:easy_ride/widgets/design_system.dart';
import 'package:easy_ride/widgets/common/message_dialog.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:easy_ride/core/utils/date_time_helper.dart';

class PassengerHomeScreen extends StatefulWidget {
  const PassengerHomeScreen({Key? key}) : super(key: key);

  @override
  State<PassengerHomeScreen> createState() => _PassengerHomeScreenState();
}

class _PassengerHomeScreenState extends State<PassengerHomeScreen>
    with SingleTickerProviderStateMixin {
  String? _selectedSource;
  String? _selectedDestination;
  DateTime? _selectedDate = DateTime.now();

  Timer? _timeTimer;
  late DateTime _visakhapatnamTime;

  late AnimationController _staggerController;
  late List<Animation<double>> _staggerFades;
  late List<Animation<Offset>> _staggerSlides;

  @override
  void initState() {
    super.initState();

    // Initialize Visakhapatnam time (IST = UTC + 5:30)
    _visakhapatnamTime = DateTime.now().toUtc().add(const Duration(hours: 5, minutes: 30));
    _timeTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _visakhapatnamTime = DateTime.now().toUtc().add(const Duration(hours: 5, minutes: 30));
        });
      }
    });
    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _staggerFades = List.generate(5, (i) {
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _staggerController,
          curve: Interval(i * 0.12, (i * 0.12) + 0.5, curve: Curves.easeOut),
        ),
      );
    });

    _staggerSlides = List.generate(5, (i) {
      return Tween<Offset>(
        begin: const Offset(0, 0.25),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _staggerController,
          curve: Interval(i * 0.12, (i * 0.12) + 0.5, curve: Curves.easeOutCubic),
        ),
      );
    });

    _staggerController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRoutes();
    });
  }

  @override
  void dispose() {
    _timeTimer?.cancel();
    _staggerController.dispose();
    super.dispose();
  }

  Future<void> _loadRoutes() async {
    final routeProvider = Provider.of<RouteProvider>(context, listen: false);
    await routeProvider.loadRoutes();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.liquidCyan,
              onPrimary: AppColors.bgPrimary,
              surface: AppColors.bgSecondary,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _searchBuses() async {
    if (_selectedSource == null || _selectedDestination == null) {
      MessageDialog.showError(
        context,
        message: 'Please select source and destination',
      );
      return;
    }

    if (_selectedDate == null) {
      MessageDialog.showError(
        context,
        message: 'Please select journey date',
      );
      return;
    }

    final routeProvider = Provider.of<RouteProvider>(context, listen: false);
    routeProvider.setSearchParameters(
      source: _selectedSource,
      destination: _selectedDestination,
      date: _selectedDate,
    );

    Navigator.of(context).pushNamed(RouteConstants.busList);
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

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final routeProvider = Provider.of<RouteProvider>(context);
    final sources = routeProvider.allSources;
    final destinations = _selectedSource != null
        ? routeProvider.getDestinationsForSource(_selectedSource!)
        : routeProvider.allDestinations;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F172A), Color(0xFF0A0A1A)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildTopBar(userProvider),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _loadRoutes,
                  color: AppColors.liquidCyan,
                  backgroundColor: AppColors.bgSecondary,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Hero section
                        _buildAnimated(0, _buildHeroSection(userProvider)),
                        // Search card
                        _buildAnimated(
                          1,
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                            child: _buildSearchCard(
                                sources, destinations, routeProvider),
                          ),
                        ),
                        const SizedBox(height: 28),
                        // Quick access header
                        _buildAnimated(
                          2,
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                            child: _buildSectionHeader('Quick Access', Icons.grid_view_rounded),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Quick access grid
                        _buildAnimated(
                          3,
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                            child: _buildQuickAccessGrid(context),
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimated(int index, Widget child) {
    return FadeTransition(
      opacity: _staggerFades[index],
      child: SlideTransition(
        position: _staggerSlides[index],
        child: child,
      ),
    );
  }

  Widget _buildTopBar(UserProvider userProvider) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          // Logo + name
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: AppGradients.premium,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: AppColors.liquidCyan.withValues(alpha: 0.3),
                  blurRadius: 12,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: const Icon(
              Icons.directions_bus_filled_rounded,
              size: 20,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            'EasyRide',
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const Spacer(),
          // Logout button
          GestureDetector(
            onTap: _logout,
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
              child: Icon(
                Icons.logout_rounded,
                size: 18,
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection(UserProvider userProvider) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1E3A5F),
            Color(0xFF1A2A4A),
            Color(0xFF0F1E38),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2563EB).withValues(alpha: 0.2),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background bus icon (decorative)
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(
              Icons.directions_bus_filled_rounded,
              size: 120,
              color: Colors.white.withValues(alpha: 0.04),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.liquidCyan.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.liquidCyan.withValues(alpha: 0.25),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: AppColors.liquidCyan,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.liquidCyan,
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              'Live • Routes Available',
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.liquidCyan,
                                letterSpacing: 0.5,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.access_time_rounded,
                          color: Colors.white70,
                          size: 14,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${DateFormat('hh:mm:ss a').format(_visakhapatnamTime)} IST',
                          style: AppTypography.labelMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                'welcome_back'.tr(context),
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                userProvider.currentUser?.name ?? 'Traveller',
                style: AppTypography.headlineSmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                height: 2,
                width: 50,
                decoration: const BoxDecoration(
                  gradient: AppGradients.liquidCyan,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Where are you headed today?',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchCard(
      List<String> sources, List<String> destinations, RouteProvider routeProvider) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xFF192134),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: AppGradients.premium,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.search_rounded, size: 16, color: Colors.white),
                ),
                const SizedBox(width: 10),
                Text(
                  'search_buses'.tr(context),
                  style: AppTypography.titleSmall.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // From
            _buildDropdownField(
              label: 'from'.tr(context),
              hint: 'select_source'.tr(context),
              value: _selectedSource,
              icon: Icons.trip_origin_rounded,
              iconColor: AppColors.liquidCyan,
              items: sources,
              onChanged: (value) {
                setState(() {
                  _selectedSource = value;
                  _selectedDestination = null;
                });
              },
            ),

            // Route line connector
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Column(
                children: List.generate(
                  3,
                  (i) => Container(
                    width: 2,
                    height: 6,
                    margin: const EdgeInsets.symmetric(vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ),
              ),
            ),

            // To
            _buildDropdownField(
              label: 'to'.tr(context),
              hint: 'select_destination'.tr(context),
              value: _selectedDestination,
              icon: Icons.location_on_rounded,
              iconColor: const Color(0xFF10B981),
              items: destinations,
              onChanged: (value) {
                setState(() {
                  _selectedDestination = value;
                });
              },
            ),

            const SizedBox(height: 16),

            // Date picker
            _buildDateField(),

            const SizedBox(height: 20),

            // Search button
            _buildSearchButton(routeProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String hint,
    required String? value,
    required IconData icon,
    required Color iconColor,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.labelMedium.copyWith(
            color: AppColors.textTertiary,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.08),
              width: 1,
            ),
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            isExpanded: true,
            dropdownColor: const Color(0xFF1E2942),
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTypography.bodyMedium.copyWith(
                color: AppColors.textQuaternary,
              ),
              prefixIcon: Icon(icon, color: iconColor, size: 20),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
            ),
            items: items.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(
                  item,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'journey_date'.tr(context),
          style: AppTypography.labelMedium.copyWith(
            color: AppColors.textTertiary,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _selectDate,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.08),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  color: AppColors.electricPurple,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _selectedDate != null
                        ? DateTimeHelper.formatDate(_selectedDate!)
                        : 'select_date'.tr(context),
                    style: AppTypography.bodyMedium.copyWith(
                      color: _selectedDate != null
                          ? AppColors.textPrimary
                          : AppColors.textQuaternary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textQuaternary,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchButton(RouteProvider routeProvider) {
    return GestureDetector(
      onTap: routeProvider.isLoading ? null : _searchBuses,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 54,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2563EB).withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (routeProvider.isLoading)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            else ...[
              const Icon(Icons.search_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Text(
                'search_buses'.tr(context),
                style: AppTypography.labelLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.textSecondary, size: 18),
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

  Widget _buildQuickAccessGrid(BuildContext context) {
    final items = [
      _QuickAccessItem(
        label: 'my_tickets'.tr(context),
        icon: Icons.confirmation_number_rounded,
        gradientColors: const [Color(0xFF2563EB), Color(0xFF1D4ED8)],
        glowColor: const Color(0xFF2563EB),
        onTap: () => Navigator.of(context).pushNamed(RouteConstants.myTickets),
      ),
      _QuickAccessItem(
        label: 'help'.tr(context),
        icon: Icons.support_agent_rounded,
        gradientColors: const [Color(0xFF10B981), Color(0xFF059669)],
        glowColor: const Color(0xFF10B981),
        onTap: () {
          MessageDialog.showSuccess(
            context,
            title: 'Help & Support',
            message: 'Contact: support@apsrtc.in\nPhone: 1800-XXX-XXXX',
          );
        },
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildQuickAccessCard(item);
      },
    );
  }

  Widget _buildQuickAccessCard(_QuickAccessItem item) {
    return GestureDetector(
      onTap: item.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: const Color(0xFF192134),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.06),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: item.glowColor.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: item.gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: item.glowColor.withValues(alpha: 0.35),
                    blurRadius: 12,
                    spreadRadius: 0,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(item.icon, color: Colors.white, size: 26),
            ),
            const SizedBox(height: 12),
            Text(
              item.label,
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAccessItem {
  final String label;
  final IconData icon;
  final List<Color> gradientColors;
  final Color glowColor;
  final VoidCallback onTap;

  const _QuickAccessItem({
    required this.label,
    required this.icon,
    required this.gradientColors,
    required this.glowColor,
    required this.onTap,
  });
}
