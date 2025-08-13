import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:calculadora_electronica/widgets/input_row_widget.dart';
import 'package:calculadora_electronica/main.dart';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart'; // Importa fl_chart para la gráfica

class OhmLawScreen extends StatefulWidget {
  const OhmLawScreen({super.key});

  @override
  State<OhmLawScreen> createState() => _OhmLawScreenState();
}

class _OhmLawScreenState extends State<OhmLawScreen> {
  final TextEditingController _voltageController = TextEditingController();
  final TextEditingController _currentController = TextEditingController();
  final TextEditingController _resistanceController = TextEditingController();
  final TextEditingController _powerController = TextEditingController();

  String _selectedVoltageUnit = 'V';
  String _selectedCurrentUnit = 'A';
  String _selectedResistanceUnit = 'Ω';
  String _selectedPowerUnit = 'W';

  final List<String> _voltageUnits = ['V', 'mV', 'kV'];
  final List<String> _currentUnits = ['A', 'mA', 'µA'];
  final List<String> _resistanceUnits = ['Ω', 'kΩ', 'MΩ'];
  final List<String> _powerUnits = ['W', 'mW', 'kW'];

  String? _calculatedVoltage;
  String? _calculatedCurrent;
  String? _calculatedResistance;
  String? _calculatedPower;
  String _resultMessage = '';
  final List<String> _formulasUsed = [];

  List<BarChartGroupData> _chartData = [];

  @override
  void dispose() {
    _voltageController.dispose();
    _currentController.dispose();
    _resistanceController.dispose();
    _powerController.dispose();
    super.dispose();
  }

  double? _convertToBaseUnit(double? value, String unit) {
    if (value == null) return null;
    switch (unit) {
      case 'mV':
        return value / 1000;
      case 'kV':
        return value * 1000;
      case 'mA':
        return value / 1000;
      case 'µA':
        return value / 1000000;
      case 'kΩ':
        return value * 1000;
      case 'MΩ':
        return value * 1000000;
      case 'mW':
        return value / 1000;
      case 'kW':
        return value * 1000;
      default:
        return value;
    }
  }

  String _convertFromBaseUnit(double value, String targetUnit) {
    double displayValue = value;
    String formattedValue;

    switch (targetUnit) {
      case 'mV':
        displayValue = value * 1000;
        break;
      case 'kV':
        displayValue = value / 1000;
        break;
      case 'mA':
        displayValue = value * 1000;
        break;
      case 'µA':
        displayValue = value * 1000000;
        break;
      case 'kΩ':
        displayValue = value / 1000;
        break;
      case 'MΩ':
        displayValue = value / 1000000;
        break;
      case 'mW':
        displayValue = value * 1000;
        break;
      case 'kW':
        displayValue = value / 1000;
        break;
    }

    if (displayValue.abs() >= 1000 ||
        (displayValue.abs() < 0.001 && displayValue != 0)) {
      formattedValue = displayValue.toStringAsPrecision(4);
    } else {
      formattedValue = displayValue.toStringAsFixed(3);
    }

    return formattedValue;
  }

