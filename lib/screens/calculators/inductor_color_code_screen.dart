import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:calculadora_electronica/main.dart'; // Asegúrate de que esta ruta sea correcta

class InductorColorCodeScreen extends StatefulWidget {
  const InductorColorCodeScreen({super.key});

  @override
  State<InductorColorCodeScreen> createState() =>
      _InductorColorCodeScreenState();
}

class _InductorColorCodeScreenState extends State<InductorColorCodeScreen> {
  String? _selectedBand1;
  String? _selectedBand2;
  String? _selectedMultiplier;
  String? _selectedTolerance;
  String? _selectedBand3; // New for 5-band code
  String? _selectedTempCoeff; // New for 5-band code

  bool _is5Band = false; // Toggle for 4 vs 5 bands

  String _result = '';
  String _toleranceResult = '';
  String _tempCoeffResult = '';

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

  final Map<String, String> _tempCoeffValue = {
    'Negro': '250 ppm/°C',
    'Marrón': '100 ppm/°C',
    'Rojo': '50 ppm/°C',
    'Naranja': '15 ppm/°C',
    'Amarillo': '25 ppm/°C',
    'Verde': '20 ppm/°C',
    'Azul': '10 ppm/°C',
    'Violeta': '5 ppm/°C',
  };

  void _calculateInductorValue() {
    setState(() {
      if (_selectedBand1 == null ||
          _selectedBand2 == null ||
          _selectedMultiplier == null) {
        _result = 'Por favor, selecciona al menos 3 bandas.';
        _toleranceResult = '';
        _tempCoeffResult = '';
        return;
      }

      if (_is5Band && _selectedBand3 == null) {
        _result =
            'Por favor, selecciona la tercera banda para el código de 5 bandas.';
        _toleranceResult = '';
        _tempCoeffResult = '';
        return;
      }

      int? val1 = _bandValue[_selectedBand1];
      int? val2 = _bandValue[_selectedBand2];
      int? val3 = _is5Band ? _bandValue[_selectedBand3] : null;
      double? multiplier = _multiplierValue[_selectedMultiplier];

      if (val1 == null ||
          val2 == null ||
          multiplier == null ||
          (_is5Band && val3 == null)) {
        _result = 'Error en la selección de colores.';
        _toleranceResult = '';
        _tempCoeffResult = '';
        return;
      }

      String baseValueString = _is5Band ? '$val1$val2$val3' : '$val1$val2';
      double baseValue = double.parse(baseValueString);

      double inductorValue = baseValue * multiplier;

      String formattedValue;
      if (inductorValue >= 1000000000) {
        formattedValue = '${inductorValue / 1000000000} H';
      } else if (inductorValue >= 1000000) {
        formattedValue = '${inductorValue / 1000000} mH';
      } else if (inductorValue >= 1000) {
        formattedValue = '${inductorValue / 1000} µH';
      } else {
        formattedValue = '$inductorValue nH';
      }

      _result = 'Inductancia: $formattedValue';
      _toleranceResult = _selectedTolerance != null
          ? 'Tolerancia: ${_toleranceValue[_selectedTolerance]}'
          : 'Tolerancia: N/A';
      _tempCoeffResult = _is5Band && _selectedTempCoeff != null
          ? 'Coeficiente de Temperatura: ${_tempCoeffValue[_selectedTempCoeff]}'
          : '';
    });
  }

  void _clearFields() {
    setState(() {
      _selectedBand1 = null;
      _selectedBand2 = null;
      _selectedBand3 = null;
      _selectedMultiplier = null;
      _selectedTolerance = null;
      _selectedTempCoeff = null;
      _result = '';
      _toleranceResult = '';
      _tempCoeffResult = '';
    });
  }

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
        return const Color(0xFFFFD700);
      case 'Plata':
        return const Color(0xFFC0C0C0);
      default:
        return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final settings = Provider.of<AppSettings>(context);

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
            _buildColorDropdown(
              'Banda 1 (Primer Dígito)',
              _selectedBand1,
              _bandValue.keys.toList(),
              (String? newValue) => setState(() => _selectedBand1 = newValue),
            ),
            const SizedBox(height: 16),
            _buildColorDropdown(
              'Banda 2 (Segundo Dígito)',
              _selectedBand2,
              _bandValue.keys.toList(),
              (String? newValue) => setState(() => _selectedBand2 = newValue),
            ),
            if (settings.professionalMode && _is5Band) ...[
              const SizedBox(height: 16),
              _buildColorDropdown(
                'Banda 3 (Tercer Dígito)',
                _selectedBand3,
                _bandValue.keys.toList(),
                (String? newValue) => setState(() => _selectedBand3 = newValue),
              ),
            ],
            const SizedBox(height: 16),
            _buildColorDropdown(
              'Banda Multiplicador',
              _selectedMultiplier,
              _multiplierValue.keys.toList(),
              (String? newValue) =>
                  setState(() => _selectedMultiplier = newValue),
            ),
            const SizedBox(height: 16),
            _buildColorDropdown(
              'Banda de Tolerancia',
              _selectedTolerance,
              _toleranceValue.keys.toList(),
              (String? newValue) =>
                  setState(() => _selectedTolerance = newValue),
            ),
            if (settings.professionalMode && _is5Band) ...[
              const SizedBox(height: 16),
              _buildColorDropdown(
                'Banda de Coeficiente de Temp.',
                _selectedTempCoeff,
                _tempCoeffValue.keys.toList(),
                (String? newValue) =>
                    setState(() => _selectedTempCoeff = newValue),
              ),
            ],
            const SizedBox(height: 24),
            // Sección de Modo Profesional
            if (settings.professionalMode) ...[
              _buildProfessionalModeSection(colorScheme),
              const SizedBox(height: 24),
            ],
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
                    if (_tempCoeffResult.isNotEmpty)
                      Text(
                        _tempCoeffResult,
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

  Widget _buildProfessionalModeSection(ColorScheme colorScheme) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Opciones de Modo Profesional',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
                Icon(Icons.precision_manufacturing, color: colorScheme.primary),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Código de 5 bandas'),
              value: _is5Band,
              onChanged: (bool value) {
                setState(() {
                  _is5Band = value;
                  _clearFields();
                });
              },
              secondary: const Icon(Icons.palette),
            ),
          ],
        ),
      ),
    );
  }
}
