import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:calculadora_electronica/main.dart';

class FilterCalculatorScreen extends StatefulWidget {
  const FilterCalculatorScreen({super.key});

  @override
  State<FilterCalculatorScreen> createState() => _FilterCalculatorScreenState();
}

class _FilterCalculatorScreenState extends State<FilterCalculatorScreen> {
  final TextEditingController _resistanceController = TextEditingController();
  final TextEditingController _capacitanceController = TextEditingController();
  final TextEditingController _inductanceController = TextEditingController();

  String? _resistanceErrorText;
  String? _capacitanceErrorText;
  String? _inductanceErrorText;

  String _selectedResistanceUnit = 'Ω';
  String _selectedCapacitanceUnit = 'µF';
  String _selectedInductanceUnit = 'mH';

  FilterType _filterType = FilterType.lowPass;
  FilterConfig _filterConfig = FilterConfig.rc;

  // New state variables for professional mode
  double _qFactor = 0.707;
  bool _showQFactor = false;

  double _cutoffFrequency = 0.0;
  String _result = '';
  List<FlSpot> _frequencyResponse = [];
  double _resistanceValue = 0.0;
  double _capacitanceValue = 0.0;
  double _inductanceValue = 0.0;

  @override
  void dispose() {
    _resistanceController.dispose();
    _capacitanceController.dispose();
    _inductanceController.dispose();
    super.dispose();
  }

  void _calculateFilter() {
    final resistance = double.tryParse(_resistanceController.text) ?? 0;
    final capacitance = double.tryParse(_capacitanceController.text) ?? 0;
    final inductance = double.tryParse(_inductanceController.text) ?? 0;

    setState(() {
      _resistanceErrorText = resistance <= 0 ? 'Valor inválido' : null;
      _capacitanceErrorText = capacitance <= 0 ? 'Valor inválido' : null;
      _inductanceErrorText = inductance <= 0 ? 'Valor inválido' : null;
    });

    if (_resistanceErrorText != null ||
        _capacitanceErrorText != null ||
        (_filterConfig == FilterConfig.lc && _inductanceErrorText != null)) {
      return;
    }

    _resistanceValue = _convertResistance(resistance, _selectedResistanceUnit);
    _capacitanceValue = _convertCapacitance(
      capacitance,
      _selectedCapacitanceUnit,
    );
    _inductanceValue = _filterConfig == FilterConfig.lc
        ? _convertInductance(inductance, _selectedInductanceUnit)
        : 0;

    setState(() {
      if (_filterConfig == FilterConfig.rc) {
        _cutoffFrequency =
            1 / (2 * math.pi * _resistanceValue * _capacitanceValue);
        _result =
            'Frecuencia de corte: ${_cutoffFrequency.toStringAsFixed(2)} Hz\n'
            'Configuración: ${_filterType.name.toUpperCase()} RC';
      } else {
        _cutoffFrequency =
            1 / (2 * math.pi * math.sqrt(_inductanceValue * _capacitanceValue));
        _result =
            'Frecuencia de corte: ${_cutoffFrequency.toStringAsFixed(2)} Hz\n'
            'Configuración: ${_filterType.name.toUpperCase()} LC';
      }
      _generateFrequencyResponse();
    });
  }

  void _generateFrequencyResponse() {
    final List<FlSpot> points = [];
    final double fc = _cutoffFrequency;
    const int pointsCount = 100;
    const double startFreq = 0.1; // 0.1 * fc
    const double endFreq = 10.0; // 10 * fc

    for (int i = 0; i <= pointsCount; i++) {
      final double ratio = startFreq + (endFreq - startFreq) * i / pointsCount;
      final double f = ratio * fc;
      final double w = 2 * math.pi * f;
      double gain = 1.0;

      if (_filterConfig == FilterConfig.rc) {
        final double rc = 1 / (2 * math.pi * fc);
        if (_filterType == FilterType.lowPass) {
          gain = 1 / math.sqrt(1 + math.pow(w * rc, 2));
        } else {
          // highPass
          gain = w * rc / math.sqrt(1 + math.pow(w * rc, 2));
        }
      } else {
        // LC config
        if (_filterType == FilterType.lowPass) {
          gain =
              1 /
              math.sqrt(
                math.pow(
                  1 - math.pow(w, 2) * _inductanceValue * _capacitanceValue,
                  2,
                ),
              );
        } else {
          // highPass
          gain =
              math.pow(w, 2) *
              _inductanceValue *
              _capacitanceValue /
              math.sqrt(
                math.pow(
                  1 - math.pow(w, 2) * _inductanceValue * _capacitanceValue,
                  2,
                ),
              );
        }
      }

      // Convertir a dB
      final double gainDb = 20 * math.log(gain) / math.ln10;
      points.add(FlSpot(ratio, gainDb));
    }

    setState(() {
      _frequencyResponse = points;
    });
  }

  double _convertResistance(double value, String unit) {
    switch (unit) {
      case 'kΩ':
        return value * 1e3;
      case 'MΩ':
        return value * 1e6;
      default:
        return value;
    }
  }

  double _convertCapacitance(double value, String unit) {
    switch (unit) {
      case 'pF':
        return value * 1e-12;
      case 'nF':
        return value * 1e-9;
      case 'µF':
        return value * 1e-6;
      case 'mF':
        return value * 1e-3;
      default:
        return value;
    }
  }

