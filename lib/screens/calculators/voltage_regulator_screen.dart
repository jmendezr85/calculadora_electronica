import 'package:flutter/material.dart';
import 'dart:math' as math;

enum RegulatorCategory { linear, switching }

enum LinearRegulatorType {
  lm317,
  lm7805,
  lm7812,
  lm7824,
  lm7905,
  lm7912,
  lm7924,
  ams1117,
  ld1117,
  lt1083,
}

enum SwitchingRegulatorType { lm2596, xl4015, xl6009, mp1584, tps5430, tps7a47 }

class VoltageRegulatorScreen extends StatefulWidget {
  const VoltageRegulatorScreen({super.key});

  @override
  State<VoltageRegulatorScreen> createState() => _VoltageRegulatorScreenState();
}

class _VoltageRegulatorScreenState extends State<VoltageRegulatorScreen> {
  final TextEditingController _voutController = TextEditingController(
    text: '5.0',
  );
  final TextEditingController _r1Controller = TextEditingController(
    text: '240',
  );
  final TextEditingController _iadjController = TextEditingController(
    text: '0.05',
  );
  final TextEditingController _vinController = TextEditingController(
    text: '12.0',
  );
  final TextEditingController _taController = TextEditingController(text: '25');
  final TextEditingController _tjMaxController = TextEditingController(
    text: '125',
  );
  final TextEditingController _rthJaController = TextEditingController(
    text: '50',
  );
  final TextEditingController _efficiencyController = TextEditingController(
    text: '90',
  );

  RegulatorCategory _selectedCategory = RegulatorCategory.linear;
  LinearRegulatorType _selectedLinearRegulator = LinearRegulatorType.lm317;
  SwitchingRegulatorType _selectedSwitchingRegulator =
      SwitchingRegulatorType.lm2596;

  String _selectedResistanceUnit = 'Ω';
  String _selectedCurrentUnit = 'µA';

  double _r2Value = 0.0;
  double _powerDissipation = 0.0;
  double _outputCurrent = 0.0;
  double _efficiency = 90.0;
  String _heatsinkAdvice = '';
  double _vin = 0.0;
  double _vout = 0.0;
  double _vref = 1.25;
  String _resultText = '';
  bool _showLinearParams = true;
  bool _showSwitchingParams = false;

  @override
  void initState() {
    super.initState();
    _updateRegulatorParameters();
  }

  void _updateRegulatorParameters() {
    setState(() {
      _showLinearParams = _selectedCategory == RegulatorCategory.linear;
      _showSwitchingParams = _selectedCategory == RegulatorCategory.switching;

      if (_selectedCategory == RegulatorCategory.linear) {
        switch (_selectedLinearRegulator) {
          case LinearRegulatorType.lm317:
            _vref = 1.25;
            _r1Controller.text = '240';
            break;
          case LinearRegulatorType.lm7805:
            _vref = 5.0;
            _r1Controller.text = '0';
            break;
          case LinearRegulatorType.lm7812:
            _vref = 12.0;
            _r1Controller.text = '0';
            break;
          case LinearRegulatorType.lm7824:
            _vref = 24.0;
            _r1Controller.text = '0';
            break;
          case LinearRegulatorType.lm7905:
            _vref = -5.0;
            _r1Controller.text = '0';
            break;
          case LinearRegulatorType.lm7912:
            _vref = -12.0;
            _r1Controller.text = '0';
            break;
          case LinearRegulatorType.lm7924:
            _vref = -24.0;
            _r1Controller.text = '0';
            break;
          case LinearRegulatorType.ams1117:
            _vref = 1.25;
            _r1Controller.text = '150';
            break;
          case LinearRegulatorType.ld1117:
            _vref = 1.25;
            _r1Controller.text = '150';
            break;
          case LinearRegulatorType.lt1083:
            _vref = 1.25;
            _r1Controller.text = '300';
            break;
        }
      } else {
        _efficiencyController.text = '90';
        switch (_selectedSwitchingRegulator) {
          case SwitchingRegulatorType.lm2596:
            _vref = 1.23;
            break;
          case SwitchingRegulatorType.xl4015:
            _vref = 1.25;
            break;
          case SwitchingRegulatorType.xl6009:
            _vref = 1.25;
            break;
          case SwitchingRegulatorType.mp1584:
            _vref = 0.8;
            break;
          case SwitchingRegulatorType.tps5430:
            _vref = 0.8;
            break;
          case SwitchingRegulatorType.tps7a47:
            _vref = 1.2;
            break;
        }
      }
      _calculate();
    });
  }

