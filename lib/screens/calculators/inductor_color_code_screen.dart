// lib/screens/inductor_color_code_screen.dart
import 'package:flutter/material.dart';

class InductorColorCodeScreen extends StatefulWidget {
  const InductorColorCodeScreen({super.key});

  @override
  State<InductorColorCodeScreen> createState() =>
      _InductorColorCodeScreenState();
}

class _InductorColorCodeScreenState extends State<InductorColorCodeScreen> {
  // Aquí puedes definir los controladores para los DropdownButtons o TextField si los usas
  // Ejemplo:
  String? _selectedBand1;
  String? _selectedBand2;
  String? _selectedMultiplier;
  String? _selectedTolerance;

  String _result = ''; // Para mostrar el valor del inductor
  String _toleranceResult = ''; // Para mostrar la tolerancia

  // Define los colores y sus valores/multiplicadores/tolerancias para inductores
  // (Esto es un ejemplo, las tablas de código de colores de inductores pueden variar,
  // asegúrate de usar la tabla estándar que desees)
  final Map<String, int> _bandValue = {
    'Negro': 0,
    'Marrón': 1,
    'Rojo': 2,
    'Naranja': 3,
    'Amarillo': 4,
    'Verde': 5,
    'Azul': 6,
    'Violeta': 7,
    'Gris': 8,
    'Blanco': 9,
  };

  final Map<String, double> _multiplierValue = {
    'Negro': 1,
    'Marrón': 10,
    'Rojo': 100,
    'Naranja': 1000,
    'Amarillo': 10000,
    'Verde': 100000,
    'Azul': 1000000,
    'Violeta': 10000000,
    'Gris': 100000000,
    'Blanco': 1000000000,
    'Oro': 0.1,
    'Plata': 0.01,
  };

  final Map<String, String> _toleranceValue = {
    'Marrón': '±1%',
    'Rojo': '±2%',
    'Oro': '±5%',
    'Plata': '±10%',
  };

  void _calculateInductorValue() {
    setState(() {
      if (_selectedBand1 == null ||
          _selectedBand2 == null ||
          _selectedMultiplier == null) {
        _result = 'Por favor, selecciona al menos 3 bandas.';
        _toleranceResult = '';
        return;
      }

      // Convertir las bandas a números
      int? val1 = _bandValue[_selectedBand1];
      int? val2 = _bandValue[_selectedBand2];
      double? multiplier = _multiplierValue[_selectedMultiplier];

      if (val1 == null || val2 == null || multiplier == null) {
        _result = 'Error en la selección de colores.';
        _toleranceResult = '';
        return;
      }

      // Calcular el valor base (ej: 10, 22, 47, etc.)
      double baseValue = double.parse('$val1$val2');

      // Calcular el valor final
      double inductorValue = baseValue * multiplier;

      // Formatear el resultado para mostrar en unidades amigables (nH, µH, mH)
      String formattedValue;
      if (inductorValue >= 1000000000) {
        formattedValue = '${inductorValue / 1000000000} H';
      } else if (inductorValue >= 1000000) {
        formattedValue = '${inductorValue / 1000000} mH';
      } else if (inductorValue >= 1000) {
        formattedValue = '${inductorValue / 1000} µH';
      } else {
        formattedValue = '$inductorValue nH'; // Valor base en nanohenrios
      }

      _result = 'Inductancia: $formattedValue';
      _toleranceResult = _selectedTolerance != null
          ? 'Tolerancia: ${_toleranceValue[_selectedTolerance]}'
          : 'Tolerancia: N/A';
    });
  }

  void _clearFields() {
    setState(() {
      _selectedBand1 = null;
      _selectedBand2 = null;
      _selectedMultiplier = null;
      _selectedTolerance = null;
      _result = '';
      _toleranceResult = '';
    });
  }

  // Helper para obtener el objeto Color de Flutter dado un nombre de color
  Color _getColor(String colorName) {
    switch (colorName) {
      case 'Negro':
        return Colors.black;
      case 'Marrón':
        return Colors.brown;
      case 'Rojo':
        return Colors.red;
      case 'Naranja':
        return Colors.orange;
      case 'Amarillo':
        return Colors.yellow;
      case 'Verde':
        return Colors.green;
      case 'Azul':
        return Colors.blue;
      case 'Violeta':
        return Colors.purple;
      case 'Gris':
        return Colors.grey;
      case 'Blanco':
        return Colors.white;
      case 'Oro':
        return const Color(0xFFFFD700); // Oro
      case 'Plata':
        return const Color(0xFFC0C0C0); // Plata
      default:
        return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Código de Colores de Inductores'),
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
              'Selecciona las bandas de color del inductor para calcular su valor.',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Band 1
            _buildColorDropdown(
              'Banda 1 (Primer Dígito)',
              _selectedBand1,
              _bandValue.keys.toList(),
              (String? newValue) {
                setState(() {
                  _selectedBand1 = newValue;
                });
              },
            ),
            const SizedBox(height: 16),

            // Band 2
            _buildColorDropdown(
              'Banda 2 (Segundo Dígito)',
              _selectedBand2,
              _bandValue.keys.toList(),
              (String? newValue) {
                setState(() {
                  _selectedBand2 = newValue;
                });
              },
            ),
            const SizedBox(height: 16),

            // Multiplier Band
            _buildColorDropdown(
              'Banda Multiplicador',
              _selectedMultiplier,
              _multiplierValue.keys.toList(),
              (String? newValue) {
                setState(() {
                  _selectedMultiplier = newValue;
                });
              },
            ),
            const SizedBox(height: 16),

            // Tolerance Band (Optional)
            _buildColorDropdown(
              'Banda de Tolerancia (Opcional)',
              _selectedTolerance,
              _toleranceValue.keys.toList(),
              (String? newValue) {
                setState(() {
                  _selectedTolerance = newValue;
                });
              },
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _calculateInductorValue,
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

            if (_result.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withAlpha(128),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      _result,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onPrimaryContainer,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    if (_toleranceResult.isNotEmpty)
                      Text(
                        _toleranceResult,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(color: colorScheme.onSurfaceVariant),
                        textAlign: TextAlign.center,
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorDropdown(
    String label,
    String? selectedValue,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.outline),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedValue,
              hint: Text(
                'Selecciona un color',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              onChanged: onChanged,
              items: items.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          color: _getColor(value),
                          border: Border.all(
                            color: Colors.grey.shade400,
                            width: 0.5,
                          ),
                        ),
                      ),
                      Text(value),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
