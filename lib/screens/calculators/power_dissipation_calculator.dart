import 'dart:math' as math;

import 'package:flutter/material.dart';

enum ComponentType {
  resistor,
  transistorBJT,
  transistorMOSFET,
  diode,
  led,
  voltageRegulator,
}

class PowerDissipationCalculator extends StatefulWidget {
  const PowerDissipationCalculator({super.key});

  @override
  State<PowerDissipationCalculator> createState() =>
      _PowerDissipationCalculatorState();
}

class _PowerDissipationCalculatorState
    extends State<PowerDissipationCalculator> {
  ComponentType _selectedComponent = ComponentType.resistor;
  final TextEditingController _currentController = TextEditingController(
    text: '0.1',
  );
  final TextEditingController _voltageController = TextEditingController(
    text: '5.0',
  );
  final TextEditingController _resistanceController = TextEditingController(
    text: '100',
  );
  final TextEditingController _voutController = TextEditingController(
    text: '3.3',
  );
  final TextEditingController _taController = TextEditingController(text: '25');
  final TextEditingController _tjMaxController = TextEditingController(
    text: '150',
  );
  final TextEditingController _rthJCController = TextEditingController(
    text: '5',
  );
  final TextEditingController _rthCAController = TextEditingController(
    text: '10',
  );

  String _selectedCurrentUnit = 'mA';
  String _selectedResistanceUnit = 'Ω';
  double _powerDissipation = 0.0;
  double _junctionTemp = 0.0;
  String _heatsinkAdvice = '';
  String _resultText = '';

  @override
  void dispose() {
    _currentController.dispose();
    _voltageController.dispose();
    _resistanceController.dispose();
    _voutController.dispose();
    _taController.dispose();
    _tjMaxController.dispose();
    _rthJCController.dispose();
    _rthCAController.dispose();
    super.dispose();
  }

  void _calculate() {
    final current = _convertCurrent(
      double.tryParse(_currentController.text) ?? 0.0,
      _selectedCurrentUnit,
    );
    final voltage = double.tryParse(_voltageController.text) ?? 0.0;
    final resistance = _convertResistance(
      double.tryParse(_resistanceController.text) ?? 0.0,
      _selectedResistanceUnit,
    );
    final rthJC = double.tryParse(_rthJCController.text) ?? 0.0;
    final rthCA = double.tryParse(_rthCAController.text) ?? 0.0;
    final ta = double.tryParse(_taController.text) ?? 25.0;
    final tjMax = double.tryParse(_tjMaxController.text) ?? 150.0;
    final vout = double.tryParse(_voutController.text) ?? 0.0;

    setState(() {
      switch (_selectedComponent) {
        case ComponentType.resistor:
          _powerDissipation = current * current * resistance;
          break;
        case ComponentType.transistorBJT:
        case ComponentType.transistorMOSFET:
          _powerDissipation = current * voltage;
          break;
        case ComponentType.diode:
        case ComponentType.led:
          _powerDissipation = current * voltage;
          break;
        case ComponentType.voltageRegulator:
          _powerDissipation = (voltage - vout) * current;
      }

      final rthJA = rthJC + rthCA;
      _junctionTemp = ta + (_powerDissipation * rthJA);
      final requiredRthSA =
          (tjMax - ta) / math.max(_powerDissipation, 0.001) - rthJC;

      _heatsinkAdvice = (_junctionTemp <= tjMax)
          ? '✅ No requiere disipador'
          : '⚠️ Necesita disipador con RθSA < ${requiredRthSA.toStringAsFixed(2)}°C/W';

      _resultText =
          '''
Potencia disipada: ${_powerDissipation.toStringAsFixed(2)} W
Temperatura de juntura: ${_junctionTemp.toStringAsFixed(2)}°C
$_heatsinkAdvice
''';
    });
  }

  double _convertCurrent(double value, String unit) {
    switch (unit) {
      case 'A':
        return value;
      case 'mA':
        return value * 0.001;
      default:
        return value * 0.000001;
    }
  }

  double _convertResistance(double value, String unit) {
    switch (unit) {
      case 'Ω':
        return value;
      case 'kΩ':
        return value * 1000;
      case 'MΩ':
        return value * 1000000;
      default:
        return value;
    }
  }

  Widget _buildComponentSelector() {
    final theme = Theme.of(context);
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Tipo de Componente:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ComponentType.values.map((type) {
                return ChoiceChip(
                  label: Text(_getComponentName(type)),
                  selected: _selectedComponent == type,
                  selectedColor: Color.alphaBlend(
                    theme.colorScheme.primary.withAlpha(51),
                    theme.colorScheme.surface,
                  ),
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _selectedComponent = type);
                    }
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDynamicInputs() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Parámetros Eléctricos',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (_selectedComponent == ComponentType.resistor) ...[
              _buildInputRow(
                'Corriente (I)',
                _currentController,
                _selectedCurrentUnit,
                ['µA', 'mA', 'A'],
                (value) {
                  setState(() => _selectedCurrentUnit = value ?? 'mA');
                },
              ),
              _buildInputRow(
                'Resistencia (R)',
                _resistanceController,
                _selectedResistanceUnit,
                ['Ω', 'kΩ', 'MΩ'],
                (value) {
                  setState(() => _selectedResistanceUnit = value ?? 'Ω');
                },
              ),
            ] else if (_selectedComponent ==
                ComponentType.voltageRegulator) ...[
              _buildInputRow('Voltaje Entrada (Vin)', _voltageController, 'V', [
                'V',
              ], (_) {}),
              _buildInputRow('Voltaje Salida (Vout)', _voutController, 'V', [
                'V',
              ], (_) {}),
              _buildInputRow(
                'Corriente Salida (Iout)',
                _currentController,
                _selectedCurrentUnit,
                ['mA', 'A'],
                (value) {
                  setState(() => _selectedCurrentUnit = value ?? 'mA');
                },
              ),
            ] else ...[
              _buildInputRow(
                'Corriente',
                _currentController,
                _selectedCurrentUnit,
                ['mA', 'A'],
                (value) {
                  setState(() => _selectedCurrentUnit = value ?? 'mA');
                },
              ),
              _buildInputRow('Caída de Voltaje', _voltageController, 'V', [
                'V',
              ], (_) {}),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildThermalParamsCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Parámetros Térmicos',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildInputRow('Temp. Ambiente (Ta)', _taController, '°C', [
              '°C',
            ], (_) {}),
            _buildInputRow('Temp. Máx. Juntura (Tj)', _tjMaxController, '°C', [
              '°C',
            ], (_) {}),
            _buildInputRow(
              'Rθ Juntura-Cápsula (RθJC)',
              _rthJCController,
              '°C/W',
              ['°C/W'],
              (_) {},
            ),
            _buildInputRow('Rθ Cápsula-Aire (RθCA)', _rthCAController, '°C/W', [
              '°C/W',
            ], (_) {}),
          ],
        ),
      ),
    );
  }

  Widget _buildInputRow(
    String label,
    TextEditingController controller,
    String selectedUnit,
    List<String> units,
    ValueChanged<String?> onUnitChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: label,
                border: const OutlineInputBorder(),
              ),
              onChanged: (_) => _calculate(),
            ),
          ),
          if (units.length > 1) ...[
            const SizedBox(width: 8),
            Expanded(
              child: DropdownButtonFormField<String>(
                initialValue: selectedUnit,
                items: units
                    .map(
                      (unit) =>
                          DropdownMenuItem(value: unit, child: Text(unit)),
                    )
                    .toList(),
                onChanged: onUnitChanged,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 14,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildResultsCard() {
    return Card(
      elevation: 4,
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Resultados:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              _resultText.isEmpty
                  ? 'Ingresa los datos y presiona CALCULAR'
                  : _resultText,
              style: TextStyle(
                fontSize: 15,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getComponentName(ComponentType type) {
    switch (type) {
      case ComponentType.resistor:
        return 'Resistencia';
      case ComponentType.transistorBJT:
        return 'Transistor (BJT)';
      case ComponentType.transistorMOSFET:
        return 'Transistor (MOSFET)';
      case ComponentType.diode:
        return 'Diodo';
      case ComponentType.led:
        return 'LED';
      case ComponentType.voltageRegulator:
        return 'Regulador';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora de Disipación'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildComponentSelector(),
            const SizedBox(height: 20),
            _buildDynamicInputs(),
            const SizedBox(height: 20),
            _buildThermalParamsCard(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculate,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('CALCULAR', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 20),
            _buildResultsCard(),
          ],
        ),
      ),
    );
  }
}
