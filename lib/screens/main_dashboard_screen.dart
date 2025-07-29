// lib/screens/main_dashboard_screen.dart
import 'package:flutter/material.dart';
// Asegúrate de que esta ruta sea correcta para tu archivo de lista de calculadoras
import 'package:calculadora_electronica/screens/calculators_list_screen.dart';
// Asegúrate de que estas rutas sean correctas si ya tienes estos archivos
import 'package:calculadora_electronica/screens/about_screen.dart';
import 'package:calculadora_electronica/screens/calculators/units_and_prefixes_screen.dart';
import 'package:calculadora_electronica/screens/pinouts/pinouts_list_screen.dart'; // <--- ¡NUEVA IMPORTACIÓN!

class MainDashboardScreen extends StatefulWidget {
  const MainDashboardScreen({super.key});

  @override
  State<MainDashboardScreen> createState() => _MainDashboardScreenState();
}

class _MainDashboardScreenState extends State<MainDashboardScreen> {
  int _selectedIndex = 0; // Índice de la pestaña seleccionada

  // Lista de widgets para cada pestaña
  // Ahora con una cuarta opción para los Pin-Outs
  static const List<Widget> _widgetOptions = <Widget>[
    CalculatorsListScreen(),
    PinoutsListScreen(), // <--- ¡AÑADE LA PANTALLA DE PIN-OUTS AQUÍ!
    UnitsAndPrefixesScreen(),
    AboutScreen(),
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
      appBar: AppBar(
        title: const Text('Electrónicos App'),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        elevation: 4,
        centerTitle: true,
      ),
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Calculadoras',
          ),
          BottomNavigationBarItem(
            // <--- ¡NUEVO ITEM PARA PIN-OUTS!
            icon: Icon(
              Icons.hub,
            ), // O cualquier otro icono que prefieras para pin-outs
            label: 'Pin-Outs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.table_chart),
            label: 'Tablas',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'Acerca de'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: colorScheme.surfaceContainerHigh,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
