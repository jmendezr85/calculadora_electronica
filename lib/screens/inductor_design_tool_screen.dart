// lib/screens/inductor_design_tool_screen.dart

import 'package:flutter/material.dart';
import 'dart:math'; // Para pi

class InductorDesignToolScreen extends StatefulWidget {
  const InductorDesignToolScreen({super.key});

  @override
  State<InductorDesignToolScreen> createState() =>
      _InductorDesignToolScreenState();
}

class _InductorDesignToolScreenState extends State<InductorDesignToolScreen> {
  final TextEditingController _turnsController = TextEditingController();
  final TextEditingController _diameterController = TextEditingController();
  final TextEditingController _lengthController = TextEditingController();

  String _diameterUnit = 'mm';
  String _lengthUnit = 'mm';
  String _inductanceUnit =
      'µH'; // Microhenrios como unidad de salida por defecto

  final List<String> _lengthUnits = ['mm', 'cm', 'inches', 'm'];
  final List<String> _inductanceUnits = ['nH', 'µH', 'mH', 'H'];

  String _result = '';
  final double _mu0 =
      4 * pi * pow(10, -7); // Permeabilidad del espacio libre (H/m)

  // --- Funciones de Conversión de Unidades ---
  double _convertLengthToMeters(double value, String unit) {
    switch (unit) {
      case 'mm':
        return value / 1000;
      case 'cm':
        return value / 100;
      case 'inches':
        return value * 0.0254; // 1 inch = 0.0254 meters
      case 'm':
      default:
        return value;
    }
  }

  double _convertInductanceToSelectedUnit(double henryValue, String unit) {
    switch (unit) {
      case 'nH':
        return henryValue * pow(10, 9);
      case 'µH':
        return henryValue * pow(10, 6);
      case 'mH':
        return henryValue * pow(10, 3);
      case 'H':
      default:
        return henryValue;
    }
  }

  void _calculateInductance() {
    setState(() {
      final int turns = int.tryParse(_turnsController.text) ?? 0;
      final double rawDiameter =
          double.tryParse(_diameterController.text) ?? 0.0;
      final double rawLength = double.tryParse(_lengthController.text) ?? 0.0;

      if (turns <= 0 || rawDiameter <= 0 || rawLength <= 0) {
        _result = 'Ingrese valores válidos y positivos.';
        return;
      }

      // Convertir diámetro y longitud a metros
      final double diameterMeters = _convertLengthToMeters(
        rawDiameter,
        _diameterUnit,
      );
      final double lengthMeters = _convertLengthToMeters(
        rawLength,
        _lengthUnit,
      );

      // Calcular radio en metros
      final double radiusMeters = diameterMeters / 2;

      // Fórmula para solenoide de núcleo de aire (en Henrys)
      // L = (μ0 * N^2 * π * r^2) / l
      final double inductanceHenry =
          (_mu0 * pow(turns, 2) * pi * pow(radiusMeters, 2)) / lengthMeters;

      // Convertir a la unidad de salida seleccionada
      final double finalInductance = _convertInductanceToSelectedUnit(
        inductanceHenry,
        _inductanceUnit,
      );

      _result = '${finalInductance.toStringAsFixed(4)} $_inductanceUnit';
    });
  }

  void _clearFields() {
    setState(() {
      _turnsController.clear();
      _diameterController.clear();
      _lengthController.clear();
      _diameterUnit = 'mm';
      _lengthUnit = 'mm';
      _inductanceUnit = 'µH';
      _result = '';
    });
  }

  @override
  void dispose() {
    _turnsController.dispose();
    _diameterController.dispose();
    _lengthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Herramienta de Diseño de Inductores'),
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
              'Diseño para Inductores Solenoides de Núcleo de Aire.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            _buildInputField(
              controller: _turnsController,
              labelText: 'Número de Vueltas (N)',
              hintText: 'Ej: 10',
              keyboardType: TextInputType.number,
              icon: Icons.loop,
            ),
            const SizedBox(height: 15),
            _buildUnitInputField(
              controller: _diameterController,
              labelText: 'Diámetro de la Bobina (d)',
              hintText: 'Ej: 10',
              unit: _diameterUnit,
              units: _lengthUnits,
              onUnitChanged: (newValue) {
                setState(() {
                  _diameterUnit = newValue!;
                });
              },
              icon: Icons.circle,
            ),
            const SizedBox(height: 15),
            _buildUnitInputField(
              controller: _lengthController,
              labelText: 'Longitud de la Bobina (l)',
              hintText: 'Ej: 20',
              unit: _lengthUnit,
              units: _lengthUnits,
              onUnitChanged: (newValue) {
                setState(() {
                  _lengthUnit = newValue!;
                });
              },
              icon: Icons.straighten,
            ),
            const SizedBox(height: 20),
            Text(
              'Unidad de Inductancia de Salida:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            DropdownButton<String>(
              value: _inductanceUnit,
              isExpanded: true,
              items: _inductanceUnits.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _inductanceUnit = newValue!;
                  // Recalcular el resultado si ya hay datos y el formato cambia
                  if (_result.isNotEmpty &&
                      _result != 'Ingrese valores válidos y positivos.') {
                    _calculateInductance();
                  }
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculateInductance,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text('Calcular Inductancia'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _clearFields,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: Theme.of(context).colorScheme.errorContainer,
                foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
              ),
              child: const Text('Borrar Campos'),
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
                      'Inductancia Calculada:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        _result.isEmpty
                            ? 'Ingrese datos para calcular.'
                            : _result,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineMedium!
                            .copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget genérico para campos de entrada de texto puro (sin unidad)
  Widget _buildInputField({
    required TextEditingController controller,
    required String labelText,
    String? hintText,
    TextInputType keyboardType = TextInputType.text,
    IconData? icon,
  }) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, color: Theme.of(context).colorScheme.secondary),
          const SizedBox(width: 10),
        ],
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              labelText: labelText,
              hintText: hintText,
              border: const OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  // Widget genérico para campos de entrada con selector de unidad e icono
  Widget _buildUnitInputField({
    required TextEditingController controller,
    required String labelText,
    String? hintText,
    required String unit,
    required List<String> units,
    required ValueChanged<String?> onUnitChanged,
    IconData? icon,
  }) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, color: Theme.of(context).colorScheme.secondary),
          const SizedBox(width: 10),
        ],
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
