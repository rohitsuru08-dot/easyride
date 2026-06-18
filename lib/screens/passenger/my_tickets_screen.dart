// My tickets screen — Premium dark design with tab view and staggered cards
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_ride/core/constants/app_constants.dart';
import 'package:easy_ride/core/constants/route_constants.dart';
import 'package:easy_ride/models/ticket_model.dart';
import 'package:easy_ride/providers/ticket_provider.dart';
import 'package:easy_ride/providers/user_provider.dart';
import 'package:easy_ride/localization/localization_service.dart';
import 'package:easy_ride/widgets/design_system.dart';
import 'package:easy_ride/widgets/passenger/ticket_card.dart';
import 'package:easy_ride/core/theme/app_design_system.dart';

class MyTicketsScreen extends StatefulWidget {
  const MyTicketsScreen({Key? key}) : super(key: key);

  @override
  State<MyTicketsScreen> createState() => _MyTicketsScreenState();
}

class _MyTicketsScreenState extends State<MyTicketsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadTickets());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadTickets() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final ticketProvider = Provider.of<TicketProvider>(context, listen: false);

    final userId = userProvider.currentUser?.userId;
    // ignore: avoid_print
    print('[MyTickets] currentUser=${userProvider.currentUser}, userId="$userId"');

    if (userId != null && userId.isNotEmpty) {
      await ticketProvider.loadUserTickets(userId);
    } else {
      // ignore: avoid_print
      print('[MyTickets] userId is null/empty — skipping Firestore query');
    }
  }

  @override
  Widget build(BuildContext context) {
    final ticketProvider = Provider.of<TicketProvider>(context);

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
          child: Column(
            children: [
              _buildHeader(),
              _buildTabBar(),

              // Error banner
              if (ticketProvider.errorMessage != null)
                _buildErrorBanner(ticketProvider.errorMessage!),

              // Tab content
              Expanded(
                child: ticketProvider.isLoading
                    ? _buildLoadingState()
                    : TabBarView(
                        controller: _tabController,
                        children: [
                          _buildTicketList(
                            tickets: ticketProvider.upcomingTickets,
                            emptyMessage: 'No upcoming trips',
                            emptySubtitle: 'Book a bus to get started',
                            emptyIcon: Icons.schedule_rounded,
                          ),
                          _buildTicketList(
                            tickets: ticketProvider.historyTickets,
                            emptyMessage: 'No travel history',
                            emptySubtitle: 'Your past trips will appear here',
                            emptyIcon: Icons.history_rounded,
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              child: const Icon(Icons.arrow_back_rounded,
                  color: Colors.white, size: 20),
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'my_tickets'.tr(context),
                style: AppTypography.titleLarge.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                'Your journey history',
                style: AppTypography.captionSmall.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: _loadTickets,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.liquidCyan.withValues(alpha: 0.08),
                border: Border.all(
                  color: AppColors.liquidCyan.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Icon(Icons.refresh_rounded,
                  color: AppColors.liquidCyan, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFF192134),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
          width: 1,
        ),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2563EB).withValues(alpha: 0.4),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: const EdgeInsets.all(4),
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.textTertiary,
        dividerColor: Colors.transparent,
        labelStyle: AppTypography.labelMedium.copyWith(
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: AppTypography.labelMedium.copyWith(
          fontWeight: FontWeight.w500,
        ),
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.schedule_rounded, size: 16),
                const SizedBox(width: 6),
                Text('upcoming'.tr(context)),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.history_rounded, size: 16),
                const SizedBox(width: 6),
                Text('history'.tr(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorBanner(String message) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.error.withValues(alpha: 0.25),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded, color: AppColors.error, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Error: $message',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.liquidCyan.withValues(alpha: 0.08),
            ),
            child: Center(
              child: SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.liquidCyan),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading your tickets...',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketList({
    required List<TicketModel> tickets,
    required String emptyMessage,
    required String emptySubtitle,
    required IconData emptyIcon,
  }) {
    final ticketProvider =
        Provider.of<TicketProvider>(context, listen: false);

    if (tickets.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppColors.liquidCyan.withValues(alpha: 0.12),
                    AppColors.electricPurple.withValues(alpha: 0.06),
                  ],
                ),
              ),
              child: Icon(emptyIcon, size: 48, color: AppColors.liquidCyan),
            ),
            const SizedBox(height: 20),
            Text(
              emptyMessage,
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              emptySubtitle,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadTickets,
      color: AppColors.liquidCyan,
      backgroundColor: AppColors.bgSecondary,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        itemCount: tickets.length,
        itemBuilder: (context, index) {
          final ticket = tickets[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ScaleInAnimation(
              duration: Duration(milliseconds: 300 + (index * 80)),
              child: TicketCard(
                ticket: ticket,
                onTap: () {
                  ticketProvider.setCurrentTicket(ticket);
                  Navigator.of(context).pushNamed(RouteConstants.qrTicket);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
