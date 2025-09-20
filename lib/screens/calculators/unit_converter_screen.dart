import 'package:calculadora_electronica/utils/unit_utils.dart'; // Importa las utilidades de unidades
import 'package:flutter/material.dart';

// --- 1. (UnitPrefix ahora viene de unit_utils.dart) ---

// --- 2. Definición de Unidades Electrónicas ---
// Ahora cada ElectronicUnit puede tener un UnitPrefix asociado.
class ElectronicUnit {
  final String name; // Nombre de la unidad base (ej. "Voltios", "Faradios")
  final String baseSymbol; // Símbolo de la unidad base (ej. "V", "F")
  final String category; // Ej: "Voltaje", "Corriente", "Resistencia"
  final UnitPrefix?
  prefix; // Prefijo asociado a esta unidad (mili, micro, etc.)

  const ElectronicUnit(
    this.name,
    this.baseSymbol,
    this.category, {
    this.prefix,
  });

  // Método para obtener el símbolo completo de la unidad (ej. mV, kΩ, µF)
  String get fullSymbol => '${prefix?.symbol ?? ''}$baseSymbol';

  // Método para obtener el factor de conversión total a la unidad base de su categoría
  double get totalConversionFactor => prefix?.multiplier ?? 1.0;

  // Todas las unidades electrónicas con sus prefijos si aplican
  static final List<ElectronicUnit> all = [
    // Voltaje
    ElectronicUnit(
      'Voltios',
      'V',
      'Voltaje',
      prefix: UnitPrefix.all[4],
    ), // Ninguno
    ElectronicUnit(
      'Milivoltios',
      'V',
      'Voltaje',
      prefix: UnitPrefix.all[3],
    ), // Mili
    ElectronicUnit(
      'Microvoltios',
      'V',
      'Voltaje',
      prefix: UnitPrefix.all[2],
    ), // Micro
    ElectronicUnit(
      'Nanovoltios',
      'V',
      'Voltaje',
      prefix: UnitPrefix.all[1],
    ), // Nano
    ElectronicUnit(
      'Picovoltios',
      'V',
      'Voltaje',
      prefix: UnitPrefix.all[0],
    ), // Pico
    // Corriente
    ElectronicUnit(
      'Amperios',
      'A',
      'Corriente',
      prefix: UnitPrefix.all[4],
    ), // Ninguno
    ElectronicUnit(
      'Miliamperios',
      'A',
      'Corriente',
      prefix: UnitPrefix.all[3],
    ), // Mili
    ElectronicUnit(
      'Microamperios',
      'A',
      'Corriente',
      prefix: UnitPrefix.all[2],
    ), // Micro
    ElectronicUnit(
      'Nanoamperios',
      'A',
      'Corriente',
      prefix: UnitPrefix.all[1],
    ), // Nano
    ElectronicUnit(
      'Picoamperios',
      'A',
      'Corriente',
      prefix: UnitPrefix.all[0],
    ), // Pico
    // Resistencia
    ElectronicUnit(
      'Ohmios',
      'Ω',
      'Resistencia',
      prefix: UnitPrefix.all[4],
    ), // Ninguno
    ElectronicUnit(
      'Miliohmios',
      'Ω',
      'Resistencia',
      prefix: UnitPrefix.all[3],
    ), // Mili
    ElectronicUnit(
      'Kiloohmios',
      'Ω',
      'Resistencia',
      prefix: UnitPrefix.all[5],
    ), // Kilo
    ElectronicUnit(
      'Megaohmios',
      'Ω',
      'Resistencia',
      prefix: UnitPrefix.all[6],
    ), // Mega
    ElectronicUnit(
      'Gigaohmios',
      'Ω',
      'Resistencia',
      prefix: UnitPrefix.all[7],
    ), // Giga
    // Capacitancia
    ElectronicUnit(
      'Faradios',
      'F',
      'Capacitancia',
      prefix: UnitPrefix.all[4],
    ), // Ninguno
    ElectronicUnit(
      'Milifaradios',
      'F',
      'Capacitancia',
      prefix: UnitPrefix.all[3],
    ), // Mili
    ElectronicUnit(
      'Microfaradios',
      'F',
      'Capacitancia',
      prefix: UnitPrefix.all[2],
    ), // Micro
    ElectronicUnit(
      'Nanofaradios',
      'F',
      'Capacitancia',
      prefix: UnitPrefix.all[1],
    ), // Nano
    ElectronicUnit(
      'Picofaradios',
      'F',
      'Capacitancia',
      prefix: UnitPrefix.all[0],
    ), // Pico
    // Inductancia
    ElectronicUnit(
      'Henrios',
      'H',
      'Inductancia',
      prefix: UnitPrefix.all[4],
    ), // Ninguno
    ElectronicUnit(
      'Milihenrios',
      'H',
      'Inductancia',
      prefix: UnitPrefix.all[3],
    ), // Mili
    ElectronicUnit(
      'Microhenrios',
      'H',
      'Inductancia',
      prefix: UnitPrefix.all[2],
    ), // Micro
    ElectronicUnit(
      'Nanohenrios',
      'H',
      'Inductancia',
      prefix: UnitPrefix.all[1],
    ), // Nano
    ElectronicUnit(
      'Picohenrios',
      'H',
      'Inductancia',
      prefix: UnitPrefix.all[0],
    ), // Pico
    // Frecuencia
    ElectronicUnit(
      'Hertz',
      'Hz',
      'Frecuencia',
      prefix: UnitPrefix.all[4],
    ), // Ninguno
    ElectronicUnit(
      'KiloHertz',
      'Hz',
      'Frecuencia',
      prefix: UnitPrefix.all[5],
    ), // Kilo
    ElectronicUnit(
      'MegaHertz',
      'Hz',
      'Frecuencia',
      prefix: UnitPrefix.all[6],
    ), // Mega
    ElectronicUnit(
      'GigaHertz',
      'Hz',
      'Frecuencia',
      prefix: UnitPrefix.all[7],
    ), // Giga
    // Potencia
    ElectronicUnit(
      'Vatios',
      'W',
      'Potencia',
      prefix: UnitPrefix.all[4],
    ), // Ninguno
    ElectronicUnit(
      'Milivatios',
      'W',
      'Potencia',
      prefix: UnitPrefix.all[3],
    ), // Mili
    ElectronicUnit(
      'Kilovatios',
      'W',
      'Potencia',
      prefix: UnitPrefix.all[5],
    ), // Kilo
    ElectronicUnit(
      'Megavatios',
      'W',
      'Potencia',
      prefix: UnitPrefix.all[6],
    ), // Mega
  ];
}

