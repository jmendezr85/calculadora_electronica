import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'dart:async';

enum SimulationMode { charging, discharging, both }

enum ResistorFault { normal, open, short }

enum CapacitorFault { normal, open, short }

class RCCircuitSimulatorScreen extends StatefulWidget {
  const RCCircuitSimulatorScreen({super.key});

  @override
  State<RCCircuitSimulatorScreen> createState() =>
      _RCCircuitSimulatorScreenState();
}

class _RCCircuitSimulatorScreenState extends State<RCCircuitSimulatorScreen> {
  late TextEditingController _resistanceController;
  late TextEditingController _capacitanceController;
  late TextEditingController _voltageController;
  late TextEditingController _initialDischargeVoltageController;

  String? _resistanceErrorText;
  String? _capacitanceErrorText;
  String? _voltageErrorText;
  String? _initialDischargeVoltageErrorText;

  double _resistance = 0.0;
  double _capacitance = 0.0;
  double _voltage = 0.0;
  double _initialDischargeVoltage = 0.0;
  double _timeConstant = 0.0;

  String _selectedResistanceUnit = 'Ω';
  String _selectedCapacitanceUnit = 'µF';
  String _selectedVoltageUnit = 'V';

  final List<String> _resistanceUnits = ['Ω', 'kΩ', 'MΩ'];
  final List<String> _capacitanceUnits = ['pF', 'nF', 'µF', 'mF', 'F'];
  final List<String> _voltageUnits = ['mV', 'V', 'kV'];

  SimulationMode _simulationMode = SimulationMode.charging;
  int _simulationDurationSeconds = 5;

  final _chargingDataNotifier = ValueNotifier<List<FlSpot>>([]);
  final _dischargingDataNotifier = ValueNotifier<List<FlSpot>>([]);

  Timer? _simulationTimer;
  double _currentTime = 0.0;

  ResistorFault _resistorFault = ResistorFault.normal;
  CapacitorFault _capacitorFault = CapacitorFault.normal;

  bool get _canCalculate {
    return _resistanceController.text.isNotEmpty &&
        _capacitanceController.text.isNotEmpty &&
        _voltageController.text.isNotEmpty &&
        _initialDischargeVoltageController.text.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    _resistanceController = TextEditingController();
    _capacitanceController = TextEditingController();
    _voltageController = TextEditingController();
    _initialDischargeVoltageController = TextEditingController();
  }

  @override
  void dispose() {
    _resistanceController.dispose();
    _capacitanceController.dispose();
    _voltageController.dispose();
    _initialDischargeVoltageController.dispose();
    _simulationTimer?.cancel();
    _chargingDataNotifier.dispose();
    _dischargingDataNotifier.dispose();
    super.dispose();
  }

