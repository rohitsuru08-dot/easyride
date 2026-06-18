// Manual ticket generation screen — Premium dark glass design for cash payments
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_ride/core/constants/app_constants.dart';
import 'package:easy_ride/core/theme/app_design_system.dart';
import 'package:easy_ride/providers/conductor_provider.dart';
import 'package:easy_ride/providers/route_provider.dart';
import 'package:easy_ride/providers/user_provider.dart';
import 'package:easy_ride/localization/localization_service.dart';
import 'package:easy_ride/widgets/common/loading_dialog.dart';
import 'package:easy_ride/widgets/common/message_dialog.dart';
import 'package:easy_ride/widgets/modern_app_bar.dart';

class ManualTicketScreen extends StatefulWidget {
  const ManualTicketScreen({Key? key}) : super(key: key);

  @override
  State<ManualTicketScreen> createState() => _ManualTicketScreenState();
}

class _ManualTicketScreenState extends State<ManualTicketScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  String? _selectedSource;
  String? _selectedDestination;
  String _selectedPassengerType = 'Adult';
  double _fare = 30.0;

  late AnimationController _controller;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
    _fadeIn = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRoutes();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadRoutes() async {
    final routeProvider = Provider.of<RouteProvider>(context, listen: false);
    await routeProvider.loadRoutes();
  }

  Future<void> _updateFare(String source, String destination) async {
    final routeProvider = Provider.of<RouteProvider>(context, listen: false);
    await routeProvider.searchBuses(source, destination);
    if (routeProvider.searchResults.isNotEmpty) {
      setState(() {
        _fare = routeProvider.searchResults
            .map((b) => b.fare)
            .reduce((a, b) => a < b ? a : b);
      });
    } else {
      setState(() => _fare = 30.0);
    }
  }

  String _hhmm(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

  Future<void> _generateTicket() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedSource == null || _selectedDestination == null) {
      MessageDialog.showError(
        context,
        message: 'Please select source and destination',
      );
      return;
    }

    LoadingDialog.show(context, message: 'Generating ticket...');

    final conductorProvider =
        Provider.of<ConductorProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final routeProvider = Provider.of<RouteProvider>(context, listen: false);
    final matchedBus = routeProvider.searchResults.isNotEmpty
        ? routeProvider.searchResults.first
        : null;

    final now = DateTime.now();
    final ticket = await conductorProvider.generateManualTicket(
      conductorId: userProvider.currentUser?.userId ?? '',
      source: _selectedSource!,
      destination: _selectedDestination!,
      fare: _fare,
      busType: matchedBus?.busType ?? 'Ordinary',
      busNumber: matchedBus?.busNumber ?? 'CASH',
      routeId: matchedBus?.routeId ?? '',
      departureTime: matchedBus?.departureTime ?? _hhmm(now),
      arrivalTime: matchedBus?.arrivalTime ??
          _hhmm(now.add(const Duration(hours: 2))),
      passengerType: _selectedPassengerType,
    );

    if (!mounted) return;
    LoadingDialog.hide(context);

    if (ticket != null) {
      MessageDialog.showSuccess(
        context,
        title: 'Ticket Generated',
        message:
            'Cash ticket issued successfully\nTicket ID: ${ticket.ticketId}',
        onClose: () {
          Navigator.of(context).pop();
        },
      );
    } else {
      MessageDialog.showError(
        context,
        message:
            conductorProvider.errorMessage ?? 'Failed to generate ticket',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final routeProvider = Provider.of<RouteProvider>(context);
    final sources = routeProvider.allSources;
    final destinations = _selectedSource != null
        ? routeProvider.getDestinationsForSource(_selectedSource!)
        : routeProvider.allDestinations;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: ModernAppBar(
        title: 'manual_ticket'.tr(context),
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
          opacity: _fadeIn,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Info banner
                        _buildInfoBanner(),
                        const SizedBox(height: 20),

                        // Route card
                        _buildRouteCard(sources, destinations),
                        const SizedBox(height: 16),

                        // Passenger type card
                        _buildPassengerCard(),
                        const SizedBox(height: 16),

                        // Fare display
                        _buildFareCard(),
                      ],
                    ),
                  ),
                ),

                // Bottom button
                _buildBottomBar(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.warning.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.info_rounded,
                color: AppColors.warning, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Generate ticket for cash payments',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteCard(List<String> sources, List<String> destinations) {
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
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.route_rounded,
                      color: Colors.white, size: 14),
                ),
                const SizedBox(width: 10),
                Text(
                  'Route Details',
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
                // From
                _buildDropdown(
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
                      _fare = 30.0;
                    });
                  },
                  validator: (value) =>
                      (value == null || value.isEmpty)
                          ? 'select_source'.tr(context)
                          : null,
                ),
                const SizedBox(height: 14),

                // To
                _buildDropdown(
                  label: 'to'.tr(context),
                  hint: 'select_destination'.tr(context),
                  value: _selectedDestination,
                  icon: Icons.location_on_rounded,
                  iconColor: const Color(0xFF10B981),
                  items: destinations,
                  onChanged: (value) {
                    setState(() => _selectedDestination = value);
                    if (_selectedSource != null && value != null) {
                      _updateFare(_selectedSource!, value);
                    }
                  },
                  validator: (value) =>
                      (value == null || value.isEmpty)
                          ? 'select_destination'.tr(context)
                          : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPassengerCard() {
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
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: AppColors.electricPurple.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.person_rounded,
                      color: AppColors.electricPurple, size: 14),
                ),
                const SizedBox(width: 10),
                Text(
                  'passenger_type'.tr(context),
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
            child: _buildDropdown(
              label: '',
              hint: 'Select passenger type',
              value: _selectedPassengerType,
              icon: Icons.person_outline_rounded,
              iconColor: AppColors.electricPurple,
              items: ['Adult', 'Child', 'Senior Citizen'],
              onChanged: (value) {
                if (value != null) setState(() => _selectedPassengerType = value);
              },
              validator: null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String hint,
    required String? value,
    required IconData icon,
    required Color iconColor,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required FormFieldValidator<String>? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.textTertiary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
        ],
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
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            ),
            items: items.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(
                  item,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              );
            }).toList(),
            onChanged: onChanged,
            validator: validator,
          ),
        ),
      ],
    );
  }

  Widget _buildFareCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
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
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'fare'.tr(context),
                style: AppTypography.captionMedium.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '₹',
                    style: AppTypography.titleSmall.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    _fare.toStringAsFixed(0),
                    style: AppTypography.displaySmall.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.warning.withValues(alpha: 0.25),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.money_rounded,
                    color: AppColors.warning, size: 16),
                const SizedBox(width: 6),
                Text(
                  'cash'.tr(context),
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.warning,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1929),
        border: Border(
          top: BorderSide(
            color: Colors.white.withValues(alpha: 0.06),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: GestureDetector(
          onTap: _generateTicket,
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF10B981), Color(0xFF059669)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF10B981).withValues(alpha: 0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.confirmation_number_rounded,
                    color: Colors.white, size: 22),
                const SizedBox(width: 10),
                Text(
                  'issue_ticket'.tr(context),
                  style: AppTypography.labelLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
