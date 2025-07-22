import 'package:flutter/material.dart';

class LedResistorScreen extends StatefulWidget {
  const LedResistorScreen({super.key});

  @override
  State<LedResistorScreen> createState() => _LedResistorScreenState();
}

class _LedResistorScreenState extends State<LedResistorScreen> {
  final TextEditingController _supplyVoltageController =
      TextEditingController();
  final TextEditingController _ledVoltageDropController =
      TextEditingController();
  final TextEditingController _ledCurrentController = TextEditingController();

  String _result = '';

  @override
  void dispose() {
    _supplyVoltageController.dispose();
    _ledVoltageDropController.dispose();
    _ledCurrentController.dispose();
    super.dispose();
  }

  void _calculateLedResistor() {
    setState(() {
      _result = ''; // Limpiar resultado anterior
    });

    final double? supplyVoltage = double.tryParse(
      _supplyVoltageController.text,
    );
    final double? ledVoltageDrop = double.tryParse(
      _ledVoltageDropController.text,
    );
    final double? ledCurrent = double.tryParse(_ledCurrentController.text);

    if (supplyVoltage == null || ledVoltageDrop == null || ledCurrent == null) {
      setState(() {
        _result = 'Por favor, introduce todos los valores.';
      });
      return;
    }

    if (supplyVoltage <= 0 || ledVoltageDrop <= 0 || ledCurrent <= 0) {
      setState(() {
        _result = 'Los valores deben ser mayores que cero.';
      });
      return;
    }

    if (ledVoltageDrop >= supplyVoltage) {
      setState(() {
        _result =
            'Error: El voltaje de caída del LED debe ser menor que el voltaje de la fuente.';
      });
      return;
    }

    // Convertir corriente de mA a Amperios para el cálculo de Ohm
    final double ledCurrentAmps =
        ledCurrent / 1000.0; // Asumiendo que el usuario introduce mA

    // Fórmula: R = (Vs - Vf) / I
    // Donde:
    // Vs = Voltaje de la fuente
    // Vf = Voltaje de caída del LED
    // I = Corriente del LED (en Amperios)
    final double requiredResistance =
        (supplyVoltage - ledVoltageDrop) / ledCurrentAmps;

    setState(() {
      _result =
          'Resistencia Requerida: ${_formatResistance(requiredResistance)}';
    });
  }

  String _formatResistance(double value) {
    if (value.abs() >= 1e9) {
      // Giga
      return '${(value / 1e9).toStringAsFixed(3)} GΩ';
    } else if (value.abs() >= 1e6) {
      // Mega
      return '${(value / 1e6).toStringAsFixed(3)} MΩ';
    } else if (value.abs() >= 1e3) {
      // Kilo
      return '${(value / 1e3).toStringAsFixed(3)} kΩ';
    } else {
      return '${value.toStringAsFixed(3)} Ω';
    }
  }

  void _clearFields() {
    _supplyVoltageController.clear();
    _ledVoltageDropController.clear();
    _ledCurrentController.clear();
    setState(() {
      _result = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resistencia para LED'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _supplyVoltageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Voltaje de la Fuente (Vs)',
                hintText: 'Ej: 12.0',
                border: OutlineInputBorder(),
                suffixText: 'V',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _ledVoltageDropController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Voltaje de Caída del LED (Vf)',
                hintText: 'Ej: 2.0 (para LED rojo)',
                border: OutlineInputBorder(),
                suffixText: 'V',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _ledCurrentController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Corriente del LED (I) en mA',
                hintText: 'Ej: 20 (valor típico en mA)',
                border: OutlineInputBorder(),
                suffixText: 'mA',
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _calculateLedResistor,
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
