import 'package:calculadora_electronica/screens/calculators/adc_calculator_screen.dart';
import 'package:calculadora_electronica/screens/calculators/battery_life_calculator_screen.dart';
// Importa todas tus pantallas de calculadoras aquí
import 'package:calculadora_electronica/screens/calculators/capacitor_calculator_screen.dart';
import 'package:calculadora_electronica/screens/calculators/decibel_calculator_screen.dart';
import 'package:calculadora_electronica/screens/calculators/electronic_symbols_screen.dart';
import 'package:calculadora_electronica/screens/calculators/filter_calculator_screen.dart';
import 'package:calculadora_electronica/screens/calculators/frequency_converter.dart';
import 'package:calculadora_electronica/screens/calculators/inductive_reactance_screen.dart';
import 'package:calculadora_electronica/screens/calculators/inductor_color_code_screen.dart';
import 'package:calculadora_electronica/screens/calculators/inductor_design_tool_screen.dart';
import 'package:calculadora_electronica/screens/calculators/led_resistor_screen.dart';
import 'package:calculadora_electronica/screens/calculators/ne555_calculator_screen.dart';
import 'package:calculadora_electronica/screens/calculators/ohm_law_screen.dart';
import 'package:calculadora_electronica/screens/calculators/opamp_calculator_screen.dart';
import 'package:calculadora_electronica/screens/calculators/pcb_trace_width_calculator_screen.dart';
import 'package:calculadora_electronica/screens/calculators/power_calculator_screen.dart';
import 'package:calculadora_electronica/screens/calculators/power_dissipation_calculator.dart';
import 'package:calculadora_electronica/screens/calculators/rc_circuit_simulator_screen.dart';
import 'package:calculadora_electronica/screens/calculators/resistor_color_code_screen.dart';
import 'package:calculadora_electronica/screens/calculators/resistor_color_table_screen.dart';
import 'package:calculadora_electronica/screens/calculators/resistor_series_parallel_screen.dart';
import 'package:calculadora_electronica/screens/calculators/smd_calculator_screen.dart';
import 'package:calculadora_electronica/screens/calculators/unit_converter_screen.dart';
import 'package:calculadora_electronica/screens/calculators/voltage_divider_screen.dart';
import 'package:calculadora_electronica/screens/calculators/voltage_drop_calculator.dart';
import 'package:calculadora_electronica/screens/calculators/voltage_regulator_screen.dart';
import 'package:calculadora_electronica/screens/calculators/zener_diode_code_screen.dart';
import 'package:calculadora_electronica/screens/servo_ble_screen.dart';
import 'package:flutter/material.dart';

