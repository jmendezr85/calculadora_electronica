import 'dart:math' as math;

import 'package:flutter/material.dart';

// Nueva clase para almacenar los resultados de cada componente
class SmdComponentData {
  final String type;
  final String value;
  final String explanation;

  SmdComponentData({
    required this.type,
    required this.value,
    required this.explanation,
  });
}

class SMDCalculatorScreen extends StatefulWidget {
  const SMDCalculatorScreen({super.key});

  @override
  State<SMDCalculatorScreen> createState() => _SMDCalculatorScreenState();
}

class _SMDCalculatorScreenState extends State<SMDCalculatorScreen> {
  final TextEditingController _smdCodeController = TextEditingController();
  String _result = '';
  String _explanation = '';
  String _componentType = '';

  final List<String> _componentTypesOptions = [
    'Auto-Detectar',
    'Resistencia',
    'Capacitor',
    'Inductor',
    'Diodo',
    'Transistor',
    'Circuito Integrado',
  ];
  String _selectedComponentType = 'Auto-Detectar'; // Valor por defecto

  @override
  void dispose() {
    _smdCodeController.dispose();
    super.dispose();
  }

  void _calculateSmdValue() {
    final String code = _smdCodeController.text.trim().toUpperCase();
    _result = '';
    _explanation = '';
    _componentType = '';

    if (code.isEmpty) {
      setState(() {
        _result = 'Por favor, introduce un código SMD.';
        _componentType = 'Error';
      });
      return;
    }

    final List<SmdComponentData> possibleResults = [];

    if (_selectedComponentType == 'Auto-Detectar') {
      final SmdComponentData? resResult = _parseResistance(code);
      if (resResult != null) {
        possibleResults.add(resResult);
      }

      final SmdComponentData? capResult = _parseCapacitor(code);
      if (capResult != null) {
        possibleResults.add(capResult);
      }

      final SmdComponentData? indResult = _parseInductor(code);
      if (indResult != null) {
        possibleResults.add(indResult);
      }

      if (possibleResults.isEmpty) {
        _result = 'Código no reconocido para ningún componente común (R/C/L).';
        _explanation =
            'Verifica el formato del código o selecciona un tipo específico.';
        _componentType = 'Desconocido';
      } else if (possibleResults.length == 1) {
        _componentType = possibleResults.first.type;
        _result = 'Valor: ${possibleResults.first.value}';
        _explanation = possibleResults.first.explanation;
      } else {
        // Si hay múltiples resultados (ambigüedad)
        _componentType = 'Múltiples Posibilidades';
        _result = 'El código podría ser:';
        _explanation = possibleResults
            .map((e) => '- ${e.type}: ${e.value}\n  (${e.explanation})')
            .join('\n\n');
      }
    } else if (_selectedComponentType == 'Resistencia') {
      final SmdComponentData? resResult = _parseResistance(code);
      if (resResult != null) {
        _componentType = resResult.type;
        _result = 'Valor: ${resResult.value}';
        _explanation = resResult.explanation;
      } else {
        _result = 'Código no reconocido como Resistencia.';
        _explanation =
            'Por favor, verifica el código. Ejemplos: 103 (10kΩ), 4702 (47kΩ), 4R7 (4.7Ω).';
        _componentType = 'Resistencia';
      }
    } else if (_selectedComponentType == 'Capacitor') {
      final SmdComponentData? capResult = _parseCapacitor(code);
      if (capResult != null) {
        _componentType = capResult.type;
        _result = 'Valor: ${capResult.value}';
        _explanation = capResult.explanation;
      } else {
        _result = 'Código no reconocido como Capacitor.';
        _explanation =
            'Por favor, verifica el código. Ejemplos: 104 (100nF), 220 (22pF), 4R7 (4.7pF).';
        _componentType = 'Capacitor';
      }
    } else if (_selectedComponentType == 'Inductor') {
      final SmdComponentData? indResult = _parseInductor(code);
      if (indResult != null) {
        _componentType = indResult.type;
        _result = 'Valor: ${indResult.value}';
        _explanation = indResult.explanation;
      } else {
        _result = 'Código no reconocido como Inductor.';
        _explanation =
            'Por favor, verifica el código. Ejemplos: 100 (10nH), 2R2 (2.2nH), 1N5 (1.5nH).';
        _componentType = 'Inductor';
      }
    } else {
      // Para Diodos, Transistores, Circuitos Integrados (no soportados)
      _result = 'Cálculo no soportado para $_selectedComponentType.';
      _explanation =
          'Las marcas de $_selectedComponentType son complejas y no estandarizadas. Consulta la hoja de datos (datasheet) del fabricante.';
      _componentType = _selectedComponentType;
    }

    setState(() {});
  }

