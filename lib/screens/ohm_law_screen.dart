import 'package:flutter/material.dart';
import 'dart:math';

class OhmLawScreen extends StatefulWidget {
  const OhmLawScreen({super.key});

  @override
  State<OhmLawScreen> createState() => _OhmLawScreenState();
}

class _OhmLawScreenState extends State<OhmLawScreen> {
  final TextEditingController _voltageController = TextEditingController();
  final TextEditingController _currentController = TextEditingController();
  final TextEditingController _resistanceController = TextEditingController();
  final TextEditingController _powerController = TextEditingController();

  String _result = ''; // For general messages or errors

  // Selected units for each parameter
  String _selectedVoltageUnit = 'V';
  String _selectedCurrentUnit = 'A';
  String _selectedResistanceUnit = 'Ω';
  String _selectedPowerUnit = 'W';

  // Available units for each parameter
  final List<String> _voltageUnits = ['V', 'mV', 'kV'];
  final List<String> _currentUnits = ['A', 'mA', 'µA'];
  final List<String> _resistanceUnits = ['Ω', 'kΩ', 'MΩ'];
  final List<String> _powerUnits = ['W', 'mW', 'kW'];

  @override
  void dispose() {
    _voltageController.dispose();
    _currentController.dispose();
    _resistanceController.dispose();
    _powerController.dispose();
    super.dispose();
  }

  // Helper to convert input value to base unit (V, A, Ohm, W)
  double? _convertToBaseUnit(double? value, String unit) {
    if (value == null) return null;
    switch (unit) {
      case 'mV':
        return value / 1000;
      case 'kV':
        return value * 1000;
      case 'mA':
        return value / 1000;
      case 'µA':
        return value / 1000000;
      case 'kΩ':
        return value * 1000;
      case 'MΩ':
        return value * 1000000;
      case 'mW':
        return value / 1000;
      case 'kW':
        return value * 1000;
      default:
        return value; // Base unit
    }
  }

  // Helper to convert a base unit value to the selected display unit
  String _convertFromBaseUnit(double value, String targetUnit) {
    double displayValue = value;

    // First, convert to the selected target unit
    switch (targetUnit) {
      case 'mV':
        displayValue = value * 1000;
        break;
      case 'kV':
        displayValue = value / 1000;
        break;
      case 'mA':
        displayValue = value * 1000;
        break;
      case 'µA':
        displayValue = value * 1000000;
        break;
      case 'kΩ':
        displayValue = value / 1000;
        break;
      case 'MΩ':
        displayValue = value / 1000000;
        break;
      case 'mW':
        displayValue = value * 1000;
        break;
      case 'kW':
        displayValue = value / 1000;
        break;
    }

    // Then, format the number. Prefer fixed 3 decimals, or scientific for very small/large.
    if (displayValue.abs() >= 1000 ||
        displayValue.abs() < 0.001 && displayValue != 0) {
      return displayValue.toStringAsPrecision(
        4,
      ); // Use precision for large/small numbers
    }
    return displayValue.toStringAsFixed(3); // Default fixed 3 decimals
  }

  void _calculateOhmLaw() {
    setState(() {
      _result = ''; // Clear previous messages
    });

    // Get raw inputs from controllers
    double? rawVoltage = double.tryParse(_voltageController.text);
    double? rawCurrent = double.tryParse(_currentController.text);
    double? rawResistance = double.tryParse(_resistanceController.text);
    double? rawPower = double.tryParse(_powerController.text);

    // Convert inputs to base units
    double? V = _convertToBaseUnit(rawVoltage, _selectedVoltageUnit);
    double? I = _convertToBaseUnit(rawCurrent, _selectedCurrentUnit);
    double? R = _convertToBaseUnit(rawResistance, _selectedResistanceUnit);
    double? P = _convertToBaseUnit(rawPower, _selectedPowerUnit);

    // Track which fields are null (empty)
    List<double?> values = [V, I, R, P];

    List<int> filledIndices = [];
    List<int> emptyIndices = [];

    for (int i = 0; i < values.length; i++) {
      if (values[i] != null) {
        filledIndices.add(i);
      } else {
        emptyIndices.add(i);
      }
    }

    // Clear all output fields if less than 2 inputs or more than 2 inputs are present
    if (filledIndices.length < 2 || filledIndices.length > 2) {
      _clearCalculatedFields(
        emptyIndices,
      ); // Clear any previously calculated values
      if (filledIndices.length < 2) {
        setState(() {
          _result = 'Ingresa al menos dos valores para calcular.';
        });
      } else {
        // filledIndices.length > 2
        setState(() {
          _result =
              'Por favor, deja solo dos campos con valores para calcular los demás.';
        });
      }
      return;
    }

    // Exactly two fields are filled, proceed with calculation
    _result = ''; // Clear any specific error messages

    try {
      if (V != null && I != null) {
        // V, I given: Calculate R, P
        R = V / I;
        P = V * I;
      } else if (V != null && R != null) {
        // V, R given: Calculate I, P
        I = V / R;
        P = (V * V) / R;
      } else if (I != null && R != null) {
        // I, R given: Calculate V, P
        V = I * R;
        P = (I * I) * R;
      } else if (V != null && P != null) {
        // V, P given: Calculate I, R
        I = P / V;
        R = (V * V) / P;
      } else if (I != null && P != null) {
        // I, P given: Calculate V, R
        V = P / I;
        R = P / (I * I);
      } else if (R != null && P != null) {
        // R, P given: Calculate V, I
        V = sqrt(P * R);
        I = sqrt(P / R);
      } else {
        // This case should ideally not be reached if filledIndices.length == 2
        // But good for safety.
        setState(() {
          _result = 'Error de lógica en la selección de valores.';
        });
        return;
      }

      // Handle division by zero or invalid calculations (e.g., sqrt of negative)
      if (V.isNaN ||
          I.isNaN ||
          R.isNaN ||
          P.isNaN ||
          V.isInfinite ||
          I.isInfinite ||
          R.isInfinite ||
          P.isInfinite) {
        throw FormatException(
          'Resultado indefinido o división por cero. Verifica tus entradas.',
        );
      }

      // Update controllers with calculated values, formatted to their selected units
      if (emptyIndices.contains(0)) {
        _voltageController.text = _convertFromBaseUnit(V, _selectedVoltageUnit);
      }
      if (emptyIndices.contains(1)) {
        _currentController.text = _convertFromBaseUnit(I, _selectedCurrentUnit);
      }
      if (emptyIndices.contains(2)) {
        _resistanceController.text = _convertFromBaseUnit(
          R,
          _selectedResistanceUnit,
        );
      }
      if (emptyIndices.contains(3)) {
        _powerController.text = _convertFromBaseUnit(P, _selectedPowerUnit);
      }
    } on FormatException catch (e) {
      setState(() {
        _result = 'Error: ${e.message}';
      });
      _clearCalculatedFields(emptyIndices); // Clear outputs on error
    } catch (e) {
      setState(() {
        _result = 'Ocurrió un error inesperado. Revisa las entradas.';
      });
      _clearCalculatedFields(emptyIndices); // Clear outputs on error
    }

    setState(() {}); // Rebuild UI to show results/messages
  }

