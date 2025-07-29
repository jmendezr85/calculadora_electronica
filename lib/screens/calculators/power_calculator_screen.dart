// lib/screens/power_calculator_screen.dart

import 'package:flutter/material.dart';
// import 'dart:math'; // <--- ELIMINADA ESTA LÍNEA

class PowerCalculatorScreen extends StatefulWidget {
  const PowerCalculatorScreen({super.key});

  @override
  State<PowerCalculatorScreen> createState() => _PowerCalculatorScreenState();
}

class _PowerCalculatorScreenState extends State<PowerCalculatorScreen> {
  // Controladores para los campos de entrada
  final TextEditingController _voltageController = TextEditingController();
  final TextEditingController _currentController = TextEditingController();
  final TextEditingController _resistanceController = TextEditingController();

  // Unidades seleccionadas
  String _voltageUnit = 'V';
  String _currentUnit = 'A';
  String _resistanceUnit = 'Ω';
  String _powerOutputUnit = 'W'; // Unidad de salida de potencia por defecto

  // Listas de opciones para los Dropdowns
  final List<String> _voltageUnits = ['mV', 'V', 'kV'];
  final List<String> _currentUnits = ['µA', 'mA', 'A'];
  final List<String> _resistanceUnits = ['mΩ', 'Ω', 'kΩ', 'MΩ'];
  final List<String> _powerUnits = ['mW', 'W', 'kW'];

  // Resultados
  String _powerResult = '';
  String _missingParameterResult = '';
  String _missingParameterLabel = '';

  @override
  void dispose() {
    _voltageController.dispose();
    _currentController.dispose();
    _resistanceController.dispose();
    super.dispose();
  }

  // --- Funciones de Conversión de Unidades ---
  double _convertVoltageToBase(double value, String unit) {
    switch (unit) {
      case 'mV':
        return value / 1000;
      case 'V':
        return value;
      case 'kV':
        return value * 1000;
      default:
        return value;
    }
  }

  double _convertCurrentToBase(double value, String unit) {
    switch (unit) {
      case 'µA':
        return value / 1e6;
      case 'mA':
        return value / 1000;
      case 'A':
        return value;
      default:
        return value;
    }
  }

  double _convertResistanceToBase(double value, String unit) {
    switch (unit) {
      case 'mΩ':
        return value / 1000;
      case 'Ω':
        return value;
      case 'kΩ':
        return value * 1000;
      case 'MΩ':
        return value * 1e6;
      default:
        return value;
    }
  }

  String _formatPowerOutput(double watts, String unit) {
    double value;
    String suffix;
    switch (unit) {
      case 'mW':
        value = watts * 1000;
        suffix = 'mW';
        break;
      case 'W':
        value = watts;
        suffix = 'W';
        break;
      case 'kW':
        value = watts / 1000;
        suffix = 'kW';
        break;
      default:
        value = watts;
        suffix = 'W';
        break;
    }
    return '${value.toStringAsFixed(4)} $suffix';
  }

  // Función para formatear el resultado del parámetro faltante
  String _formatMissingParameter(double value, String type) {
    String unit = '';
    switch (type) {
      case 'V':
        if (value >= 1000) {
          unit = 'kV';
          value /= 1000;
        } else if (value < 1) {
          unit = 'mV';
          value *= 1000;
        } else {
          unit = 'V';
        }
        break;
      case 'I':
        if (value < 1e-3) {
          unit = 'µA';
          value *= 1e6;
        } else if (value < 1) {
          unit = 'mA';
          value *= 1000;
        } else {
          unit = 'A';
        }
        break;
      case 'R':
        if (value >= 1e6) {
          unit = 'MΩ';
          value /= 1e6;
        } else if (value >= 1000) {
          unit = 'kΩ';
          value /= 1000;
        } else if (value < 1) {
          unit = 'mΩ';
          value *= 1000;
        } else {
          unit = 'Ω';
        }
        break;
    }
    return '${value.toStringAsFixed(4)} $unit';
  }

