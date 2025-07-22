import 'package:flutter/material.dart';
import 'package:calculadora_electronica/screens/ohm_law_screen.dart';
import 'package:calculadora_electronica/screens/resistor_color_code_screen.dart';
import 'package:calculadora_electronica/screens/voltage_divider_screen.dart';
import 'package:calculadora_electronica/screens/led_resistor_screen.dart';
import 'package:calculadora_electronica/screens/capacitor_calculator_screen.dart';
import 'package:calculadora_electronica/screens/resistor_series_parallel_screen.dart';
import 'package:calculadora_electronica/screens/resistor_color_table_screen.dart';
import 'package:calculadora_electronica/screens/units_and_prefixes_screen.dart';
import 'package:calculadora_electronica/screens/electronic_symbols_screen.dart';
import 'package:calculadora_electronica/screens/about_screen.dart'; // Importa la pantalla de Acerca de
import 'package:calculadora_electronica/screens/smd_calculator_screen.dart'; // Importa la calculadora SMD
import 'package:calculadora_electronica/utils/custom_page_route.dart'; // Importa la ruta personalizada
import 'package:calculadora_electronica/main.dart'; // Importa para ThemeProvider

class HomeScreen extends StatelessWidget {
  final ThemeProvider themeProvider;

  const HomeScreen({super.key, required this.themeProvider});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> menuOptions = [
      {
        'title': 'Ley de Ohm',
        'description': 'Calcula voltaje, corriente y resistencia.',
        'icon': Icons.flash_on,
        'color': Colors.deepPurple,
        'screen': const OhmLawScreen(),
      },
      {
        'title': 'Código de Colores de Resistencias',
        'description':
            'Determina el valor de una resistencia por sus bandas de color.',
        'icon': Icons.colorize,
        'color': Colors.teal,
        'screen': const ResistorColorCodeScreen(),
      },
      {
        'title': 'Divisor de Voltaje',
        'description': 'Calcula el voltaje de salida en un circuito divisor.',
        'icon': Icons.electrical_services,
        'color': Colors.indigo,
        'screen': const VoltageDividerScreen(),
      },
      {
        'title': 'Resistencia para LED',
        'description': 'Calcula la resistencia necesaria para un LED.',
        'icon': Icons.lightbulb_outline,
        'color': Colors.amber,
        'screen': const LedResistorScreen(),
      },
      {
        'title': 'Resistencias S/P',
        'description':
            'Calcula la resistencia equivalente en serie y paralelo.',
        'icon': Icons.waves,
        'color': Colors.deepOrange,
        'screen': const ResistorSeriesParallelScreen(),
      },
      {
        'title': 'Capacitores S/P',
        'description':
            'Calcula la capacitancia equivalente en serie y paralelo.',
        'icon': Icons.speed,
        'color': Colors.indigo,
        'screen': const CapacitorCalculatorScreen(),
      },
      {
        'title': 'Tabla Código Colores',
        'description': 'Consulta rápida de valores de bandas de resistencia.',
        'icon': Icons.palette,
        'color': Colors.blueGrey,
        'screen': const ResistorColorTableScreen(),
      },
      {
        'title': 'Unidades y Prefijos',
        'description': 'Referencia de unidades electrónicas y prefijos SI.',
        'icon': Icons.straighten,
        'color': Colors.teal,
        'screen': const UnitsAndPrefixesScreen(),
      },
      {
        'title': 'Símbolos Electrónicos',
        'description': 'Referencia de símbolos esquemáticos comunes.',
        'icon': Icons.device_hub,
        'color': Colors.indigo,
        'screen': const ElectronicSymbolsScreen(),
      },
      {
        'title': 'Calculadora SMD',
        'description': 'Decodifica códigos de resistencias SMD.',
        'icon': Icons.qr_code,
        'color': Colors.brown,
        'screen': const SmdCalculatorScreen(),
      },
      {
        'title': 'Acerca de la App',
        'description': 'Información sobre la aplicación y el desarrollador.',
        'icon': Icons.info_outline,
        'color': Colors.grey,
        'screen': const AboutScreen(),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora Electrónica'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.themeMode == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              themeProvider.toggleTheme(
                themeProvider.themeMode != ThemeMode.dark,
              );
            },
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          final screenWidth = MediaQuery.of(context).size.width;
          final double horizontalPadding = screenWidth > 600 ? 32.0 : 16.0;
          final double verticalPadding = screenWidth > 600 ? 24.0 : 16.0;

          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: verticalPadding,
            ),
            child: Column(
              children: <Widget>[
                const Text(
                  'Bienvenido a la Calculadora Electrónica',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Selecciona una opción:',
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final double itemWidth =
                          180.0; // Ancho mínimo deseado por tarjeta
                      int crossAxisCount = (constraints.maxWidth / itemWidth)
                          .floor();
                      if (crossAxisCount < 1)
                        crossAxisCount = 1; // Asegurarse de al menos 1 columna

                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 16.0,
                          mainAxisSpacing: 16.0,
                          childAspectRatio: 0.95,
                        ),
                        itemCount: menuOptions.length,
                        itemBuilder: (context, index) {
                          final option = menuOptions[index];
                          return Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  FadePageRoute(child: option['screen']),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      option['icon'],
                                      size: 40,
                                      color: option['color'],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      option['title'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      option['description'],
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