  // --- Lógica de Parsing para RESISTENCIAS ---
  SmdComponentData? _parseResistance(String code) {
    if (RegExp(r'^\d{3}$').hasMatch(code)) {
      final int value = int.parse(code.substring(0, 2));
      final int multiplier = int.parse(code.substring(2, 3));
      final double resistance = value * math.pow(10, multiplier).toDouble();
      return SmdComponentData(
        type: 'Resistencia',
        value: '${_formatResistance(resistance)}Ω', // Interpolación aquí
        explanation:
            'Código de 3 dígitos (Resistencia): Los primeros dos dígitos son el valor, el tercero es el número de ceros.',
      );
    } else if (RegExp(r'^\d{4}$').hasMatch(code)) {
      final int value = int.parse(code.substring(0, 3));
      final int multiplier = int.parse(code.substring(3, 4));
      final double resistance = value * math.pow(10, multiplier).toDouble();
      return SmdComponentData(
        type: 'Resistencia',
        value: '${_formatResistance(resistance)}Ω', // Interpolación aquí
        explanation:
            'Código de 4 dígitos (Resistencia): Los primeros tres dígitos son el valor, el cuarto es el número de ceros.',
      );
    } else if (RegExp(r'^\d*[RKM]$', caseSensitive: false).hasMatch(code)) {
      final String numericPart = code.substring(0, code.length - 1);
      final String unitChar = code.substring(code.length - 1).toUpperCase();
      double multiplier = 1.0;

      if (unitChar == 'R') {
        multiplier = 1.0;
      }
      if (unitChar == 'K') {
        multiplier = 1000.0;
      }
      if (unitChar == 'M') {
        multiplier = 1000000.0;
      }

      final String valueStr = numericPart.replaceAll('R', '.');
      final double? value = double.tryParse(valueStr);

      if (value != null) {
        final double resistance = value * multiplier;
        return SmdComponentData(
          type: 'Resistencia',
          value: '${_formatResistance(resistance)}Ω', // Interpolación aquí
          explanation:
              'Código con R/K/M (Resistencia): R=punto decimal (Ohmios), K=kiloOhmios, M=MegaOhmios.',
        );
      }
    }
    return null; // No reconocido como Resistencia
  }

  // --- Lógica de Parsing para CAPACITORES ---
  SmdComponentData? _parseCapacitor(String code) {
    if (RegExp(r'^\d{3}$').hasMatch(code)) {
      final int value = int.parse(code.substring(0, 2));
      final int multiplier = int.parse(code.substring(2, 3));
      final double capacitance = value * math.pow(10, multiplier).toDouble();
      return SmdComponentData(
        type: 'Capacitor',
        value: '${_formatCapacitance(capacitance)}F', // Interpolación aquí
        explanation:
            'Código de 3 dígitos (Capacitor): Los primeros dos dígitos son el valor en pF, el tercero es el número de ceros.',
      );
    } else if (RegExp(r'^\d*[R]$', caseSensitive: false).hasMatch(code)) {
      final String valueStr = code.replaceAll('R', '.');
      final double? value = double.tryParse(valueStr);
      if (value != null) {
        return SmdComponentData(
          type: 'Capacitor',
          value: '${_formatCapacitance(value)}F', // Interpolación aquí
          explanation:
              'Código con R (Capacitor): R indica el punto decimal (valor en pF).',
        );
      }
    }
    return null; // No reconocido como Capacitor
  }