class CalculatorsListScreen extends StatelessWidget {
  const CalculatorsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Lista de calculadoras disponibles con sus respectivos iconos Y COLORES
    final List<Map<String, dynamic>> calculators = [
      {
        'name': 'Ley de Ohm',
        'screen': const OhmLawScreen(),
        'icon': Icons.flash_on,
        'color': Colors.orange[700],
      },
      {
        'name': 'Código de Colores de Resistencia',
        'screen': const ResistorColorCodeScreen(),
        'icon': Icons.color_lens,
        'color': Colors.red[700],
      },
      {
        'name': 'Tabla de Colores de Resistencia',
        'screen': const ResistorColorTableScreen(),
        'icon': Icons.table_chart,
        'color': Colors.teal[700],
      },
      {
        'name': 'Resistencias Serie/Paralelo',
        'screen': const ResistorSeriesParallelScreen(),
        'icon': Icons.line_style,
        'color': Colors.purple[700],
      },
      {
        'name': 'Calculadora de SMD',
        'screen': const SMDCalculatorScreen(),
        'icon': Icons.square_foot,
        'color': Colors.brown[700],
      },
      {
        'name': 'Capacitores Serie/Paralelo',
        'screen': const CapacitorCalculatorScreen(),
        'icon': Icons.electrical_services,
        'color': Colors.cyan[700],
      },
      {
        'name': 'Resistencia para LED',
        'screen': const LedResistorScreen(),
        'icon': Icons.lightbulb_outline,
        'color': Colors.amber[700],
      },
      {
        'name': 'Divisor de Voltaje',
        'screen': const VoltageDividerScreen(),
        'icon': Icons.call_split,
        'color': Colors.indigo[700],
      },
      {
        'name': 'Convertidor de Unidades',
        'screen': const UnitConverterScreen(),
        'icon': Icons.swap_horiz,
        'color': Colors.lime[700],
      },
      {
        'name': 'Simulador Circuito RC',
        'screen': const RCCircuitSimulatorScreen(),
        'icon': Icons.waves,
        'color': Colors.blueGrey[700],
      },
      {
        'name': 'Código de Colores de Inductores',
        'screen': const InductorColorCodeScreen(),
        'icon': Icons.track_changes,
        'color': Colors.green[700],
      },
      {
        'name': 'Código de Diodo Zener',
        'screen': const ZenerDiodeCodeScreen(),
        'icon': Icons.settings_input_component,
        'color': Colors.blue[700],
      },
      {
        'name': 'Calculadora de Decibelios',
        'screen': const DecibelCalculatorScreen(),
        'icon': Icons.volume_up,
        'color': Colors.pink[700],
      },
      {
        'name': 'Reactancia Inductiva (XL)',
        'screen': const InductiveReactanceScreen(),
        'icon': Icons.trending_up,
        'color': Colors.deepOrange[700],
      },
      {
        'name': 'Calculadora de Filtros',
        'screen': const FilterCalculatorScreen(),
        'icon': Icons.filter_alt,
        'color': Colors.lightGreen[700],
      },
      {
        'name': 'Amplificadores Operacionales',
        'screen': const OpAmpCalculatorScreen(),
        'icon': Icons.compare_arrows,
        'color': Colors.grey[700],
      },
      {
        'name': 'Regulador de Voltaje Ajustable',
        'screen': const VoltageRegulatorScreen(),
        'icon': Icons.tune,
        'color': Colors.deepPurple[700],
      },
      {
        'name': 'Calculadora NE555',
        'screen': const Ne555CalculatorScreen(),
        'icon': Icons.timer,
        'color': Colors.indigoAccent[700],
      },
      {
        'name': 'Cálculo de Vida de Baterías',
        'screen': const BatteryLifeCalculatorScreen(),
        'icon': Icons.battery_charging_full,
        'color': Colors.lightBlue[700],
      },
      {
        'name': 'Disipación de Energía',
        'screen': const PowerDissipationCalculator(),
        'icon': Icons.power,
        'color': Colors.redAccent[700],
      },
      {
        'name': 'Herramienta Diseño de Inductores',
        'screen': const InductorDesignToolScreen(),
        'icon': Icons.build,
        'color': Colors.brown,
      },
      {
        'name': 'Caída de Voltaje en Cables',
        'screen': const VoltageDropCalculator(),
        'icon': Icons.trending_down,
        'color': Colors.blueAccent,
      },
      {
        'name': 'Calculadora de Ancho de Pista PCB',
        'screen': const PcbTraceWidthCalculatorScreen(),
        'icon': Icons.grid_on,
        'color': Colors.cyan,
      },
      {
        'name': 'Calculadora de Potencia',
        'screen': const PowerCalculatorScreen(),
        'icon': Icons.bolt,
        'color': Colors.yellow[700],
      },
      {
        'name': 'Conversor de Frecuencias',
        'screen': const FrequencyConverter(),
        'icon': Icons.multiline_chart,
        'color': Colors.purpleAccent,
      },
      {
        'name': 'Calculadora ADC (Analógico-Digital)',
        'screen': const AdcCalculatorScreen(),
        'icon': Icons.compare,
        'color': Colors.greenAccent[700],
      },
      {
        'name': 'Símbolos Electrónicos',
        'screen': const ElectronicSymbolsScreen(),
        'icon': Icons.graphic_eq,
        'color': Colors.deepPurple[700],
      },
      {
        'name': 'Control Servo BLE',
        'screen': const ServoBleScreen(),
        'icon': Icons.settings_remote,
        'color': Colors.blueAccent[700],
      },
    ];

    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: colorScheme.primary, // Usa el color primario del tema
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Image.asset(
                    'assets/branding/logo_calcuvolt.png',
                    height: 30,
                    color: colorScheme
                        .onPrimary, // Ajusta el color del logo al color del tema
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    'Calculadoras Electrónicas',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: colorScheme
                          .onPrimary, // Ajusta el color del texto al color del tema
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: calculators.length,
              itemBuilder: (context, index) {
                final calculator = calculators[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: colorScheme.primary.withAlpha((255 * 0.5).round()),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withAlpha((255 * 0.2).round()),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: InkWell(
                    onTap: () {
                      if (calculator['screen'] != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
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
                            calculator['icon'] as IconData,
                            color: calculator['color'] as Color?,
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
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
