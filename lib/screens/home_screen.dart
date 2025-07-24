import 'package:flutter/material.dart';
import 'package:calculadora_electronica/main.dart';
import 'package:calculadora_electronica/screens/ohm_law_screen.dart';
import 'package:calculadora_electronica/screens/smd_calculator_screen.dart';
import 'package:calculadora_electronica/screens/resistor_color_code_screen.dart';
import 'package:calculadora_electronica/screens/capacitor_calculator_screen.dart';
import 'package:calculadora_electronica/screens/resistor_series_parallel_screen.dart';
import 'package:calculadora_electronica/screens/rc_circuit_simulator_screen.dart';
import 'package:calculadora_electronica/screens/electronic_symbols_screen.dart';
import 'package:calculadora_electronica/screens/led_resistor_screen.dart';
import 'package:calculadora_electronica/screens/resistor_color_table_screen.dart';
import 'package:calculadora_electronica/screens/about_screen.dart';
// Nuevas importaciones para las tarjetas adicionales
import 'package:calculadora_electronica/screens/unit_converter_screen.dart'; //
import 'package:calculadora_electronica/screens/units_and_prefixes_screen.dart'; //
import 'package:calculadora_electronica/screens/voltage_divider_screen.dart'; //

class HomeScreen extends StatelessWidget {
  final ThemeProvider themeProvider;

  const HomeScreen({super.key, required this.themeProvider});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora Electrónica'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        actions: [
          Switch(
            value: themeProvider.themeMode == ThemeMode.dark,
            onChanged: (value) {
              themeProvider.toggleTheme(value);
            },
            trackColor: WidgetStateProperty.all(
              Theme.of(context).colorScheme.tertiary,
            ),
            thumbColor: WidgetStateProperty.all(
              Theme.of(context).colorScheme.onTertiary,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                children: <Widget>[
                  _buildCalculatorCard(
                    context,
                    icon: Icons.flash_on,
                    title: 'Ley de Ohm y Potencia',
                    destination: const OhmLawScreen(),
                    color: Colors.blue.shade300,
                  ),
                  _buildCalculatorCard(
                    context,
                    icon: Icons.qr_code,
                    title: 'Calculadora SMD',
                    destination: const SMDCalculatorScreen(),
                    color: Colors.green.shade300,
                  ),
                  _buildCalculatorCard(
                    context,
                    icon: Icons.color_lens,
                    title: 'Código de Colores (Resistencias)',
                    destination: const ResistorColorCodeScreen(),
                    color: Colors.orange.shade300,
                  ),
                  _buildCalculatorCard(
                    context,
                    icon: Icons.electrical_services,
                    title: 'Resistencias Serie/Paralelo',
                    destination: const ResistorSeriesParallelScreen(),
                    color: Colors.purple.shade300,
                  ),
                  _buildCalculatorCard(
                    context,
                    icon: Icons.ac_unit,
                    title: 'Calculadora de Capacitores',
                    destination: const CapacitorCalculatorScreen(),
                    color: Colors.red.shade300,
                  ),
                  _buildCalculatorCard(
                    context,
                    icon: Icons.graphic_eq,
                    title: 'Simulador Circuito RC',
                    destination: const RCCircuitSimulatorScreen(),
                    color: Colors.teal.shade300,
                  ),
                  _buildCalculatorCard(
                    context,
                    icon: Icons.schema,
                    title: 'Símbolos Electrónicos',
                    destination: const ElectronicSymbolsScreen(),
                    color: Colors.brown.shade300,
                  ),
                  _buildCalculatorCard(
                    context,
                    icon: Icons.lightbulb,
                    title: 'Resistencia para LED',
                    destination: const LedResistorScreen(),
                    color: Colors.lime.shade300,
                  ),
                  _buildCalculatorCard(
                    context,
                    icon: Icons.table_chart,
                    title: 'Tabla Códigos Color',
                    destination: const ResistorColorTableScreen(),
                    color: Colors.indigo.shade300,
                  ),
                  _buildCalculatorCard(
                    // Nueva tarjeta: Convertidor de Unidades
                    context,
                    icon: Icons.transform,
                    title: 'Convertidor de Unidades',
                    destination: const UnitConverterScreen(),
                    color: Colors.cyan.shade600,
                  ),
                  _buildCalculatorCard(
                    // Nueva tarjeta: Unidades y Prefijos
                    context,
                    icon: Icons.science,
                    title: 'Unidades y Prefijos',
                    destination: const UnitsAndPrefixesScreen(),
                    color: Colors.deepOrange.shade600,
                  ),
                  _buildCalculatorCard(
                    // Nueva tarjeta: Divisor de Voltaje
                    context,
                    icon: Icons.call_split,
                    title: 'Divisor de Voltaje',
                    destination: const VoltageDividerScreen(),
                    color: Colors.blueGrey.shade600,
                  ),
                  _buildCalculatorCard(
                    context,
                    icon: Icons.info_outline,
                    title: 'Acerca de la App',
                    destination: const AboutScreen(),
                    color: Colors.grey.shade600,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalculatorCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Widget destination,
    required Color color,
  }) {
    // Corrección para la advertencia de 'withOpacity'
    final Color cardColor = color.withAlpha((0.8 * 255).round());

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      color: cardColor,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
        },
        borderRadius: BorderRadius.circular(15.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon, size: 50, color: Colors.white),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Text(
          'Pantalla de $title en construcción',
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