  void _calculateAndSimulate() {
    if (!_canCalculate) return;

    _simulationTimer?.cancel();
    _chargingDataNotifier.value = [];
    _dischargingDataNotifier.value = [];
    _currentTime = 0.0;

    final resistanceInput = double.tryParse(_resistanceController.text);
    final capacitanceInput = double.tryParse(_capacitanceController.text);
    final voltageInput = double.tryParse(_voltageController.text);
    final initialDischargeVoltageInput = double.tryParse(
      _initialDischargeVoltageController.text,
    );

    setState(() {
      _resistanceErrorText = null;
      _capacitanceErrorText = null;
      _voltageErrorText = null;
      _initialDischargeVoltageErrorText = null;
    });

    if (resistanceInput == null || resistanceInput <= 0) {
      setState(() => _resistanceErrorText = 'Ingrese valor > 0');
      return;
    }
    if (capacitanceInput == null || capacitanceInput <= 0) {
      setState(() => _capacitanceErrorText = 'Ingrese valor > 0');
      return;
    }
    if (voltageInput == null || voltageInput <= 0) {
      setState(() => _voltageErrorText = 'Ingrese valor > 0');
      return;
    }
    if (initialDischargeVoltageInput == null ||
        initialDischargeVoltageInput <= 0) {
      setState(() => _initialDischargeVoltageErrorText = 'Ingrese valor > 0');
      return;
    }

    _resistance = _convertResistance(resistanceInput, _selectedResistanceUnit);
    _capacitance = _convertCapacitance(
      capacitanceInput,
      _selectedCapacitanceUnit,
    );
    _voltage = _convertVoltage(voltageInput, _selectedVoltageUnit);
    _initialDischargeVoltage = _convertVoltage(
      initialDischargeVoltageInput,
      _selectedVoltageUnit,
    );

    double effectiveResistance = _resistance;
    if (_resistorFault == ResistorFault.open) {
      effectiveResistance = 1e12;
    } else if (_resistorFault == ResistorFault.short) {
      effectiveResistance = 1e-12;
    }

    double effectiveCapacitance = _capacitance;
    if (_capacitorFault == CapacitorFault.open) {
      effectiveCapacitance = 1e-12;
    } else if (_capacitorFault == CapacitorFault.short) {
      effectiveCapacitance = 1e12;
    }

    _timeConstant = effectiveResistance * effectiveCapacitance;
    _simulationDurationSeconds = (_timeConstant * 5).clamp(1, 60).round();
    _startSimulationTimer();
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

  double _convertVoltage(double value, String unit) {
    switch (unit) {
      case 'mV':
        return value * 1e-3;
      case 'kV':
        return value * 1e3;
      default:
        return value;
    }
  }

  void _startSimulationTimer() {
    _simulationTimer = Timer.periodic(const Duration(milliseconds: 100), (
      timer,
    ) {
      _currentTime += _simulationDurationSeconds / 100.0;
      if (_currentTime > _simulationDurationSeconds) {
        _currentTime = _simulationDurationSeconds.toDouble();
        _simulationTimer?.cancel();
      }

      final newChargingData = [..._chargingDataNotifier.value];
      newChargingData.add(
        FlSpot(
          _currentTime,
          _voltage * (1 - math.exp(-_currentTime / _timeConstant)),
        ),
      );
      _chargingDataNotifier.value = newChargingData;

      final newDischargingData = [..._dischargingDataNotifier.value];
      newDischargingData.add(
        FlSpot(
          _currentTime,
          _initialDischargeVoltage * math.exp(-_currentTime / _timeConstant),
        ),
      );
      _dischargingDataNotifier.value = newDischargingData;
    });
  }

  void _clearFields() {
    setState(() {
      _resistanceController.clear();
      _capacitanceController.clear();
      _voltageController.clear();
      _initialDischargeVoltageController.clear();
      _selectedResistanceUnit = 'Ω';
      _selectedCapacitanceUnit = 'µF';
      _selectedVoltageUnit = 'V';
      _resistorFault = ResistorFault.normal;
      _capacitorFault = CapacitorFault.normal;
      _simulationMode = SimulationMode.charging;
      _resistanceErrorText = null;
      _capacitanceErrorText = null;
      _voltageErrorText = null;
      _initialDischargeVoltageErrorText = null;
    });
  }

  String _formatTimeConstant(double timeConstant) {
    if (timeConstant < 1e-9) {
      return '${(timeConstant * 1e12).toStringAsFixed(2)} ps';
    } else if (timeConstant < 1e-6) {
      return '${(timeConstant * 1e9).toStringAsFixed(2)} ns';
    } else if (timeConstant < 1e-3) {
      return '${(timeConstant * 1e6).toStringAsFixed(2)} µs';
    } else if (timeConstant < 1) {
      return '${(timeConstant * 1e3).toStringAsFixed(2)} ms';
    } else {
      return '${timeConstant.toStringAsFixed(2)} s';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simulador de Circuito RC'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Simula el comportamiento de un circuito RC durante la carga y descarga.',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Entrada de Resistencia
            _buildInputRow(
              'Resistencia (R)',
              _resistanceController,
              _selectedResistanceUnit,
              _resistanceUnits,
              (value) => setState(() => _selectedResistanceUnit = value!),
              _resistanceErrorText,
              _buildFaultDropdown<ResistorFault>(
                value: _resistorFault,
                items: ResistorFault.values,
                onChanged: (value) => setState(() => _resistorFault = value!),
              ),
            ),

            // Entrada de Capacitancia
            _buildInputRow(
              'Capacitancia (C)',
              _capacitanceController,
              _selectedCapacitanceUnit,
              _capacitanceUnits,
              (value) => setState(() => _selectedCapacitanceUnit = value!),
              _capacitanceErrorText,
              _buildFaultDropdown<CapacitorFault>(
                value: _capacitorFault,
                items: CapacitorFault.values,
                onChanged: (value) => setState(() => _capacitorFault = value!),
              ),
            ),

            // Entrada de Voltaje
            _buildInputRow(
              'Voltaje de la Fuente (Vcc)',
              _voltageController,
              _selectedVoltageUnit,
              _voltageUnits,
              (value) => setState(() => _selectedVoltageUnit = value!),
              _voltageErrorText,
            ),

            // Entrada de Voltaje Inicial
            _buildInputRow(
              'Voltaje Inicial de Descarga (Vo)',
              _initialDischargeVoltageController,
              _selectedVoltageUnit,
              _voltageUnits,
              (value) => setState(() => _selectedVoltageUnit = value!),
              _initialDischargeVoltageErrorText,
            ),

            const SizedBox(height: 16),
            Text(
              _timeConstant > 0
                  ? 'Constante de Tiempo (τ): ${_formatTimeConstant(_timeConstant)}'
                  : 'Ingrese valores válidos para calcular τ',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: _timeConstant > 0
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Selector de Modo
            Wrap(
              spacing: 10,
              alignment: WrapAlignment.center,
              children: [
                _buildModeButton('Carga', SimulationMode.charging),
                _buildModeButton('Descarga', SimulationMode.discharging),
                _buildModeButton('Ambos', SimulationMode.both),
              ],
            ),
            const SizedBox(height: 24),

            // Gráfico
            SizedBox(
              height: 300,
              child: _timeConstant > 0
                  ? ValueListenableBuilder<List<FlSpot>>(
                      valueListenable: _chargingDataNotifier,
                      builder: (context, chargingData, _) {
                        return ValueListenableBuilder<List<FlSpot>>(
                          valueListenable: _dischargingDataNotifier,
                          builder: (context, dischargingData, _) {
                            return LineChart(
                              LineChartData(
                                gridData: const FlGridData(show: true),
                                titlesData: FlTitlesData(
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) =>
                                          Text('${value.toStringAsFixed(1)}s'),
                                      interval: _simulationDurationSeconds / 5,
                                    ),
                                  ),
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) =>
                                          Text('${value.toStringAsFixed(1)}V'),
                                      interval:
                                          math.max(
                                            _voltage,
                                            _initialDischargeVoltage,
                                          ) /
                                          4,
                                    ),
                                  ),
                                ),
                                minX: 0,
                                maxX: _simulationDurationSeconds.toDouble(),
                                minY: 0,
                                maxY:
                                    math.max(
                                      _voltage,
                                      _initialDischargeVoltage,
                                    ) *
                                    1.1,
                                lineBarsData: [
                                  if (_simulationMode !=
                                      SimulationMode.discharging)
                                    LineChartBarData(
                                      spots: chargingData,
                                      isCurved: true,
                                      color: Colors.blue,
                                      barWidth: 3,
                                    ),
                                  if (_simulationMode !=
                                      SimulationMode.charging)
                                    LineChartBarData(
                                      spots: dischargingData,
                                      isCurved: true,
                                      color: Colors.red,
                                      barWidth: 3,
                                    ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        'Ingrese valores válidos para ver la simulación',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.error,
                            ),
                      ),
                    ),
            ),
            const SizedBox(height: 24),

            // Botones
            ElevatedButton(
              onPressed: _canCalculate ? _calculateAndSimulate : null,
              child: const Text('Calcular'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: _clearFields,
              child: const Text('Limpiar Todo'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputRow(
    String label,
    TextEditingController controller,
    String selectedUnit,
    List<String> units,
    ValueChanged<String?> onUnitChanged,
    String? errorText, [
    Widget? extraWidget,
  ]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: label,
            hintText: '0.0',
            border: const OutlineInputBorder(),
            suffixIcon: DropdownButton<String>(
              value: selectedUnit,
              onChanged: onUnitChanged,
              items: units
                  .map(
                    (unit) => DropdownMenuItem(value: unit, child: Text(unit)),
                  )
                  .toList(),
            ),
            errorText: errorText,
          ),
          onChanged: (value) => setState(() {}),
        ),
        if (extraWidget != null) ...[const SizedBox(height: 8), extraWidget],
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildModeButton(String text, SimulationMode mode) {
    return ChoiceChip(
      label: Text(text),
      selected: _simulationMode == mode,
      onSelected: (selected) => setState(() => _simulationMode = mode),
      selectedColor: Theme.of(context).colorScheme.primary,
      labelStyle: TextStyle(
        color: _simulationMode == mode
            ? Theme.of(context).colorScheme.onPrimary
            : Theme.of(context).colorScheme.onSurface,
      ),
    );
  }

  Widget _buildFaultDropdown<T>({
    required T value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
  }) {
    return DropdownButton<T>(
      value: value,
      onChanged: onChanged,
      items: items.map((T item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(item.toString().split('.').last),
        );
      }).toList(),
    );
  }
}
