import 'package:businesstrack/app/myapp.dart';
import 'package:businesstrack/features/auth/presentation/pages/login_screen.dart';
import 'package:businesstrack/features/dashboard/presentation/widgets/module_button.dart';
import 'package:businesstrack/features/dashboard/presentation/widgets/overview_tab.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  final List<Map<String, dynamic>> modules = const [
    {
      'title': 'Raw Materials',
      'description': 'Manage inventory items',
      'icon': Icons.inventory,
      'color': Colors.blue,
    },
    {
      'title': 'Bill of Materials',
      'description': 'Product recipes & costs',
      'icon': Icons.description,
      'color': Colors.cyan,
    },
    {
      'title': 'Stock Management',
      'description': 'Add or remove stock',
      'icon': Icons.inventory_2,
      'color': Colors.green,
    },
    {
      'title': 'Supplier Management',
      'description': 'Manage suppliers',
      'icon': Icons.people,
      'color': Colors.orange,
    },
    {
      'title': 'Low Stock Alerts',
      'description': 'Items below threshold',
      'icon': Icons.warning,
      'color': Colors.red,
    },
    {
      'title': 'Production Batches',
      'description': 'Create & track batches',
      'icon': Icons.layers,
      'color': Colors.blue,
    },
    {
      'title': 'Reports & Analytics',
      'description': 'Production insights',
      'icon': Icons.bar_chart,
      'color': Colors.cyan,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final brightness = theme.brightness;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('BusinessTrack', style: textTheme.titleLarge),
        actions: [
          // Theme switch
          IconButton(
            icon: Icon(
              brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
              color: theme.iconTheme.color,
            ),
            onPressed: () {
              MyApp.themeNotifier.value =
                  MyApp.themeNotifier.value == ThemeMode.light
                  ? ThemeMode.dark
                  : ThemeMode.light;
            },
          ),
          // Notification icon
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.notifications, color: theme.iconTheme.color),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
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
              Text(
                'Welcome back!',
                style: textTheme.titleLarge?.copyWith(fontSize: 25),
              ),
              const SizedBox(height: 4),
              Text(
                'Here\'s your production overview,',
                style: textTheme.bodyMedium?.copyWith(
                  fontSize: 16,
                  color: brightness == Brightness.dark
                      ? Colors.grey[400]
                      : Colors.grey[600],
                ),
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
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
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