  void _clearCalculatedFields(List<int> emptyIndices) {
    List<TextEditingController> controllers = [
      _voltageController,
      _currentController,
      _resistanceController,
      _powerController,
    ];
    for (int index in emptyIndices) {
      controllers[index].clear();
    }
  }

  void _clearAllFields() {
    _voltageController.clear();
    _currentController.clear();
    _resistanceController.clear();
    _powerController.clear();
    setState(() {
      _result = '';
      _selectedVoltageUnit = 'V';
      _selectedCurrentUnit = 'A';
      _selectedResistanceUnit = 'Ω';
      _selectedPowerUnit = 'W';
    });
  }

  // Reusable widget for each input row
  Widget _buildInputRow({
    required IconData icon,
    required String labelText,
    required TextEditingController controller,
    required String selectedUnit,
    required List<String> units,
    required ValueChanged<String?> onUnitChanged,
    // Removed: required ValueChanged<String> onChanged, // No longer needed for dynamic calculation
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: labelText,
                  border: InputBorder.none, // Remove default border
                  isDense: true,
                ),
                // Removed: onChanged: onChanged, // No longer trigger calculation on text change
              ),
            ),
            SizedBox(
              width: 80, // Fixed width for dropdown
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedUnit,
                  onChanged: (String? newValue) {
                    onUnitChanged(newValue);
                    // The main calculation is now only triggered by the button,
                    // but changing units might still clear outputs if not re-calculated
                    // so we keep this call for immediate unit-based display refresh
                    // for the currently entered values.
                    _calculateOhmLaw();
                  },
                  items: units.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  isExpanded: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ley de Ohm y Potencia'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildInputRow(
              icon: Icons.power_outlined, // Icon for Voltage
              labelText: 'Voltaje',
              controller: _voltageController,
              selectedUnit: _selectedVoltageUnit,
              units: _voltageUnits,
              onUnitChanged: (newValue) {
                setState(() {
                  _selectedVoltageUnit = newValue!;
                });
              },
              // Removed: onChanged: (_) => _calculateOhmLaw(),
            ),
            _buildInputRow(
              icon: Icons.electrical_services_outlined, // Icon for Current
              labelText: 'Corriente',
              controller: _currentController,
              selectedUnit: _selectedCurrentUnit,
              units: _currentUnits,
              onUnitChanged: (newValue) {
                setState(() {
                  _selectedCurrentUnit = newValue!;
                });
              },
              // Removed: onChanged: (_) => _calculateOhmLaw(),
            ),
            _buildInputRow(
              icon:
                  Icons.clear_all, // Icon for Resistance (looks like a zig-zag)
              labelText: 'Resistencia',
              controller: _resistanceController,
              selectedUnit: _selectedResistanceUnit,
              units: _resistanceUnits,
              onUnitChanged: (newValue) {
                setState(() {
                  _selectedResistanceUnit = newValue!;
                });
              },
              // Removed: onChanged: (_) => _calculateOhmLaw(),
            ),
            _buildInputRow(
              icon: Icons.speed, // Icon for Power
              labelText: 'Potencia',
              controller: _powerController,
              selectedUnit: _selectedPowerUnit,
              units: _powerUnits,
              onUnitChanged: (newValue) {
                setState(() {
                  _selectedPowerUnit = newValue!;
                });
              },
              // Removed: onChanged: (_) => _calculateOhmLaw(),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _calculateOhmLaw, // Calculation now only happens here
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
              onPressed: _clearAllFields,
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
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _result,
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onErrorContainer,
                    fontWeight: FontWeight.bold,
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
