// lib/screens/ne555_calculator_screen.dart

import 'package:flutter/material.dart';

class Ne555CalculatorScreen extends StatefulWidget {
  const Ne555CalculatorScreen({super.key});

  @override
  State<Ne555CalculatorScreen> createState() => _Ne555CalculatorScreenState();
}

class _Ne555CalculatorScreenState extends State<Ne555CalculatorScreen> {
  // Variables para el modo Astable
  final TextEditingController _r1AstableController = TextEditingController();
  final TextEditingController _r2AstableController = TextEditingController();
  final TextEditingController _cAstableController = TextEditingController();
  String _astableFrequency = '';
  String _astableDutyCycle = '';
  String _astableTimeHigh = '';
  String _astableTimeLow = '';

  String _r1AstableUnit = 'Ω'; // Ohms
  String _r2AstableUnit = 'Ω'; // Ohms
  String _cAstableUnit = 'µF'; // Microfaradios

  // Variables para el modo Monoestable
  final TextEditingController _rMonostableController = TextEditingController();
  final TextEditingController _cMonostableController = TextEditingController();
  String _monostablePulseDuration = '';

  String _rMonostableUnit = 'Ω'; // Ohms
  String _cMonostableUnit = 'µF'; // Microfaradios

  // Selector de modo
  bool _isAstableMode = true; // true para Astable, false para Monoestable

  // Listas de unidades disponibles
  final List<String> _resistanceUnits = ['Ω', 'kΩ', 'MΩ'];
  final List<String> _capacitanceUnits = ['pF', 'nF', 'µF', 'mF'];

  // Función para convertir valores de entrada a unidades base (Ohms y Faradios)
  double _convertToBaseUnit(double value, String unit) {
    switch (unit) {
      case 'kΩ':
      case 'kF': // Si alguna vez necesitas kF
        return value * 1e3; // Kilo
      case 'MΩ':
      case 'MF': // Si alguna vez necesitas MF
        return value * 1e6; // Mega
      case 'mF':
        return value * 1e-3; // Mili
      case 'µF':
        return value * 1e-6; // Micro
      case 'nF':
        return value * 1e-9; // Nano
      case 'pF':
        return value * 1e-12; // Pico
      default: // 'Ω' o 'F' (base)
        return value;
    }
  }

  void _calculateAstable() {
    setState(() {
      final double r1 = _convertToBaseUnit(
        double.tryParse(_r1AstableController.text) ?? 0.0,
        _r1AstableUnit,
      );
      final double r2 = _convertToBaseUnit(
        double.tryParse(_r2AstableController.text) ?? 0.0,
        _r2AstableUnit,
      );
      final double c = _convertToBaseUnit(
        double.tryParse(_cAstableController.text) ?? 0.0,
        _cAstableUnit,
      );

      if (r1 > 0 && r2 > 0 && c > 0) {
        final double tHigh = 0.693 * (r1 + r2) * c;
        final double tLow = 0.693 * r2 * c;
        final double period = tHigh + tLow;
        final double frequency = 1.44 / ((r1 + 2 * r2) * c);
        final double dutyCycle = (tHigh / period) * 100;

        _astableFrequency = '${frequency.toStringAsFixed(2)} Hz';
        _astableDutyCycle = '${dutyCycle.toStringAsFixed(2)} %';
        _astableTimeHigh = _formatTime(tHigh);
        _astableTimeLow = _formatTime(tLow);
      } else {
        _astableFrequency = 'Ingrese valores válidos';
        _astableDutyCycle = '';
        _astableTimeHigh = '';
        _astableTimeLow = '';
      }
    });
  }

  void _calculateMonostable() {
    setState(() {
      final double r = _convertToBaseUnit(
        double.tryParse(_rMonostableController.text) ?? 0.0,
        _rMonostableUnit,
      );
      final double c = _convertToBaseUnit(
        double.tryParse(_cMonostableController.text) ?? 0.0,
        _cMonostableUnit,
      );

      if (r > 0 && c > 0) {
        final double pulseDuration = 1.1 * r * c;
        _monostablePulseDuration = _formatTime(pulseDuration);
      } else {
        _monostablePulseDuration = 'Ingrese valores válidos';
      }
    });
  }

  // Función auxiliar para formatear el tiempo en ms, µs o ns
  String _formatTime(double seconds) {
    if (seconds >= 1) {
      return '${seconds.toStringAsFixed(2)} s';
    } else if (seconds * 1000 >= 1) {
      return '${(seconds * 1000).toStringAsFixed(2)} ms';
    } else if (seconds * 1e6 >= 1) {
      return '${(seconds * 1e6).toStringAsFixed(2)} µs';
    } else {
      return '${(seconds * 1e9).toStringAsFixed(2)} ns';
    }
  }

