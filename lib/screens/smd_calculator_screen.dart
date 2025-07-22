import 'package:flutter/material.dart';
import 'dart:math' as math; // Ya deberías tener esta línea

class SmdCalculatorScreen extends StatefulWidget {
  const SmdCalculatorScreen({super.key});

  @override
  State<SmdCalculatorScreen> createState() => _SmdCalculatorScreenState();
}

class _SmdCalculatorScreenState extends State<SmdCalculatorScreen> {
  final TextEditingController _smdCodeController = TextEditingController();
  String _result = '';
  String _explanation = '';

  @override
  void dispose() {
    _smdCodeController.dispose();
    super.dispose();
  }

  void _calculateSmdValue() {
    String code = _smdCodeController.text.trim().toUpperCase();
    _result = '';
    _explanation = '';

    if (code.isEmpty) {
      setState(() {
        _result = 'Por favor, introduce un código SMD.';
      });
      return;
    }

    // Lógica para códigos SMD de 3 y 4 dígitos (Resistencias)
    if (RegExp(r'^\d{3}$').hasMatch(code)) {
      // 3 dígitos: XYK (XY = valor, K = multiplicador)
      int value = int.parse(code.substring(0, 2));
      int multiplier = int.parse(code.substring(2, 3));
      // Corrección aquí: .toDouble() para math.pow
      double resistance = value * math.pow(10, multiplier).toDouble();
      _result = 'Resistencia: ${_formatResistance(resistance)}Ω';
      _explanation =
          'Código de 3 dígitos: Los primeros dos dígitos son el valor, el tercero es el número de ceros.';
    } else if (RegExp(r'^\d{4}$').hasMatch(code)) {
      // 4 dígitos: XYZK (XYZ = valor, K = multiplicador)
      int value = int.parse(code.substring(0, 3));
      int multiplier = int.parse(code.substring(3, 4));
      // Corrección aquí: .toDouble() para math.pow
      double resistance = value * math.pow(10, multiplier).toDouble();
      _result = 'Resistencia: ${_formatResistance(resistance)}Ω';
      _explanation =
          'Código de 4 dígitos: Los primeros tres dígitos son el valor, el cuarto es el número de ceros.';
    } else if (RegExp(r'^\d+[RKM]$', caseSensitive: false).hasMatch(code)) {
      // Código con "R", "K", "M" (ej. 4R7, 10K, 2M2)
      // Ajuste de regex para permitir números de múltiples dígitos antes de R/K/M
      String numericPart = code.substring(0, code.length - 1);
      String unit = code.substring(code.length - 1).toUpperCase();
      double multiplier = 1.0;

      if (unit == 'R') multiplier = 1.0;
      if (unit == 'K') multiplier = 1000.0;
      if (unit == 'M') multiplier = 1000000.0;

      // Reemplaza 'R', 'K', 'M' en la parte numérica por un punto decimal
      String valueStr = numericPart.replaceAll(
        RegExp(r'[RKM]', caseSensitive: false),
        '.',
      );
      double value = double.tryParse(valueStr) ?? 0.0;

      double resistance = value * multiplier;
      _result = 'Resistencia: ${_formatResistance(resistance)}Ω';
      _explanation =
          'Código con R/K/M: R=punto decimal (Ohmios), K=kiloOhmios, M=MegaOhmios.';
    } else {
      _result =
          'Código no reconocido. Intenta con 3 o 4 dígitos, o formato XRY/XK/XM.';
      _explanation =
          'Ejemplos: 103 (10kΩ), 4702 (47kΩ), 4R7 (4.7Ω), 10K (10kΩ), 2M2 (2.2MΩ).';
    }

    setState(() {});
  }

  String _formatResistance(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(value % 1000000 == 0 ? 0 : 2)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(value % 1000 == 0 ? 0 : 2)}k';
    } else {
      return value.toStringAsFixed(value % 1 == 0 ? 0 : 2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora SMD'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'Calculadora de Códigos de Resistencias SMD',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _smdCodeController,
              keyboardType: TextInputType.text, // Puede ser alfanumérico
              textCapitalization: TextCapitalization
                  .characters, // Para que R, K, M sean mayúsculas
              decoration: InputDecoration(
                labelText: 'Introduce el código SMD',
                hintText: 'Ej: 103, 4702, 4R7, 10K, 2M2',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _smdCodeController.clear();
                    setState(() {
                      _result = '';
                      _explanation = '';
                    });
                  },
                ),
              ),
              onChanged: (value) {
                // Puedes recalcular al escribir si quieres, o solo con el botón
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculateSmdValue,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Calcular', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 30),
            if (_result.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Resultado:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _result,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Explicación: $_explanation',
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
