import 'package:businesstrack/core/utils/responsive_helper.dart';
import 'package:businesstrack/features/bill_of_materials/presentation/pages/bill_of_materials_page.dart';
import 'package:businesstrack/features/dashboard/presentation/state/dashboard_state.dart';
import 'package:businesstrack/features/dashboard/presentation/viewmodel/dashboard_viewmodel.dart';
import 'package:businesstrack/features/dashboard/presentation/widgets/alerts_widget.dart';
import 'package:businesstrack/features/dashboard/presentation/widgets/professional_module_button.dart';
import 'package:businesstrack/features/dashboard/presentation/widgets/professional_stat_card.dart';
import 'package:businesstrack/features/low_stock_alert/presentation/pages/low_stock_alert_page.dart';
import 'package:businesstrack/features/material/presentation/pages/material_list_page.dart';
import 'package:businesstrack/features/production/presentation/pages/production_page.dart';
import 'package:businesstrack/features/report/presentation/pages/report_page.dart';
import 'package:businesstrack/features/stock/presentation/pages/stock_management_page.dart';
import 'package:businesstrack/features/supplier/presentation/pages/supplier_list_page.dart';
import 'package:businesstrack/features/users/presentation/pages/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardScreen extends ConsumerWidget {
  static const String _defaultUserId = '6990a8b6c6b613e7c98648c2';

  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final dashboardState = ref.watch(dashboardViewModelProvider);
    final dashboardVM = ref.read(dashboardViewModelProvider.notifier);
    final horizontalPadding = ResponsiveHelper.getHorizontalPadding(context);
    final verticalPadding = ResponsiveHelper.getVerticalPadding(context);
    final spacing = ResponsiveHelper.getSpacing(
      context,
      mobile: 12,
      tablet: 16,
    );
    final maxWidth = ResponsiveHelper.getMaxContentWidth(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(context),
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? null
              : LinearGradient(
                  colors: [
                    colorScheme.primary.withValues(alpha: 0.06),
                    colorScheme.surface,
                    colorScheme.primary.withValues(alpha: 0.03),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
        ),
        child: dashboardState.status == DashboardStatus.loading
            ? const _LoadingWidget()
            : RefreshIndicator(
                onRefresh: () => dashboardVM.refreshDashboard(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Center(
                    child: Container(
                      constraints: BoxConstraints(maxWidth: maxWidth),
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        verticalPadding,
                        horizontalPadding,
                        24,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildGreeting(context),
                          SizedBox(
                            height: ResponsiveHelper.getSpacing(
                              context,
                              mobile: 24,
                              tablet: 28,
                            ),
                          ),

                          // Key Metrics
                          _buildKeyMetrics(context, dashboardState),
                          SizedBox(
                            height: ResponsiveHelper.getSpacing(
                              context,
                              mobile: 24,
                              tablet: 28,
                            ),
                          ),

                          // Alerts Section
                          AlertsWidget(
                            criticalCount: dashboardState.alerts
                                .where(
                                  (a) =>
                                      !a.isResolved &&
                                      (a.severity == 'critical' ||
                                          a.severity == 'high'),
                                )
                                .length,
                            warningCount: dashboardState.alerts
                                .where(
                                  (a) =>
                                      !a.isResolved && a.severity == 'medium',
                                )
                                .length,
                            onViewAll: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LowStockAlertPage(),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: ResponsiveHelper.getSpacing(
                              context,
                              mobile: 24,
                              tablet: 28,
                            ),
                          ),

                          // Quick Actions
                          _buildSectionTitle(context, 'Quick Actions'),
                          SizedBox(height: spacing),

                          _buildQuickActions(context, dashboardState, spacing),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text(
        'BusinessTrack',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
      ),
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {},
          tooltip: 'Notifications',
        ),
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingScreen()),
            );
          },
          tooltip: 'Settings',
        ),
      ],
    );
  }

  Widget _buildGreeting(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good Morning'
        : hour < 17
        ? 'Good Afternoon'
        : 'Good Evening';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$greeting! 👋',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              mobile: 24,
              tablet: 28,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Here\'s your production overview for today',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              mobile: 14,
              tablet: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKeyMetrics(BuildContext context, DashboardState state) {
    final isTablet =
        ResponsiveHelper.isTablet(context) ||
        ResponsiveHelper.isDesktop(context);
    final spacing = ResponsiveHelper.getSpacing(
      context,
      mobile: 12,
      tablet: 16,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, 'Key Metrics'),
        SizedBox(height: spacing),
        isTablet
            ? _buildMetricsGrid(context, state, spacing)
            : _buildMetricsRows(context, state, spacing),
      ],
    );
  }

  Widget _buildMetricsGrid(
    BuildContext context,
    DashboardState state,
    double spacing,
  ) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      crossAxisSpacing: spacing,
      mainAxisSpacing: spacing,
      childAspectRatio: 1.2,
      children: [
        ProfessionalStatCard(
          title: 'Total Materials',
          value: '${state.totalMaterials}',
          subtitle: 'Tracked items',
          icon: Icons.inventory_2,
          color: Colors.blue,
        ),
        ProfessionalStatCard(
          title: 'Low Stock',
          value: '${state.lowStockAlertCount}',
          subtitle: 'Alert items',
          icon: Icons.warning_amber,
          color: Colors.orange,
        ),
        ProfessionalStatCard(
          title: 'Inventory Value',
          value: '\$${state.totalInventoryValue.toStringAsFixed(2)}',
          subtitle: 'Total worth',
          icon: Icons.attach_money,
          color: Colors.green,
        ),
        ProfessionalStatCard(
          title: 'Production Today',
          value: '${state.completedProductionToday}',
          subtitle: 'Completed',
          icon: Icons.factory,
          color: Colors.purple,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildMetricsRows(
    BuildContext context,
    DashboardState state,
    double spacing,
  ) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Row(
          children: [
            Expanded(
              child: ProfessionalStatCard(
                title: 'Total Materials',
                value: '${state.totalMaterials}',
                subtitle: 'Tracked items',
                icon: Icons.inventory_2,
                color: Colors.blue,
              ),
            ),
            SizedBox(width: spacing),
            Expanded(
              child: ProfessionalStatCard(
                title: 'Low Stock',
                value: '${state.lowStockAlertCount}',
                subtitle: 'Alert items',
                icon: Icons.warning_amber,
                color: Colors.orange,
              ),
            ),
          ],
        ),
        SizedBox(height: spacing),
        Row(
          children: [
            Expanded(
              child: ProfessionalStatCard(
                title: 'Inventory Value',
                value: '\$${state.totalInventoryValue.toStringAsFixed(2)}',
                subtitle: 'Total worth',
                icon: Icons.attach_money,
                color: Colors.green,
              ),
            ),
            SizedBox(width: spacing),
            Expanded(
              child: ProfessionalStatCard(
                title: 'Production Today',
                value: '${state.completedProductionToday}',
                subtitle: 'Completed',
                icon: Icons.factory,
                color: Colors.purple,
                onTap: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActions(
    BuildContext context,
    DashboardState dashboardState,
    double spacing,
  ) {
    final isTablet =
        ResponsiveHelper.isTablet(context) ||
        ResponsiveHelper.isDesktop(context);

    final modules = [
      _ModuleData(
        title: 'Stock Management',
        description: 'Add or remove stock inventory',
        icon: Icons.inventory_2,
        color: Colors.green,
        isHighlighted: true,
        badge: dashboardState.lowStockAlertCount > 0
            ? '${dashboardState.lowStockAlertCount}'
            : null,
        page: const StockManagementPage(),
      ),
      _ModuleData(
        title: 'Raw Materials',
        description: '${dashboardState.totalMaterials} items tracked',
        icon: Icons.inventory,
        color: Colors.blue,
        page: const MaterialListPage(),
      ),
      _ModuleData(
        title: 'Production',
        description: 'Create & track batches',
        icon: Icons.factory,
        color: Colors.purple,
        badge: dashboardState.productionCount > 0
            ? '${dashboardState.productionCount}'
            : null,
        page: const ProductionPage(),
      ),
      _ModuleData(
        title: 'Low Stock Alerts',
        description: 'Items below threshold',
        icon: Icons.warning_amber,
        color: Colors.orange,
        page: const LowStockAlertPage(),
      ),
      _ModuleData(
        title: 'Suppliers',
        description: 'Manage supplier information',
        icon: Icons.people,
        color: Colors.teal,
        page: const SupplierListPage(userId: _defaultUserId),
      ),
      _ModuleData(
        title: 'Bill of Materials',
        description: 'Product recipes & costs',
        icon: Icons.description,
        color: Colors.cyan,
        page: const BillOfMaterialsPage(),
      ),
      _ModuleData(
        title: 'Reports & Analytics',
        description: 'Production insights & trends',
        icon: Icons.bar_chart,
        color: Colors.indigo,
        page: const ReportPage(),
      ),
    ];

    if (isTablet) {
      // Grid layout for tablets
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
          childAspectRatio: 3.5,
        ),
        itemCount: modules.length,
        itemBuilder: (context, index) {
          final module = modules[index];
          return ProfessionalModuleButton(
            title: module.title,
            description: module.description,
            icon: module.icon,
            color: module.color,
            isHighlighted: module.isHighlighted,
            badge: module.badge,
            onPress: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => module.page),
            ),
          );
        },
      );
    } else {
      // List layout for mobile
      return Column(
        children: modules.map((module) {
          return Padding(
            padding: EdgeInsets.only(bottom: spacing),
            child: ProfessionalModuleButton(
              title: module.title,
              description: module.description,
              icon: module.icon,
              color: module.color,
              isHighlighted: module.isHighlighted,
              badge: module.badge,
              onPress: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => module.page),
              ),
            ),
          );
        }).toList(),
      );
    }
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    final colorScheme = Theme.of(context).colorScheme;
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: colorScheme.onSurface,
        fontSize: ResponsiveHelper.getResponsiveFontSize(
          context,
          mobile: 20,
          tablet: 24,
        ),
      ),
    );
  }
}

class _ModuleData {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final bool isHighlighted;
  final String? badge;
  final Widget page;

  _ModuleData({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    this.isHighlighted = false,
    this.badge,
    required this.page,
  });
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            'Loading dashboard...',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
