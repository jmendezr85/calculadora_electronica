import 'package:flutter/material.dart';

class VoltageDividerScreen extends StatefulWidget {
  const VoltageDividerScreen({super.key});

  @override
  State<VoltageDividerScreen> createState() => _VoltageDividerScreenState();
}

class _VoltageDividerScreenState extends State<VoltageDividerScreen> {
  final TextEditingController _vinController = TextEditingController();
  final TextEditingController _r1Controller = TextEditingController();
  final TextEditingController _r2Controller = TextEditingController();

  String _result = '';

  @override
  void dispose() {
    _vinController.dispose();
    _r1Controller.dispose();
    _r2Controller.dispose();
    super.dispose();
  }

  void _calculateVoltageDivider() {
    setState(() {
      _result = ''; // Limpiar resultado anterior
    });

    final double? vin = double.tryParse(_vinController.text);
    final double? r1 = double.tryParse(_r1Controller.text);
    final double? r2 = double.tryParse(_r2Controller.text);

    if (vin == null || r1 == null || r2 == null) {
      setState(() {
        _result = 'Por favor, introduce todos los valores.';
      });
      return;
    }

    // Asegurarse de que las resistencias no sean negativas o cero (aunque R2 puede ser cero idealmente, en la práctica no)
    if (r1 < 0 || r2 < 0) {
      setState(() {
        _result = 'Las resistencias no pueden ser negativas.';
      });
      return;
    }

    if (r1 + r2 == 0) {
      // Evitar división por cero si ambas son cero
      setState(() {
        _result = 'La suma de las resistencias (R1 + R2) no puede ser cero.';
      });
      return;
    }

    // Fórmula del divisor de voltaje: Vout = Vin * (R2 / (R1 + R2))
    final double vout = vin * (r2 / (r1 + r2));

    setState(() {
      _result = 'Voltaje de Salida (Vout): ${_formatVoltage(vout)} V';
    });
  }

  String _formatVoltage(double value) {
    if (value.abs() >= 1e9) {
      // Giga
      return '${(value / 1e9).toStringAsFixed(3)} GV';
    } else if (value.abs() >= 1e6) {
      // Mega
      return '${(value / 1e6).toStringAsFixed(3)} MV';
    } else if (value.abs() >= 1e3) {
      // Kilo
      return '${(value / 1e3).toStringAsFixed(3)} kV';
    } else if (value.abs() >= 1 || value == 0) {
      // Base unit
      return value.toStringAsFixed(3);
    } else if (value.abs() >= 1e-3) {
      // Milli
      return '${(value / 1e-3).toStringAsFixed(3)} mV';
    } else if (value.abs() >= 1e-6) {
      // Micro
      return '${(value / 1e-6).toStringAsFixed(3)} µV';
    } else if (value.abs() >= 1e-9) {
      // Nano
      return '${(value / 1e-9).toStringAsFixed(3)} nV';
    } else {
      return value.toStringAsExponential(
        3,
      ); // Para valores extremadamente pequeños
    }
  }

  void _clearFields() {
    _vinController.clear();
    _r1Controller.clear();
    _r2Controller.clear();
    setState(() {
      _result = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Divisor de Voltaje'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _vinController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Voltaje de Entrada (Vin)',
                hintText: 'Ej: 5.0',
                border: OutlineInputBorder(),
                suffixText: 'V',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _r1Controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Resistencia 1 (R1)',
                hintText: 'Ej: 1000',
                border: OutlineInputBorder(),
                suffixText: 'Ω',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _r2Controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Resistencia 2 (R2)',
                hintText: 'Ej: 2000',
                border: OutlineInputBorder(),
                suffixText: 'Ω',
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _calculateVoltageDivider,
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
