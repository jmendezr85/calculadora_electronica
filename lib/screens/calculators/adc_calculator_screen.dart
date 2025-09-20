// lib/screens/adc_calculator_screen.dart

import 'dart:math';
import 'package:calculadora_electronica/main.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdcCalculatorScreen extends StatefulWidget {
  const AdcCalculatorScreen({super.key});

  @override
  State<AdcCalculatorScreen> createState() => _AdcCalculatorScreenState();
}

class _AdcCalculatorScreenState extends State<AdcCalculatorScreen>
    with SingleTickerProviderStateMixin {
  // Controladores básicos
  final TextEditingController _referenceVoltageController =
      TextEditingController();
  final TextEditingController _inputVoltageController = TextEditingController();

  // Unidades
  String _referenceVoltageUnit = 'V';
  String _inputVoltageUnit = 'V';
  String _lsbVoltageUnit = 'V';
  final List<String> _voltageUnits = ['mV', 'V'];
  final List<String> _lsbUnits = ['mV', 'V'];

  // Resolución
  int _resolutionBits = 10;
  final List<int> _resolutionOptions = [8, 10, 12, 14, 16, 18, 20, 24];

  // Resultados
  String _quantizationLevelsResult = '';
  String _lsbValueResult = '';
  String _digitalCodeResult = '';
  String _binaryCodeResult = '';

  // Controladores profesionales
  final TextEditingController _noiseController = TextEditingController(
    text: '0.1',
  );
  final TextEditingController _offsetController = TextEditingController(
    text: '0.0',
  );
  final TextEditingController _gainErrorController = TextEditingController(
    text: '0.0',
  );
  final TextEditingController _inlController = TextEditingController(
    text: '0.5',
  );
  final TextEditingController _dnlController = TextEditingController(
    text: '0.3',
  );

  // Estado profesional
  bool _showAdvancedChart = false;
  List<FlSpot> _errorSpots = [];

  // Animación
  late AnimationController _animationController;
  late Animation<double> _adcAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _adcAnimation =
        Tween<double>(begin: 0.0, end: 0.0).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        )..addListener(() {
          if (mounted) {
            setState(() {});
          }
        });
  }

  // Funciones de conversión
  double _convertVoltageToBase(double value, String unit) {
    return unit == 'mV' ? value / 1000 : value;
  }

  String _formatVoltageOutput(double volts, String targetUnit) {
    double value;
    String suffix;
    if (targetUnit == 'mV') {
      value = volts * 1000;
      suffix = 'mV';
    } else {
      value = volts;
      suffix = 'V';
    }
    return '${value.toStringAsFixed(6)} $suffix';
  }

  // Lógica de cálculo principal
  void _calculateADCProperties() {
    if (!mounted) return;
    final isPro = context.read<AppSettings>().professionalMode;

    setState(() {
      final double referenceVoltage = _convertVoltageToBase(
        double.tryParse(_referenceVoltageController.text) ?? 0.0,
        _referenceVoltageUnit,
      );
      final double inputVoltage = _convertVoltageToBase(
        double.tryParse(_inputVoltageController.text) ?? 0.0,
        _inputVoltageUnit,
      );

      if (referenceVoltage <= 0 || _resolutionBits <= 0) {
        _quantizationLevelsResult = 'Ingrese valores válidos y positivos.';
        _lsbValueResult = '';
        _digitalCodeResult = '';
        _binaryCodeResult = '';
        return;
      }

      // 1. Niveles de Cuantificación
      final int quantizationLevels = pow(2, _resolutionBits).toInt();
      _quantizationLevelsResult = '$quantizationLevels';

      // 2. Tamaño del Paso (LSB)
      final double lsbValue = referenceVoltage / (quantizationLevels - 1);
      _lsbValueResult = _formatVoltageOutput(lsbValue, _lsbVoltageUnit);

      // 3. Código Digital de Salida
      int digitalCode = 0;
      if (inputVoltage >= 0 && inputVoltage <= referenceVoltage) {
        digitalCode =
            (inputVoltage / referenceVoltage * (quantizationLevels - 1))
                .floor();
        if (digitalCode >= quantizationLevels) {
          digitalCode = quantizationLevels - 1;
        }
      } else if (inputVoltage < 0) {
        digitalCode = 0;
      } else {
        digitalCode = quantizationLevels - 1;
      }

      // Aplicar efectos profesionales si está en modo PRO
      if (isPro) {
        final noise = double.tryParse(_noiseController.text) ?? 0.0;
        final offset = double.tryParse(_offsetController.text) ?? 0.0;
        final gainError = double.tryParse(_gainErrorController.text) ?? 0.0;
        final inl = double.tryParse(_inlController.text) ?? 0.0;
        final dnl = double.tryParse(_dnlController.text) ?? 0.0;

        // Simular efectos de errores
        final noiseEffect = noise * (Random().nextDouble() * 2 - 1);
        final offsetEffect = offset / lsbValue;
        final gainEffect = gainError * digitalCode / quantizationLevels;
        final inlEffect = inl * sin(digitalCode * 0.1);
        final dnlEffect = dnl * (Random().nextDouble() * 2 - 1);

        digitalCode =
            (digitalCode +
                    noiseEffect +
                    offsetEffect +
                    gainEffect +
                    inlEffect +
                    dnlEffect)
                .round();
        digitalCode = digitalCode.clamp(0, quantizationLevels - 1);

        _generateErrorAnalysisData(referenceVoltage, quantizationLevels);
      }

      _digitalCodeResult = '$digitalCode (decimal)';
      _binaryCodeResult =
          '${digitalCode.toRadixString(2).padLeft(_resolutionBits, '0')} (binario)';

      _animationController.reset();
      _adcAnimation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(_animationController);
      _animationController.forward();
    });
  }

  void _generateErrorAnalysisData(
    double referenceVoltage,
    int quantizationLevels,
  ) {
    _errorSpots = [];
    final lsbValue = referenceVoltage / (quantizationLevels - 1);
    final noise = double.tryParse(_noiseController.text) ?? 0.0;
    final inl = double.tryParse(_inlController.text) ?? 0.0;
    final dnl = double.tryParse(_dnlController.text) ?? 0.0;

    for (
      int i = 0;
      i < quantizationLevels;
      i += max(1, quantizationLevels ~/ 50)
    ) {
      final idealVoltage = i * lsbValue;
      final noiseEffect = noise * (Random().nextDouble() * 2 - 1);
      final inlEffect = inl * lsbValue * sin(i * 0.1);
      final dnlEffect = dnl * lsbValue * (Random().nextDouble() * 2 - 1);
      final error = noiseEffect + inlEffect + dnlEffect;

      _errorSpots.add(FlSpot(idealVoltage, error));
    }
  }

  void _clearFields() {
    setState(() {
      _referenceVoltageController.clear();
      _inputVoltageController.clear();
      _resolutionBits = 10;
      _referenceVoltageUnit = 'V';
      _inputVoltageUnit = 'V';
      _lsbVoltageUnit = 'V';

      _quantizationLevelsResult = '';
      _lsbValueResult = '';
      _digitalCodeResult = '';
      _binaryCodeResult = '';

      _errorSpots = [];
      _animationController.reset();
    });
  }

  @override
  void dispose() {
    _referenceVoltageController.dispose();
    _inputVoltageController.dispose();
    _noiseController.dispose();
    _offsetController.dispose();
    _gainErrorController.dispose();
    _inlController.dispose();
    _dnlController.dispose();

    _animationController
      ..stop()
      ..dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPro = context.select<AppSettings, bool>((s) => s.professionalMode);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora ADC'),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Calcula los parámetros y la salida de un Conversor Analógico-Digital (ADC).',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),

            // Sección básica
            Text('Resolución (N de bits):', style: theme.textTheme.titleSmall),
            DropdownButton<int>(
              value: _resolutionBits,
              isExpanded: true,
              items: _resolutionOptions.map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text('$value bits'),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _resolutionBits = newValue!;
                });
              },
            ),

            const SizedBox(height: 15),
            _buildUnitInputField(
              controller: _referenceVoltageController,
              labelText: 'Voltaje de Referencia (Vref)',
              hintText: 'Ej: 5.0',
              unit: _referenceVoltageUnit,
              units: _voltageUnits,
              onUnitChanged: (newValue) {
                setState(() {
                  _referenceVoltageUnit = newValue!;
                });
              },
              icon: Icons.electrical_services,
            ),

            const SizedBox(height: 15),
            _buildUnitInputField(
              controller: _inputVoltageController,
              labelText: 'Voltaje Analógico de Entrada (Vin)',
              hintText: 'Ej: 2.5',
              unit: _inputVoltageUnit,
              units: _voltageUnits,
              onUnitChanged: (newValue) {
                setState(() {
                  _inputVoltageUnit = newValue!;
                });
              },
              icon: Icons.input,
            ),

            const SizedBox(height: 20),
            Text(
              'Unidad de Salida para LSB:',
              style: theme.textTheme.titleSmall,
            ),
            DropdownButton<String>(
              value: _lsbVoltageUnit,
              isExpanded: true,
              items: _lsbUnits.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _lsbVoltageUnit = newValue!;
                });
              },
            ),

            // Sección profesional
            if (isPro) ...[
              const SizedBox(height: 24),
              _buildProSectionHeader(context),
              const SizedBox(height: 12),

              ExpansionTile(
                initiallyExpanded: true,
                title: const Text(
                  'Parámetros de Error ADC',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                leading: const Icon(Icons.tune, color: Colors.deepPurple),
                children: [
                  _buildProParameter(
                    context,
                    icon: Icons.grain,
                    label: 'Ruido',
                    value: _noiseController.text,
                    unit: 'LSB',
                    onChanged: (v) => setState(() => _noiseController.text = v),
                    min: 0,
                    max: 2,
                  ),
                  _buildProParameter(
                    context,
                    icon: Icons.exposure_zero,
                    label: 'Offset',
                    value: _offsetController.text,
                    unit: 'V',
                    onChanged: (v) =>
                        setState(() => _offsetController.text = v),
                    min: -0.1,
                    max: 0.1,
                  ),
                  _buildProParameter(
                    context,
                    icon: Icons.trending_up,
                    label: 'Error de Ganancia',
                    value: _gainErrorController.text,
                    unit: '%',
                    onChanged: (v) =>
                        setState(() => _gainErrorController.text = v),
                    min: 0,
                    max: 5,
                  ),
                  _buildProParameter(
                    context,
                    icon: Icons.waves,
                    label: 'INL',
                    value: _inlController.text,
                    unit: 'LSB',
                    onChanged: (v) => setState(() => _inlController.text = v),
                    min: 0,
                    max: 2,
                  ),
                  _buildProParameter(
                    context,
                    icon: Icons.show_chart,
                    label: 'DNL',
                    value: _dnlController.text,
                    unit: 'LSB',
                    onChanged: (v) => setState(() => _dnlController.text = v),
                    min: 0,
                    max: 2,
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
                            'Análisis de Errores',
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
                      if (_showAdvancedChart && _errorSpots.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 200,
                          child: _buildErrorAnalysisChart(context),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Distribución de errores en el rango de entrada',
                          style: theme.textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculateADCProperties,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
              ),
              child: const Text('Calcular ADC'),
            ),

            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _clearFields,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: colorScheme.errorContainer,
                foregroundColor: colorScheme.onErrorContainer,
              ),
              child: const Text('Borrar Campos'),
            ),

            const SizedBox(height: 20),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Resultados ADC:', style: theme.textTheme.titleMedium),
                    const SizedBox(height: 8),
                    _buildResultRow(
                      'Niveles de Cuantificación:',
                      _quantizationLevelsResult,
                      colorScheme,
                    ),
                    _buildResultRow('Valor LSB:', _lsbValueResult, colorScheme),
                    _buildResultRow(
                      'Código Digital de Salida:',
                      _digitalCodeResult,
                      colorScheme,
                    ),
                    _buildResultRow(
                      'Representación Binaria:',
                      _binaryCodeResult,
                      colorScheme,
                    ),

                    // Visualización animada en modo PRO
                    if (isPro) ...[
                      const SizedBox(height: 16),
                      AnimatedBuilder(
                        animation: _adcAnimation,
                        builder: (context, _) {
                          return Column(
                            children: [
                              LinearProgressIndicator(
                                value: _adcAnimation.value,
                                minHeight: 10,
                                backgroundColor:
                                    theme.colorScheme.surfaceContainerHighest,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  theme.colorScheme.primary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Simulación ADC',
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============ COMPONENTES PERSONALIZADOS ============

  Widget _buildUnitInputField({
    required TextEditingController controller,
    required String labelText,
    String? hintText,
    required String unit,
    required List<String> units,
    required ValueChanged<String?> onUnitChanged,
    IconData? icon,
  }) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, color: Theme.of(context).colorScheme.secondary),
          const SizedBox(width: 10),
        ],
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: labelText,
              hintText: hintText,
              border: const OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(width: 10),
        DropdownButton<String>(
          value: unit,
          items: units.map((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
          onChanged: onUnitChanged,
        ),
      ],
    );
  }

  Widget _buildResultRow(String label, String value, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(
            value.isEmpty ? 'N/A' : value,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

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
    final int? divisions = range > 0
        ? range ~/ 0.01
        : null; // Asegura divisions válido

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
            divisions: divisions, // Usa divisions calculado
            label: '${numericValue.toStringAsFixed(2)}$unit',
            activeColor: Colors.deepPurple,
            onChanged: (v) => onChanged(v.toStringAsFixed(2)),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorAnalysisChart(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(drawVerticalLine: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) =>
                  Text('${value.toStringAsFixed(2)}V'),
              reservedSize: 40,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) =>
                  Text('${value.toStringAsFixed(2)}V'),
            ),
          ),
          rightTitles: const AxisTitles(),
          topTitles: const AxisTitles(),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: _errorSpots,
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
