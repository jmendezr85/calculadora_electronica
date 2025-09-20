import 'package:calculadora_electronica/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LedResistorScreen extends StatefulWidget {
  const LedResistorScreen({super.key});

  @override
  State<LedResistorScreen> createState() => _LedResistorScreenState();
}

class _LedResistorScreenState extends State<LedResistorScreen> {
  final TextEditingController _supplyVoltageController =
      TextEditingController();
  final TextEditingController _ledVoltageDropController =
      TextEditingController();
  final TextEditingController _ledCurrentController = TextEditingController();
  final TextEditingController _ledsInSeriesController = TextEditingController(
    text: '1',
  );

  String _result = '';
  String _powerResult = '';
  String _standardResistorResult = '';
  bool _isSeriesConnection = true;

  @override
  void dispose() {
    _supplyVoltageController.dispose();
    _ledVoltageDropController.dispose();
    _ledCurrentController.dispose();
    _ledsInSeriesController.dispose();
    super.dispose();
  }

  void _calculateLedResistor() {
    setState(() {
      _result = '';
      _powerResult = '';
      _standardResistorResult = '';
    });

    final double? supplyVoltage = double.tryParse(
      _supplyVoltageController.text,
    );
    final double? ledVoltageDrop = double.tryParse(
      _ledVoltageDropController.text,
    );
    final double? ledCurrent = double.tryParse(_ledCurrentController.text);
    final int? numLeds = int.tryParse(_ledsInSeriesController.text);

    if (supplyVoltage == null ||
        ledVoltageDrop == null ||
        ledCurrent == null ||
        numLeds == null) {
      setState(() {
        _result = 'Por favor, introduce todos los valores.';
      });
      return;
    }

    if (supplyVoltage <= 0 ||
        ledVoltageDrop <= 0 ||
        ledCurrent <= 0 ||
        numLeds <= 0) {
      setState(() {
        _result = 'Los valores deben ser mayores que cero.';
      });
      return;
    }

    double totalLedVoltage;
    if (_isSeriesConnection) {
      totalLedVoltage = ledVoltageDrop * numLeds;
    } else {
      totalLedVoltage = ledVoltageDrop;
    }

    if (totalLedVoltage >= supplyVoltage) {
      setState(() {
        _result =
            'Error: El voltaje total del/los LED(s) debe ser menor que el voltaje de la fuente.';
      });
      return;
    }

    final double ledCurrentAmps = ledCurrent / 1000.0;

    final double requiredResistance =
        (supplyVoltage - totalLedVoltage) / ledCurrentAmps;

    setState(() {
      _result =
          'Resistencia Requerida: ${_formatResistance(requiredResistance)}';

      final double resistorVoltage = supplyVoltage - totalLedVoltage;
      final double powerDissipation = resistorVoltage * ledCurrentAmps;

      _powerResult = 'Potencia Disipada: ${_formatPower(powerDissipation)}';

      final double standardResistor = _getStandardResistorValue(
        requiredResistance,
      );
      _standardResistorResult =
          'Valor estándar (E24): ${_formatResistance(standardResistor)}';
    });
  }

  double _getStandardResistorValue(double requiredResistance) {
    final List<double> e24 = [
      1.0,
      1.1,
      1.2,
      1.3,
      1.5,
      1.6,
      1.8,
      2.0,
      2.2,
      2.4,
      2.7,
      3.0,
      3.3,
      3.6,
      3.9,
      4.3,
      4.7,
      5.1,
      5.6,
      6.2,
      6.8,
      7.5,
      8.2,
      9.1,
    ];

    double nearestValue = e24[0];
    double lowestDifference = (requiredResistance / nearestValue - 1).abs();

    for (var value in e24) {
      double magnitude = 1;
      while (value * magnitude < requiredResistance) {
        magnitude *= 10;
      }
      final candidates = [value * magnitude, value * magnitude / 10];
      for (var candidate in candidates) {
        final double difference = (requiredResistance / candidate - 1).abs();
        if (difference < lowestDifference) {
          lowestDifference = difference;
          nearestValue = candidate;
        }
      }
    }
    return nearestValue;
  }

  String _formatResistance(double value) {
    if (value.abs() >= 1e9) {
      return '${(value / 1e9).toStringAsFixed(2)} GΩ';
    } else if (value.abs() >= 1e6) {
      return '${(value / 1e6).toStringAsFixed(2)} MΩ';
    } else if (value.abs() >= 1e3) {
      return '${(value / 1e3).toStringAsFixed(2)} kΩ';
    } else {
      return '${value.toStringAsFixed(2)} Ω';
    }
  }

  String _formatPower(double value) {
    if (value.abs() >= 1) {
      return '${value.toStringAsFixed(3)} W';
    } else if (value.abs() >= 1e-3) {
      return '${(value / 1e-3).toStringAsFixed(3)} mW';
    } else if (value.abs() >= 1e-6) {
      return '${(value / 1e-6).toStringAsFixed(3)} µW';
    } else {
      return '${value.toStringAsFixed(3)} W';
    }
  }

  void _clearFields() {
    _supplyVoltageController.clear();
    _ledVoltageDropController.clear();
    _ledCurrentController.clear();
    _ledsInSeriesController.text = '1';
    setState(() {
      _result = '';
      _powerResult = '';
      _standardResistorResult = '';
      _isSeriesConnection = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final settings = Provider.of<AppSettings>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resistencia para LED'),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _supplyVoltageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Voltaje de la Fuente (Vs)',
                hintText: 'Ej: 12.0',
                border: OutlineInputBorder(),
                suffixText: 'V',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _ledVoltageDropController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Voltaje de Caída del LED (Vf)',
                hintText: 'Ej: 2.0 (para LED rojo)',
                border: OutlineInputBorder(),
                suffixText: 'V',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _ledCurrentController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Corriente del LED (I)',
                hintText: 'Ej: 20 (valor en mA)',
                border: OutlineInputBorder(),
                suffixText: 'mA',
              ),
            ),
            const SizedBox(height: 24),
            // Sección de Modo Profesional
            if (settings.professionalMode) ...[
              _buildProfessionalModeSection(colorScheme),
              const SizedBox(height: 24),
            ],
            ElevatedButton(
              onPressed: _calculateLedResistor,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Calcular', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: _clearFields,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Limpiar', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 24),
            if (_result.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withAlpha(128),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      _result,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onPrimaryContainer,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    if (settings.professionalMode &&
                        _powerResult.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        _powerResult,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(color: colorScheme.onPrimaryContainer),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _standardResistorResult,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(color: colorScheme.onPrimaryContainer),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfessionalModeSection(ColorScheme colorScheme) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Opciones de Modo Profesional',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
                Icon(Icons.military_tech, color: colorScheme.primary),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            TextField(
              controller: _ledsInSeriesController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Número de LEDs en Serie',
                hintText: 'Ej: 1',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.numbers),
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Conexión en Serie'),
              subtitle: const Text(
                'Activar para LEDs en serie, desactivar para paralelo.',
              ),
              value: _isSeriesConnection,
              onChanged: (bool value) {
                setState(() {
                  _isSeriesConnection = value;
                });
              },
              secondary: Icon(
                _isSeriesConnection ? Icons.linear_scale : Icons.fork_right,
                color: colorScheme.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
