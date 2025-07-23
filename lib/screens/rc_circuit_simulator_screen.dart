import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:calculadora_electronica/utils/unit_utils.dart';
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
  final TextEditingController _resistanceController = TextEditingController();
  final TextEditingController _capacitanceController = TextEditingController();
  final TextEditingController _voltageController = TextEditingController();
  final TextEditingController _initialDischargeVoltageController =
      TextEditingController();

  String? _resistanceErrorText;
  String? _capacitanceErrorText;
  String? _voltageErrorText;
  String? _initialDischargeVoltageErrorText;

  double _resistance = 1.0;
  double _capacitance = 1.0;
  double _voltage = 5.0;
  double _initialDischargeVoltage = 5.0;

  UnitPrefix _selectedResistancePrefix = UnitPrefix.resistancePrefixes[2];
  UnitPrefix _selectedCapacitancePrefix = UnitPrefix.capacitancePrefixes[2];

  final List<FlSpot> _chargingData = [];
  final List<FlSpot> _dischargingData = [];
  double _tau = 0.0;

  Timer? _debounceTimer;

  SimulationMode _simulationMode = SimulationMode.both;

  ResistorFault _selectedResistorFault = ResistorFault.normal;
  CapacitorFault _selectedCapacitorFault = CapacitorFault.normal;

  @override
  void initState() {
    super.initState();
    _resistanceController.text = '1';
    _capacitanceController.text = '1';
    _voltageController.text = _voltage.toStringAsFixed(0);
    _initialDischargeVoltageController.text = _initialDischargeVoltage
        .toStringAsFixed(0);
    _validateInputs(initial: true);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _resistanceController.dispose();
    _capacitanceController.dispose();
    _voltageController.dispose();
    _initialDischargeVoltageController.dispose();
    super.dispose();
  }

  void _validateInputs({bool initial = false}) {
    bool allValid = true;

    if (_selectedResistorFault == ResistorFault.normal) {
      final double? r = double.tryParse(_resistanceController.text);
      if (r == null || r <= 0) {
        _resistanceErrorText = 'Debe ser un número positivo.';
        allValid = false;
      } else {
        _resistanceErrorText = null;
      }
    } else {
      _resistanceErrorText = null;
    }

    if (_selectedCapacitorFault == CapacitorFault.normal) {
      final double? c = double.tryParse(_capacitanceController.text);
      if (c == null || c <= 0) {
        _capacitanceErrorText = 'Debe ser un número positivo.';
        allValid = false;
      } else {
        _capacitanceErrorText = null;
      }
    } else {
      _capacitanceErrorText = null;
    }

    final double? v = double.tryParse(_voltageController.text);
    if (v == null || v <= 0) {
      _voltageErrorText = 'Debe ser un número positivo.';
      allValid = false;
    } else {
      _voltageErrorText = null;
    }

    if (_simulationMode == SimulationMode.discharging ||
        _simulationMode == SimulationMode.both) {
      final double? vid = double.tryParse(
        _initialDischargeVoltageController.text,
      );
      if (vid == null || vid < 0) {
        // Permitir 0V para descarga inicial
        _initialDischargeVoltageErrorText =
            'Debe ser un número positivo o cero.';
        allValid = false;
      } else {
        _initialDischargeVoltageErrorText = null;
      }
    } else {
      _initialDischargeVoltageErrorText = null;
    }

    if (allValid ||
        initial ||
        _resistanceErrorText != null ||
        _capacitanceErrorText != null ||
        _voltageErrorText != null ||
        _initialDischargeVoltageErrorText != null) {
      setState(() {
        if (allValid) {
          _calculateAndPlotInternal(
            double.tryParse(_resistanceController.text) ?? 1.0,
            double.tryParse(_capacitanceController.text) ?? 1.0,
            v!,
            initialDischargeV:
                double.tryParse(_initialDischargeVoltageController.text) ?? v,
          );
        } else {
          _chargingData.clear();
          _dischargingData.clear();
          _tau = 0.0;
        }
      });
    }
  }

  void _onInputChanged() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _validateInputs();
    });
  }

  void _calculateAndPlotInternal(
    double rawResistance,
    double rawCapacitance,
    double rawVoltage, {
    required double initialDischargeV,
  }) {
    // Valores efectivos de R y C basados en el modo de fallo
    double effectiveResistance;
    double effectiveCapacitance;

    if (_selectedResistorFault == ResistorFault.open) {
      effectiveResistance = double.infinity;
    } else if (_selectedResistorFault == ResistorFault.short) {
      effectiveResistance = 0.0;
    } else {
      effectiveResistance =
          rawResistance * _selectedResistancePrefix.multiplier;
    }

    if (_selectedCapacitorFault == CapacitorFault.open) {
      effectiveCapacitance =
          0.0; // Un capacitor abierto actúa como un circuito abierto sin capacidad de almacenar carga
    } else if (_selectedCapacitorFault == CapacitorFault.short) {
      effectiveCapacitance = double
          .infinity; // Un capacitor en cortocircuito es como un cable, su impedancia es casi cero, por lo tanto, la constante de tiempo RC se vuelve instantánea
    } else {
      effectiveCapacitance =
          rawCapacitance * _selectedCapacitancePrefix.multiplier;
    }

    _resistance = effectiveResistance;
    _capacitance = effectiveCapacitance;
    _voltage = rawVoltage;
    _initialDischargeVoltage = initialDischargeV;

    _chargingData.clear();
    _dischargingData.clear();

    // Lógica para generar las curvas, manejando los fallos explícitamente
    if (_selectedResistorFault == ResistorFault.open ||
        _selectedCapacitorFault == CapacitorFault.open) {
      // Circuito abierto: no hay carga/descarga. El voltaje del capacitor no cambia.
      _tau = double.infinity;
      final double maxTimeForFault = 1.0; // Tiempo para ver la línea plana

      if (_simulationMode == SimulationMode.charging ||
          _simulationMode == SimulationMode.both) {
        _chargingData.add(FlSpot(0, 0)); // Empieza en 0V
        _chargingData.add(FlSpot(maxTimeForFault, 0)); // Se mantiene en 0V
      }
      if (_simulationMode == SimulationMode.discharging ||
          _simulationMode == SimulationMode.both) {
        _dischargingData.add(
          FlSpot(0, _initialDischargeVoltage),
        ); // Empieza en Vo
        _dischargingData.add(
          FlSpot(maxTimeForFault, _initialDischargeVoltage),
        ); // Se mantiene en Vo
      }
    } else if (_selectedResistorFault == ResistorFault.short ||
        _selectedCapacitorFault == CapacitorFault.short) {
      // Resistor en corto o Capacitor en corto: carga/descarga instantánea
      _tau = 0.0;
      final double maxTimeForFault =
          0.1; // Un tiempo muy corto para mostrar el salto instantáneo

      if (_simulationMode == SimulationMode.charging ||
          _simulationMode == SimulationMode.both) {
        if (_selectedCapacitorFault == CapacitorFault.short) {
          _chargingData.add(FlSpot(0, 0)); // Vc siempre 0
          _chargingData.add(FlSpot(maxTimeForFault, 0)); // Se mantiene en 0V
        } else {
          // Resistor en corto (Carga instantánea a V_fuente)
          _chargingData.add(FlSpot(0, 0)); // Inicia en 0V
          _chargingData.add(FlSpot(0.0001, _voltage)); // Salto instantáneo
          _chargingData.add(
            FlSpot(maxTimeForFault, _voltage),
          ); // Se mantiene en V_fuente
        }
      }

      if (_simulationMode == SimulationMode.discharging ||
          _simulationMode == SimulationMode.both) {
        // Descarga instantánea a 0V
        _dischargingData.add(
          FlSpot(0, _initialDischargeVoltage),
        ); // Inicia en Vo
        _dischargingData.add(FlSpot(0.0001, 0)); // Salto instantáneo
        _dischargingData.add(FlSpot(maxTimeForFault, 0)); // Se mantiene en 0V
      }
    } else {
      // Modo normal, sin fallos
      _tau = _resistance * _capacitance;
      final double maxTime = _tau * 5;

      if (_simulationMode == SimulationMode.charging ||
          _simulationMode == SimulationMode.both) {
        for (double t = 0; t <= maxTime; t += maxTime / 100) {
          double vc = _voltage * (1 - math.exp(-t / _tau));
          _chargingData.add(FlSpot(t, vc));
        }
      }

      if (_simulationMode == SimulationMode.discharging ||
          _simulationMode == SimulationMode.both) {
        for (double t = 0; t <= maxTime; t += maxTime / 100) {
          double vc = _initialDischargeVoltage * math.exp(-t / _tau);
          _dischargingData.add(FlSpot(t, vc));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determinar el valor máximo para el eje Y de la gráfica
    double graphMaxY = 0;
    if (_simulationMode == SimulationMode.charging ||
        _simulationMode == SimulationMode.both) {
      graphMaxY = math.max(graphMaxY, _voltage);
    }
    if (_simulationMode == SimulationMode.discharging ||
        _simulationMode == SimulationMode.both) {
      graphMaxY = math.max(graphMaxY, _initialDischargeVoltage);
    }
    graphMaxY = (graphMaxY > 0)
        ? graphMaxY * 1.1
        : 5.0; // Asegura un rango visible si los voltajes son 0

    // Ajustar maxX para casos de tau infinito o cero
    double displayMaxX;
    if (_tau.isInfinite) {
      displayMaxX =
          5.0; // Por ejemplo, 5 segundos para ver que la línea es plana
    } else if (_tau == 0.0) {
      displayMaxX = 0.5; // Un rango corto para mostrar el salto instantáneo
    } else {
      displayMaxX = _tau * 5;
    }
    // Asegurarse de que displayMaxX sea al menos un valor positivo para evitar errores del gráfico
    if (displayMaxX <= 0) displayMaxX = 1.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Simulador Circuito RC'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'Simulador de Carga y Descarga de un Capacitor en un Circuito RC.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            _buildInputRow(
              'Resistencia (R)',
              _resistanceController,
              'Ω',
              prefixes: UnitPrefix.resistancePrefixes,
              selectedPrefix: _selectedResistancePrefix,
              onPrefixChanged: (newValue) {
                setState(() {
                  _selectedResistancePrefix = newValue!;
                  _onInputChanged();
                });
              },
              onTextChanged: _onInputChanged,
              errorText: _resistanceErrorText,
              faultDropdown: DropdownButton<ResistorFault>(
                value: _selectedResistorFault,
                onChanged: (ResistorFault? newValue) {
                  setState(() {
                    _selectedResistorFault = newValue!;
                    _onInputChanged();
                  });
                },
                items: const [
                  DropdownMenuItem(
                    value: ResistorFault.normal,
                    child: Text('Normal'),
                  ),
                  DropdownMenuItem(
                    value: ResistorFault.open,
                    child: Text('Abierto'),
                  ),
                  DropdownMenuItem(
                    value: ResistorFault.short,
                    child: Text('Corto'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildInputRow(
              'Capacitancia (C)',
              _capacitanceController,
              'F',
              prefixes: UnitPrefix.capacitancePrefixes,
              selectedPrefix: _selectedCapacitancePrefix,
              onPrefixChanged: (newValue) {
                setState(() {
                  _selectedCapacitancePrefix = newValue!;
                  _onInputChanged();
                });
              },
              onTextChanged: _onInputChanged,
              errorText: _capacitanceErrorText,
              faultDropdown: DropdownButton<CapacitorFault>(
                value: _selectedCapacitorFault,
                onChanged: (CapacitorFault? newValue) {
                  setState(() {
                    _selectedCapacitorFault = newValue!;
                    _onInputChanged();
                  });
                },
                items: const [
                  DropdownMenuItem(
                    value: CapacitorFault.normal,
                    child: Text('Normal'),
                  ),
                  DropdownMenuItem(
                    value: CapacitorFault.open,
                    child: Text('Abierto'),
                  ),
                  DropdownMenuItem(
                    value: CapacitorFault.short,
                    child: Text('Corto'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildInputRow(
              'Voltaje de Fuente (V)',
              _voltageController,
              'V',
              onTextChanged: _onInputChanged,
              errorText: _voltageErrorText,
            ),
            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Modo de Simulación:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: RadioListTile<SimulationMode>(
                          title: const Text('Carga'),
                          value: SimulationMode.charging,
                          groupValue: _simulationMode,
                          onChanged: (SimulationMode? value) {
                            setState(() {
                              _simulationMode = value!;
                              // Si es carga, el voltaje inicial de descarga se iguala al de la fuente por coherencia visual al cambiar de modo
                              _initialDischargeVoltageController.text = _voltage
                                  .toStringAsFixed(0);
                              _validateInputs();
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<SimulationMode>(
                          title: const Text('Descarga'),
                          value: SimulationMode.discharging,
                          groupValue: _simulationMode,
                          onChanged: (SimulationMode? value) {
                            setState(() {
                              _simulationMode = value!;
                              _initialDischargeVoltageController.text = _voltage
                                  .toStringAsFixed(0);
                              _validateInputs();
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<SimulationMode>(
                          title: const Text('Ambos'),
                          value: SimulationMode.both,
                          groupValue: _simulationMode,
                          onChanged: (SimulationMode? value) {
                            setState(() {
                              _simulationMode = value!;
                              _initialDischargeVoltageController.text = _voltage
                                  .toStringAsFixed(0);
                              _validateInputs();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Opacity(
              opacity:
                  (_simulationMode == SimulationMode.discharging ||
                      _simulationMode == SimulationMode.both)
                  ? 1.0
                  : 0.4,
              child: IgnorePointer(
                ignoring:
                    !(_simulationMode == SimulationMode.discharging ||
                        _simulationMode == SimulationMode.both),
                child: _buildInputRow(
                  'Voltaje Inicial de Descarga (Vo)',
                  _initialDischargeVoltageController,
                  'V',
                  onTextChanged: _onInputChanged,
                  errorText: _initialDischargeVoltageErrorText,
                ),
              ),
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () {
                _debounceTimer?.cancel();
                _validateInputs();
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Simular y Graficar (Manual)',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),

            // Mostrar "∞" si _tau es infinito, "0" si es cero, o el valor calculado
            Text(
              'Constante de Tiempo (τ): ${_tau.isInfinite ? "∞" : (_tau == 0.0 ? "0" : _tau.toStringAsFixed(3))} segundos',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            AspectRatio(
              aspectRatio: 1.5,
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: displayMaxX),
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeOutCubic,
                builder: (context, animatedMaxX, child) {
                  // Ajuste para limpiar la gráfica si hay errores de entrada
                  bool hasInputError =
                      _resistanceErrorText != null ||
                      _capacitanceErrorText != null ||
                      _voltageErrorText != null ||
                      (_initialDischargeVoltageErrorText != null &&
                          (_simulationMode == SimulationMode.discharging ||
                              _simulationMode == SimulationMode.both));

                  List<FlSpot> currentChargingData = hasInputError
                      ? []
                      : _chargingData
                            .where((spot) => spot.x <= animatedMaxX)
                            .toList();
                  List<FlSpot> currentDischargingData = hasInputError
                      ? []
                      : _dischargingData
                            .where((spot) => spot.x <= animatedMaxX)
                            .toList();

                  return LineChart(
                    LineChartData(
                      gridData: const FlGridData(show: true),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) =>
                                Text('${value.toStringAsFixed(1)}s'),
                            reservedSize: 30,
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) =>
                                Text('${value.toStringAsFixed(1)}V'),
                            reservedSize: 40,
                          ),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border.all(
                          color: const Color(0xff37434d),
                          width: 1,
                        ),
                      ),
                      minX: 0,
                      maxX: displayMaxX,
                      minY: 0,
                      maxY: graphMaxY,
                      lineBarsData: [
                        if (_simulationMode == SimulationMode.charging ||
                            _simulationMode == SimulationMode.both)
                          LineChartBarData(
                            spots: currentChargingData,
                            isCurved: true,
                            color: Colors.blue,
                            barWidth: 3,
                            isStrokeCapRound: true,
                            dotData: const FlDotData(show: false),
                            belowBarData: BarAreaData(show: false),
                          ),
                        if (_simulationMode == SimulationMode.discharging ||
                            _simulationMode == SimulationMode.both)
                          LineChartBarData(
                            spots: currentDischargingData,
                            isCurved: true,
                            color: Colors.red,
                            barWidth: 3,
                            isStrokeCapRound: true,
                            dotData: const FlDotData(show: false),
                            belowBarData: BarAreaData(show: false),
                          ),
                      ],
                      extraLinesData: ExtraLinesData(
                        verticalLines: [
                          // Solo muestra la línea Tau si el cálculo es válido y tau es finito y positivo
                          if (_tau > 0 && _tau.isFinite && !hasInputError)
                            VerticalLine(
                              x: _tau,
                              color: Colors.grey,
                              strokeWidth: 1,
                              dashArray: [5, 5],
                              label: VerticalLineLabel(
                                show: true,
                                alignment: Alignment.topRight,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                ),
                                labelResolver: (line) =>
                                    'τ (${_tau.toStringAsFixed(2)}s)',
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_simulationMode == SimulationMode.charging ||
                    _simulationMode == SimulationMode.both)
                  Row(
                    children: [
                      Container(width: 15, height: 3, color: Colors.blue),
                      const SizedBox(width: 5),
                      const Text('Carga'),
                      const SizedBox(width: 15),
                    ],
                  ),
                if (_simulationMode == SimulationMode.discharging ||
                    _simulationMode == SimulationMode.both)
                  Row(
                    children: [
                      Container(width: 15, height: 3, color: Colors.red),
                      const SizedBox(width: 5),
                      const Text('Descarga'),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputRow(
    String label,
    TextEditingController controller,
    String baseUnitSymbol, {
    List<UnitPrefix>? prefixes,
    UnitPrefix? selectedPrefix,
    ValueChanged<UnitPrefix?>? onPrefixChanged,
    VoidCallback? onTextChanged,
    String? errorText,
    Widget? faultDropdown,
  }) {
    // Determinar si el campo de texto debe estar habilitado
    bool isEnabled = true;
    if (label.contains('Resistencia') &&
        _selectedResistorFault != ResistorFault.normal) {
      isEnabled = false;
    } else if (label.contains('Capacitancia') &&
        _selectedCapacitorFault != CapacitorFault.normal) {
      isEnabled = false;
    }

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Opacity(
            opacity: isEnabled ? 1.0 : 0.4,
            child: IgnorePointer(
              ignoring: !isEnabled,
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: label,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  errorText: errorText,
                ),
                onChanged: (text) => onTextChanged?.call(),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        if (prefixes != null &&
            selectedPrefix != null &&
            onPrefixChanged != null)
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Container(
                  width: 100,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<UnitPrefix>(
                      value: selectedPrefix,
                      onChanged: onPrefixChanged,
                      items: prefixes.map((UnitPrefix prefix) {
                        return DropdownMenuItem<UnitPrefix>(
                          value: prefix,
                          child: Text(
                            prefix.symbol.isEmpty
                                ? baseUnitSymbol
                                : '${prefix.symbol}$baseUnitSymbol',
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                if (faultDropdown != null) ...[
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(child: faultDropdown),
                    ),
                  ),
                ],
              ],
            ),
          )
        else // Para el campo de voltaje que no tiene prefijos ni dropdown de fallo
          SizedBox(
            width: 50,
            child: Text(
              baseUnitSymbol,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
      ],
    );
  }
}
