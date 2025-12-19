
import 'package:businesstrack/screens/bottom_navigation/dashboard_screen.dart';
import 'package:businesstrack/screens/bottom_navigation/inventory_screen.dart';
import 'package:businesstrack/screens/bottom_navigation/reportscreen.dart';
import 'package:flutter/material.dart';

class BottomNavigaiton extends StatefulWidget {
  const BottomNavigaiton({super.key});

  @override
  State<BottomNavigaiton> createState() => _BottomNavigaitonState();
}

class _BottomNavigaitonState extends State<BottomNavigaiton> {
  int _selectedIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const DashboardScreen(),
      const InventoryScreen(),
      Center(child: Text('Stock Screen')), // Placeholder
      const Reportscreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 134, 167, 210),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2),
            label: "Inventory",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.storage),
            label: "Stock",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: "Report",
          ),
        ],
      ),
    );
  }
}
