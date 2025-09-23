import 'package:calculadora_electronica/screens/calculators_list_screen.dart';
import 'package:calculadora_electronica/screens/pinouts/pinouts_list_screen.dart';
import 'package:calculadora_electronica/screens/settings_screen.dart';
import 'package:flutter/material.dart';

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

  static const List<String> _titles = <String>[
    'Calculadoras',
    'Pinouts',
    'Configuración',
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
      appBar: AppBar(title: Text(_titles[_selectedIndex])),
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: colorScheme.primaryContainer),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    'Calculadora Electrónica',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.calculate),
                title: const Text('Calculadoras'),
                selected: _selectedIndex == 0,
                onTap: () {
                  Navigator.pop(context);
                  _onItemTapped(0);
                },
              ),
              ListTile(
                leading: const Icon(Icons.developer_board),
                title: const Text('Pinouts'),
                selected: _selectedIndex == 1,
                onTap: () {
                  Navigator.pop(context);
                  _onItemTapped(1);
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Configuración'),
                selected: _selectedIndex == 2,
                onTap: () {
                  Navigator.pop(context);
                  _onItemTapped(2);
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.science),
                title: const Text('Laboratorio'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/lab');
                },
              ),
            ],
          ),
        ),
      ),
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
