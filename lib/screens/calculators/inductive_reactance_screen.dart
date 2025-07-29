// lib/screens/inductive_reactance_screen.dart
import 'package:flutter/material.dart';
import 'dart:math' as math; // Para math.pi
import 'package:calculadora_electronica/utils/unit_utils.dart'; // Para las utilidades de unidades

class InductiveReactanceScreen extends StatefulWidget {
  const InductiveReactanceScreen({super.key});

  @override
  State<InductiveReactanceScreen> createState() =>
      _InductiveReactanceScreenState();
}

class _InductiveReactanceScreenState extends State<InductiveReactanceScreen> {
  final TextEditingController _frequencyController = TextEditingController();
  final TextEditingController _inductanceController = TextEditingController();

  String _result = '';
  String _frequencyUnit = 'Hz';
  String _inductanceUnit = 'H';

  final List<String> _frequencyUnits = ['Hz', 'kHz', 'MHz', 'GHz'];
  final List<String> _inductanceUnits = ['H', 'mH', 'µH', 'nH'];

  @override
  void dispose() {
    _frequencyController.dispose();
    _inductanceController.dispose();
    super.dispose();
  }

  void _calculateReactance() {
    setState(() {
      _result = ''; // Limpiar resultado anterior
    });

    final double? frequencyInput = double.tryParse(_frequencyController.text);
    final double? inductanceInput = double.tryParse(_inductanceController.text);

    if (frequencyInput == null || inductanceInput == null) {
      setState(() {
        _result = 'Por favor, introduce la Frecuencia y la Inductancia.';
      });
      return;
    }

    if (frequencyInput <= 0 || inductanceInput <= 0) {
      setState(() {
        _result =
            'Los valores de Frecuencia e Inductancia deben ser mayores que cero.';
      });
      return;
    }

    // Convertir a unidades base (Hz y Henrios)
    double frequencyHz = UnitUtils.convertToBase(
      frequencyInput,
      _frequencyUnit,
      UnitCategory.frequency,
    );
    double inductanceH = UnitUtils.convertToBase(
      inductanceInput,
      _inductanceUnit,
      UnitCategory.inductance,
    );

    // Fórmula: XL = 2 * pi * f * L
    double reactanceOhm = 2 * math.pi * frequencyHz * inductanceH;

    // Convertir el resultado a una unidad más legible (ej. Ohmios, kOhmios)
    String formattedReactance = UnitUtils.formatResult(
      reactanceOhm,
      UnitCategory.resistance,
    );

    setState(() {
      _result = 'Reactancia Inductiva (XL): $formattedReactance';
    });
  }

  void _clearFields() {
    setState(() {
      _frequencyController.clear();
      _inductanceController.clear();
      _result = '';
      _frequencyUnit = 'Hz';
      _inductanceUnit = 'H';
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reactancia Inductiva (XL)'),
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
              'Calcula la reactancia inductiva (XL) de un inductor a una frecuencia dada.',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _frequencyController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Frecuencia (f)',
                      hintText: 'Ej: 1000',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _frequencyUnit,
                  onChanged: (String? newValue) {
                    setState(() {
                      _frequencyUnit = newValue!;
                    });
                  },
                  items: _frequencyUnits.map<DropdownMenuItem<String>>((
                    String value,
                  ) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _inductanceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Inductancia (L)',
                      hintText: 'Ej: 0.01',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _inductanceUnit,
                  onChanged: (String? newValue) {
                    setState(() {
                      _inductanceUnit = newValue!;
                    });
                  },
                  items: _inductanceUnits.map<DropdownMenuItem<String>>((
                    String value,
                  ) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _calculateReactance,
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
                child: Text(
                  _result,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onPrimaryContainer,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
