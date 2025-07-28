// lib/screens/pcb_trace_width_calculator_screen.dart

import 'package:flutter/material.dart';
import 'dart:math';

class PcbTraceWidthCalculatorScreen extends StatefulWidget {
  const PcbTraceWidthCalculatorScreen({super.key});

  @override
  State<PcbTraceWidthCalculatorScreen> createState() =>
      _PcbTraceWidthCalculatorScreenState();
}

class _PcbTraceWidthCalculatorScreenState
    extends State<PcbTraceWidthCalculatorScreen> {
  // Controladores para los campos de entrada
  final TextEditingController _currentController = TextEditingController();
  final TextEditingController _tempRiseController = TextEditingController();
  final TextEditingController _ambientTempController =
      TextEditingController(); // Para cálculos de resistencia más precisos
  final TextEditingController _traceLengthController = TextEditingController();

  // Unidades seleccionadas
  String _currentUnit = 'A';
  String _copperThicknessOz = '1 oz'; // Grosor de cobre por defecto
  String _layerType = 'Externa'; // Tipo de capa por defecto
  String _traceLengthUnit = 'mm';
  String _outputWidthUnit = 'mils'; // Unidad de salida de ancho por defecto

  // Listas de opciones para los Dropdowns
  final List<String> _currentUnits = ['mA', 'A'];
  final List<String> _copperThicknessOptions = [
    '0.5 oz',
    '1 oz',
    '2 oz',
    '3 oz',
  ];
  final List<String> _layerTypes = ['Externa', 'Interna'];
  final List<String> _lengthUnits = ['mm', 'cm', 'inches', 'm'];
  final List<String> _widthUnits = ['mils', 'mm', 'inches'];

  // Resultados
  String _traceWidthResult = '';
  String _traceResistanceResult = '';
  String _voltageDropResult = '';
  String _powerDissipationResult = '';

  // Constantes para IPC-2221 (mils, Amps, °C, oz)
  // Fuente: https://www.smps.us/pcb-traces-ipc2221.html
  static const double kExternal = 0.048;
  static const double kInternal = 0.024;
  static const double a = 0.44;
  static const double b1 = 0.725;
  static const double b2 = 0.386;

  // Resistividad del cobre (Ohm-metros) a 20°C y coeficiente de temperatura
  static const double rhoCopper20C = 1.72e-8; // Ohm-m
  static const double alphaCopper = 0.0039; // /°C

  // Conversión de oz a metros (grosor del cobre)
  // 1 oz = 1.37 mils = 34.7985 micrometros = 0.0000347985 metros
  final Map<String, double> _copperOzToMeters = {
    '0.5 oz': 0.5 * 0.0000347985,
    '1 oz': 1.0 * 0.0000347985,
    '2 oz': 2.0 * 0.0000347985,
    '3 oz': 3.0 * 0.0000347985,
  };

  @override
  void dispose() {
    _currentController.dispose();
    _tempRiseController.dispose();
    _ambientTempController.dispose();
    _traceLengthController.dispose();
    super.dispose();
  }

  // --- Funciones de Conversión de Unidades ---

  double _convertCurrentToBase(double value, String unit) {
    return unit == 'mA' ? value / 1000 : value; // Convertir a Amperios
  }

  double _convertLengthToMeters(double value, String unit) {
    switch (unit) {
      case 'mm':
        return value / 1000;
      case 'cm':
        return value / 100;
      case 'inches':
        return value * 0.0254;
      case 'm':
      default:
        return value;
    }
  }

  double _convertWidthFromMils(double mils, String targetUnit) {
    switch (targetUnit) {
      case 'mils':
        return mils;
      case 'mm':
        return mils * 0.0254; // 1 mil = 0.0254 mm
      case 'inches':
        return mils / 1000; // 1 mil = 0.001 inches
      default:
        return mils;
    }
  }

  // --- Lógica de Cálculo Principal ---

  void _calculateTraceProperties() {
    setState(() {
      final double current = _convertCurrentToBase(
        double.tryParse(_currentController.text) ?? 0.0,
        _currentUnit,
      );
      final double tempRise = double.tryParse(_tempRiseController.text) ?? 0.0;
      final double ambientTemp =
          double.tryParse(_ambientTempController.text) ??
          20.0; // Default a 20C si no se especifica
      final double copperThicknessOz =
          double.tryParse(_copperThicknessOz.replaceAll(' oz', '')) ?? 1.0;

      if (current <= 0 || tempRise <= 0 || copperThicknessOz <= 0) {
        _traceWidthResult = 'Ingrese valores válidos.';
        _traceResistanceResult = '';
        _voltageDropResult = '';
        _powerDissipationResult = '';
        return;
      }

      // 1. Calcular Ancho de Pista (en mils)
      final double k = (_layerType == 'Externa') ? kExternal : kInternal;
      final double numerator = current;
      final double denominator =
          k * pow(tempRise, b1) * pow(copperThicknessOz, b2);
      final double widthMils = pow(numerator / denominator, 1 / a).toDouble();

      _traceWidthResult =
          '${_convertWidthFromMils(widthMils, _outputWidthUnit).toStringAsFixed(3)} $_outputWidthUnit';

      // 2. Cálculos de Resistencia, Caída de Voltaje y Disipación de Potencia (si se proporciona la longitud)
      final double rawTraceLength =
          double.tryParse(_traceLengthController.text) ?? 0.0;
      if (rawTraceLength > 0) {
        final double traceLengthMeters = _convertLengthToMeters(
          rawTraceLength,
          _traceLengthUnit,
        );
        final double copperThicknessMeters =
            _copperOzToMeters[_copperThicknessOz] ?? _copperOzToMeters['1 oz']!;

        // Convertir ancho de mils a metros
        final double widthMeters =
            widthMils * 0.0254 / 1000; // mils to inches, then inches to meters

        // Calcular resistividad del cobre a la temperatura final
        final double finalTraceTemperature = ambientTemp + tempRise;
        final double rhoCopperTemp =
            rhoCopper20C * (1 + alphaCopper * (finalTraceTemperature - 20));

        // Área de la sección transversal de la pista
        final double crossSectionalArea = widthMeters * copperThicknessMeters;

        if (crossSectionalArea > 0) {
          final double resistance =
              (rhoCopperTemp * traceLengthMeters) / crossSectionalArea;
          final double voltageDrop = current * resistance;
          final double powerDissipation = current * current * resistance;

          _traceResistanceResult = '${resistance.toStringAsFixed(4)} Ω';
          _voltageDropResult = '${voltageDrop.toStringAsFixed(4)} V';
          _powerDissipationResult = '${powerDissipation.toStringAsFixed(4)} W';
        } else {
          _traceResistanceResult = 'Error de cálculo (área=0)';
          _voltageDropResult = '';
          _powerDissipationResult = '';
        }
      } else {
        _traceResistanceResult = 'Longitud no especificada';
        _voltageDropResult = 'Longitud no especificada';
        _powerDissipationResult = 'Longitud no especificada';
      }
    });
  }

  void _clearFields() {
    setState(() {
      _currentController.clear();
      _tempRiseController.clear();
      _ambientTempController.clear();
      _traceLengthController.clear();

      _currentUnit = 'A';
      _copperThicknessOz = '1 oz';
      _layerType = 'Externa';
      _traceLengthUnit = 'mm';
      _outputWidthUnit = 'mils';

      _traceWidthResult = '';
      _traceResistanceResult = '';
      _voltageDropResult = '';
      _powerDissipationResult = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora de Ancho de Pista PCB'),
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
              'Calcule el ancho de pista requerido para su PCB y sus propiedades eléctricas.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            _buildUnitInputField(
              controller: _currentController,
              labelText: 'Corriente Máxima (I)',
              hintText: 'Ej: 1.5',
              unit: _currentUnit,
              units: _currentUnits,
              onUnitChanged: (newValue) {
                setState(() {
                  _currentUnit = newValue!;
                });
              },
              icon: Icons.flash_on,
            ),
            const SizedBox(height: 15),
            _buildInputField(
              controller: _tempRiseController,
              labelText: 'Aumento de Temperatura Permitido (ΔT en °C)',
              hintText: 'Ej: 10 (grados Celsius)',
              keyboardType: TextInputType.number,
              icon: Icons.thermostat,
            ),
            const SizedBox(height: 15),
            Text(
              'Grosor del Cobre:',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            DropdownButton<String>(
              value: _copperThicknessOz,
              isExpanded: true,
              items: _copperThicknessOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _copperThicknessOz = newValue!;
                });
              },
            ),
            const SizedBox(height: 15),
            Text(
              'Tipo de Capa:',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Row(
              children: _layerTypes.map((type) {
                return Expanded(
                  child: RadioListTile<String>(
                    title: Text(type),
                    value: type,
                    groupValue: _layerType,
                    onChanged: (value) {
                      setState(() {
                        _layerType = value!;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 15),
            _buildUnitInputField(
              controller: _traceLengthController,
              labelText: 'Longitud de Pista (L) (Opcional)',
              hintText: 'Ej: 50 (para resistencia, caída de voltaje, etc.)',
              unit: _traceLengthUnit,
              units: _lengthUnits,
              onUnitChanged: (newValue) {
                setState(() {
                  _traceLengthUnit = newValue!;
                });
              },
              icon: Icons.straighten,
            ),
            const SizedBox(height: 15),
            _buildInputField(
              controller: _ambientTempController,
              labelText: 'Temperatura Ambiente (T_ambiente en °C) (Opcional)',
              hintText: 'Ej: 25 (para cálculo de resistencia)',
              keyboardType: TextInputType.number,
              icon: Icons.thermostat_outlined,
            ),
            const SizedBox(height: 20),
            Text(
              'Unidad de Salida del Ancho:',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            DropdownButton<String>(
              value: _outputWidthUnit,
              isExpanded: true,
              items: _widthUnits.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _outputWidthUnit = newValue!;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculateTraceProperties,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text('Calcular Ancho de Pista'),
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
                      'Resultados:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    _buildResultRow(
                      'Ancho de Pista:',
                      _traceWidthResult,
                      colorScheme,
                    ),
                    _buildResultRow(
                      'Resistencia de Pista:',
                      _traceResistanceResult,
                      colorScheme,
                    ),
                    _buildResultRow(
                      'Caída de Voltaje:',
                      _voltageDropResult,
                      colorScheme,
                    ),
                    _buildResultRow(
                      'Disipación de Potencia:',
                      _powerDissipationResult,
                      colorScheme,
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

  // Widget auxiliar para mostrar filas de resultados
  Widget _buildResultRow(String label, String value, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(
            value.isEmpty ? 'N/A' : value,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  // Widget genérico para campos de entrada de texto puro (sin unidad)
  Widget _buildInputField({
    required TextEditingController controller,
    required String labelText,
    String? hintText,
    TextInputType keyboardType =
        TextInputType.number, // Default a number para inputs numéricos
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
