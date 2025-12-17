import 'package:flutter/material.dart';

class BottomNavigationscreen extends StatefulWidget {
  const BottomNavigationscreen({super.key});

  @override
  State<BottomNavigationscreen> createState() => _BottomNavigationscreenState();
}

class _BottomNavigationscreenState extends State<BottomNavigationscreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
  
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_quilt),
            label: 'Layouts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Employees',
          ),
        ],
      ),
    );
  }
}
