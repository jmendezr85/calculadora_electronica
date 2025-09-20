import 'dart:math' as math;

import 'package:calculadora_electronica/main.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DecibelCalculatorScreen extends StatefulWidget {
  const DecibelCalculatorScreen({super.key});

  @override
  State<DecibelCalculatorScreen> createState() =>
      _DecibelCalculatorScreenState();
}

enum DecibelMode { power, voltage }

enum ReferenceLevel { dBm, dBW, dBV, dBu }

class _DecibelCalculatorScreenState extends State<DecibelCalculatorScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _input1Controller = TextEditingController();
  final TextEditingController _input2Controller = TextEditingController();
  final TextEditingController _dbValueController = TextEditingController();

  // Controladores profesionales
  final TextEditingController _impedanceController = TextEditingController(
    text: '600',
  );
  final TextEditingController _noiseFloorController = TextEditingController(
    text: '-96',
  );
  final TextEditingController _dynamicRangeController = TextEditingController(
    text: '120',
  );

  // Estado
  DecibelMode _selectedMode = DecibelMode.power;
  ReferenceLevel _referenceLevel = ReferenceLevel.dBm;
  String _result = '';
  String _explanation = '';
  bool _showAdvancedChart = false;
  List<FlSpot> _dynamicRangeSpots = [];

  // Animación
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _input1Controller.dispose();
    _input2Controller.dispose();
    _dbValueController.dispose();
    _impedanceController.dispose();
    _noiseFloorController.dispose();
    _dynamicRangeController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _calculateDecibels() {
    _animationController.reset();

    setState(() {
      _result = '';
      _explanation = '';
      _dynamicRangeSpots = [];
    });

    final isPro = context.read<AppSettings>().professionalMode;
    final double? value1 = double.tryParse(_input1Controller.text);
    final double? value2 = double.tryParse(_input2Controller.text);
    final double? dbValue = double.tryParse(_dbValueController.text);

    if (_dbValueController.text.isNotEmpty && dbValue != null) {
      // Calcular valor lineal a partir de dB
      if (_selectedMode == DecibelMode.power) {
        final double linearValue = math.pow(10, dbValue / 10).toDouble();
        _result = 'Valor Lineal (Potencia): ${linearValue.toStringAsFixed(4)}';
        _explanation = 'Power (dB) = 10 * log10(P2/P1) => P2/P1 = 10^(dB/10)';
      } else {
        final double linearValue = math.pow(10, dbValue / 20).toDouble();
        _result = 'Valor Lineal (Voltaje): ${linearValue.toStringAsFixed(4)}';
        _explanation = 'Voltage (dB) = 20 * log10(V2/V1) => V2/V1 = 10^(dB/20)';
      }
    } else if (value1 != null && value2 != null && value1 != 0) {
      // Calcular dB a partir de valores lineales
      final double ratio = value2 / value1;
      double calculatedDb;
      if (_selectedMode == DecibelMode.power) {
        calculatedDb = 10 * math.log(ratio) / math.ln10;
        _explanation = 'dB (Potencia) = 10 * log10(Salida / Entrada)';
      } else {
        calculatedDb = 20 * math.log(ratio) / math.ln10;
        _explanation = 'dB (Voltaje) = 20 * log10(Salida / Entrada)';
      }

      if (isPro) {
        _generateDynamicRangeData(calculatedDb);
        _result =
            '${_formatProfessionalResult(calculatedDb)}\n'
            'Valor Absoluto: ${calculatedDb.toStringAsFixed(4)} dB';
      } else {
        _result = 'Decibelios (dB): ${calculatedDb.toStringAsFixed(4)} dB';
      }
    } else {
      _result = 'Introduce dos valores (Entrada y Salida) o un valor en dB.';
    }

    _animationController.forward();
  }

  String _formatProfessionalResult(double dbValue) {
    switch (_referenceLevel) {
      case ReferenceLevel.dBm:
        return '${dbValue.toStringAsFixed(2)} dBm (1 mW @ ${_impedanceController.text}Ω)';
      case ReferenceLevel.dBW:
        return '${dbValue.toStringAsFixed(2)} dBW (1 W referencia)';
      case ReferenceLevel.dBV:
        return '${dbValue.toStringAsFixed(2)} dBV (1 V referencia)';
      case ReferenceLevel.dBu:
        return '${dbValue.toStringAsFixed(2)} dBu (0.775 V @ ${_impedanceController.text}Ω)';
    }
  }

  void _generateDynamicRangeData(double dbValue) {
    _dynamicRangeSpots = [];
    final noiseFloor = double.tryParse(_noiseFloorController.text) ?? -96;
    final dynamicRange = double.tryParse(_dynamicRangeController.text) ?? 120;

    // Generar puntos para el gráfico de rango dinámico
    for (double i = noiseFloor; i <= noiseFloor + dynamicRange; i += 5) {
      _dynamicRangeSpots.add(
        FlSpot(i, math.pow(10, (i - dbValue) / 10).toDouble()),
      );
    }
  }

  void _clearFields() {
    setState(() {
      _input1Controller.clear();
      _input2Controller.clear();
      _dbValueController.clear();
      _result = '';
      _explanation = '';
      _dynamicRangeSpots = [];
    });
    _animationController.reset();
  }

  @override
  Widget build(BuildContext context) {
    final isPro = context.select<AppSettings, bool>((s) => s.professionalMode);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cálculo de Decibelios (dB)'),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        centerTitle: true,
        actions: [
          if (isPro)
            const Chip(
              label: Text('PRO', style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.deepPurple,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Calcula la ganancia/pérdida en dB o convierte dB a valores lineales.',
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Selector de modo (Potencia vs Voltaje)
            SegmentedButton<DecibelMode>(
              segments: const <ButtonSegment<DecibelMode>>[
                ButtonSegment<DecibelMode>(
                  value: DecibelMode.power,
                  label: Text('Potencia'),
                  icon: Icon(Icons.power),
                ),
                ButtonSegment<DecibelMode>(
                  value: DecibelMode.voltage,
                  label: Text('Voltaje'),
                  icon: Icon(Icons.flash_on),
                ),
              ],
              selected: <DecibelMode>{_selectedMode},
              onSelectionChanged: (Set<DecibelMode> newSelection) {
                setState(() {
                  _selectedMode = newSelection.first;
                  _clearFields();
                });
              },
              style: SegmentedButton.styleFrom(
                selectedForegroundColor: colorScheme.onPrimaryContainer,
                selectedBackgroundColor: colorScheme.primaryContainer,
                foregroundColor: colorScheme.onSurfaceVariant,
              ),
            ),

            // Selector de nivel de referencia (modo profesional)
            if (isPro) ...[
              const SizedBox(height: 16),
              Text('Nivel de Referencia:', style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              SegmentedButton<ReferenceLevel>(
                segments: const <ButtonSegment<ReferenceLevel>>[
                  ButtonSegment<ReferenceLevel>(
                    value: ReferenceLevel.dBm,
                    label: Text('dBm'),
                  ),
                  ButtonSegment<ReferenceLevel>(
                    value: ReferenceLevel.dBW,
                    label: Text('dBW'),
                  ),
                  ButtonSegment<ReferenceLevel>(
                    value: ReferenceLevel.dBV,
                    label: Text('dBV'),
                  ),
                  ButtonSegment<ReferenceLevel>(
                    value: ReferenceLevel.dBu,
                    label: Text('dBu'),
                  ),
                ],
                selected: <ReferenceLevel>{_referenceLevel},
                onSelectionChanged: (Set<ReferenceLevel> newSelection) {
                  setState(() {
                    _referenceLevel = newSelection.first;
                  });
                },
                style: SegmentedButton.styleFrom(
                  selectedForegroundColor: colorScheme.onPrimaryContainer,
                  selectedBackgroundColor: colorScheme.primaryContainer,
                  foregroundColor: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            const SizedBox(height: 24),

            Text(
              'Para calcular dB (Ganancia/Pérdida):',
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _input1Controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Valor de Entrada (P1/V1)',
                hintText: _selectedMode == DecibelMode.power
                    ? 'Ej: 0.001 (1mW)'
                    : 'Ej: 0.775 (0dBu)',
                border: const OutlineInputBorder(),
                suffixText: _selectedMode == DecibelMode.power ? 'W' : 'V',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _input2Controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Valor de Salida (P2/V2)',
                hintText: _selectedMode == DecibelMode.power
                    ? 'Ej: 0.1 (100mW)'
                    : 'Ej: 7.75 (+20dBu)',
                border: const OutlineInputBorder(),
                suffixText: _selectedMode == DecibelMode.power ? 'W' : 'V',
              ),
            ),
            const SizedBox(height: 24),

            Text(
              'O, para convertir de dB a valor lineal:',
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _dbValueController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Valor en Decibelios (dB)',
                hintText: 'Ej: 3 (para +3dB de ganancia)',
                border: OutlineInputBorder(),
                suffixText: 'dB',
              ),
            ),

            // Sección profesional
            if (isPro) ...[
              const SizedBox(height: 24),
              _buildProSectionHeader(context),
              const SizedBox(height: 12),

              ExpansionTile(
                initiallyExpanded: true,
                title: const Text(
                  'Parámetros Avanzados',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                leading: const Icon(Icons.tune, color: Colors.deepPurple),
                children: [
                  _buildProParameter(
                    context,
                    icon: Icons.electrical_services,
                    label: 'Impedancia',
                    value: _impedanceController.text,
                    unit: 'Ω',
                    onChanged: (v) {
                      setState(() => _impedanceController.text = v);
                      _calculateDecibels();
                    },
                    min: 50,
                    max: 1000,
                  ),
                  _buildProParameter(
                    context,
                    icon: Icons.volume_down,
                    label: 'Piso de Ruido',
                    value: _noiseFloorController.text,
                    unit: 'dB',
                    onChanged: (v) {
                      setState(() => _noiseFloorController.text = v);
                      _calculateDecibels();
                    },
                    min: -120,
                    max: -60,
                  ),
                  _buildProParameter(
                    context,
                    icon: Icons.volume_up,
                    label: 'Rango Dinámico',
                    value: _dynamicRangeController.text,
                    unit: 'dB',
                    onChanged: (v) {
                      setState(() => _dynamicRangeController.text = v);
                      _calculateDecibels();
                    },
                    min: 60,
                    max: 140,
                  ),
                ],
              ),

              const SizedBox(height: 16),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: theme.dividerColor),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.show_chart,
                            color: Colors.deepPurple,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Análisis de Rango Dinámico',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.deepPurple,
                            ),
                          ),
                          const Spacer(),
                          Switch(
                            value: _showAdvancedChart,
                            onChanged: (v) =>
                                setState(() => _showAdvancedChart = v),
                            activeColor: Colors.deepPurple,
                          ),
                        ],
                      ),
                      if (_showAdvancedChart &&
                          _dynamicRangeSpots.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 200,
                          child: _buildDynamicRangeChart(context),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Relación señal/ruido en función del nivel de referencia',
                          style: theme.textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _calculateDecibels,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
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
              AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Transform.translate(
                      offset: Offset(0, 10 * (1 - _fadeAnimation.value)),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer.withAlpha(128),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _result,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onPrimaryContainer,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            if (_explanation.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  _explanation,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontStyle: FontStyle.italic,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  // ============ COMPONENTES PERSONALIZADOS ============

  Widget _buildProSectionHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.deepPurple.withAlpha(30),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.deepPurple.withAlpha(100)),
      ),
      child: Row(
        children: [
          const Icon(Icons.engineering, color: Colors.deepPurple),
          const SizedBox(width: 12),
          Text(
            'MODO PROFESIONAL',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.deepPurple,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProParameter(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required String unit,
    required ValueChanged<String> onChanged,
    required double min,
    required double max,
  }) {
    final double numericValue = double.tryParse(value) ?? min;
    final double range = max - min;
    final int? divisions = range > 0 ? (range ~/ (range < 10 ? 0.1 : 1)) : null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: Colors.deepPurple),
              const SizedBox(width: 12),
              Text(label, style: Theme.of(context).textTheme.bodyMedium),
              const Spacer(),
              SizedBox(
                width: 60,
                child: TextField(
                  controller: TextEditingController(text: value),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    suffixText: unit,
                    border: const UnderlineInputBorder(),
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: onChanged,
                ),
              ),
            ],
          ),
          Slider(
            value: numericValue.clamp(min, max),
            min: min,
            max: max,
            divisions: divisions,
            label: '$numericValue$unit',
            activeColor: Colors.deepPurple,
            onChanged: (v) => onChanged(v.toStringAsFixed(1)),
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicRangeChart(BuildContext context) {
    return LineChart(
      LineChartData(
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) => Text(value.toStringAsFixed(1)),
              reservedSize: 40,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) => Text('${value.toInt()}dB'),
            ),
          ),
          rightTitles: const AxisTitles(),
          topTitles: const AxisTitles(),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: _dynamicRangeSpots,
            isCurved: true,
            color: Colors.deepPurple,
            barWidth: 3,
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  Colors.deepPurple.withAlpha(50),
                  Colors.deepPurple.withAlpha(10),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            dotData: const FlDotData(show: false),
          ),
        ],
      ),
    );
  }
}
