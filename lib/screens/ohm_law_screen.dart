import 'package:flutter/material.dart';

class OhmLawScreen extends StatefulWidget {
  const OhmLawScreen({super.key});

  @override
  State<OhmLawScreen> createState() => _OhmLawScreenState();
}

class _OhmLawScreenState extends State<OhmLawScreen> {
  final TextEditingController _voltageController = TextEditingController();
  final TextEditingController _currentController = TextEditingController();
  final TextEditingController _resistanceController = TextEditingController();

  String _result = '';

  @override
  void dispose() {
    _voltageController.dispose();
    _currentController.dispose();
    _resistanceController.dispose();
    super.dispose();
  }

  void _calculateOhmLaw() {
    setState(() {
      _result = '';
    });

    final double? voltageInput = double.tryParse(_voltageController.text);
    final double? currentInput = double.tryParse(_currentController.text);
    final double? resistanceInput = double.tryParse(_resistanceController.text);

    int filledFields = 0;
    if (voltageInput != null) filledFields++;
    if (currentInput != null) filledFields++;
    if (resistanceInput != null) filledFields++;

    if (filledFields == 2) {
      if (voltageInput == null) {
        // Calcular Voltaje (V = I * R)
        final double current =
            currentInput!; // Necesario porque currentInput podría ser null
        final double resistance =
            resistanceInput!; // Necesario porque resistanceInput podría ser null

        if (resistance == 0) {
          setState(() {
            _result = 'Error: La resistencia no puede ser cero.';
          });
          return;
        }
        final double calculatedVoltage = current * resistance;
        _voltageController.text = _formatResult(calculatedVoltage);
        setState(() {
          _result = 'Voltaje (V): ${_formatResult(calculatedVoltage)} V';
        });
      } else if (currentInput == null) {
        // Calcular Corriente (I = V / R)
        final double voltage =
            voltageInput; // No necesita ! porque ya sabemos que no es null
        final double resistance =
            resistanceInput!; // Necesario porque resistanceInput podría ser null

        if (resistance == 0) {
          setState(() {
            _result =
                'Error: La resistencia no puede ser cero para calcular corriente.';
          });
          return;
        }
        final double calculatedCurrent = voltage / resistance;
        _currentController.text = _formatResult(calculatedCurrent);
        setState(() {
          _result = 'Corriente (I): ${_formatResult(calculatedCurrent)} A';
        });
      } else if (resistanceInput == null) {
        // Calcular Resistencia (R = V / I)
        final double voltage =
            voltageInput; // No necesita ! porque ya sabemos que no es null
        final double current =
            currentInput; // No necesita ! porque ya sabemos que no es null

        if (current == 0) {
          setState(() {
            _result =
                'Error: La corriente no puede ser cero para calcular resistencia.';
          });
          return;
        }
        final double calculatedResistance = voltage / current;
        _resistanceController.text = _formatResult(calculatedResistance);
        setState(() {
          _result = 'Resistencia (R): ${_formatResult(calculatedResistance)} Ω';
        });
      }
    } else if (filledFields < 2) {
      setState(() {
        _result = 'Por favor, introduce al menos dos valores.';
      });
    } else {
      // filledFields > 2
      setState(() {
        _result = 'Por favor, deja un campo vacío para calcular.';
      });
    }
  }

  String _formatResult(double value) {
    if (value.abs() >= 1e9) {
      // Giga
      return '${(value / 1e9).toStringAsFixed(3)} G';
    } else if (value.abs() >= 1e6) {
      // Mega
      return '${(value / 1e6).toStringAsFixed(3)} M';
    } else if (value.abs() >= 1e3) {
      // Kilo
      return '${(value / 1e3).toStringAsFixed(3)} k';
    } else if (value.abs() >= 1 || value == 0) {
      // Unidad base
      return value.toStringAsFixed(3);
    } else if (value.abs() >= 1e-3) {
      // Mili
      return '${(value / 1e-3).toStringAsFixed(3)} m';
    } else if (value.abs() >= 1e-6) {
      // Micro
      return '${(value / 1e-6).toStringAsFixed(3)} µ';
    } else if (value.abs() >= 1e-9) {
      // Nano
      return '${(value / 1e-9).toStringAsFixed(3)} n';
    } else if (value.abs() >= 1e-12) {
      // Pico
      return '${(value / 1e-12).toStringAsFixed(3)} p';
    } else {
      return value.toStringAsExponential(
        3,
      ); // Para valores extremadamente pequeños
    }
  }

  void _clearFields() {
    _voltageController.clear();
    _currentController.clear();
    _resistanceController.clear();
    setState(() {
      _result = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora de Ley de Ohm'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _voltageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Voltaje (V)',
                hintText: 'Ej: 12.5',
                border: OutlineInputBorder(),
                suffixText: 'V',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _currentController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Corriente (I)',
                hintText: 'Ej: 0.5',
                border: OutlineInputBorder(),
                suffixText: 'A',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _resistanceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Resistencia (R)',
                hintText: 'Ej: 1000',
                border: OutlineInputBorder(),
                suffixText: 'Ω',
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _calculateOhmLaw,
              child: const Text('Calcular'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: _clearFields,
              child: const Text('Limpiar'),
            ),
            const SizedBox(height: 24),
            Text(
              _result,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
