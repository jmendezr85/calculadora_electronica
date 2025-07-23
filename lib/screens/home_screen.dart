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
import 'package:calculadora_electronica/screens/rc_circuit_simulator_screen.dart';
import 'package:calculadora_electronica/screens/about_screen.dart';
import 'package:calculadora_electronica/screens/smd_calculator_screen.dart'; // ¡Nueva importación para SMD!
import 'package:calculadora_electronica/main.dart'; // Importa main.dart para ThemeProvider

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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            children: <Widget>[
              _buildFeatureCard(
                context,
                'Ley de Ohm',
                'Calcula Voltaje, Corriente, Resistencia y Potencia.',
                Icons.flash_on,
                OhmLawScreen(),
                Colors.orange,
              ),
              _buildFeatureCard(
                context,
                'Código Colores Resistencia',
                'Decodifica resistencias por su código de colores.',
                Icons.color_lens,
                ResistorColorCodeScreen(),
                Colors.purple,
              ),
              _buildFeatureCard(
                context,
                'Divisor de Voltaje',
                'Calcula el voltaje de salida en un divisor resistivo.',
                Icons.grain,
                VoltageDividerScreen(),
                Colors.teal,
              ),
              _buildFeatureCard(
                context,
                'Resistencia para LED',
                'Calcula la resistencia necesaria para un LED.',
                Icons.lightbulb_outline,
                LedResistorScreen(),
                Colors.yellow[700]!,
              ),
              _buildFeatureCard(
                context,
                'Capacitores S/P',
                'Calcula la capacitancia equivalente en serie y paralelo.',
                Icons.offline_bolt,
                CapacitorCalculatorScreen(),
                Colors.blue,
              ),
              _buildFeatureCard(
                context,
                'Resistencias S/P',
                'Calcula la resistencia equivalente en serie y paralelo.',
                Icons.line_axis,
                ResistorSeriesParallelScreen(),
                Colors.brown,
              ),
              _buildFeatureCard(
                context,
                'Tabla Colores Resistencia',
                'Consulta los valores estándar del código de colores.',
                Icons.table_chart,
                ResistorColorTableScreen(),
                Colors.grey,
              ),
              _buildFeatureCard(
                context,
                'Unidades y Prefijos',
                'Herramienta de conversión de unidades y prefijos.',
                Icons.straighten,
                UnitsAndPrefixesScreen(),
                Colors.indigo,
              ),
              _buildFeatureCard(
                context,
                'Símbolos Electrónicos',
                'Guía de símbolos electrónicos comunes.',
                Icons.schema,
                ElectronicSymbolsScreen(),
                Colors.cyan,
              ),
              _buildFeatureCard(
                context,
                'Simulador Circuito RC',
                'Simula la carga y descarga de un capacitor en un circuito RC.',
                Icons.timeline,
                const RCCircuitSimulatorScreen(),
                Colors.green,
              ),
              _buildFeatureCard(
                context,
                'Calculadora SMD', // ¡Nueva tarjeta!
                'Calcula valores de componentes SMD por su código.',
                Icons
                    .fiber_manual_record, // Un ícono que evoca componentes pequeños
                const SMDCalculatorScreen(), // Navega a la nueva pantalla SMD
                Colors.deepPurple, // Color personalizado
              ),
              _buildFeatureCard(
                context,
                'Acerca de',
                'Información sobre la aplicación.',
                Icons.info_outline,
                const AboutScreen(),
                Colors.pink,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Widget screen,
    Color iconColor,
  ) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: iconColor),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Text(
                description,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
