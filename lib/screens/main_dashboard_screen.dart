import 'package:flutter/material.dart';
import 'package:calculadora_electronica/screens/calculators_list_screen.dart';
import "package:calculadora_electronica/screens/settings_screen.dart";
import 'package:calculadora_electronica/screens/pinouts/pinouts_list_screen.dart';

class MainDashboardScreen extends StatefulWidget {
  const MainDashboardScreen({super.key});

  @override
  State<MainDashboardScreen> createState() => _MainDashboardScreenState();
}

class _MainDashboardScreenState extends State<MainDashboardScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const CalculatorsListScreen(),
    const PinoutsListScreen(),
    const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Calculadoras', // Coincide con el índice 0
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.developer_board),
            label: 'Pinouts', // Coincide con el índice 1
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configuración', // Coincide con el índice 2
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        onTap: _onItemTapped,
      ),
    );
  }
}
