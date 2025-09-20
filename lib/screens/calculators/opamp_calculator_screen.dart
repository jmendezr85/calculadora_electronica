import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class OpAmpCalculatorScreen extends StatefulWidget {
  const OpAmpCalculatorScreen({super.key});

  @override
  State<OpAmpCalculatorScreen> createState() => _OpAmpCalculatorScreenState();
}

class _OpAmpCalculatorScreenState extends State<OpAmpCalculatorScreen> {
  final TextEditingController _r1Controller = TextEditingController();
  final TextEditingController _r2Controller = TextEditingController();
  final TextEditingController _vinController = TextEditingController();

  String _selectedConfig = 'inversor';
  double _gain = 1.0;
  double _vout = 0.0;
  List<FlSpot> _transferCurve = [];

  @override
  void dispose() {
    _r1Controller.dispose();
    _r2Controller.dispose();
    _vinController.dispose();
    super.dispose();
  }

  void _calculate() {
    final r1 = double.tryParse(_r1Controller.text) ?? 0;
    final r2 = double.tryParse(_r2Controller.text) ?? 0;
    final vin = double.tryParse(_vinController.text) ?? 0;

    if (r1 <= 0 || r2 <= 0) return;

    setState(() {
      if (_selectedConfig == 'inversor') {
        _gain = -r2 / r1;
        _vout = _gain * vin;
      } else if (_selectedConfig == 'no_inversor') {
        _gain = 1 + (r2 / r1);
        _vout = _gain * vin;
      } else {
        // seguidor
        _gain = 1;
        _vout = vin;
      }
      _generateTransferCurve();
    });
  }

  void _generateTransferCurve() {
    final List<FlSpot> points = [];
    const int pointsCount = 100;
    const double maxVoltage = 15.0; // Asumiendo fuente de ±15V

    for (int i = 0; i <= pointsCount; i++) {
      final double vin = -maxVoltage + (2 * maxVoltage) * i / pointsCount;
      double vout = 0;

      if (_selectedConfig == 'inversor') {
        vout = _gain * vin;
      } else if (_selectedConfig == 'no_inversor') {
        vout = _gain * vin;
      } else {
        vout = vin;
      }

      // Limitación a voltaje de alimentación
      vout = vout.clamp(-maxVoltage, maxVoltage);
      points.add(FlSpot(vin, vout));
    }

    setState(() {
      _transferCurve = points;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Amplificadores Operacionales')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildConfigSelector(),
            const SizedBox(height: 20),
            if (_selectedConfig != 'seguidor') ...[
              _buildInputRow('Resistencia R1 (Ω)', _r1Controller),
              _buildInputRow('Resistencia R2 (Ω)', _r2Controller),
            ],
            _buildInputRow('Voltaje de Entrada (V)', _vinController),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculate,
              child: const Text('Calcular'),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ganancia: ${_gain.toStringAsFixed(2)}'),
                    Text('Voltaje de Salida: ${_vout.toStringAsFixed(2)} V'),
                  ],
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
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            return Text('${value.toStringAsFixed(0)} V');
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            return Text('${value.toStringAsFixed(0)} V');
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: true),
                    minX: -15,
                    maxX: 15,
                    minY: -15,
                    maxY: 15,
                    lineBarsData: [
                      LineChartBarData(
                        spots: _transferCurve,
                        color: Colors.blue,
                        barWidth: 3,
                        dotData: const FlDotData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildConfigDiagram(),
          ],
        ),
      ),
    );
  }

  Widget _buildConfigSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Configuración:', style: Theme.of(context).textTheme.titleMedium),
        DropdownButton<String>(
          value: _selectedConfig,
          items: const [
            DropdownMenuItem(
              value: 'inversor',
              child: Text('Amplificador Inversor'),
            ),
            DropdownMenuItem(
              value: 'no_inversor',
              child: Text('Amplificador No Inversor'),
            ),
            DropdownMenuItem(
              value: 'seguidor',
              child: Text('Seguidor de Voltaje'),
            ),
          ],
          onChanged: (value) {
            setState(() => _selectedConfig = value!);
            _calculate();
          },
        ),
      ],
    );
  }

  Widget _buildInputRow(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        onChanged: (_) => _calculate(),
      ),
    );
  }

  Widget _buildConfigDiagram() {
    String diagramText;
    switch (_selectedConfig) {
      case 'inversor':
        diagramText = 'Diagrama: R2 desde salida a entrada inversora (-)';
        break;
      case 'no_inversor':
        diagramText = 'Diagrama: R2 desde salida a tierra, entrada a (+)';
        break;
      case 'seguidor':
        diagramText = 'Diagrama: Salida conectada directamente a entrada (-)';
        break;
      default:
        diagramText = '';
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(diagramText),
    );
  }
}
