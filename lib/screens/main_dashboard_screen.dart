// lib/screens/main_dashboard_screen.dart
import 'package:flutter/material.dart';
// Asegúrate de que esta ruta sea correcta para tu archivo de lista de calculadoras
import 'package:calculadora_electronica/screens/calculators_list_screen.dart';
// Asegúrate de que estas rutas sean correctas si ya tienes estos archivos
import 'package:calculadora_electronica/screens/about_screen.dart';
import 'package:calculadora_electronica/screens/units_and_prefixes_screen.dart';

class MainDashboardScreen extends StatefulWidget {
  const MainDashboardScreen({super.key});

  @override
  State<MainDashboardScreen> createState() => _MainDashboardScreenState();
}

class _MainDashboardScreenState extends State<MainDashboardScreen> {
  int _selectedIndex = 0; // Índice de la pestaña seleccionada

  // Lista de widgets para cada pestaña (ahora sin 'const' redundante en los elementos)
  static const List<Widget> _widgetOptions = <Widget>[
    // YA NO NECESITAS 'const' aquí porque la lista _widgetOptions ya es 'const'
    CalculatorsListScreen(),
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
        elevation: 4, // Un poco de sombra para la AppBar
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
            icon: Icon(
              Icons.table_chart,
            ), // Icono provisional para tabla de datos
            label: 'Tablas', // O "Datos" / "Referencia"
          ),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'Acerca de'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: colorScheme.primary, // Color del ícono seleccionado
        unselectedItemColor:
            colorScheme.onSurfaceVariant, // Color de íconos no seleccionados
        onTap: _onItemTapped,
        type: BottomNavigationBarType
            .fixed, // Asegura que todos los ítems se vean
        backgroundColor: colorScheme.surfaceContainerHigh, // Fondo de la barra
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ), // Agregado const
      ),
    );
  }
}