  void _calculateOhmLaw() {
    setState(() {
      _resultMessage = '';
      _formulasUsed.clear();
      _calculatedVoltage = null;
      _calculatedCurrent = null;
      _calculatedResistance = null;
      _calculatedPower = null;
      _chartData = [];
    });

    double? rawVoltage = double.tryParse(_voltageController.text);
    double? rawCurrent = double.tryParse(_currentController.text);
    double? rawResistance = double.tryParse(_resistanceController.text);
    double? rawPower = double.tryParse(_powerController.text);

    double? V = _convertToBaseUnit(rawVoltage, _selectedVoltageUnit);
    double? I = _convertToBaseUnit(rawCurrent, _selectedCurrentUnit);
    double? R = _convertToBaseUnit(rawResistance, _selectedResistanceUnit);
    double? P = _convertToBaseUnit(rawPower, _selectedPowerUnit);

    List<double?> values = [V, I, R, P];
    int filledCount = values.where((v) => v != null).length;

    if (filledCount != 2) {
      setState(() {
        _resultMessage =
            'Por favor, ingresa exactamente dos valores para calcular los demás.';
      });
      return;
    }

    try {
      if (V != null && I != null) {
        R = V / I;
        P = V * I;
        _formulasUsed.add('R = V / I');
        _formulasUsed.add('P = V * I');
      } else if (V != null && R != null) {
        I = V / R;
        P = (V * V) / R;
        _formulasUsed.add('I = V / R');
        _formulasUsed.add('P = V² / R');
      } else if (I != null && R != null) {
        V = I * R;
        P = (I * I) * R;
        _formulasUsed.add('V = I * R');
        _formulasUsed.add('P = I² * R');
      } else if (V != null && P != null) {
        I = P / V;
        R = (V * V) / P;
        _formulasUsed.add('I = P / V');
        _formulasUsed.add('R = V² / P');
      } else if (I != null && P != null) {
        V = P / I;
        R = P / (I * I);
        _formulasUsed.add('V = P / I');
        _formulasUsed.add('R = P / I²');
      } else if (R != null && P != null) {
        V = sqrt(P * R);
        I = sqrt(P / R);
        _formulasUsed.add('V = √ (P * R)');
        _formulasUsed.add('I = √ (P / R)');
      }

      if (V!.isNaN ||
          I!.isNaN ||
          R!.isNaN ||
          P!.isNaN ||
          V.isInfinite ||
          I.isInfinite ||
          R.isInfinite ||
          P.isInfinite) {
        throw FormatException(
          'Resultado indefinido o división por cero. Verifica tus entradas.',
        );
      }

      setState(() {
        _calculatedVoltage = _convertFromBaseUnit(V!, _selectedVoltageUnit);
        _calculatedCurrent = _convertFromBaseUnit(I!, _selectedCurrentUnit);
        _calculatedResistance = _convertFromBaseUnit(
          R!,
          _selectedResistanceUnit,
        );
        _calculatedPower = _convertFromBaseUnit(P!, _selectedPowerUnit);

        _chartData = _createChartData(V, I, R, P);
      });
    } on FormatException catch (e) {
      setState(() {
        _resultMessage = 'Error: ${e.message}';
      });
    } catch (e) {
      setState(() {
        _resultMessage = 'Ocurrió un error inesperado. Revisa las entradas.';
      });
    }
  }

  List<BarChartGroupData> _createChartData(
    double v,
    double i,
    double r,
    double p,
  ) {
    return [
      BarChartGroupData(
        x: 0,
        barRods: [BarChartRodData(toY: v, color: Colors.blue)],
      ),
      BarChartGroupData(
        x: 1,
        barRods: [BarChartRodData(toY: i, color: Colors.green)],
      ),
      BarChartGroupData(
        x: 2,
        barRods: [BarChartRodData(toY: r, color: Colors.orange)],
      ),
      BarChartGroupData(
        x: 3,
        barRods: [BarChartRodData(toY: p, color: Colors.purple)],
      ),
    ];
  }