  double _convertInductance(double value, String unit) {
    switch (unit) {
      case 'µH':
        return value * 1e-6;
      case 'mH':
        return value * 1e-3;
      default:
        return value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettings>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Calculadora de Filtros')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildFilterTypeSelector(),
            const SizedBox(height: 16),
            _buildFilterConfigSelector(),
            const SizedBox(height: 16),
            if (_filterConfig == FilterConfig.rc) ...[
              _buildInputRow(
                'Resistencia (R)',
                _resistanceController,
                _selectedResistanceUnit,
                ['Ω', 'kΩ', 'MΩ'],
                (value) => setState(() => _selectedResistanceUnit = value!),
                _resistanceErrorText,
              ),
              const SizedBox(height: 8),
              _buildInputRow(
                'Capacitancia (C)',
                _capacitanceController,
                _selectedCapacitanceUnit,
                ['pF', 'nF', 'µF', 'mF'],
                (value) => setState(() => _selectedCapacitanceUnit = value!),
                _capacitanceErrorText,
              ),
            ] else ...[
              _buildInputRow(
                'Inductancia (L)',
                _inductanceController,
                _selectedInductanceUnit,
                ['µH', 'mH', 'H'],
                (value) => setState(() => _selectedInductanceUnit = value!),
                _inductanceErrorText,
              ),
              const SizedBox(height: 8),
              _buildInputRow(
                'Capacitancia (C)',
                _capacitanceController,
                _selectedCapacitanceUnit,
                ['pF', 'nF', 'µF', 'mF'],
                (value) => setState(() => _selectedCapacitanceUnit = value!),
                _capacitanceErrorText,
              ),
            ],
            // 🚨 Sección de modo profesional con nuevo estilo 🚨
            if (settings.professionalMode) ...[
              const SizedBox(height: 24),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildProfessionalModeSection(),
                ),
              ),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculateFilter,
              child: const Text('Calcular'),
            ),
            const SizedBox(height: 20),
            if (_result.isNotEmpty) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _result,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 300,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(show: true),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final freq = value * _cutoffFrequency;
                              if (freq < 1000) {
                                return Text('${freq.toStringAsFixed(0)} Hz');
                              } else {
                                return Text(
                                  '${(freq / 1000).toStringAsFixed(1)} kHz',
                                );
                              }
                            },
                            interval: 2,
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              return Text('${value.toInt()} dB');
                            },
                            interval: 10,
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: true),
                      minX: 0.1,
                      maxX: 10.0,
                      minY: -60,
                      maxY: 10,
                      lineBarsData: [
                        LineChartBarData(
                          spots: _frequencyResponse,
                          isCurved: true,
                          color: Colors.blue,
                          barWidth: 3,
                          dotData: FlDotData(show: false),
                          belowBarData: BarAreaData(show: false),
                        ),
                      ],
                      lineTouchData: LineTouchData(
                        touchTooltipData: LineTouchTooltipData(
                          getTooltipItems: (List<LineBarSpot> spots) {
                            return spots.map((spot) {
                              final freq = spot.x * _cutoffFrequency;
                              return LineTooltipItem(
                                'Frec: ${freq.toStringAsFixed(1)} Hz\n'
                                'Ganancia: ${spot.y.toStringAsFixed(1)} dB',
                                const TextStyle(),
                              );
                            }).toList();
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // New method to build the professional mode section
  Widget _buildProfessionalModeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Opciones de Modo Profesional',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Icon(
              Icons.precision_manufacturing,
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
        const SizedBox(height: 16),
        SwitchListTile(
          title: const Text('Mostrar Factor de Calidad (Q)'),
          value: _showQFactor,
          onChanged: (bool value) {
            setState(() {
              _showQFactor = value;
            });
          },
          secondary: const Icon(Icons.speed),
        ),
        if (_showQFactor)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Factor Q: ${_qFactor.toStringAsFixed(3)}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Slider(
                  value: _qFactor,
                  min: 0.1,
                  max: 10.0,
                  divisions: 99,
                  label: _qFactor.toStringAsFixed(2),
                  onChanged: (double value) {
                    setState(() {
                      _qFactor = value;
                    });
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildFilterTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tipo de Filtro:', style: Theme.of(context).textTheme.titleMedium),
        Wrap(
          children: FilterType.values.map((type) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: ChoiceChip(
                label: Text(type.label),
                selected: _filterType == type,
                onSelected: (selected) {
                  if (selected) {
                    setState(() => _filterType = type);
                  }
                },
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFilterConfigSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Configuración:', style: Theme.of(context).textTheme.titleMedium),
        Wrap(
          children: FilterConfig.values.map((config) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: ChoiceChip(
                label: Text(config.label),
                selected: _filterConfig == config,
                onSelected: (selected) {
                  if (selected) {
                    setState(() => _filterConfig = config);
                  }
                },
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildInputRow(
    String label,
    TextEditingController controller,
    String selectedUnit,
    List<String> units,
    ValueChanged<String?> onUnitChanged,
    String? errorText,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: DropdownButton<String>(
            value: selectedUnit,
            onChanged: onUnitChanged,
            items: units
                .map((unit) => DropdownMenuItem(value: unit, child: Text(unit)))
                .toList(),
          ),
          errorText: errorText,
        ),
      ),
    );
  }
}

enum FilterType {
  lowPass('Paso Bajo'),
  highPass('Paso Alto'),
  bandPass('Paso Banda'),
  bandStop('Rechazo Banda');

  const FilterType(this.label);
  final String label;
}

enum FilterConfig {
  rc('RC'),
  lc('LC');

  const FilterConfig(this.label);
  final String label;
}
