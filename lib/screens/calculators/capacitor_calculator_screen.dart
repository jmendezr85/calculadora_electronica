import 'package:flutter/material.dart';

class CapacitorCalculatorScreen extends StatefulWidget {
  const CapacitorCalculatorScreen({super.key});

  @override
  State<CapacitorCalculatorScreen> createState() =>
      _CapacitorCalculatorScreenState();
}

class _CapacitorCalculatorScreenState extends State<CapacitorCalculatorScreen> {
  final List<TextEditingController> _capacitorControllers = [];
  final FocusNode _lastTextFieldFocusNode =
      FocusNode(); // Para añadir nuevos campos al perder el foco

  String _resultSeries = '';
  String _resultParallel = '';
  int _numberOfCapacitors = 2; // Inicia con 2 capacitores por defecto

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _lastTextFieldFocusNode.addListener(_onLastTextFieldUnfocused);
  }

  void _initializeControllers() {
    for (int i = 0; i < _numberOfCapacitors; i++) {
      _capacitorControllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    for (var controller in _capacitorControllers) {
      controller.dispose();
    }
    _lastTextFieldFocusNode.removeListener(_onLastTextFieldUnfocused);
    _lastTextFieldFocusNode.dispose();
    super.dispose();
  }

  void _onLastTextFieldUnfocused() {
    if (!_lastTextFieldFocusNode.hasFocus && _capacitorControllers.isNotEmpty) {
      // Si el último campo de texto pierde el foco y no está vacío, añade uno nuevo
      if (_capacitorControllers.last.text.isNotEmpty &&
          _numberOfCapacitors < 10) {
        // Limita a 10 capacitores
        setState(() {
          _numberOfCapacitors++;
          _capacitorControllers.add(TextEditingController());
          _calculateCapacitance(); // Recalcular al añadir un nuevo campo
        });
      }
    }
  }

  void _addCapacitorField() {
    if (_numberOfCapacitors < 10) {
      // Limita la cantidad de capacitores para evitar sobrecarga
      setState(() {
        _numberOfCapacitors++;
        _capacitorControllers.add(TextEditingController());
        _calculateCapacitance();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Máximo de 10 capacitores alcanzado.')),
      );
    }
  }

  void _removeCapacitorField() {
    if (_numberOfCapacitors > 2) {
      // Mínimo de 2 capacitores
      setState(() {
        _numberOfCapacitors--;
        final TextEditingController removedController = _capacitorControllers
            .removeLast();
        removedController.dispose(); // Libera los recursos del controlador
        _calculateCapacitance();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Se requieren al menos 2 capacitores.')),
      );
    }
  }

  void _calculateCapacitance() {
    setState(() {
      _resultSeries = '';
      _resultParallel = '';
    });

    List<double> capacitances = [];
    for (int i = 0; i < _numberOfCapacitors; i++) {
      final String text = _capacitorControllers[i].text;
      final double? value = double.tryParse(text);
      if (value == null || value <= 0) {
        setState(() {
          _resultSeries =
              'Introduce valores válidos y positivos en todos los campos.';
          _resultParallel = '';
        });
        return;
      }
      capacitances.add(value);
    }

    // Cálculo para capacitores en paralelo: Cp = C1 + C2 + ... + Cn
    double parallelCapacitance = capacitances.fold(0.0, (sum, c) => sum + c);
    setState(() {
      _resultParallel =
          'Capacitancia en Paralelo: ${_formatCapacitance(parallelCapacitance)}';
    });

    // Cálculo para capacitores en serie: 1/Cs = 1/C1 + 1/C2 + ... + 1/Cn
    double sumOfReciprocals = 0.0;
    for (double c in capacitances) {
      if (c == 0) {
        // Evitar división por cero
        setState(() {
          _resultSeries = 'Error: Un capacitor en serie no puede ser cero.';
          _resultParallel = ''; // Limpiar el paralelo también si hay un error
        });
        return;
      }
      sumOfReciprocals += 1 / c;
    }

    if (sumOfReciprocals == 0) {
      // Esto solo ocurriría si no hay capacitores, pero la lista no está vacía.
      setState(() {
        _resultSeries = 'Error de cálculo en serie.';
      });
      return;
    }

    double seriesCapacitance = 1 / sumOfReciprocals;
    setState(() {
      _resultSeries =
          'Capacitancia en Serie: ${_formatCapacitance(seriesCapacitance)}';
    });
  }

  String _formatCapacitance(double value) {
    if (value.abs() >= 1e-6) {
      // Microfaradios (µF)
      return '${(value * 1e6).toStringAsFixed(3)} µF';
    } else if (value.abs() >= 1e-9) {
      // Nanofaradios (nF)
      return '${(value * 1e9).toStringAsFixed(3)} nF';
    } else if (value.abs() >= 1e-12) {
      // Picofaradios (pF)
      return '${(value * 1e12).toStringAsFixed(3)} pF';
    } else if (value.abs() >= 1) {
      // Faradios (F)
      return '${value.toStringAsFixed(3)} F';
    } else {
      // Corregida: Usar interpolación para la cadena.
      return '${value.toStringAsExponential(3)} F';
    }
  }

  void _clearFields() {
    for (var controller in _capacitorControllers) {
      controller.clear();
    }
    setState(() {
      _resultSeries = '';
      _resultParallel = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Capacitores Serie/Paralelo'),
        centerTitle: true,
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Ingresa los valores de los capacitores en Faradios (F).',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // Campos de entrada para los capacitores
            ...List.generate(_numberOfCapacitors, (index) {
              final isLast = index == _numberOfCapacitors - 1;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: TextField(
                  controller: _capacitorControllers[index],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Capacitor ${index + 1} (F)',
                    hintText: 'Ej: 0.000001 (1µF)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    // Corregida: Usar surfaceContainerHighest en lugar de surfaceVariant.
                    fillColor: colorScheme.surfaceContainerHighest,
                    suffixText: 'F',
                  ),
                  onChanged: (text) => _calculateCapacitance(),
                  focusNode: isLast ? _lastTextFieldFocusNode : null,
                ),
              );
            }),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _addCapacitorField,
                  icon: const Icon(Icons.add_circle),
                  label: const Text('Añadir Capacitor'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: _removeCapacitorField,
                  icon: const Icon(Icons.remove_circle),
                  label: const Text('Quitar Capacitor'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.error,
                    foregroundColor: colorScheme.onError,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Sección de resultados
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: colorScheme.secondaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Resultados:',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: colorScheme.onSecondaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _resultParallel,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _resultSeries,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _clearFields,
              icon: const Icon(Icons.clear_all),
              label: const Text('Limpiar Todo'),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.surfaceContainerHighest,
                foregroundColor: colorScheme.onSurfaceVariant,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