  void _clearAllFields() {
    _voltageController.clear();
    _currentController.clear();
    _resistanceController.clear();
    _powerController.clear();
    setState(() {
      _resultMessage = '';
      _formulasUsed.clear();
      _calculatedVoltage = null;
      _calculatedCurrent = null;
      _calculatedResistance = null;
      _calculatedPower = null;
      _chartData = [];
      _selectedVoltageUnit = 'V';
      _selectedCurrentUnit = 'A';
      _selectedResistanceUnit = 'Ω';
      _selectedPowerUnit = 'W';
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final settings = Provider.of<AppSettings>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ley de Ohm y Potencia'),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        centerTitle: true,
        actions: [
          if (settings.professionalMode)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 8.0,
              ),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.secondaryContainer,
                  foregroundColor: colorScheme.onSecondaryContainer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.star,
                      size: 18,
                      color: colorScheme.onSecondaryContainer,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'PRO',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            InputRowWidget(
              icon: Icons.power_outlined,
              labelText: 'Voltaje',
              controller: _voltageController,
              selectedUnit: _selectedVoltageUnit,
              units: _voltageUnits,
              onUnitChanged: (newValue) {
                setState(() {
                  _selectedVoltageUnit = newValue!;
                });
              },
            ),
            const SizedBox(height: 15),
            InputRowWidget(
              icon: Icons.electric_bolt,
              labelText: 'Corriente',
              controller: _currentController,
              selectedUnit: _selectedCurrentUnit,
              units: _currentUnits,
              onUnitChanged: (newValue) {
                setState(() {
                  _selectedCurrentUnit = newValue!;
                });
              },
            ),
            const SizedBox(height: 15),
            InputRowWidget(
              icon: Icons.clear_all,
              labelText: 'Resistencia',
              controller: _resistanceController,
              selectedUnit: _selectedResistanceUnit,
              units: _resistanceUnits,
              onUnitChanged: (newValue) {
                setState(() {
                  _selectedResistanceUnit = newValue!;
                });
              },
            ),
            const SizedBox(height: 15),
            InputRowWidget(
              icon: Icons.speed,
              labelText: 'Potencia',
              controller: _powerController,
              selectedUnit: _selectedPowerUnit,
              units: _powerUnits,
              onUnitChanged: (newValue) {
                setState(() {
                  _selectedPowerUnit = newValue!;
                });
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _calculateOhmLaw,
              child: const Text('Calcular'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: _clearAllFields,
              child: const Text('Limpiar'),
            ),
            const SizedBox(height: 24),
            if (_resultMessage.isNotEmpty)
              _buildMessageCard(_resultMessage, colorScheme),
            if (_calculatedVoltage != null)
              _buildResultCard(colorScheme, settings.professionalMode),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageCard(String message, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        message,
        style: TextStyle(
          fontSize: 16,
          color: colorScheme.onErrorContainer,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildResultCard(ColorScheme colorScheme, bool isProfessionalMode) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.calculate, color: colorScheme.primary),
                const SizedBox(width: 10),
                Text(
                  'Resultados del Cálculo',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(color: colorScheme.primary),
                ),
              ],
            ),
            const Divider(height: 24),
            Text(
              'Voltaje: ${_calculatedVoltage ?? 'N/A'} $_selectedVoltageUnit',
            ),
            Text(
              'Corriente: ${_calculatedCurrent ?? 'N/A'} $_selectedCurrentUnit',
            ),
            Text(
              'Resistencia: ${_calculatedResistance ?? 'N/A'} $_selectedResistanceUnit',
            ),
            Text('Potencia: ${_calculatedPower ?? 'N/A'} $_selectedPowerUnit'),
            if (isProfessionalMode) ...[
              const SizedBox(height: 24),
              Text(
                'Análisis Gráfico',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 200,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: _chartData.isNotEmpty
                        ? _chartData
                                  .map((e) => e.barRods.first.toY)
                                  .reduce((a, b) => a > b ? a : b) *
                              1.2
                        : 10,
                    barGroups: _chartData,
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: Colors.grey, width: 0.5),
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            const labels = ['V', 'I', 'R', 'P'];
                            return Text(
                              labels[value.toInt()],
                              style: const TextStyle(fontSize: 10),
                            );
                          },
                        ),
                      ),
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ExpansionTile(
                title: const Text(
                  'Fórmulas Utilizadas',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                leading: Icon(Icons.code, color: colorScheme.secondary),
                children: _formulasUsed
                    .map(
                      (formula) => Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4.0,
                          horizontal: 16.0,
                        ),
                        child: Text(
                          formula,
                          style: const TextStyle(fontFamily: 'monospace'),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
