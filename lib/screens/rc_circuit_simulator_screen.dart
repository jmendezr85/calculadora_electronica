import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:calculadora_electronica/utils/unit_utils.dart'; // Asegúrate de que esta importación sea correcta
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

  // Valores de los componentes
  double _resistance = 1.0;
  double _capacitance = 1.0;
  double _voltage = 5.0; // Voltaje de la fuente
  double _initialDischargeVoltage = 5.0; // Voltaje inicial para descarga

  // Prefijos de unidad seleccionados
  UnitPrefix _selectedResistancePrefix =
      UnitPrefix.resistancePrefixes[1]; // Ohms
  UnitPrefix _selectedCapacitancePrefix =
      UnitPrefix.capacitancePrefixes[2]; // µF

  // Modos de simulación y fallos
  SimulationMode _simulationMode = SimulationMode.charging;
  ResistorFault _selectedResistorFault = ResistorFault.normal;
  CapacitorFault _selectedCapacitorFault = CapacitorFault.normal;

  // Datos para el gráfico - CAMBIADOS A FINAL
  final List<FlSpot> _chargingData = [];
  final List<FlSpot> _dischargingData = [];
  final int _maxDataPoints = 500; // Máximo de puntos para el gráfico
  double _currentTime = 0.0;
  Timer? _simulationTimer;

  // Controladores de foco para los TextFields
  final FocusNode _resistanceFocusNode = FocusNode();
  final FocusNode _capacitanceFocusNode = FocusNode();
  final FocusNode _voltageFocusNode = FocusNode();
  final FocusNode _initialDischargeVoltageFocusNode = FocusNode();

  // Variables para la simulación
  double tau = 0.0; // Constante de tiempo RC

  // Variables para controlar la resolución de la simulación y la actualización del UI
  final double _simulationAdvancePerTick =
      0.01; // Cuántos segundos de simulación avanzar por cada tick del Timer
  final Duration _timerUpdateFrequency = const Duration(
    milliseconds: 100,
  ); // Frecuencia de actualización del UI (100ms = 10 FPS del gráfico)

  @override
  void initState() {
    super.initState();
    // Inicializa los controladores con los valores por defecto
    _resistanceController.text = _resistance.toString();
    _capacitanceController.text = _capacitance.toString();
    _voltageController.text = _voltage.toString();
    _initialDischargeVoltageController.text = _initialDischargeVoltage
        .toString();

    // Añade listeners para validar en tiempo real y actualizar valores
    _resistanceController.addListener(_validateResistance);
    _capacitanceController.addListener(_validateCapacitance);
    _voltageController.addListener(_validateVoltage);
    _initialDischargeVoltageController.addListener(
      _validateInitialDischargeVoltage,
    );

    // Añade listeners de foco para validar al perder el foco (opcional, pero útil para UX)
    _resistanceFocusNode.addListener(_onFocusChange);
    _capacitanceFocusNode.addListener(_onFocusChange);
    _voltageFocusNode.addListener(_onFocusChange);
    _initialDischargeVoltageFocusNode.addListener(_onFocusChange);

    _calculateRCConstant(); // Calcula la constante RC inicial
  }

  // Método genérico para validar valores numéricos y actualizar variables
  void _validateAndSetValue({
    required TextEditingController controller,
    required UnitPrefix selectedPrefix,
    required void Function(double) setter,
    required void Function(String?) setError,
    required String fieldName,
    bool allowZero = false,
    bool allowNegative = false,
  }) {
    final String text = controller.text;
    final double? parsedValue = double.tryParse(text);

    if (parsedValue == null) {
      setError('Introduce un número válido.');
      setter(0.0); // O un valor por defecto seguro
      return;
    }
    if (!allowZero && parsedValue == 0) {
      setError('$fieldName no puede ser cero.');
      setter(0.0);
      return;
    }
    if (!allowNegative && parsedValue < 0) {
      setError('$fieldName no puede ser negativo.');
      setter(0.0);
      return;
    }

    final double convertedValue = parsedValue * selectedPrefix.multiplier;
    setter(convertedValue);
    setError(null); // Borra el error si la validación es exitosa
    _calculateRCConstant(); // Recalcula tau al cambiar cualquier valor RC
  }

  void _validateResistance() => _validateAndSetValue(
    controller: _resistanceController,
    selectedPrefix: _selectedResistancePrefix,
    setter: (value) => _resistance = value,
    setError: (error) => setState(() => _resistanceErrorText = error),
    fieldName: 'Resistencia',
  );

  void _validateCapacitance() => _validateAndSetValue(
    controller: _capacitanceController,
    selectedPrefix: _selectedCapacitancePrefix,
    setter: (value) => _capacitance = value,
    setError: (error) => setState(() => _capacitanceErrorText = error),
    fieldName: 'Capacitancia',
  );

  void _validateVoltage() => _validateAndSetValue(
    controller: _voltageController,
    selectedPrefix: UnitPrefix.none, // Ahora UnitPrefix.none existe
    setter: (value) => _voltage = value,
    setError: (error) => setState(() => _voltageErrorText = error),
    fieldName: 'Voltaje',
    allowZero: true, // El voltaje puede ser 0
    allowNegative: true, // El voltaje puede ser negativo
  );

  void _validateInitialDischargeVoltage() => _validateAndSetValue(
    controller: _initialDischargeVoltageController,
    selectedPrefix: UnitPrefix.none, // Ahora UnitPrefix.none existe
    setter: (value) => _initialDischargeVoltage = value,
    setError: (error) =>
        setState(() => _initialDischargeVoltageErrorText = error),
    fieldName: 'Voltaje inicial de descarga',
    allowZero: true,
    allowNegative: true,
  );

  void _onFocusChange() {
    setState(() {
      // Forzar la revalidación cuando el foco cambia
      _validateResistance();
      _validateCapacitance();
      _validateVoltage();
      _validateInitialDischargeVoltage();
    });
  }

  @override
  void dispose() {
    _simulationTimer?.cancel();
    _resistanceController.dispose();
    _capacitanceController.dispose();
    _voltageController.dispose();
    _initialDischargeVoltageController.dispose();
    _resistanceFocusNode.dispose();
    _capacitanceFocusNode.dispose();
    _voltageFocusNode.dispose();
    _initialDischargeVoltageFocusNode.dispose();
    super.dispose();
  }

  void _calculateRCConstant() {
    // Aplicar fallos
    double currentResistance = _resistance;
    double currentCapacitance = _capacitance;

    if (_selectedResistorFault == ResistorFault.open) {
      currentResistance =
          double.infinity; // Resistencia infinita (circuito abierto)
    } else if (_selectedResistorFault == ResistorFault.short) {
      currentResistance = 0.0; // Resistencia cero (cortocircuito)
    }

    if (_selectedCapacitorFault == CapacitorFault.open) {
      currentCapacitance =
          0.0; // Un capacitor abierto actúa como circuito abierto después de la carga inicial
    } else if (_selectedCapacitorFault == CapacitorFault.short) {
      currentCapacitance = double
          .infinity; // Un capacitor en cortocircuito actúa como resistencia cero
    }

    if (currentResistance == double.infinity || currentCapacitance == 0.0) {
      tau = double.infinity; // Circuito abierto o capacitor abierto
    } else if (currentResistance == 0.0 ||
        currentCapacitance == double.infinity) {
      tau = 0.0; // Cortocircuito o capacitor en cortocircuito
    } else if (currentResistance.isNaN ||
        currentCapacitance.isNaN ||
        currentResistance <= 0 ||
        currentCapacitance <= 0) {
      // Manejar casos de entrada no válida o valores no positivos
      tau = 0.0; // O algún valor que indique un estado no válido
    } else {
      tau = currentResistance * currentCapacitance;
    }
    setState(() {}); // Forzar la actualización del UI para mostrar el nuevo tau
  }

  void _startSimulation() {
    _simulationTimer?.cancel(); // Cancela cualquier simulación previa
    _chargingData.clear();
    _dischargingData.clear();
    _currentTime = 0.0;

    // Asegurarse de que los valores de entrada son válidos antes de iniciar
    _validateResistance();
    _validateCapacitance();
    _validateVoltage();
    _validateInitialDischargeVoltage();

    if (_resistanceErrorText != null ||
        _capacitanceErrorText != null ||
        _voltageErrorText != null ||
        _initialDischargeVoltageErrorText != null ||
        tau.isNaN) {
      // Si hay errores en la validación, no iniciar la simulación
      return;
    }

    // Calcular el tiempo máximo de simulación para cubrir al menos 5 * tau
    // Si tau es 0 o infinito, establecer un tiempo máximo sensato o adaptativo.
    double maxTime;
    if (tau == 0.0) {
      maxTime =
          0.01; // Para cortocircuitos o fallos que hacen tau cero, simular muy poco tiempo
    } else if (tau == double.infinity) {
      maxTime = 0.01; // Para circuitos abiertos o fallos que hacen tau infinito
    } else {
      maxTime = tau * 5; // Simular al menos 5 constantes de tiempo
      // Asegurarse de que maxTime no sea absurdamente pequeño o grande para la visualización.
      if (maxTime < 0.1) maxTime = 0.1;
      if (maxTime > 60.0) {
        maxTime = 60.0;
      } // Limitar el tiempo máximo de simulación a 60 segundos, por ejemplo
    }

    // Si ambos modos no están seleccionados, o si tau es infinito y no es un fallo abierto/corto, o tau es 0
    if ((_simulationMode == SimulationMode.charging &&
            (_resistance <= 0 || _capacitance <= 0 || _voltage == 0)) ||
        (_simulationMode == SimulationMode.discharging &&
            (_resistance <= 0 ||
                _capacitance <= 0 ||
                _initialDischargeVoltage == 0))) {
      // No tiene sentido simular si los parámetros son inválidos para el modo seleccionado
      // o si la carga/descarga es instantánea (tau=0) o nunca ocurre (tau=infinito)
      setState(() {
        // Podrías mostrar un mensaje aquí si lo deseas
      });
      return;
    }

    _simulationTimer = Timer.periodic(_timerUpdateFrequency, (timer) {
      setState(() {
        _currentTime +=
            _simulationAdvancePerTick; // Avanzar el tiempo de simulación

        // Cálculo para Carga
        if ((_simulationMode == SimulationMode.charging ||
            _simulationMode == SimulationMode.both)) {
          double chargingVoltage;
          if (tau == 0.0) {
            // Carga instantánea (cortocircuito)
            chargingVoltage = _voltage;
          } else if (tau == double.infinity) {
            // Nunca carga (circuito abierto)
            chargingVoltage = 0.0;
          } else {
            chargingVoltage = _voltage * (1 - math.exp(-_currentTime / tau));
          }

          // Asegurarse de que no se añadan más puntos de los necesarios
          if (_chargingData.length < _maxDataPoints) {
            _chargingData.add(FlSpot(_currentTime, chargingVoltage));
          }
        }

        // Cálculo para Descarga
        if ((_simulationMode == SimulationMode.discharging ||
            _simulationMode == SimulationMode.both)) {
          double dischargingVoltage;
          if (tau == 0.0) {
            // Descarga instantánea (cortocircuito)
            dischargingVoltage = 0.0;
          } else if (tau == double.infinity) {
            // Nunca descarga (circuito abierto)
            dischargingVoltage = _initialDischargeVoltage;
          } else {
            dischargingVoltage =
                _initialDischargeVoltage * math.exp(-_currentTime / tau);
          }

          // Asegurarse de que no se añadan más puntos de los necesarios
          if (_dischargingData.length < _maxDataPoints) {
            _dischargingData.add(FlSpot(_currentTime, dischargingVoltage));
          }
        }

        // Condición de parada del temporizador
        bool stopSimulation = false;
        if (_currentTime >= maxTime) {
          stopSimulation = true;
        } else if ((_simulationMode == SimulationMode.charging ||
                _simulationMode == SimulationMode.both) &&
            _chargingData.length >= _maxDataPoints) {
          stopSimulation = true;
        } else if ((_simulationMode == SimulationMode.discharging ||
                _simulationMode == SimulationMode.both) &&
            _dischargingData.length >= _maxDataPoints) {
          stopSimulation = true;
        }

        if (stopSimulation) {
          _simulationTimer?.cancel();
        }
      });
    });
  }

  void _resetSimulation() {
    _simulationTimer?.cancel();
    setState(() {
      _chargingData.clear();
      _dischargingData.clear();
      _currentTime = 0.0;
      // Puedes resetear los valores de los controladores a los valores por defecto si lo deseas
      // _resistanceController.text = '1.0';
      // _capacitanceController.text = '1.0';
      // _voltageController.text = '5.0';
      // _initialDischargeVoltageController.text = '5.0';
      // _selectedResistancePrefix = UnitPrefix.resistancePrefixes[1];
      // _selectedCapacitancePrefix = UnitPrefix.capacitancePrefixes[2];
      // _simulationMode = SimulationMode.charging;
      // _selectedResistorFault = ResistorFault.normal;
      // _selectedCapacitorFault = CapacitorFault.normal;
      // _calculateRCConstant();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Simulador Circuito RC'),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Constante de Tiempo RC (Tau): ${tau.isFinite ? UnitUtils.formatValue(tau, UnitType.time) : (tau == double.infinity ? '∞' : 'Error')}',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            _buildInputRow(
              context,
              controller: _resistanceController,
              focusNode: _resistanceFocusNode,
              labelText: 'Resistencia (R)',
              baseUnitSymbol: 'Ω',
              prefixes: UnitPrefix.resistancePrefixes,
              selectedPrefix: _selectedResistancePrefix,
              onPrefixChanged: (UnitPrefix? newPrefix) {
                if (newPrefix != null) {
                  setState(() {
                    _selectedResistancePrefix = newPrefix;
                    _validateResistance(); // Re-validar al cambiar el prefijo
                  });
                }
              },
              errorText: _resistanceErrorText,
              faultDropdown: DropdownButton<ResistorFault>(
                value: _selectedResistorFault,
                onChanged: (ResistorFault? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedResistorFault = newValue;
                      _calculateRCConstant();
                    });
                  }
                },
                items: ResistorFault.values.map((ResistorFault fault) {
                  return DropdownMenuItem<ResistorFault>(
                    value: fault,
                    child: Text(
                      fault.name == 'normal'
                          ? 'Normal'
                          : (fault.name == 'open' ? 'Abierto' : 'Corto'),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            _buildInputRow(
              context,
              controller: _capacitanceController,
              focusNode: _capacitanceFocusNode,
              labelText: 'Capacitancia (C)',
              baseUnitSymbol: 'F',
              prefixes: UnitPrefix.capacitancePrefixes,
              selectedPrefix: _selectedCapacitancePrefix,
              onPrefixChanged: (UnitPrefix? newPrefix) {
                if (newPrefix != null) {
                  setState(() {
                    _selectedCapacitancePrefix = newPrefix;
                    _validateCapacitance(); // Re-validar al cambiar el prefijo
                  });
                }
              },
              errorText: _capacitanceErrorText,
              faultDropdown: DropdownButton<CapacitorFault>(
                value: _selectedCapacitorFault,
                onChanged: (CapacitorFault? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedCapacitorFault = newValue;
                      _calculateRCConstant();
                    });
                  }
                },
                items: CapacitorFault.values.map((CapacitorFault fault) {
                  return DropdownMenuItem<CapacitorFault>(
                    value: fault,
                    child: Text(
                      fault.name == 'normal'
                          ? 'Normal'
                          : (fault.name == 'open' ? 'Abierto' : 'Corto'),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            _buildInputRow(
              context,
              controller: _voltageController,
              focusNode: _voltageFocusNode,
              labelText: 'Voltaje Fuente (V)',
              baseUnitSymbol: 'V',
              errorText: _voltageErrorText,
            ),
            const SizedBox(height: 16),
            _buildInputRow(
              context,
              controller: _initialDischargeVoltageController,
              focusNode: _initialDischargeVoltageFocusNode,
              labelText: 'Voltaje Inicial Descarga (Vo)',
              baseUnitSymbol: 'V',
              errorText: _initialDischargeVoltageErrorText,
            ),
            const SizedBox(height: 24),
            Text('Modo de Simulación:', style: textTheme.titleMedium),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: RadioListTile<SimulationMode>(
                    title: const Text('Carga'),
                    value: SimulationMode.charging,
                    groupValue: _simulationMode,
                    onChanged: (value) {
                      setState(() {
                        _simulationMode = value!;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<SimulationMode>(
                    title: const Text('Descarga'),
                    value: SimulationMode.discharging,
                    groupValue: _simulationMode,
                    onChanged: (value) {
                      setState(() {
                        _simulationMode = value!;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<SimulationMode>(
                    title: const Text('Ambos'),
                    value: SimulationMode.both,
                    groupValue: _simulationMode,
                    onChanged: (value) {
                      setState(() {
                        _simulationMode = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _startSimulation,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Iniciar Simulación'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _resetSimulation,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reiniciar'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            AspectRatio(
              aspectRatio: 1.5,
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                color: colorScheme.surfaceContainerHighest,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: true,
                        horizontalInterval: _voltage > 0
                            ? (_voltage / 4)
                            : 1, // Intervalo dinámico para el voltaje
                        verticalInterval: tau.isFinite && tau > 0
                            ? (tau / 2)
                            : 1, // Intervalo dinámico para tau
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: colorScheme.onSurface.withAlpha(
                              (0.3 * 255).round(),
                            ), // Usar withAlpha
                            strokeWidth: 0.5,
                          );
                        },
                        getDrawingVerticalLine: (value) {
                          return FlLine(
                            color: colorScheme.onSurface.withAlpha(
                              (0.3 * 255).round(),
                            ), // Usar withAlpha
                            strokeWidth: 0.5,
                          );
                        },
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            interval: tau.isFinite && tau > 0
                                ? (tau / 2)
                                : 1, // Intervalo dinámico para el tiempo
                            getTitlesWidget: (value, meta) {
                              return SideTitleWidget(
                                axisSide: meta.axisSide,
                                space: 8.0,
                                child: Text(
                                  value.toStringAsFixed(tau > 1 ? 1 : 2),
                                  style: textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            interval: _voltage > 0
                                ? (_voltage / 4)
                                : 1, // Intervalo dinámico para el voltaje
                            getTitlesWidget: (value, meta) {
                              return Text(
                                value.toStringAsFixed(1),
                                style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                                textAlign: TextAlign.left,
                              );
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border.all(
                          color: colorScheme.outlineVariant,
                          width: 1,
                        ),
                      ),
                      minX: 0,
                      maxX: tau.isFinite && tau > 0
                          ? tau * 5.5
                          : (_currentTime == 0 ? 1 : _currentTime * 1.1),
                      minY: 0,
                      maxY:
                          _voltage *
                          1.1, // Un poco más del voltaje de la fuente
                      lineBarsData: [
                        if (_simulationMode == SimulationMode.charging ||
                            _simulationMode == SimulationMode.both)
                          LineChartBarData(
                            spots: _chargingData,
                            isCurved: true,
                            color: Colors.blueAccent,
                            barWidth: 3,
                            isStrokeCapRound: true,
                            dotData: const FlDotData(show: false),
                            belowBarData: BarAreaData(show: false),
                          ),
                        if (_simulationMode == SimulationMode.discharging ||
                            _simulationMode == SimulationMode.both)
                          LineChartBarData(
                            spots: _dischargingData,
                            isCurved: true,
                            color: Colors.redAccent,
                            barWidth: 3,
                            isStrokeCapRound: true,
                            dotData: const FlDotData(show: false),
                            belowBarData: BarAreaData(show: false),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget auxiliar para las filas de entrada con prefijos y errores
  Widget _buildInputRow(
    BuildContext context, {
    required TextEditingController controller,
    required FocusNode focusNode,
    required String labelText,
    required String baseUnitSymbol,
    List<UnitPrefix>? prefixes, // Lista opcional de prefijos
    UnitPrefix? selectedPrefix, // Prefijo seleccionado (si aplica)
    ValueChanged<UnitPrefix?>?
    onPrefixChanged, // Callback para cambio de prefijo
    String? errorText,
    Widget? faultDropdown, // Dropdown opcional para fallos
  }) {
    // Eliminada la declaración de colorScheme no utilizada
    //

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: labelText,
            border: const OutlineInputBorder(),
            suffixIcon: prefixes != null && prefixes.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(right: 8.0),
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
                  )
                : (baseUnitSymbol.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: Align(
                            alignment: Alignment.centerRight,
                            widthFactor: 1.0,
                            child: Text(
                              baseUnitSymbol,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      : null),
            errorText: errorText,
          ),
        ),
        if (faultDropdown != null) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: DropdownButtonHideUnderline(child: faultDropdown),
          ),
        ],
        const SizedBox(height: 8), // Espacio para el error o entre elementos
      ],
    );
  }
}