// --- 3. La pantalla del Conversor de Unidades ---
class UnitConverterScreen extends StatefulWidget {
  const UnitConverterScreen({super.key});

  @override
  State<UnitConverterScreen> createState() => _UnitConverterScreenState();
}

class _UnitConverterScreenState extends State<UnitConverterScreen> {
  final TextEditingController _inputValueController = TextEditingController();
  String _outputValue = '';

  // Categorías de unidades
  final List<String> _unitCategories = ElectronicUnit.all
      .map((u) => u.category)
      .toSet()
      .toList();

  // Unidad de entrada y salida seleccionadas
  String? _selectedCategory;
  ElectronicUnit? _inputUnit;
  ElectronicUnit? _outputUnit;

  @override
  void initState() {
    super.initState();
    if (_unitCategories.isNotEmpty) {
      _selectedCategory = _unitCategories.first;
      _updateUnitsForCategory();
    }
  }

  void _updateUnitsForCategory() {
    if (_selectedCategory == null) return;
    final List<ElectronicUnit> unitsInSelectedCategory = ElectronicUnit.all
        .where((unit) => unit.category == _selectedCategory)
        .toList();

    setState(() {
      if (unitsInSelectedCategory.isNotEmpty) {
        _inputUnit = unitsInSelectedCategory.first;
        _outputUnit = unitsInSelectedCategory.first;
      } else {
        _inputUnit = null;
        _outputUnit = null;
      }
      _outputValue = ''; // Limpiar resultado al cambiar de categoría
    });
  }

