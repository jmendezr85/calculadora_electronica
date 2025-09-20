import 'package:flutter/material.dart';

class ResistorSeriesParallelScreen extends StatefulWidget {
  const ResistorSeriesParallelScreen({super.key});

  @override
  State<ResistorSeriesParallelScreen> createState() =>
      _ResistorSeriesParallelScreenState();
}

class _ResistorSeriesParallelScreenState
    extends State<ResistorSeriesParallelScreen> {
  final List<TextEditingController> _resistorControllers = [];
  final FocusNode _lastTextFieldFocusNode =
      FocusNode(); // Para añadir nuevos campos al perder el foco

  String _resultSeries = '';
  String _resultParallel = '';
  int _numberOfResistors = 2; // Inicia con 2 resistencias por defecto

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _lastTextFieldFocusNode.addListener(_onLastTextFieldUnfocused);
  }

  void _initializeControllers() {
    for (int i = 0; i < _numberOfResistors; i++) {
      _resistorControllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    for (var controller in _resistorControllers) {
      controller.dispose();
    }
    _lastTextFieldFocusNode
      ..removeListener(_onLastTextFieldUnfocused)
      ..dispose(); // ✅ sin duplicar el receptor
    super.dispose();
  }

  void _onLastTextFieldUnfocused() {
    if (!_lastTextFieldFocusNode.hasFocus && _resistorControllers.isNotEmpty) {
      // Si el último campo de texto pierde el foco y no está vacío, añade uno nuevo
      if (_resistorControllers.last.text.isNotEmpty &&
          _numberOfResistors < 10) {
        // Limita a 10 resistencias
        setState(() {
          _numberOfResistors++;
          _resistorControllers.add(TextEditingController());
          _calculateResistance(); // Recalcular al añadir un nuevo campo
        });
      }
    }
  }

  void _addResistorField() {
    if (_numberOfResistors < 10) {
      // Limita la cantidad de resistencias para evitar sobrecarga
      setState(() {
        _numberOfResistors++;
        _resistorControllers.add(TextEditingController());
        _calculateResistance();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Máximo de 10 resistencias alcanzado.')),
      );
    }
  }

  void _removeResistorField() {
    if (_numberOfResistors > 2 && _resistorControllers.isNotEmpty) {
      setState(() {
        _numberOfResistors--;
        _resistorControllers.removeLast().dispose(); // ✅ sin cascada única
        _calculateResistance();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Se requieren al menos 2 resistencias.')),
      );
    }
  }

  void _calculateResistance() {
    setState(() {
      _resultSeries = '';
      _resultParallel = '';
    });

    final List<double> resistances = [];
    for (int i = 0; i < _numberOfResistors; i++) {
      final String text = _resistorControllers[i].text;
      final double? value = double.tryParse(text);
      if (value == null || value <= 0) {
        setState(() {
          _resultSeries =
              'Introduce valores válidos y positivos en todos los campos.';
          _resultParallel = '';
        });
        return;
      }
      resistances.add(value);
    }

    // Cálculo para resistencias en serie: Rs = R1 + R2 + ... + Rn
    final double seriesResistance = resistances.fold(0.0, (sum, r) => sum + r);
    setState(() {
      _resultSeries =
          'Resistencia en Serie: ${_formatResistance(seriesResistance)}';
    });

    // Cálculo para resistencias en paralelo: 1/Rp = 1/R1 + 1/R2 + ... + 1/Rn
    double sumOfReciprocals = 0.0;
    for (double r in resistances) {
      if (r == 0) {
        // Evitar división por cero
        setState(() {
          _resultParallel =
              'Error: Una resistencia en paralelo no puede ser cero.';
          _resultSeries = ''; // Limpiar el serie también si hay un error
        });
        return;
      }
      sumOfReciprocals += 1 / r;
    }

    if (sumOfReciprocals == 0) {
      // Esto solo ocurriría si no hay resistencias.
      setState(() {
        _resultParallel = 'Error de cálculo en paralelo.';
      });
      return;
    }

    final double parallelResistance = 1 / sumOfReciprocals;
    setState(() {
      _resultParallel =
          'Resistencia en Paralelo: ${_formatResistance(parallelResistance)}';
    });
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

  void _clearFields() {
    for (var controller in _resistorControllers) {
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
        title: const Text('Resistencias Serie/Paralelo'),
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
              'Ingresa los valores de las resistencias en Ohmios (Ω).',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // Campos de entrada para las resistencias
            ...List.generate(_numberOfResistors, (index) {
              final isLast = index == _numberOfResistors - 1;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: TextField(
                  controller: _resistorControllers[index],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Resistencia ${index + 1} (Ω)',
                    hintText: 'Ej: 1000',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: colorScheme.surfaceContainerHighest,
                    suffixText: 'Ω',
                  ),
                  onChanged: (text) => _calculateResistance(),
                  focusNode: isLast ? _lastTextFieldFocusNode : null,
                ),
              );
            }),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _addResistorField,
                  icon: const Icon(Icons.add_circle),
                  label: const Text('Añadir Resistencia'),
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
                  onPressed: _removeResistorField,
                  icon: const Icon(Icons.remove_circle),
                  label: const Text('Quitar Resistencia'),
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
                      _resultSeries,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _resultParallel,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800],
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