  void _clearAstableCalculations() {
    setState(() {
      _r1AstableController.clear();
      _r2AstableController.clear();
      _cAstableController.clear();
      _astableFrequency = '';
      _astableDutyCycle = '';
      _astableTimeHigh = '';
      _astableTimeLow = '';
      _r1AstableUnit = 'Ω';
      _r2AstableUnit = 'Ω';
      _cAstableUnit = 'µF';
    });
  }

  void _clearMonostableCalculations() {
    setState(() {
      _rMonostableController.clear();
      _cMonostableController.clear();
      _monostablePulseDuration = '';
      _rMonostableUnit = 'Ω';
      _cMonostableUnit = 'µF';
    });
  }

  @override
  void dispose() {
    _r1AstableController.dispose();
    _r2AstableController.dispose();
    _cAstableController.dispose();
    _rMonostableController.dispose();
    _cMonostableController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora NE555'),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Seleccione el Modo de Operación:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<bool>(
                    title: const Text('Astable'),
                    value: true,
                    groupValue: _isAstableMode,
                    onChanged: (bool? value) {
                      setState(() {
                        _isAstableMode = value!;
                        // Limpiar resultados al cambiar de modo
                        _clearAstableCalculations();
                        _clearMonostableCalculations();
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<bool>(
                    title: const Text('Monoestable'),
                    value: false,
                    groupValue: _isAstableMode,
                    onChanged: (bool? value) {
                      setState(() {
                        _isAstableMode = value!;
                        // Limpiar resultados al cambiar de modo
                        _clearAstableCalculations();
                        _clearMonostableCalculations();
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _isAstableMode ? _buildAstableMode() : _buildMonostableMode(),
          ],
        ),
      ),
    );
  }

  Widget _buildAstableMode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Modo Astable (Oscilador)',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 10),
        _buildInputField(
          controller: _r1AstableController,
          labelText: 'Resistencia R1',
          unit: _r1AstableUnit,
          units: _resistanceUnits,
          onUnitChanged: (newValue) {
            setState(() {
              _r1AstableUnit = newValue!;
            });
          },
        ),
        const SizedBox(height: 15),
        _buildInputField(
          controller: _r2AstableController,
          labelText: 'Resistencia R2',
          unit: _r2AstableUnit,
          units: _resistanceUnits,
          onUnitChanged: (newValue) {
            setState(() {
              _r2AstableUnit = newValue!;
            });
          },
        ),
        const SizedBox(height: 15),
        _buildInputField(
          controller: _cAstableController,
          labelText: 'Capacitor C1',
          unit: _cAstableUnit,
          units: _capacitanceUnits,
          onUnitChanged: (newValue) {
            setState(() {
              _cAstableUnit = newValue!;
            });
          },
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _calculateAstable,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50), // Botón de ancho completo
          ),
          child: const Text('Calcular Astable'),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: _clearAstableCalculations,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
            backgroundColor: Theme.of(context).colorScheme.errorContainer,
            foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
          ),
          child: const Text('Borrar Cálculos'),
        ),
        const SizedBox(height: 20),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Resultados:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text('Frecuencia (F): $_astableFrequency'),
                Text('Ciclo de Trabajo (Duty Cycle): $_astableDutyCycle'),
                Text('Tiempo en Alto (T_high): $_astableTimeHigh'),
                Text('Tiempo en Bajo (T_low): $_astableTimeLow'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMonostableMode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Modo Monoestable (Disparo Único)',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 10),
        _buildInputField(
          controller: _rMonostableController,
          labelText: 'Resistencia R1',
          unit: _rMonostableUnit,
          units: _resistanceUnits,
          onUnitChanged: (newValue) {
            setState(() {
              _rMonostableUnit = newValue!;
            });
          },
        ),
        const SizedBox(height: 15),
        _buildInputField(
          controller: _cMonostableController,
          labelText: 'Capacitor C1',
          unit: _cMonostableUnit,
          units: _capacitanceUnits,
          onUnitChanged: (newValue) {
            setState(() {
              _cMonostableUnit = newValue!;
            });
          },
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _calculateMonostable,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50), // Botón de ancho completo
          ),
          child: const Text('Calcular Monoestable'),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: _clearMonostableCalculations,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
            backgroundColor: Theme.of(context).colorScheme.errorContainer,
            foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
          ),
          child: const Text('Borrar Cálculos'),
        ),
        const SizedBox(height: 20),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Resultados:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text('Duración del Pulso: $_monostablePulseDuration'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Widget genérico para campos de entrada con selector de unidad
  Widget _buildInputField({
    required TextEditingController controller,
    required String labelText,
    required String unit,
    required List<String> units,
    required ValueChanged<String?> onUnitChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: labelText,
              border: const OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(width: 10),
        DropdownButton<String>(
          value: unit,
          items: units.map((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
          onChanged: onUnitChanged,
        ),
      ],
    );
  }
}
