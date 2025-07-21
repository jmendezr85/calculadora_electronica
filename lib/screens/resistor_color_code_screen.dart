import 'package:flutter/material.dart';

class ResistorColorCodeScreen extends StatefulWidget {
  const ResistorColorCodeScreen({super.key});

  @override
  State<ResistorColorCodeScreen> createState() =>
      _ResistorColorCodeScreenState();
}

class _ResistorColorCodeScreenState extends State<ResistorColorCodeScreen> {
  // Mapas para almacenar los valores de los colores
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
    'Negro': 1, // 10^0
    'Marrón': 10, // 10^1
    'Rojo': 100, // 10^2
    'Naranja': 1000, // 10^3 (1k)
    'Amarillo': 10000, // 10^4
    'Verde': 100000, // 10^5
    'Azul': 1000000, // 10^6 (1M)
    'Violeta': 10000000, // 10^7
    'Gris': 100000000, // 10^8
    'Blanco': 1000000000, // 10^9 (1G)
    'Oro': 0.1, // 10^-1
    'Plata': 0.01, // 10^-2
  };

  final Map<String, String> _toleranceValue = {
    'Marrón': '±1%',
    'Rojo': '±2%',
    'Verde': '±0.5%',
    'Azul': '±0.25%',
    'Violeta': '±0.1%',
    'Gris': '±0.05%',
    'Oro': '±5%',
    'Plata': '±10%',
  };

  // Listas de colores disponibles para cada banda
  final List<String> _band1Colors = [
    'Marrón',
    'Rojo',
    'Naranja',
    'Amarillo',
    'Verde',
    'Azul',
    'Violeta',
    'Gris',
    'Blanco',
  ];
  final List<String> _band2Colors = [
    'Negro',
    'Marrón',
    'Rojo',
    'Naranja',
    'Amarillo',
    'Verde',
    'Azul',
    'Violeta',
    'Gris',
    'Blanco',
  ];
  final List<String> _band3Colors = [
    'Negro',
    'Marrón',
    'Rojo',
    'Naranja',
    'Amarillo',
    'Verde',
    'Azul',
    'Violeta',
    'Gris',
    'Blanco',
  ];
  final List<String> _multiplierColors = [
    'Negro',
    'Marrón',
    'Rojo',
    'Naranja',
    'Amarillo',
    'Verde',
    'Azul',
    'Violeta',
    'Gris',
    'Blanco',
    'Oro',
    'Plata',
  ];
  final List<String> _toleranceColors = [
    'Marrón',
    'Rojo',
    'Verde',
    'Azul',
    'Violeta',
    'Gris',
    'Oro',
    'Plata',
  ];

  // Colores seleccionados por el usuario
  String? _selectedBand1;
  String? _selectedBand2;
  String? _selectedMultiplier;
  String? _selectedTolerance;
  String? _selectedBand3; // Para 5 y 6 bandas

  // Resultado
  String _resistanceValue = '';
  String _tolerance = '';

  // Número de bandas (4, 5, o 6)
  int _numberOfBands = 4;

  @override
  void initState() {
    super.initState();
    // Inicializar con valores por defecto o dejar en null para forzar selección
    _selectedBand1 = null;
    _selectedBand2 = null;
    _selectedMultiplier = null;
    _selectedTolerance = null;
    _selectedBand3 = null;
    _calculateResistance(); // Calcular con valores iniciales (o mostrar "selecciona colores")
  }

  void _calculateResistance() {
    // Si es de 4 bandas, ignoramos _selectedBand3
    if (_numberOfBands == 4) {
      if (_selectedBand1 != null &&
          _selectedBand2 != null &&
          _selectedMultiplier != null &&
          _selectedTolerance != null) {
        final int band1Val = _bandValue[_selectedBand1]!;
        final int band2Val = _bandValue[_selectedBand2]!;
        final double multiplierVal = _multiplierValue[_selectedMultiplier]!;
        final String toleranceVal = _toleranceValue[_selectedTolerance]!;

        double resistance = (band1Val * 10 + band2Val) * multiplierVal;

        setState(() {
          _resistanceValue = _formatResistance(resistance);
          _tolerance = toleranceVal;
        });
      } else {
        setState(() {
          _resistanceValue = 'Selecciona todos los colores';
          _tolerance = '';
        });
      }
    }
    // Si es de 5 o 6 bandas, incluimos _selectedBand3
    else {
      if (_selectedBand1 != null &&
          _selectedBand2 != null &&
          _selectedBand3 != null &&
          _selectedMultiplier != null &&
          _selectedTolerance != null) {
        final int band1Val = _bandValue[_selectedBand1]!;
        final int band2Val = _bandValue[_selectedBand2]!;
        final int band3Val = _bandValue[_selectedBand3]!;
        final double multiplierVal = _multiplierValue[_selectedMultiplier]!;
        final String toleranceVal = _toleranceValue[_selectedTolerance]!;

        double resistance =
            (band1Val * 100 + band2Val * 10 + band3Val) * multiplierVal;

        setState(() {
          _resistanceValue = _formatResistance(resistance);
          _tolerance = toleranceVal;
        });
      } else {
        setState(() {
          _resistanceValue = 'Selecciona todos los colores';
          _tolerance = '';
        });
      }
    }
  }

  String _formatResistance(double value) {
    if (value.abs() >= 1e9) {
      return '${(value / 1e9).toStringAsFixed(3)} GΩ';
    } else if (value.abs() >= 1e6) {
      return '${(value / 1e6).toStringAsFixed(3)} MΩ';
    } else if (value.abs() >= 1e3) {
      return '${(value / 1e3).toStringAsFixed(3)} kΩ';
    } else {
      return '${value.toStringAsFixed(3)} Ω';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Código de Colores de Resistencias'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Selector de número de bandas
            const Text(
              'Número de Bandas:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ChoiceChip(
                  label: const Text('4 Bandas'),
                  selected: _numberOfBands == 4,
                  onSelected: (bool selected) {
                    setState(() {
                      _numberOfBands = 4;
                      _selectedBand3 =
                          null; // Resetea la 3ra banda si cambia a 4
                      _calculateResistance();
                    });
                  },
                ),
                ChoiceChip(
                  label: const Text('5 Bandas'),
                  selected: _numberOfBands == 5,
                  onSelected: (bool selected) {
                    setState(() {
                      _numberOfBands = 5;
                      _calculateResistance();
                    });
                  },
                ),
                ChoiceChip(
                  label: const Text('6 Bandas'),
                  selected: _numberOfBands == 6,
                  onSelected: (bool selected) {
                    setState(() {
                      _numberOfBands = 6;
                      // En 6 bandas, la última banda es de coeficiente de temperatura,
                      // pero la lógica de cálculo es la misma que 5 bandas en cuanto a las primeras 3.
                      _calculateResistance();
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Selectores de color
            _buildDropdown('Banda 1 (Digito 1)', _selectedBand1, _band1Colors, (
              String? newValue,
            ) {
              setState(() {
                _selectedBand1 = newValue;
                _calculateResistance();
              });
            }),
            _buildDropdown('Banda 2 (Digito 2)', _selectedBand2, _band2Colors, (
              String? newValue,
            ) {
              setState(() {
                _selectedBand2 = newValue;
                _calculateResistance();
              });
            }),
            // Banda 3 solo visible para 5 o 6 bandas
            if (_numberOfBands >= 5)
              _buildDropdown(
                'Banda 3 (Digito 3)',
                _selectedBand3,
                _band3Colors,
                (String? newValue) {
                  setState(() {
                    _selectedBand3 = newValue;
                    _calculateResistance();
                  });
                },
              ),
            _buildDropdown(
              'Multiplicador',
              _selectedMultiplier,
              _multiplierColors,
              (String? newValue) {
                setState(() {
                  _selectedMultiplier = newValue;
                  _calculateResistance();
                });
              },
            ),
            _buildDropdown('Tolerancia', _selectedTolerance, _toleranceColors, (
              String? newValue,
            ) {
              setState(() {
                _selectedTolerance = newValue;
                _calculateResistance();
              });
            }),
            const SizedBox(height: 24),

            // Resultados
            Text(
              'Valor de Resistencia:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              _resistanceValue,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
            ),
            const SizedBox(height: 12),
            Text('Tolerancia:', style: Theme.of(context).textTheme.titleLarge),
            Text(
              _tolerance,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.blue[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    String? selectedValue,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        value: selectedValue,
        hint: Text('Selecciona el color para $label'),
        onChanged: onChanged,
        items: items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  color: _getColor(value), // Helper para obtener el color real
                  margin: const EdgeInsets.only(right: 10),
                ),
                Text(value),
              ],
            ),
          );
        }).toList(),
      ),
    );
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
        return Colors.purple; // No hay violeta directo, morado es cercano
      case 'Gris':
        return Colors.grey;
      case 'Blanco':
        return Colors.white;
      case 'Oro':
        return const Color(0xFFFFD700); // Color oro
      case 'Plata':
        return const Color(0xFFC0C0C0); // Color plata
      default:
        return Colors.transparent;
    }
  }
}
