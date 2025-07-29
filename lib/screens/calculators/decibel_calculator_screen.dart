// lib/screens/decibel_calculator_screen.dart
import 'package:flutter/material.dart';
import 'dart:math' as math; // Para log10

class DecibelCalculatorScreen extends StatefulWidget {
  const DecibelCalculatorScreen({super.key});

  @override
  State<DecibelCalculatorScreen> createState() =>
      _DecibelCalculatorScreenState();
}

enum DecibelMode { power, voltage }

class _DecibelCalculatorScreenState extends State<DecibelCalculatorScreen> {
  final TextEditingController _input1Controller = TextEditingController();
  final TextEditingController _input2Controller = TextEditingController();
  final TextEditingController _dbValueController = TextEditingController();

  DecibelMode _selectedMode = DecibelMode.power; // Por defecto, modo Potencia

  String _result = '';
  String _explanation = '';

  @override
  void dispose() {
    _input1Controller.dispose();
    _input2Controller.dispose();
    _dbValueController.dispose();
    super.dispose();
  }

  void _calculateDecibels() {
    setState(() {
      _result = '';
      _explanation = '';
    });

    final double? value1 = double.tryParse(_input1Controller.text);
    final double? value2 = double.tryParse(_input2Controller.text);
    final double? dbValue = double.tryParse(_dbValueController.text);

    if (_dbValueController.text.isNotEmpty && dbValue != null) {
      // Calcular valor lineal a partir de dB
      if (_selectedMode == DecibelMode.power) {
        double linearValue = math.pow(10, dbValue / 10).toDouble();
        _result = 'Valor Lineal (Potencia): ${linearValue.toStringAsFixed(4)}';
        _explanation = 'Power (dB) = 10 * log10(P2/P1) => P2/P1 = 10^(dB/10)';
      } else {
        // Voltage mode
        double linearValue = math.pow(10, dbValue / 20).toDouble();
        _result = 'Valor Lineal (Voltaje): ${linearValue.toStringAsFixed(4)}';
        _explanation = 'Voltage (dB) = 20 * log10(V2/V1) => V2/V1 = 10^(dB/20)';
      }
    } else if (value1 != null && value2 != null && value1 != 0) {
      // Calcular dB a partir de valores lineales
      double ratio = value2 / value1;
      double calculatedDb;
      if (_selectedMode == DecibelMode.power) {
        calculatedDb = 10 * math.log(ratio) / math.log(10); // 10 * log10(P2/P1)
        _explanation = 'dB (Potencia) = 10 * log10(Salida / Entrada)';
      } else {
        // Voltage mode
        calculatedDb = 20 * math.log(ratio) / math.log(10); // 20 * log10(V2/V1)
        _explanation = 'dB (Voltaje) = 20 * log10(Salida / Entrada)';
      }
      _result = 'Decibelios (dB): ${calculatedDb.toStringAsFixed(4)} dB';
    } else {
      _result = 'Introduce dos valores (Entrada y Salida) o un valor en dB.';
      _explanation = '';
    }
  }

  void _clearFields() {
    setState(() {
      _input1Controller.clear();
      _input2Controller.clear();
      _dbValueController.clear();
      _result = '';
      _explanation = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cálculo de Decibelios (dB)'),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Calcula la ganancia/pérdida en dB o convierte dB a valores lineales.',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Selector de modo (Potencia vs Voltaje)
            SegmentedButton<DecibelMode>(
              segments: const <ButtonSegment<DecibelMode>>[
                ButtonSegment<DecibelMode>(
                  value: DecibelMode.power,
                  label: Text('Potencia (dBm, dBW)'),
                  icon: Icon(Icons.power),
                ),
                ButtonSegment<DecibelMode>(
                  value: DecibelMode.voltage,
                  label: Text('Voltaje (dBV, dBu)'),
                  icon: Icon(Icons.flash_on),
                ),
              ],
              selected: <DecibelMode>{_selectedMode},
              onSelectionChanged: (Set<DecibelMode> newSelection) {
                setState(() {
                  _selectedMode = newSelection.first;
                  _clearFields(); // Limpiar campos al cambiar de modo
                });
              },
              style: SegmentedButton.styleFrom(
                selectedForegroundColor: colorScheme.onPrimaryContainer,
                selectedBackgroundColor: colorScheme.primaryContainer,
                foregroundColor: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),

            Text(
              'Para calcular dB (Ganancia/Pérdida):',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _input1Controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Valor de Entrada (P1/V1)',
                hintText: 'Ej: 100',
                border: const OutlineInputBorder(),
                suffixText: _selectedMode == DecibelMode.power ? 'W' : 'V',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _input2Controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Valor de Salida (P2/V2)',
                hintText: 'Ej: 200',
                border: const OutlineInputBorder(),
                suffixText: _selectedMode == DecibelMode.power ? 'W' : 'V',
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'O, para convertir de dB a valor lineal:',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _dbValueController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Valor en Decibelios (dB)',
                hintText: 'Ej: 3 (para +3dB de ganancia)',
                border: OutlineInputBorder(),
                suffixText: 'dB',
              ),
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _calculateDecibels,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    if (_explanation.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          _explanation,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontStyle: FontStyle.italic,
                                color: colorScheme.onSurfaceVariant,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
