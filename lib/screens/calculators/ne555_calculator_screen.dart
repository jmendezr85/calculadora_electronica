// lib/screens/ne555_calculator_screen.dart

import 'package:calculadora_electronica/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Ne555CalculatorScreen extends StatefulWidget {
  const Ne555CalculatorScreen({super.key});

  @override
  State<Ne555CalculatorScreen> createState() => _Ne555CalculatorScreenState();
}

class _Ne555CalculatorScreenState extends State<Ne555CalculatorScreen>
    with TickerProviderStateMixin {
  // Controllers para el modo Astable
  final TextEditingController _r1AstableController = TextEditingController();
  final TextEditingController _r2AstableController = TextEditingController();
  final TextEditingController _cAstableController = TextEditingController();
  String _astableFrequency = '';
  String _astableDutyCycle = '';
  String _astableTimeHigh = '';
  String _astableTimeLow = '';

  String _r1AstableUnit = 'Ω';
  String _r2AstableUnit = 'Ω';
  String _cAstableUnit = 'µF';

  // Controllers para el modo Monoestable
  final TextEditingController _rMonostableController = TextEditingController();
  final TextEditingController _cMonostableController = TextEditingController();
  String _monostablePulseDuration = '';

  String _rMonostableUnit = 'Ω';
  String _cMonostableUnit = 'µF';

  // Listas de unidades
  final List<String> _resistanceUnits = ['Ω', 'kΩ', 'MΩ'];
  final List<String> _capacitanceUnits = ['pF', 'nF', 'µF', 'mF'];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _r1AstableController.dispose();
    _r2AstableController.dispose();
    _cAstableController.dispose();
    _rMonostableController.dispose();
    _cMonostableController.dispose();
    super.dispose();
  }

  double _convertToBaseUnit(double value, String unit) {
    switch (unit) {
      case 'kΩ':
        return value * 1e3;
      case 'MΩ':
        return value * 1e6;
      case 'mF':
        return value * 1e-3;
      case 'µF':
        return value * 1e-6;
      case 'nF':
        return value * 1e-9;
      case 'pF':
        return value * 1e-12;
      default:
        return value;
    }
  }

  String _formatValue(double value, String baseUnit) {
    String unit = baseUnit;
    double formattedValue = value;

    if (baseUnit == 's') {
      if (value.abs() >= 1) {
        unit = 's';
      } else if (value.abs() >= 1e-3) {
        formattedValue = value * 1e3;
        unit = 'ms';
      } else if (value.abs() >= 1e-6) {
        formattedValue = value * 1e6;
        unit = 'µs';
      } else {
        formattedValue = value * 1e9;
        unit = 'ns';
      }
    } else if (baseUnit == 'Hz') {
      if (value.abs() >= 1e6) {
        formattedValue = value / 1e6;
        unit = 'MHz';
      } else if (value.abs() >= 1e3) {
        formattedValue = value / 1e3;
        unit = 'kHz';
      } else {
        unit = 'Hz';
      }
    }

    return '${formattedValue.toStringAsFixed(2)} $unit';
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
        final double frequency = 1 / period;
        final double dutyCycle = (tHigh / period) * 100;

        _astableFrequency = _formatValue(frequency, 'Hz');
        _astableDutyCycle = '${dutyCycle.toStringAsFixed(2)} %';
        _astableTimeHigh = _formatValue(tHigh, 's');
        _astableTimeLow = _formatValue(tLow, 's');
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
        _monostablePulseDuration = _formatValue(pulseDuration, 's');
      } else {
        _monostablePulseDuration = 'Ingrese valores válidos';
      }
    });
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
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final settings = Provider.of<AppSettings>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora NE555'),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Astable'),
            Tab(text: 'Monoestable'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAstableTab(settings.professionalMode, colorScheme),
          _buildMonostableTab(settings.professionalMode, colorScheme),
        ],
      ),
    );
  }

  Widget _buildAstableTab(bool isProfessionalMode, ColorScheme colorScheme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
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
            child: const Text('Calcular'),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: _clearAstableCalculations,
            child: const Text('Limpiar'),
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
                  Text('Frecuencia: $_astableFrequency'),
                  Text('Ciclo de Trabajo: $_astableDutyCycle'),
                  if (isProfessionalMode)
                    ExpansionTile(
                      title: const Text('Opciones Profesionales'),
                      children: <Widget>[
                        if (_astableTimeHigh.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              'Tiempo en Alto (T_high): $_astableTimeHigh',
                            ),
                          ),
                        if (_astableTimeLow.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              'Tiempo en Bajo (T_low): $_astableTimeLow',
                            ),
                          ),
                        if (_astableDutyCycle.isNotEmpty)
                          if (double.tryParse(
                                _astableDutyCycle.split(' ')[0],
                              )! <
                              50)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                '¡Advertencia! Ciclo de trabajo < 50% puede ser inestable.',
                                style: TextStyle(
                                  color: colorScheme.error,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonostableTab(bool isProfessionalMode, ColorScheme colorScheme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
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
            child: const Text('Calcular'),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: _clearMonostableCalculations,
            child: const Text('Limpiar'),
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
                    'Resultado:',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text('Duración del Pulso: $_monostablePulseDuration'),
                  if (isProfessionalMode)
                    ExpansionTile(
                      title: const Text('Opciones Profesionales'),
                      children: <Widget>[
                        if (_monostablePulseDuration.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              'Considera que R y C deben ser adecuados para la duración del pulso.',
                              style: TextStyle(
                                color: colorScheme.primary,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

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