  // --- Lógica de Parsing para INDUCTORES ---
  SmdComponentData? _parseInductor(String code) {
    if (RegExp(r'^\d{3}$').hasMatch(code)) {
      final int value = int.parse(code.substring(0, 2));
      final int multiplier = int.parse(code.substring(2, 3));
      final double inductance = value * math.pow(10, multiplier).toDouble();
      return SmdComponentData(
        type: 'Inductor',
        value: '${_formatInductance(inductance)}H', // Interpolación aquí
        explanation:
            'Código de 3 dígitos (Inductor): Los primeros dos dígitos son el valor en nH, el tercero es el número de ceros.',
      );
    } else if (RegExp(r'^\d*[R]$', caseSensitive: false).hasMatch(code)) {
      final String valueStr = code.replaceAll('R', '.');
      final double? value = double.tryParse(valueStr);
      if (value != null) {
        return SmdComponentData(
          type: 'Inductor',
          value: '${_formatInductance(value)}H', // Interpolación aquí
          explanation:
              'Código con R (Inductor): R indica el punto decimal (valor en nH).',
        );
      }
    } else if (RegExp(r'^\d*[NMU]$', caseSensitive: false).hasMatch(code)) {
      final String numericPart = code.substring(0, code.length - 1);
      final String unitChar = code.substring(code.length - 1).toUpperCase();
      double multiplier = 1.0;

      if (unitChar == 'N') {
        multiplier = 1.0;
      }
      if (unitChar == 'M' || unitChar == 'U') {
        multiplier = 1000.0;
      }

      final String valueStr = numericPart.replaceAll('R', '.');
      final double? value = double.tryParse(valueStr);

      if (value != null) {
        final double inductance = value * multiplier;
        return SmdComponentData(
          type: 'Inductor',
          value: '${_formatInductance(inductance)}H', // Interpolación aquí
          explanation:
              'Código con N/M/U (Inductor): N=nanoHenrios, M/U=microHenrios.',
        );
      }
    }
    return null; // No reconocido como Inductor
  }

  // --- Funciones de Formato ---
  String _formatResistance(double value) {
    if (value >= 1000000000) {
      return '${(value / 1000000000).toStringAsFixed(value % 1000000000 == 0 ? 0 : 3)}G';
    }
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(value % 1000000 == 0 ? 0 : 3)}M';
    }
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(value % 1000 == 0 ? 0 : 3)}k';
    }
    return value.toStringAsFixed(value % 1 == 0 ? 0 : 3);
  }

  String _formatCapacitance(double value) {
    if (value >= 1000000000000) {
      return '${(value / 1000000000000).toStringAsFixed(value % 1000000000000 == 0 ? 0 : 3)}F';
    }
    if (value >= 1000000000) {
      return '${(value / 1000000000).toStringAsFixed(value % 1000000000 == 0 ? 0 : 3)}n';
    }
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(value % 1000000 == 0 ? 0 : 3)}µ';
    }
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(value % 1000 == 0 ? 0 : 3)}n';
    }
    return '${value.toStringAsFixed(value % 1 == 0 ? 0 : 3)}p'; // Interpolación aquí
  }

  String _formatInductance(double value) {
    if (value >= 1000000000) {
      return '${(value / 1000000000).toStringAsFixed(value % 1000000000 == 0 ? 0 : 3)}H';
    }
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(value % 1000000 == 0 ? 0 : 3)}m';
    }
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(value % 1000 == 0 ? 0 : 3)}µ';
    }
    return '${value.toStringAsFixed(value % 1 == 0 ? 0 : 3)}n'; // Interpolación aquí
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
              'Calculadora de Códigos de Componentes SMD',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedComponentType,
              decoration: InputDecoration(
                labelText: 'Selecciona Tipo de Componente',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              items: _componentTypesOptions.map((String type) {
                return DropdownMenuItem<String>(value: type, child: Text(type));
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedComponentType = newValue!;
                  _smdCodeController.clear();
                  _result = '';
                  _explanation = '';
                  _componentType = '';
                });
              },
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _smdCodeController,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                labelText: 'Introduce el código SMD',
                hintText:
                    'Ej: 103 (R/C), 4702 (R), 4R7 (R/C/L), 10K (R), 220 (C), 1N5 (L)',
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
                      _componentType = '';
                    });
                  },
                ),
              ),
              onSubmitted: (_) => _calculateSmdValue(),
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
                    'Tipo de Componente: $_componentType',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(height: 10),
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
