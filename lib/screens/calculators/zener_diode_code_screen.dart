// lib/screens/zener_diode_code_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Para InputFormatter

class ZenerDiodeCodeScreen extends StatefulWidget {
  const ZenerDiodeCodeScreen({super.key});

  @override
  State<ZenerDiodeCodeScreen> createState() => _ZenerDiodeCodeScreenState();
}

class _ZenerDiodeCodeScreenState extends State<ZenerDiodeCodeScreen> {
  final TextEditingController _codeController = TextEditingController();
  String _resultVoltage = '';
  String _resultPower = '';
  String _resultExplanation = '';

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _decodeZenerCode() {
    setState(() {
      _resultVoltage = '';
      _resultPower = '';
      _resultExplanation = '';

      final String code = _codeController.text.trim().toUpperCase();

      if (code.isEmpty) {
        _resultExplanation = 'Por favor, introduce un código de diodo Zener.';
        return;
      }

      // --- Decodificación de códigos comunes de diodos Zener ---

      // Estándar 1Nxxxx (ej: 1N4735A -> 6.2V)
      if (code.startsWith('1N') && code.length >= 6) {
        final String numPart = code.substring(2, 6); // Ej: "4735" de 1N4735A
        // Implementa un mapa o lógica para los códigos 1N si tienes una tabla de referencia
        // Por ahora, solo un ejemplo básico:
        if (numPart == '4735') {
          _resultVoltage = '6.2 V';
          _resultPower = '1 W';
          _resultExplanation =
              'Diodo Zener de 6.2 Voltios, 1 Watt (ejemplo común).';
        } else if (numPart == '4733') {
          _resultVoltage = '5.1 V';
          _resultPower = '1 W';
          _resultExplanation =
              'Diodo Zener de 5.1 Voltios, 1 Watt (ejemplo común).';
        } else {
          _resultExplanation =
              'Código 1Nxxxx no reconocido. Consulta la hoja de datos.';
        }
        return;
      }

      // Código de 2 caracteres y un número (ej: C3V3 -> 3.3V, 4V7 -> 4.7V, 10V -> 10V)
      // Este formato es más común en diodos SMD.
      // Formato: Digito/V/Digito (4V7), V/Digito (V51), Digito/Digito/V (3V3)
      final RegExp regExpVoltage = RegExp(r'^(\d+)?V(\d+)?$');
      Match? match = regExpVoltage.firstMatch(code);

      if (match != null) {
        final String? preV = match.group(1); // Parte antes de 'V'
        final String? postV = match.group(2); // Parte después de 'V'

        String voltageStr = '';
        if (preV != null) voltageStr += preV;
        if (postV != null) voltageStr += '.$postV';

        final double? voltage = double.tryParse(voltageStr);

        if (voltage != null) {
          _resultVoltage = '$voltage V';
          _resultExplanation = 'Valor de Voltaje Zener decodificado.';
          // La potencia (Wattage) a menudo no se deduce del código, requiere datasheet.
          _resultPower = 'Potencia: Consultar hoja de datos.';
          return;
        }
      }

      // Códigos con sufijo W (ej: 3V3W -> 3.3V) - a veces el 'W' indica potencia
      // No siempre es el voltaje, a veces indica que es de alta potencia, o es parte de un código complejo.
      // Esta lógica es más especulativa sin una tabla clara.
      if (code.endsWith('W') && code.length > 1) {
        final String potentialVoltageCode = code.substring(0, code.length - 1);
        match = regExpVoltage.firstMatch(potentialVoltageCode);
        if (match != null) {
          final String? preV = match.group(1);
          final String? postV = match.group(2);

          String voltageStr = '';
          if (preV != null) voltageStr += preV;
          if (postV != null) voltageStr += '.$postV';

          final double? voltage = double.tryParse(voltageStr);
          if (voltage != null) {
            _resultVoltage = '$voltage V';
            _resultPower =
                'Potencia: Posiblemente alta, consultar hoja de datos.';
            _resultExplanation =
                'Valor de Voltaje Zener decodificado (código con "W" final).';
            return;
          }
        }
      }

      // Si no se encontró ningún formato conocido
      _resultExplanation =
          'Formato de código no reconocido. Consulta la hoja de datos del componente.';
    });
  }

  void _clearFields() {
    setState(() {
      _codeController.clear();
      _resultVoltage = '';
      _resultPower = '';
      _resultExplanation = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Código Diodo Zener'),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Introduce el código marcado en el diodo Zener para intentar decodificarlo.',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _codeController,
              keyboardType: TextInputType.text,
              textCapitalization:
                  TextCapitalization.characters, // Para convertir a mayúsculas
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r'[0-9A-Z.]'),
                ), // Solo números, letras mayúsculas y puntos
              ],
              decoration: InputDecoration(
                labelText: 'Código del Diodo Zener',
                hintText: 'Ej: 1N4735A, C5V1, 4V7, 10V',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: _clearFields,
                ),
              ),
              onSubmitted: (_) => _decodeZenerCode(),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _decodeZenerCode,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Decodificar', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: _clearFields,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Limpiar', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 24),
            if (_resultVoltage.isNotEmpty ||
                _resultPower.isNotEmpty ||
                _resultExplanation.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withAlpha(
                    128,
                  ), // Ajustado para evitar el error anterior
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_resultVoltage.isNotEmpty)
                      Text(
                        'Voltaje Zener: $_resultVoltage',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onPrimaryContainer,
                            ),
                      ),
                    if (_resultPower.isNotEmpty)
                      Text(
                        _resultPower,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(color: colorScheme.onSurfaceVariant),
                      ),
                    if (_resultExplanation.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(
                          top:
                              _resultVoltage.isNotEmpty ||
                                  _resultPower.isNotEmpty
                              ? 8.0
                              : 0.0,
                        ),
                        child: Text(
                          _resultExplanation,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontStyle: FontStyle.italic,
                                color: colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
