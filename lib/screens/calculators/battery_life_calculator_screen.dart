import 'package:calculadora_electronica/main.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BatteryLifeCalculatorScreen extends StatefulWidget {
  const BatteryLifeCalculatorScreen({super.key});

  @override
  State<BatteryLifeCalculatorScreen> createState() =>
      _BatteryLifeCalculatorScreenState();
}

class _BatteryLifeCalculatorScreenState
    extends State<BatteryLifeCalculatorScreen>
    with SingleTickerProviderStateMixin {
  // Controladores básicos
  final TextEditingController _capacityController = TextEditingController();
  String _capacityUnit = 'mAh';
  final List<String> _capacityUnits = ['mAh', 'Ah'];

  final TextEditingController _currentController = TextEditingController();
  String _currentUnit = 'mA';
  final List<String> _currentUnits = ['µA', 'mA', 'A'];

  final TextEditingController _powerController = TextEditingController();
  final TextEditingController _voltageController = TextEditingController();
  String _powerUnit = 'mW';
  String _voltageUnit = 'V';
  final List<String> _powerUnits = ['mW', 'W'];
  final List<String> _voltageUnits = ['mV', 'V'];

  // Controladores profesionales
  final TextEditingController _efficiencyController = TextEditingController(
    text: '95',
  );
  final TextEditingController _dodController = TextEditingController(
    text: '80',
  );
  final TextEditingController _cyclesController = TextEditingController(
    text: '500',
  );
  final TextEditingController _tempController = TextEditingController(
    text: '25',
  );

  // Estado
  String _batteryLifeResult = '';
  bool _directCurrentInputMode = true;
  String _selectedTimeFormatUnit = 'Horas';
  final List<String> _timeFormatUnits = [
    'Segundos',
    'Minutos',
    'Horas',
    'Días',
    'Semanas',
    'Meses',
    'Años',
  ];
  bool _showAdvancedChart = false;
  List<FlSpot> _degradationSpots = [];

  // Animación
  late AnimationController _animationController;
  late Animation<double> _batteryAnimation;
  double _currentBatteryLevel = 0.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _batteryAnimation = Tween<double>(
      begin: 0.0,
      end: 0.0,
    ).animate(_animationController)..addListener(() => setState(() {}));
  }

  // Métodos de conversión
  double _convertToBaseCapacity(double value, String unit) {
    switch (unit) {
      case 'mAh':
        return value / 1000;
      default:
        return value;
    }
  }

  double _convertToBaseCurrent(double value, String unit) {
    switch (unit) {
      case 'µA':
        return value / 1e6;
      case 'mA':
        return value / 1000;
      default:
        return value;
    }
  }

  double _convertToBasePower(double value, String unit) {
    switch (unit) {
      case 'mW':
        return value / 1000;
      default:
        return value;
    }
  }

  double _convertToBaseVoltage(double value, String unit) {
    switch (unit) {
      case 'mV':
        return value / 1000;
      default:
        return value;
    }
  }

  void _calculateBatteryLife() {
    final isPro = context.read<AppSettings>().professionalMode;
    final double rawCapacity = double.tryParse(_capacityController.text) ?? 0.0;
    double currentA = 0.0;

    if (_directCurrentInputMode) {
      currentA = _convertToBaseCurrent(
        double.tryParse(_currentController.text) ?? 0.0,
        _currentUnit,
      );
    } else {
      final powerW = _convertToBasePower(
        double.tryParse(_powerController.text) ?? 0.0,
        _powerUnit,
      );
      final voltageV = _convertToBaseVoltage(
        double.tryParse(_voltageController.text) ?? 0.0,
        _voltageUnit,
      );
      currentA = voltageV > 0 ? powerW / voltageV : 0.0;
    }

    if (rawCapacity > 0 && currentA > 0) {
      double capacityAh = _convertToBaseCapacity(rawCapacity, _capacityUnit);

      if (isPro) {
        final efficiency =
            (double.tryParse(_efficiencyController.text) ?? 100) / 100;
        final dod = (double.tryParse(_dodController.text) ?? 100) / 100;
        capacityAh = capacityAh * efficiency * dod;
        _generateDegradationData(capacityAh, currentA);
      }

      final double batteryLifeHours = capacityAh / currentA;
      _batteryLifeResult = _formatBatteryLife(
        batteryLifeHours,
        _selectedTimeFormatUnit,
      );
      _currentBatteryLevel = 1.0;

      _animationController.reset();
      _batteryAnimation = Tween<double>(
        begin: 0.0,
        end: _currentBatteryLevel,
      ).animate(_animationController);
      _animationController.forward();
    } else {
      _batteryLifeResult = 'Ingrese valores válidos';
      _currentBatteryLevel = 0.0;
      _animationController.reset();
    }
    setState(() {});
  }

  void _generateDegradationData(double capacity, double current) {
    _degradationSpots = [];
    final int cycles = int.tryParse(_cyclesController.text) ?? 500;
    final double temp = double.tryParse(_tempController.text) ?? 25;
    final double tempEffect = 1 - ((temp - 25) * 0.005);

    for (int i = 0; i <= cycles; i += 50) {
      final degradation = 0.0002 * i * tempEffect;
      final remainingCapacity = capacity * (1 - degradation);
      final lifeHours = remainingCapacity / current;
      _degradationSpots.add(FlSpot(i.toDouble(), lifeHours));
    }
  }

  String _formatBatteryLife(double hours, String unit) {
    switch (unit) {
      case 'Segundos':
        return '${(hours * 3600).toStringAsFixed(2)} segundos';
      case 'Minutos':
        return '${(hours * 60).toStringAsFixed(2)} minutos';
      case 'Días':
        return '${(hours / 24).toStringAsFixed(2)} días';
      case 'Semanas':
        return '${(hours / 168).toStringAsFixed(2)} semanas';
      case 'Meses':
        return '${(hours / 730).toStringAsFixed(2)} meses';
      case 'Años':
        return '${(hours / 8760).toStringAsFixed(2)} años';
      default:
        return '${hours.toStringAsFixed(2)} horas';
    }
  }

  void _clearCalculations() {
    setState(() {
      _capacityController.clear();
      _currentController.clear();
      _powerController.clear();
      _voltageController.clear();
      _batteryLifeResult = '';
      _currentBatteryLevel = 0.0;
      _animationController.reset();
      _degradationSpots = [];
    });
  }

  @override
  void dispose() {
    _capacityController.dispose();
    _currentController.dispose();
    _powerController.dispose();
    _voltageController.dispose();
    _efficiencyController.dispose();
    _dodController.dispose();
    _cyclesController.dispose();
    _tempController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPro = context.select<AppSettings, bool>((s) => s.professionalMode);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora de Vida de Batería'),
        actions: [
          if (isPro)
            const Chip(
              label: Text('PRO', style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.deepPurple,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Sección básica
            _buildInputSection(
              icon: Icons.battery_charging_full,
              title: 'Capacidad de la Batería',
              controller: _capacityController,
              unit: _capacityUnit,
              units: _capacityUnits,
              onUnitChanged: (v) => setState(() => _capacityUnit = v ?? 'mAh'),
            ),

            const SizedBox(height: 20),
            Text('Método de entrada:', style: theme.textTheme.titleMedium),

            RadioGroup<bool>(
              groupValue: _directCurrentInputMode,
              onChanged: (bool? v) {
                setState(() {
                  _directCurrentInputMode = v ?? _directCurrentInputMode;
                  _clearCalculations();
                });
              },
              // 👇 Todo este child puede ser const
              child: const Row(
                children: [
                  Expanded(
                    child: RadioListTile<bool>(
                      title: Text('Corriente'),
                      value: true,
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<bool>(
                      title: Text('Potencia/Voltaje'),
                      value: false,
                    ),
                  ),
                ],
              ),
            ),

            if (_directCurrentInputMode)
              _buildInputSection(
                icon: Icons.electrical_services,
                title: 'Consumo de Corriente',
                controller: _currentController,
                unit: _currentUnit,
                units: _currentUnits,
                onUnitChanged: (v) => setState(() => _currentUnit = v ?? 'mA'),
              )
            else
              Column(
                children: [
                  _buildInputSection(
                    icon: Icons.power,
                    title: 'Consumo de Potencia',
                    controller: _powerController,
                    unit: _powerUnit,
                    units: _powerUnits,
                    onUnitChanged: (v) =>
                        setState(() => _powerUnit = v ?? 'mW'),
                  ),
                  const SizedBox(height: 10),
                  _buildInputSection(
                    icon: Icons.flash_on,
                    title: 'Voltaje',
                    controller: _voltageController,
                    unit: _voltageUnit,
                    units: _voltageUnits,
                    onUnitChanged: (v) =>
                        setState(() => _voltageUnit = v ?? 'V'),
                  ),
                ],
              ),

            const SizedBox(height: 20),
            _buildInputSection(
              icon: Icons.timer,
              title: 'Formato de Tiempo',
              controller: null,
              unit: _selectedTimeFormatUnit,
              units: _timeFormatUnits,
              onUnitChanged: (v) => setState(() {
                _selectedTimeFormatUnit = v ?? 'Horas';
                if (_batteryLifeResult.isNotEmpty) _calculateBatteryLife();
              }),
              isDropdownOnly: true,
            ),

            // Sección profesional mejorada
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
                    icon: Icons.battery_saver,
                    label: 'Eficiencia',
                    value: _efficiencyController.text,
                    unit: '%',
                    onChanged: (v) =>
                        setState(() => _efficiencyController.text = v),
                    min: 50,
                    max: 100,
                  ),
                  _buildProParameter(
                    context,
                    icon: Icons.vertical_align_bottom,
                    label: 'Profundidad de Descarga',
                    value: _dodController.text,
                    unit: '%',
                    onChanged: (v) => setState(() => _dodController.text = v),
                    min: 20,
                    max: 100,
                  ),
                  _buildProParameter(
                    context,
                    icon: Icons.repeat,
                    label: 'Ciclos de Vida',
                    value: _cyclesController.text,
                    unit: 'ciclos',
                    onChanged: (v) =>
                        setState(() => _cyclesController.text = v),
                    min: 100,
                    max: 2000,
                  ),
                  _buildProParameter(
                    context,
                    icon: Icons.thermostat,
                    label: 'Temperatura',
                    value: _tempController.text,
                    unit: '°C',
                    onChanged: (v) => setState(() => _tempController.text = v),
                    min: -20,
                    max: 60,
                  ),
                ],
              ),

              const SizedBox(height: 16),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Theme.of(context).dividerColor),
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
                            'Degradación por Ciclos',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.deepPurple,
                            ),
                          ),
                          const Spacer(),
                          Switch(
                            value: _showAdvancedChart,
                            onChanged: (v) =>
                                setState(() => _showAdvancedChart = v),
                            activeThumbColor: Colors.deepPurple,
                          ),
                        ],
                      ),
                      if (_showAdvancedChart &&
                          _degradationSpots.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 200,
                          child: _buildEnhancedDegradationChart(context),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Capacidad residual estimada tras ${_cyclesController.text} ciclos',
                          style: theme.textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],

            // Botones y resultado
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculateBatteryLife,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
              ),
              child: const Text('CALCULAR'),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: _clearCalculations,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text('LIMPIAR'),
            ),
            const SizedBox(height: 20),
            _buildResultCard(theme),
          ],
        ),
      ),
    );
  }

  // ============ COMPONENTES PERSONALIZADOS ============

  Widget _buildInputSection({
    required IconData icon,
    required String title,
    required TextEditingController? controller,
    required String unit,
    List<String> units = const [],
    required ValueChanged<String?>? onUnitChanged,
    bool isDropdownOnly = false,
  }) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 10),
        Expanded(
          child: !isDropdownOnly
              ? TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: title,
                    border: const OutlineInputBorder(),
                  ),
                )
              : InputDecorator(
                  decoration: InputDecoration(
                    labelText: title,
                    border: const OutlineInputBorder(),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: unit,
                      isExpanded: true,
                      items: units
                          .map(
                            (u) => DropdownMenuItem(value: u, child: Text(u)),
                          )
                          .toList(),
                      onChanged: onUnitChanged,
                    ),
                  ),
                ),
        ),
        if (!isDropdownOnly && units.isNotEmpty) ...[
          const SizedBox(width: 10),
          DropdownButton<String>(
            value: unit,
            items: units
                .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                .toList(),
            onChanged: onUnitChanged,
          ),
        ] else if (!isDropdownOnly) ...[
          const SizedBox(width: 10),
          Text(unit, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ],
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
            divisions: (max - min).toInt(),
            label: '$numericValue$unit',
            activeColor: Colors.deepPurple,
            onChanged: (v) => onChanged(v.round().toString()),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedDegradationChart(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(drawVerticalLine: false),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 40),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) => Text('${value.toInt()}'),
            ),
          ),
          rightTitles: const AxisTitles(),
          topTitles: const AxisTitles(),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: _degradationSpots,
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
        minX: 0,
        maxX: _degradationSpots.isNotEmpty ? _degradationSpots.last.x : 1000,
        minY: 0,
        maxY: _degradationSpots.isNotEmpty
            ? _degradationSpots.first.y * 1.1
            : 100,
      ),
    );
  }

  Widget _buildResultCard(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('RESULTADO', style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),
            AnimatedBuilder(
              animation: _batteryAnimation,
              builder: (context, _) {
                final progress = _batteryAnimation.value;
                Color color;
                if (progress > 0.7) {
                  color = Colors.green;
                } else if (progress > 0.3) {
                  color = Colors.orange;
                } else {
                  color = Colors.red;
                }

                return Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 10,
                        backgroundColor: isDark
                            ? Colors.grey.shade800
                            : Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation(color),
                      ),
                    ),
                    Icon(Icons.battery_full, size: 40, color: color),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            if (_batteryLifeResult.isEmpty)
              Text(
                'Ingrese los parámetros para calcular',
                style: theme.textTheme.bodyLarge,
              )
            else
              Column(
                children: [
                  Text('Vida estimada:', style: theme.textTheme.bodyLarge),
                  const SizedBox(height: 8),
                  Text(
                    _batteryLifeResult,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
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
