import 'package:businesstrack/features/bill_of_materials/presentation/pages/bill_of_materials_page.dart';
import 'package:businesstrack/features/low_stock_alert/presentation/pages/low_stock_alert_page.dart';
import 'package:businesstrack/features/material/presentation/pages/material_list_page.dart';
import 'package:businesstrack/features/production/presentation/pages/production_page.dart';
import 'package:businesstrack/features/report/presentation/pages/report_page.dart';
import 'package:businesstrack/features/stock/presentation/pages/stock_management_page.dart';
import 'package:businesstrack/features/supplier/presentation/pages/supplier_list_page.dart';
import 'package:businesstrack/features/users/presentation/pages/setting_screen.dart';
import 'package:flutter/material.dart';

class DashboardHomePage extends StatelessWidget {
  static const String _defaultUserId = '6990a8b6c6b613e7c98648c2';

  const DashboardHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BusinessTrack'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome Back!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Here\'s your production overview',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),

              // Quick Stats Grid - placeholder for now
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.3,
                children: [
                  _buildStatCard(
                    context,
                    'Materials',
                    '0',
                    'Tracked items',
                    Icons.inventory_2,
                    Colors.blue,
                  ),
                  _buildStatCard(
                    context,
                    'Low Stock',
                    '0',
                    'Alerts',
                    Icons.warning_amber,
                    Colors.orange,
                  ),
                  _buildStatCard(
                    context,
                    'Inventory',
                    '\$0',
                    'Total value',
                    Icons.attach_money,
                    Colors.green,
                  ),
                  _buildStatCard(
                    context,
                    'Production',
                    '0',
                    'Active batches',
                    Icons.factory,
                    Colors.purple,
                  ),
                ],
              ),

              const SizedBox(height: 24),
              Text(
                'Quick Actions',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Quick Action Buttons
              _buildQuickActionButton(
                context,
                'Raw Materials',
                'Manage inventory items',
                Icons.inventory,
                Colors.blue,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MaterialListPage()),
                ),
              ),
              const SizedBox(height: 12),
              _buildQuickActionButton(
                context,
                'Suppliers',
                'Manage suppliers',
                Icons.people,
                Colors.orange,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const SupplierListPage(userId: _defaultUserId),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _buildQuickActionButton(
                context,
                'Stock Management',
                'Add or remove stock',
                Icons.inventory_2,
                Colors.green,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const StockManagementPage(),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _buildQuickActionButton(
                context,
                'Production',
                'Create & track batches',
                Icons.factory,
                Colors.purple,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProductionPage()),
                ),
              ),
              const SizedBox(height: 12),
              _buildQuickActionButton(
                context,
                'Bill of Materials',
                'Product recipes & costs',
                Icons.description,
                Colors.cyan,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const BillOfMaterialsPage(),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _buildQuickActionButton(
                context,
                'Low Stock Alerts',
                'Items below threshold',
                Icons.warning,
                Colors.red,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LowStockAlertPage()),
                ),
              ),
              const SizedBox(height: 12),
              _buildQuickActionButton(
                context,
                'Reports & Analytics',
                'Production insights',
                Icons.bar_chart,
                Colors.indigo,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ReportPage()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }
}