  void _calculate() {
    final vin = double.tryParse(_vinController.text) ?? 0;
    final vout = double.tryParse(_voutController.text) ?? 0;
    final r1 = double.tryParse(_r1Controller.text) ?? 0;
    final iadj = double.tryParse(_iadjController.text) ?? 0;
    final ta = double.tryParse(_taController.text) ?? 0;
    final tjMax = double.tryParse(_tjMaxController.text) ?? 0;
    final rthJa = double.tryParse(_rthJaController.text) ?? 0;
    final efficiency = double.tryParse(_efficiencyController.text) ?? 90;

    if (vin <= 0 || vout <= 0) return;

    setState(() {
      _vin = vin;
      _vout = vout;
      _efficiency = efficiency;

      if (_selectedCategory == RegulatorCategory.linear) {
        _calculateLinearRegulator(r1, iadj, ta, tjMax, rthJa);
      } else {
        _calculateSwitchingRegulator();
      }
    });
  }

  void _calculateLinearRegulator(
    double r1,
    double iadj,
    double ta,
    double tjMax,
    double rthJa,
  ) {
    final r1Ohms = _convertResistance(r1, _selectedResistanceUnit);
    final iadjAmps = _convertCurrent(iadj, _selectedCurrentUnit);

    if (_selectedLinearRegulator == LinearRegulatorType.lm317 ||
        _selectedLinearRegulator == LinearRegulatorType.ams1117 ||
        _selectedLinearRegulator == LinearRegulatorType.ld1117 ||
        _selectedLinearRegulator == LinearRegulatorType.lt1083) {
      _r2Value = (math.max(_vout, _vref) / _vref - 1) * r1Ohms;
    } else {
      _r2Value = 0;
    }

    _outputCurrent = _vref / r1Ohms + iadjAmps;
    _powerDissipation = (_vin - _vout).abs() * _outputCurrent;

    final requiredRth = (tjMax - ta) / _powerDissipation - rthJa;

    _heatsinkAdvice = requiredRth <= 0
        ? 'No se requiere disipador adicional'
        : 'Se necesita disipador con Rth < ${requiredRth.toStringAsFixed(2)} °C/W';

    _resultText =
        '''
Resultados:
- Resistencia R2: ${_r2Value.toStringAsFixed(2)} Ω
- Corriente de salida: ${(_outputCurrent * 1000).toStringAsFixed(2)} mA
- Potencia disipada: ${_powerDissipation.toStringAsFixed(2)} W
- $_heatsinkAdvice
''';
  }

  void _calculateSwitchingRegulator() {
    final inputCurrent =
        (_vout * _outputCurrent) / (_vin * (_efficiency / 100));
    _powerDissipation = (_vin * inputCurrent) - (_vout * _outputCurrent);

    _resultText =
        '''
Resultados (${_getSwitchingRegulatorName(_selectedSwitchingRegulator)}):
- Eficiencia: ${_efficiency.toStringAsFixed(1)}%
- Corriente de entrada estimada: ${inputCurrent.toStringAsFixed(3)} A
- Potencia disipada: ${_powerDissipation.toStringAsFixed(2)} W
- Frecuencia recomendada: ${_getSwitchingFrequency()} kHz
''';
  }

  String _getSwitchingFrequency() {
    switch (_selectedSwitchingRegulator) {
      case SwitchingRegulatorType.lm2596:
        return '150';
      case SwitchingRegulatorType.xl4015:
        return '180';
      case SwitchingRegulatorType.xl6009:
        return '400';
      case SwitchingRegulatorType.mp1584:
        return '500';
      case SwitchingRegulatorType.tps5430:
        return '500';
      case SwitchingRegulatorType.tps7a47:
        return '1000';
    }
  }

  double _convertResistance(double value, String unit) {
    switch (unit) {
      case 'kΩ':
        return value * 1000;
      case 'MΩ':
        return value * 1000000;
      default:
        return value;
    }
  }

