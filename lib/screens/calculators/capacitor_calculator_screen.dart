import 'package:calculadora_electronica/main.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CapacitorCalculatorScreen extends StatefulWidget {
  const CapacitorCalculatorScreen({super.key});

  @override
  State<CapacitorCalculatorScreen> createState() =>
      _CapacitorCalculatorScreenState();
}

class _CapacitorCalculatorScreenState extends State<CapacitorCalculatorScreen>
    with SingleTickerProviderStateMixin {
  final List<TextEditingController> _capacitorControllers = [];
  final FocusNode _lastTextFieldFocusNode = FocusNode();

  // Resultados básicos
  String _resultSeries = '';
  String _resultParallel = '';
  int _numberOfCapacitors = 2;

  // Controladores profesionales
  final TextEditingController _toleranceController = TextEditingController(
    text: '5',
  );
  final TextEditingController _voltageRatingController = TextEditingController(
    text: '50',
  );
  final TextEditingController _temperatureController = TextEditingController(
    text: '25',
  );
  final TextEditingController _esrController = TextEditingController(
    text: '0.1',
  );

  // Estado profesional
  bool _showAdvancedResults = false;
  List<FlSpot> _voltageDistributionSpots = [];
  List<FlSpot> _esrSpots = [];

  // Animación
  late AnimationController _animationController;
  late Animation<double> _calculationAnimation;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _lastTextFieldFocusNode.addListener(_onLastTextFieldUnfocused);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _calculationAnimation =
        Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        )..addListener(() {
          if (mounted) setState(() {});
        });
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
    _lastTextFieldFocusNode
      ..removeListener(_onLastTextFieldUnfocused)
      ..dispose();

    _toleranceController.dispose();
    _voltageRatingController.dispose();
    _temperatureController.dispose();
    _esrController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onLastTextFieldUnfocused() {
    if (!_lastTextFieldFocusNode.hasFocus &&
        _capacitorControllers.isNotEmpty &&
        _capacitorControllers.last.text.isNotEmpty &&
        _numberOfCapacitors < 10) {
      setState(() {
        _numberOfCapacitors++;
        _capacitorControllers.add(TextEditingController());
        _calculateCapacitance();
      });
    }
  }

  void _addCapacitorField() {
    if (_numberOfCapacitors < 10) {
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
      setState(() {
        _numberOfCapacitors--;
        (_capacitorControllers.removeLast()..dispose());

        _calculateCapacitance();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Se requieren al menos 2 capacitores.')),
      );
    }
  }

  void _calculateCapacitance() {
    _animationController.reset();

    setState(() {
      _resultSeries = '';
      _resultParallel = '';
      _voltageDistributionSpots = [];
      _esrSpots = [];
    });

    final isPro = context.read<AppSettings>().professionalMode;
    final List<double> capacitances = [];

    // Validar entradas
    for (int i = 0; i < _numberOfCapacitors; i++) {
      final text = _capacitorControllers[i].text;
      final value = double.tryParse(text);

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

    // Cálculo básico
    final double parallelCapacitance = capacitances.fold(
      0.0,
      (sum, c) => sum + c,
    );
    final double sumOfReciprocals = capacitances.fold(
      0.0,
      (sum, c) => sum + (1 / c),
    );
    final double seriesCapacitance = 1 / sumOfReciprocals;

    // Cálculos profesionales
    if (isPro) {
      final tolerance = (double.tryParse(_toleranceController.text) ?? 5) / 100;
      final voltageRating =
          double.tryParse(_voltageRatingController.text) ?? 50;
      final temperature = double.tryParse(_temperatureController.text) ?? 25;
      final esr = double.tryParse(_esrController.text) ?? 0.1;

      _generateProfessionalData(
        capacitances,
        seriesCapacitance,
        parallelCapacitance,
        tolerance,
        voltageRating,
        temperature,
        esr,
      );
    }

    setState(() {
      _resultParallel =
          'Capacitancia en Paralelo: ${_formatCapacitance(parallelCapacitance)}';
      _resultSeries =
          'Capacitancia en Serie: ${_formatCapacitance(seriesCapacitance)}';
    });

    _animationController.forward();
  }

  void _generateProfessionalData(
    List<double> capacitances,
    double seriesCap,
    double parallelCap,
    double tolerance,
    double voltageRating,
    double temperature,
    double esr,
  ) {
    _voltageDistributionSpots = [];
    _esrSpots = [];

    // Simular distribución de voltaje en serie
    for (int i = 0; i < capacitances.length; i++) {
      final voltage = (seriesCap / capacitances[i]) * voltageRating;
      _voltageDistributionSpots.add(FlSpot(i.toDouble(), voltage));
    }

    // Simular ESR en función de la temperatura
    for (double temp = -20; temp <= 60; temp += 5) {
      final tempEffect = 1 + (0.02 * (temp - 25));
      final effectiveEsr = esr * tempEffect;
      _esrSpots.add(FlSpot(temp, effectiveEsr));
    }
  }

  String _formatCapacitance(double value) {
    if (value.abs() >= 1e-6) {
      return '${(value * 1e6).toStringAsFixed(3)} µF';
    } else if (value.abs() >= 1e-9) {
      return '${(value * 1e9).toStringAsFixed(3)} nF';
    } else if (value.abs() >= 1e-12) {
      return '${(value * 1e12).toStringAsFixed(3)} pF';
    } else if (value.abs() >= 1) {
      return '${value.toStringAsFixed(3)} F';
    } else {
      return '${value.toStringAsExponential(3)} F'; // Corregido aquí
    }
  }

  void _clearFields() {
    for (var controller in _capacitorControllers) {
      controller.clear();
    }
    setState(() {
      _resultSeries = '';
      _resultParallel = '';
      _voltageDistributionSpots = [];
      _esrSpots = [];
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
        title: const Text('Capacitores Serie/Paralelo'),
        centerTitle: true,
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        actions: [
          if (isPro)
            const Chip(
              label: Text('PRO', style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.deepPurple,
            ),
        ],
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
                    icon: Icons.percent,
                    label: 'Tolerancia',
                    value: _toleranceController.text,
                    unit: '%',
                    onChanged: (v) {
                      setState(() => _toleranceController.text = v);
                      _calculateCapacitance();
                    },
                    min: 1,
                    max: 20,
                  ),
                  _buildProParameter(
                    context,
                    icon: Icons.bolt,
                    label: 'Voltaje Máximo',
                    value: _voltageRatingController.text,
                    unit: 'V',
                    onChanged: (v) {
                      setState(() => _voltageRatingController.text = v);
                      _calculateCapacitance();
                    },
                    min: 5,
                    max: 500,
                  ),
                  _buildProParameter(
                    context,
                    icon: Icons.thermostat,
                    label: 'Temperatura',
                    value: _temperatureController.text,
                    unit: '°C',
                    onChanged: (v) {
                      setState(() => _temperatureController.text = v);
                      _calculateCapacitance();
                    },
                    min: -20,
                    max: 60,
                  ),
                  _buildProParameter(
                    context,
                    icon: Icons.electrical_services,
                    label: 'ESR',
                    value: _esrController.text,
                    unit: 'Ω',
                    onChanged: (v) {
                      setState(() => _esrController.text = v);
                      _calculateCapacitance();
                    },
                    min: 0.01,
                    max: 1,
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
                            'Análisis Profesional',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.deepPurple,
                            ),
                          ),
                          const Spacer(),
                          Switch(
                            value: _showAdvancedResults,
                            onChanged: (v) =>
                                setState(() => _showAdvancedResults = v),
                            activeColor: Colors.deepPurple,
                          ),
                        ],
                      ),
                      if (_showAdvancedResults &&
                          _voltageDistributionSpots.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 200,
                          child: _buildVoltageDistributionChart(context),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Distribución de voltaje en configuración serie',
                          style: theme.textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        SizedBox(height: 200, child: _buildEsrChart(context)),
                        const SizedBox(height: 8),
                        Text(
                          'ESR en función de la temperatura',
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
                    AnimatedBuilder(
                      animation: _calculationAnimation,
                      builder: (context, _) {
                        return Opacity(
                          opacity: _calculationAnimation.value,
                          child: Transform.translate(
                            offset: Offset(
                              0,
                              10 * (1 - _calculationAnimation.value),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  _resultParallel,
                                  style: theme.textTheme.headlineSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green[800],
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  _resultSeries,
                                  style: theme.textTheme.headlineSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue[800],
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
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
    required void Function(String) onChanged,
    required double min,
    required double max,
  }) {
    final double numericValue = double.tryParse(value) ?? min;
    final double range = max - min;
    final int? divisions = range > 0 ? (range ~/ (range < 5 ? 0.1 : 1)) : null;

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
            onChanged: (v) => onChanged(v.toStringAsFixed(2)),
          ),
        ],
      ),
    );
  }

  Widget _buildVoltageDistributionChart(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(drawVerticalLine: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) => Text('${value.toInt()}V'),
              reservedSize: 40,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) => Text('C${value.toInt() + 1}'),
            ),
          ),
          rightTitles: const AxisTitles(),
          topTitles: const AxisTitles(),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: _voltageDistributionSpots,
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

  Widget _buildEsrChart(BuildContext context) {
    return LineChart(
      LineChartData(
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) =>
                  Text('${value.toStringAsFixed(2)}Ω'),
              reservedSize: 40,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) => Text('${value.toInt()}°C'),
            ),
          ),
          rightTitles: const AxisTitles(),
          topTitles: const AxisTitles(),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: _esrSpots,
            isCurved: true,
            color: Colors.orange,
            barWidth: 3,
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  Colors.orange.withAlpha(50),
                  Colors.orange.withAlpha(10),
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