  void _convertUnits() {
    final double? inputValue = double.tryParse(_inputValueController.text);

    if (inputValue == null || _inputUnit == null || _outputUnit == null) {
      setState(() {
        _outputValue = 'Introduce un valor y selecciona unidades.';
      });
      return;
    }

    // Convertir el valor de la unidad de entrada a la unidad base de su categoría
    // Usamos totalConversionFactor que incluye el multiplicador del prefijo
    final double valueInBaseUnit =
        inputValue * _inputUnit!.totalConversionFactor;

    // Convertir el valor de la unidad base a la unidad de salida
    final double convertedValue =
        valueInBaseUnit / _outputUnit!.totalConversionFactor;

    setState(() {
      _outputValue =
          '${convertedValue.toStringAsFixed(6).replaceAll(RegExp(r'\.0*$'), '')} ${_outputUnit!.fullSymbol}';
    });
  }

  @override
  void dispose() {
    _inputValueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<ElectronicUnit> unitsInSelectedCategory =
        _selectedCategory == null
        ? []
        : ElectronicUnit.all
              .where((unit) => unit.category == _selectedCategory)
              .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversor de Unidades'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'Convierte valores entre diferentes unidades electrónicas.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Selector de Categoría
            DropdownButtonFormField<String>(
              initialValue: _selectedCategory,
              decoration: InputDecoration(
                labelText: 'Selecciona la Categoría de Unidad',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: _unitCategories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategory = newValue;
                  _updateUnitsForCategory();
                });
              },
            ),
            const SizedBox(height: 20),

            // Campo de Entrada de Valor
            TextField(
              controller: _inputValueController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Valor a convertir',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _inputValueController.clear();
                    setState(() {
                      _outputValue = '';
                    });
                  },
                ),
              ),
              onChanged: (value) {
                // Puedes optar por convertir en tiempo real o solo al presionar el botón
              },
            ),
            const SizedBox(height: 20),

            // Selectores de Unidades (De y A)
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<ElectronicUnit>(
                    initialValue: _inputUnit,
                    decoration: InputDecoration(
                      labelText: 'De Unidad',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: unitsInSelectedCategory.map((ElectronicUnit unit) {
                      // Usa fullSymbol para mostrar el símbolo completo (ej. "mV", "kΩ")
                      return DropdownMenuItem<ElectronicUnit>(
                        value: unit,
                        child: Text('${unit.name} (${unit.fullSymbol})'),
                      );
                    }).toList(),
                    onChanged: (ElectronicUnit? newValue) {
                      setState(() {
                        _inputUnit = newValue;
                        _outputValue = '';
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(Icons.arrow_right_alt, size: 30),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<ElectronicUnit>(
                    initialValue: _outputUnit,
                    decoration: InputDecoration(
                      labelText: 'A Unidad',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: unitsInSelectedCategory.map((ElectronicUnit unit) {
                      // Usa fullSymbol para mostrar el símbolo completo (ej. "mV", "kΩ")
                      return DropdownMenuItem<ElectronicUnit>(
                        value: unit,
                        child: Text('${unit.name} (${unit.fullSymbol})'),
                      );
                    }).toList(),
                    onChanged: (ElectronicUnit? newValue) {
                      setState(() {
                        _outputUnit = newValue;
                        _outputValue = '';
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _convertUnits,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Convertir', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 30),

            // Resultado
            if (_outputValue.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Resultado de Conversión:',
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
                      _outputValue,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