  double _convertCurrent(double value, String unit) {
    switch (unit) {
      case 'mA':
        return value * 0.001;
      case 'A':
        return value;
      default:
        return value * 0.000001;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calculadora de Reguladores')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCategorySelector(),
            const SizedBox(height: 20),
            _buildRegulatorSelector(),
            const SizedBox(height: 20),
            _buildInputRow('Voltaje de Entrada (Vin)', _vinController, 'V', [
              'V',
            ], (value) => _calculate()),
            _buildInputRow(
              'Voltaje de Salida (Vout)',
              _voutController,
              'V',
              ['V'],
              (value) => _calculate(),
            ),
            if (_showLinearParams) ...[
              _buildInputRow(
                'Resistencia R1',
                _r1Controller,
                _selectedResistanceUnit,
                ['Ω', 'kΩ', 'MΩ'],
                (value) {
                  setState(() => _selectedResistanceUnit = value!);
                  _calculate();
                },
              ),
              _buildInputRow(
                'Corriente Iadj',
                _iadjController,
                _selectedCurrentUnit,
                ['µA', 'mA', 'A'],
                (value) {
                  setState(() => _selectedCurrentUnit = value!);
                  _calculate();
                },
              ),
            ],
            if (_showSwitchingParams) ...[
              _buildInputRow('Eficiencia (%)', _efficiencyController, '%', [
                '%',
              ], (value) => _calculate()),
            ],
            const SizedBox(height: 10),
            const Text(
              'Parámetros Térmicos:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            _buildInputRow('Temp. Ambiente (°C)', _taController, '°C', [
              '°C',
            ], (value) => _calculate()),
            _buildInputRow(
              'Temp. Máx. Juntura (°C)',
              _tjMaxController,
              '°C',
              ['°C'],
              (value) => _calculate(),
            ),
            _buildInputRow(
              'Rth Juntura-Aire (°C/W)',
              _rthJaController,
              '°C/W',
              ['°C/W'],
              (value) => _calculate(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculate,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
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

  Widget _buildCategorySelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Tipo de Regulador:', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ChoiceChip(
                  label: const Text('Lineales'),
                  selected: _selectedCategory == RegulatorCategory.linear,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedCategory = RegulatorCategory.linear;
                        _updateRegulatorParameters();
                      });
                    }
                  },
                ),
                ChoiceChip(
                  label: const Text('Conmutados'),
                  selected: _selectedCategory == RegulatorCategory.switching,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedCategory = RegulatorCategory.switching;
                        _updateRegulatorParameters();
                      });
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegulatorSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Modelo de Regulador:', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            if (_selectedCategory == RegulatorCategory.linear)
              DropdownButton<LinearRegulatorType>(
                value: _selectedLinearRegulator,
                isExpanded: true,
                items: LinearRegulatorType.values.map((type) {
                  return DropdownMenuItem<LinearRegulatorType>(
                    value: type,
                    child: Text(_getLinearRegulatorName(type)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedLinearRegulator = value!;
                    _updateRegulatorParameters();
                  });
                },
              )
            else
              DropdownButton<SwitchingRegulatorType>(
                value: _selectedSwitchingRegulator,
                isExpanded: true,
                items: SwitchingRegulatorType.values.map((type) {
                  return DropdownMenuItem<SwitchingRegulatorType>(
                    value: type,
                    child: Text(_getSwitchingRegulatorName(type)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSwitchingRegulator = value!;
                    _updateRegulatorParameters();
                  });
                },
              ),
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
          if (units.length > 1)
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: DropdownButton<String>(
                  value: selectedUnit,
                  isExpanded: true,
                  items: units
                      .map(
                        (unit) => DropdownMenuItem(
                          value: unit,
                          child: Text(unit, textAlign: TextAlign.center),
                        ),
                      )
                      .toList(),
                  onChanged: onUnitChanged,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildResultsCard() {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          _resultText,
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
      ),
    );
  }

  String _getLinearRegulatorName(LinearRegulatorType type) {
    switch (type) {
      case LinearRegulatorType.lm317:
        return 'LM317 (Ajustable 1.25V-37V)';
      case LinearRegulatorType.lm7805:
        return 'LM7805 (+5V Fijo)';
      case LinearRegulatorType.lm7812:
        return 'LM7812 (+12V Fijo)';
      case LinearRegulatorType.lm7824:
        return 'LM7824 (+24V Fijo)';
      case LinearRegulatorType.lm7905:
        return 'LM7905 (-5V Fijo)';
      case LinearRegulatorType.lm7912:
        return 'LM7912 (-12V Fijo)';
      case LinearRegulatorType.lm7924:
        return 'LM7924 (-24V Fijo)';
      case LinearRegulatorType.ams1117:
        return 'AMS1117 (3.3V/5V/Ajustable)';
      case LinearRegulatorType.ld1117:
        return 'LD1117 (LDO 3.3V/5V)';
      case LinearRegulatorType.lt1083:
        return 'LT1083 (Ajustable 3A)';
    }
  }

  String _getSwitchingRegulatorName(SwitchingRegulatorType type) {
    switch (type) {
      case SwitchingRegulatorType.lm2596:
        return 'LM2596 (Buck Step-Down)';
      case SwitchingRegulatorType.xl4015:
        return 'XL4015 (Buck 5A)';
      case SwitchingRegulatorType.xl6009:
        return 'XL6009 (Boost/Buck-Boost)';
      case SwitchingRegulatorType.mp1584:
        return 'MP1584 (Buck 3A)';
      case SwitchingRegulatorType.tps5430:
        return 'TPS5430 (Buck 3A)';
      case SwitchingRegulatorType.tps7a47:
        return 'TPS7A47 (LDO Switching)';
    }
  }
}
