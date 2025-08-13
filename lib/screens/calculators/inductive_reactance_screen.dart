// lib/screens/inductive_reactance_screen.dart
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:calculadora_electronica/utils/unit_utils.dart';
import 'package:provider/provider.dart';
import 'package:calculadora_electronica/main.dart';

class InductiveReactanceScreen extends StatefulWidget {
  const InductiveReactanceScreen({super.key});

  @override
  State<InductiveReactanceScreen> createState() =>
      _InductiveReactanceScreenState();
}

class _InductiveReactanceScreenState extends State<InductiveReactanceScreen> {
  final TextEditingController _frequencyController = TextEditingController();
  final TextEditingController _inductanceController = TextEditingController();
  final TextEditingController _resistanceController = TextEditingController();

  String _result = '';
  String _frequencyUnit = 'Hz';
  String _inductanceUnit = 'H';
  String _resistanceUnit = 'Ω';
  String _qFactorResult = '';
  String _impedanceResult = '';

  final List<String> _frequencyUnits = ['Hz', 'kHz', 'MHz', 'GHz'];
  final List<String> _inductanceUnits = ['H', 'mH', 'µH', 'nH'];
  final List<String> _resistanceUnits = ['Ω', 'kΩ', 'MΩ'];

  @override
  void dispose() {
    _frequencyController.dispose();
    _inductanceController.dispose();
    _resistanceController.dispose();
    super.dispose();
  }

  void _calculateReactance() {
    setState(() {
      _result = '';
      _qFactorResult = '';
      _impedanceResult = '';
    });

    final double? frequencyInput = double.tryParse(_frequencyController.text);
    final double? inductanceInput = double.tryParse(_inductanceController.text);
    final double? resistanceInput = double.tryParse(_resistanceController.text);

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

    double reactanceOhm = 2 * math.pi * frequencyHz * inductanceH;
    String formattedReactance = UnitUtils.formatResult(
      reactanceOhm,
      UnitCategory.resistance,
    );

    setState(() {
      _result = 'Reactancia Inductiva (XL): $formattedReactance';
    });

    // Cálculo de modo profesional
    if (resistanceInput != null && resistanceInput > 0) {
      double resistanceOhm = UnitUtils.convertToBase(
        resistanceInput,
        _resistanceUnit,
        UnitCategory.resistance,
      );

      // Calcular Factor Q (Q = XL / R)
      double qFactor = reactanceOhm / resistanceOhm;
      _qFactorResult = 'Factor de Calidad (Q): ${qFactor.toStringAsFixed(2)}';

      // Calcular Impedancia (Z = sqrt(R^2 + XL^2))
      double impedance = math.sqrt(
        math.pow(resistanceOhm, 2) + math.pow(reactanceOhm, 2),
      );
      String formattedImpedance = UnitUtils.formatResult(
        impedance,
        UnitCategory.resistance,
      );
      _impedanceResult = 'Impedancia (Z): $formattedImpedance';
    }
  }

  void _clearFields() {
    setState(() {
      _frequencyController.clear();
      _inductanceController.clear();
      _resistanceController.clear();
      _result = '';
      _qFactorResult = '';
      _impedanceResult = '';
      _frequencyUnit = 'Hz';
      _inductanceUnit = 'H';
      _resistanceUnit = 'Ω';
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final settings = Provider.of<AppSettings>(context);

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
            _buildInputRow(
              _frequencyController,
              'Frecuencia (f)',
              'Ej: 1000',
              _frequencyUnit,
              _frequencyUnits,
              (newValue) => setState(() => _frequencyUnit = newValue!),
            ),
            const SizedBox(height: 16),
            _buildInputRow(
              _inductanceController,
              'Inductancia (L)',
              'Ej: 0.01',
              _inductanceUnit,
              _inductanceUnits,
              (newValue) => setState(() => _inductanceUnit = newValue!),
            ),
            const SizedBox(height: 24),
            // Sección de modo profesional
            if (settings.professionalMode) ...[
              _buildProfessionalModeSection(colorScheme),
              const SizedBox(height: 24),
            ],
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
            if (_qFactorResult.isNotEmpty || _impedanceResult.isNotEmpty)
              const SizedBox(height: 12),
            if (_qFactorResult.isNotEmpty || _impedanceResult.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.secondaryContainer.withAlpha(128),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    if (_qFactorResult.isNotEmpty)
                      Text(
                        _qFactorResult,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSecondaryContainer,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    if (_impedanceResult.isNotEmpty)
                      Text(
                        _impedanceResult,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSecondaryContainer,
                        ),
                        textAlign: TextAlign.center,
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputRow(
    TextEditingController controller,
    String labelText,
    String hintText,
    String unitValue,
    List<String> units,
    ValueChanged<String?> onChanged,
  ) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: labelText,
              hintText: hintText,
              border: const OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(width: 8),
        DropdownButton<String>(
          value: unitValue,
          onChanged: onChanged,
          items: units.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
        ),
      ],
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
            Text(
              'Cálculos adicionales para un circuito R-L en serie:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            _buildInputRow(
              _resistanceController,
              'Resistencia (R)',
              'Ej: 100',
              _resistanceUnit,
              _resistanceUnits,
              (newValue) => setState(() => _resistanceUnit = newValue!),
            ),
          ],
        ),
      ),
    );
  }
}
