import 'package:flutter/material.dart';

// Importa todas tus pantallas de calculadoras aquí
// Asegúrate de que las rutas sean correctas para cada archivo
import 'package:calculadora_electronica/screens/capacitor_calculator_screen.dart';
import 'package:calculadora_electronica/screens/led_resistor_screen.dart';
import 'package:calculadora_electronica/screens/rc_circuit_simulator_screen.dart';
import 'package:calculadora_electronica/screens/resistor_color_code_screen.dart';
import 'package:calculadora_electronica/screens/resistor_color_table_screen.dart';
import 'package:calculadora_electronica/screens/resistor_series_parallel_screen.dart';
import 'package:calculadora_electronica/screens/smd_calculator_screen.dart';
import 'package:calculadora_electronica/screens/unit_converter_screen.dart';
import 'package:calculadora_electronica/screens/voltage_divider_screen.dart';
import 'package:calculadora_electronica/screens/ohm_law_screen.dart';
import 'package:calculadora_electronica/screens/inductor_color_code_screen.dart';
import 'package:calculadora_electronica/screens/zener_diode_code_screen.dart';
import 'package:calculadora_electronica/screens/decibel_calculator_screen.dart';
import 'package:calculadora_electronica/screens/inductive_reactance_screen.dart';
import 'package:calculadora_electronica/screens/filter_calculator_screen.dart';
import 'package:calculadora_electronica/screens/opamp_calculator_screen.dart';
import 'package:calculadora_electronica/screens/voltage_regulator_screen.dart';
import 'package:calculadora_electronica/screens/ne555_calculator_screen.dart';
import 'package:calculadora_electronica/screens/battery_life_calculator_screen.dart';
import 'package:calculadora_electronica/screens/power_dissipation_calculator.dart';
import 'package:calculadora_electronica/screens/inductor_design_tool_screen.dart';
import 'package:calculadora_electronica/screens/voltage_drop_calculator.dart';
import 'package:calculadora_electronica/screens/pcb_trace_width_calculator_screen.dart';

// import 'package:calculadora_electronica/screens/inductive_reactance_screen.dart'; // <--- NUEVA IMPORTACIÓN (Comentado)

class CalculatorsListScreen extends StatelessWidget {
  const CalculatorsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Lista de calculadoras disponibles
    final List<Map<String, dynamic>> calculators = [
      {'name': 'Ley de Ohm', 'screen': const OhmLawScreen()},
      {
        'name': 'Código de Colores de Resistencia',
        'screen': const ResistorColorCodeScreen(),
      },
      {
        'name': 'Tabla de Colores de Resistencia',
        'screen': const ResistorColorTableScreen(),
      },
      {
        'name': 'Resistencias Serie/Paralelo',
        'screen': const ResistorSeriesParallelScreen(),
      },
      {'name': 'Calculadora de SMD', 'screen': const SMDCalculatorScreen()},
      {
        'name': 'Capacitores Serie/Paralelo',
        'screen': const CapacitorCalculatorScreen(),
      },
      {'name': 'Resistencia para LED', 'screen': const LedResistorScreen()},
      {'name': 'Divisor de Voltaje', 'screen': const VoltageDividerScreen()},
      {
        'name': 'Convertidor de Unidades',
        'screen': const UnitConverterScreen(),
      },
      {
        'name': 'Simulador Circuito RC',
        'screen': const RCCircuitSimulatorScreen(),
      },
      {
        'name': 'Código de Colores de Inductores',
        'screen': const InductorColorCodeScreen(),
      },
      {'name': 'Código de Diodo Zener', 'screen': const ZenerDiodeCodeScreen()},
      {
        'name': 'Calculadora de Decibelios',
        'screen': const DecibelCalculatorScreen(),
      },
      {
        'name': 'Reactancia Inductiva (XL)',
        'screen': const InductiveReactanceScreen(),
      },
      {
        'name': 'Calculadora de Filtros',
        'screen': const FilterCalculatorScreen(),
      },
      {
        'name': 'Amplificadores Operacionales',
        'screen': const OpAmpCalculatorScreen(),
      },
      {
        'name': 'Regulador de Voltaje Ajustable',
        'screen': const VoltageRegulatorScreen(),
      },
      {
        'name': 'Calculadora NE555', // <--- AÑADIR ESTA ENTRADA
        'screen': const Ne555CalculatorScreen(),
      },
      {
        'name': 'Cálculo de Vida de Baterías', // <--- AÑADIR ESTA ENTRADA
        'screen': const BatteryLifeCalculatorScreen(),
      },
      {
        'name': 'Disipación de Energía', // Cambia 'title' por 'name'
        'screen': const PowerDissipationCalculator(),
      },
      {
        'name': 'Herramienta Diseño de Inductores', // <--- AÑADIR ESTA ENTRADA
        'screen': const InductorDesignToolScreen(),
      },
      {
        'name': 'Caída de Voltaje en Cables',
        'screen': const VoltageDropCalculator(),
      },
      {
        'name': 'Calculadora de Ancho de Pista PCB', // <--- AÑADIR ESTA ENTRADA
        'screen': const PcbTraceWidthCalculatorScreen(),
      },

      // {
      //   'name': 'Reactancia Inductiva',
      //   'screen': const InductiveReactanceScreen(), // Comentado temporalmente
      // },
      // Puedes añadir más calculadoras aquí
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadoras Electrónicas'),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: calculators.length,
        itemBuilder: (context, index) {
          final calculator = calculators[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              onTap: () {
                if (calculator['screen'] != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => calculator['screen']!,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'La calculadora "${calculator['name']}" aún no está implementada.',
                      ),
                    ),
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.calculate,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        calculator['name'],
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
