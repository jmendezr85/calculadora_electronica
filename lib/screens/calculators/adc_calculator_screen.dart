// lib/screens/adc_calculator_screen.dart

import 'package:flutter/material.dart';
import 'dart:math'; // Necesario para la función pow

class AdcCalculatorScreen extends StatefulWidget {
  const AdcCalculatorScreen({super.key});

  @override
  State<AdcCalculatorScreen> createState() => _AdcCalculatorScreenState();
}

class _AdcCalculatorScreenState extends State<AdcCalculatorScreen> {
  // Controladores para los campos de entrada
  final TextEditingController _referenceVoltageController =
      TextEditingController();
  final TextEditingController _inputVoltageController = TextEditingController();

  // Resolución seleccionada (bits)
  int _resolutionBits = 10; // Valor por defecto, por ejemplo 10 bits

  // Unidades seleccionadas
  String _referenceVoltageUnit = 'V';
  String _inputVoltageUnit = 'V';
  String _lsbVoltageUnit = 'V'; // Unidad para mostrar el LSB

  // Listas de opciones para los Dropdowns
  final List<int> _resolutionOptions = [
    8,
    10,
    12,
    14,
    16,
    18,
    20,
    24,
  ]; // Bits comunes
  final List<String> _voltageUnits = ['mV', 'V'];
  final List<String> _lsbUnits = ['mV', 'V']; // Unidades para mostrar el LSB

  // Resultados
  String _quantizationLevelsResult = '';
  String _lsbValueResult = '';
  String _digitalCodeResult = '';
  String _binaryCodeResult = ''; // Para mostrar también en binario

  @override
  void dispose() {
    _referenceVoltageController.dispose();
    _inputVoltageController.dispose();
    super.dispose();
  }

  // --- Funciones de Conversión de Unidades ---
  double _convertVoltageToBase(double value, String unit) {
    return unit == 'mV' ? value / 1000 : value; // Convertir a Voltios
  }

  String _formatVoltageOutput(double volts, String targetUnit) {
    double value;
    String suffix;
    if (targetUnit == 'mV') {
      value = volts * 1000;
      suffix = 'mV';
    } else {
      // 'V'
      value = volts;
      suffix = 'V';
    }
    return '${value.toStringAsFixed(6)} $suffix'; // Más decimales para precisión
  }

  // --- Lógica de Cálculo Principal ---
  void _calculateADCProperties() {
    setState(() {
      final double referenceVoltage = _convertVoltageToBase(
        double.tryParse(_referenceVoltageController.text) ?? 0.0,
        _referenceVoltageUnit,
      );
      final double inputVoltage = _convertVoltageToBase(
        double.tryParse(_inputVoltageController.text) ?? 0.0,
        _inputVoltageUnit,
      );

      if (referenceVoltage <= 0 || _resolutionBits <= 0) {
        _quantizationLevelsResult = 'Ingrese valores válidos y positivos.';
        _lsbValueResult = '';
        _digitalCodeResult = '';
        _binaryCodeResult = '';
        return;
      }

      // 1. Niveles de Cuantificación
      final int quantizationLevels = pow(2, _resolutionBits).toInt();
      _quantizationLevelsResult = '$quantizationLevels';

      // 2. Tamaño del Paso (LSB)
      // LSB = Vref / (2^N - 1)
      final double lsbValue = referenceVoltage / (quantizationLevels - 1);
      _lsbValueResult = _formatVoltageOutput(lsbValue, _lsbVoltageUnit);

      // 3. Código Digital de Salida
      // DigitalCode = (Vin / Vref) * (2^N - 1)
      // Se trunca (floor) el resultado para obtener el código digital entero
      int digitalCode = 0;
      if (inputVoltage >= 0 && inputVoltage <= referenceVoltage) {
        digitalCode =
            (inputVoltage / referenceVoltage * (quantizationLevels - 1))
                .floor();
        // Asegurarse de que el código no exceda el máximo posible
        if (digitalCode >= quantizationLevels) {
          digitalCode = quantizationLevels - 1;
        }
      } else if (inputVoltage < 0) {
        digitalCode = 0; // O manejar como error/fuera de rango negativo
      } else {
        // inputVoltage > referenceVoltage
        digitalCode = quantizationLevels - 1; // Se satura al máximo
      }

      _digitalCodeResult = '$digitalCode (decimal)';
      // LÍNEA CORREGIDA: Usar interpolación en lugar de concatenación
      _binaryCodeResult =
          '${digitalCode.toRadixString(2).padLeft(_resolutionBits, '0')} (binario)';
    });
  }

  void _clearFields() {
    setState(() {
      _referenceVoltageController.clear();
      _inputVoltageController.clear();
      _resolutionBits = 10; // Reset a valor por defecto
      _referenceVoltageUnit = 'V';
      _inputVoltageUnit = 'V';
      _lsbVoltageUnit = 'V';

      _quantizationLevelsResult = '';
      _lsbValueResult = '';
      _digitalCodeResult = '';
      _binaryCodeResult = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora ADC'),
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
              'Calcula los parámetros y la salida de un Conversor Analógico-Digital (ADC).',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            Text(
              'Resolución (N de bits):',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            DropdownButton<int>(
              value: _resolutionBits,
              isExpanded: true,
              items: _resolutionOptions.map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text('$value bits'),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _resolutionBits = newValue!;
                });
              },
            ),
            const SizedBox(height: 15),
            _buildUnitInputField(
              controller: _referenceVoltageController,
              labelText: 'Voltaje de Referencia (Vref)',
              hintText: 'Ej: 5.0',
              unit: _referenceVoltageUnit,
              units: _voltageUnits,
              onUnitChanged: (newValue) {
                setState(() {
                  _referenceVoltageUnit = newValue!;
                });
              },
              icon: Icons.electrical_services,
            ),
            const SizedBox(height: 15),
            _buildUnitInputField(
              controller: _inputVoltageController,
              labelText: 'Voltaje Analógico de Entrada (Vin)',
              hintText: 'Ej: 2.5',
              unit: _inputVoltageUnit,
              units: _voltageUnits,
              onUnitChanged: (newValue) {
                setState(() {
                  _inputVoltageUnit = newValue!;
                });
              },
              icon: Icons.input,
            ),
            const SizedBox(height: 20),
            Text(
              'Unidad de Salida para LSB:',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            DropdownButton<String>(
              value: _lsbVoltageUnit,
              isExpanded: true,
              items: _lsbUnits.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _lsbVoltageUnit = newValue!;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculateADCProperties,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text('Calcular ADC'),
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
                      'Resultados ADC:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    _buildResultRow(
                      'Niveles de Cuantificación:',
                      _quantizationLevelsResult,
                      colorScheme,
                    ),
                    _buildResultRow('Valor LSB:', _lsbValueResult, colorScheme),
                    _buildResultRow(
                      'Código Digital de Salida:',
                      _digitalCodeResult,
                      colorScheme,
                    ),
                    _buildResultRow(
                      'Representación Binaria:',
                      _binaryCodeResult,
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
