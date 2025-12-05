import 'package:businesstrack/widgets/module_button.dart';
import 'package:businesstrack/widgets/overview_tab.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  final List<Map<String, dynamic>> modules = const [
    {
      'title': 'Raw Materials',
      'description': 'Manage inventory items',
      'icon': Icons.inventory,
      'color': Colors.blue,
      // 'onPress': () => Navigator.pushNamed(context, 'Inventory'),
    },
    {
      'title': 'Bill of Materials',
      'description': 'Product recipes & costs',
      'icon': Icons.description,
      'color': Colors.cyan,
      // 'onPress': () => Navigator.pushNamed(context, 'Inventory'),
    },
    {
      'title': 'Stock Management',
      'description': 'Add or remove stock',
      'icon': Icons.inventory_2,
      'color': Colors.green,
      // 'onPress': () => Navigator.pushNamed(context, 'Inventory'),
    },
    {
      'title': 'Supplier Management',
      'description': 'Manage suppliers & pricing',
      'icon': Icons.people,
      'color': Colors.orange,
      // 'onPress': () => Navigator.pushNamed(context, 'Suppliers'),
    },
    {
      'title': 'Low Stock Alerts',
      'description': 'Items below threshold',
      'icon': Icons.warning,
      'color': Colors.red,
      // 'onPress': () => Navigator.pushNamed(context, 'Inventory'),
    },
    {
      'title': 'Production Batches',
      'description': 'Create & track batches',
      'icon': Icons.layers,
      'color': Colors.blue,
      // 'onPress': () => Navigator.pushNamed(context, 'Production'),
    },
    {
      'title': 'Reports & Analytics',
      'description': 'Production insights',
      'icon': Icons.bar_chart,
      'color': Colors.cyan,
      // 'onPress': () => Navigator.pushNamed(context, 'Reports'),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 157, 193, 209),
      appBar: AppBar(
        title: const Text('BusinessTrack'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.notifications, color: theme.iconTheme.color),
                onPressed: () {},
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: const Text(
                    '3',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome
              Text('Welcome back!', style: TextStyle(fontSize: 25)),
              const SizedBox(height: 4),
              Text(
                'Here\'s your production overview,',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              // Metrics
              Row(
                children: [
                  Expanded(
                    child: OverviewTab(
                      title: 'Total Materials',
                      value: '24',
                      icon: Icons.inventory,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OverviewTab(
                      title: 'Low Stock',
                      value: '3',
                      icon: Icons.warning,
                      iconColor: Colors.red,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OverviewTab(
                      title: 'Today\'s Production',
                      value: '12',
                      icon: Icons.trending_up,
                      iconColor: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Modules
              Text(
                'Modules',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2, // adjust height vs width
                ),
                itemCount: modules.length,
                itemBuilder: (context, index) {
                  final module = modules[index];
                  return ModuleButton(
                    title: module['title'],
                    description: module['description'],
                    icon: module['icon'],
                    color: module['color'],
                    onPress: () {},
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