  // --- Lógica de Cálculo Principal ---
  void _calculatePower() {
    setState(() {
      final double? rawVoltage = double.tryParse(_voltageController.text);
      final double? rawCurrent = double.tryParse(_currentController.text);
      final double? rawResistance = double.tryParse(_resistanceController.text);

      double V = 0.0, I = 0.0, R = 0.0;
      int providedInputs = 0;

      if (rawVoltage != null) {
        V = _convertVoltageToBase(rawVoltage, _voltageUnit);
        providedInputs++;
      }
      if (rawCurrent != null) {
        I = _convertCurrentToBase(rawCurrent, _currentUnit);
        providedInputs++;
      }
      if (rawResistance != null) {
        R = _convertResistanceToBase(rawResistance, _resistanceUnit);
        providedInputs++;
      }

      if (providedInputs != 2) {
        _powerResult = 'Por favor, ingrese exactamente dos valores.';
        _missingParameterResult = '';
        _missingParameterLabel = '';
        return;
      }

      double powerWatts = 0.0;

      if (rawVoltage != null && rawCurrent != null) {
        // V y I proporcionados
        powerWatts = V * I;
        if (I != 0) {
          R = V / I;
          _missingParameterResult = _formatMissingParameter(R, 'R');
          _missingParameterLabel = 'Resistencia (R):';
        } else {
          _missingParameterResult = 'I no puede ser cero para R';
          _missingParameterLabel = 'Resistencia (R):';
        }
      } else if (rawCurrent != null && rawResistance != null) {
        // I y R proporcionados
        powerWatts = I * I * R;
        V = I * R;
        _missingParameterResult = _formatMissingParameter(V, 'V');
        _missingParameterLabel = 'Voltaje (V):';
      } else if (rawVoltage != null && rawResistance != null) {
        // V y R proporcionados
        if (R != 0) {
          powerWatts = (V * V) / R;
          I = V / R;
          _missingParameterResult = _formatMissingParameter(I, 'I');
          _missingParameterLabel = 'Corriente (I):';
        } else {
          _powerResult = 'R no puede ser cero.';
          _missingParameterResult = '';
          _missingParameterLabel = '';
          return;
        }
      } else {
        // Este caso no debería ocurrir con providedInputs == 2, pero como fallback
        _powerResult = 'Error: No se pudieron determinar los valores.';
        _missingParameterResult = '';
        _missingParameterLabel = '';
        return;
      }

      _powerResult = _formatPowerOutput(powerWatts, _powerOutputUnit);

      // Si el cálculo fue exitoso y el valor faltante es cero debido a un denominador cero
      if (powerWatts.isInfinite || powerWatts.isNaN) {
        _powerResult = 'Valor inválido (división por cero o infinito).';
        _missingParameterResult = '';
        _missingParameterLabel = '';
      }
    });
  }

  void _clearFields() {
    setState(() {
      _voltageController.clear();
      _currentController.clear();
      _resistanceController.clear();

      _voltageUnit = 'V';
      _currentUnit = 'A';
      _resistanceUnit = 'Ω';
      _powerOutputUnit = 'W';

      _powerResult = '';
      _missingParameterResult = '';
      _missingParameterLabel = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora de Potencia'),
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
              'Ingrese exactamente dos de los siguientes valores para calcular la Potencia (P) y el tercer valor.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            _buildUnitInputField(
              controller: _voltageController,
              labelText: 'Voltaje (V)',
              hintText: 'Ej: 12',
              unit: _voltageUnit,
              units: _voltageUnits,
              onUnitChanged: (newValue) {
                setState(() {
                  _voltageUnit = newValue!;
                });
              },
              icon: Icons.flash_on, // <--- CAMBIADO AQUÍ
            ),
            const SizedBox(height: 15),
            _buildUnitInputField(
              controller: _currentController,
              labelText: 'Corriente (I)',
              hintText: 'Ej: 0.5',
              unit: _currentUnit,
              units: _currentUnits,
              onUnitChanged: (newValue) {
                setState(() {
                  _currentUnit = newValue!;
                });
              },
              icon: Icons.electrical_services,
            ),
            const SizedBox(height: 15),
            _buildUnitInputField(
              controller: _resistanceController,
              labelText: 'Resistencia (R)',
              hintText: 'Ej: 100',
              unit: _resistanceUnit,
              units: _resistanceUnits,
              onUnitChanged: (newValue) {
                setState(() {
                  _resistanceUnit = newValue!;
                });
              },
              icon: Icons.timeline, // <--- CAMBIADO AQUÍ
            ),
            const SizedBox(height: 20),
            Text(
              'Unidad de Salida de Potencia:',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            DropdownButton<String>(
              value: _powerOutputUnit,
              isExpanded: true,
              items: _powerUnits.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _powerOutputUnit = newValue!;
                  // Recalcular el resultado si ya hay datos y el formato cambia
                  if (_powerResult.isNotEmpty &&
                      _powerResult !=
                          'Por favor, ingrese exactamente dos valores.' &&
                      _powerResult != 'R no puede ser cero.') {
                    _calculatePower();
                  }
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculatePower,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text('Calcular Potencia'),
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
                    _buildResultRow('Potencia (P):', _powerResult, colorScheme),
                    if (_missingParameterResult.isNotEmpty)
                      _buildResultRow(
                        _missingParameterLabel,
                        _missingParameterResult,
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
