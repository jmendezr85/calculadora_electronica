import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class VoltageDropCalculator extends StatefulWidget {
  const VoltageDropCalculator({super.key});

  @override
  State<VoltageDropCalculator> createState() => _VoltageDropCalculatorState();
}

class _VoltageDropCalculatorState extends State<VoltageDropCalculator> {
  final TextEditingController _currentController = TextEditingController();
  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _voltageController = TextEditingController(
    text: '120',
  );
  final TextEditingController _tempController = TextEditingController(
    text: '20',
  );

  String _selectedMaterial = 'Cobre';
  String _selectedAWG = '14';
  String _selectedCableType = 'THHN';
  double _voltageDrop = 0.0;
  double _percentageDrop = 0.0;
  double _powerLoss = 0.0;
  double _cost = 0.0;
  List<FlSpot> _voltageDropPoints = [];
  bool _showChart = false;
  bool _showAdvanced = false;

  final Map<String, Map<String, dynamic>> _materialDB = {
    'Cobre': {
      'resistivity20': 1.68e-8,
      'tempCoeff': 0.0039,
      'density': 8.96,
      'maxTemp': 150,
      'price': 8.96,
    },
    'Aluminio': {
      'resistivity20': 2.65e-8,
      'tempCoeff': 0.0043,
      'density': 2.70,
      'maxTemp': 90,
      'price': 2.70,
    },
    'Cable THHN': {
      'resistivity20': 1.72e-8,
      'tempCoeff': 0.0039,
      'density': 8.89,
      'maxTemp': 90,
      'price': 3.50,
    },
  };

  final Map<String, Map<String, dynamic>> _cableDB = {
    '10': {'area': 5.26, 'current': 30, 'pricePerMeter': 0.85, 'strands': 7},
    '12': {'area': 3.31, 'current': 20, 'pricePerMeter': 0.60, 'strands': 7},
    '14': {'area': 2.08, 'current': 15, 'pricePerMeter': 0.40, 'strands': 7},
    '16': {'area': 1.31, 'current': 10, 'pricePerMeter': 0.30, 'strands': 7},
    '18': {'area': 0.82, 'current': 7, 'pricePerMeter': 0.25, 'strands': 7},
  };

  final List<String> _cableTypes = ['THHN', 'THWN', 'XHHW', 'UF'];

  @override
  void dispose() {
    _currentController.dispose();
    _lengthController.dispose();
    _voltageController.dispose();
    _tempController.dispose();
    super.dispose();
  }

  void _calculate() {
    final current = double.tryParse(_currentController.text) ?? 0.0;
    final length = double.tryParse(_lengthController.text) ?? 0.0;
    final voltage = double.tryParse(_voltageController.text) ?? 120.0;
    final temp = double.tryParse(_tempController.text) ?? 20.0;

    if (current <= 0 || length <= 0 || voltage <= 0) {
      setState(() => _resetValues());
      return;
    }

    final material = _materialDB[_selectedMaterial] ?? _materialDB['Cobre']!;
    final cable = _cableDB[_selectedAWG] ?? _cableDB['14']!;

    final resistivity = _calculateResistivity(material, temp);
    final resistance = _calculateResistance(
      resistivity,
      length,
      cable['area'] as double,
    );

    setState(() {
      _voltageDrop = current * resistance;
      _percentageDrop = (_voltageDrop / voltage) * 100;
      _powerLoss = current * current * resistance;
      _cost = length * (cable['pricePerMeter'] as double);
      _generateChartData(length, voltage, material, cable);
    });

    _showWarnings(current, cable['current'] as double);
  }

  double _calculateResistivity(Map<String, dynamic> material, double temp) {
    final rho20 = material['resistivity20'] as double;
    final alpha = material['tempCoeff'] as double;
    return rho20 * (1 + alpha * (temp - 20));
  }

  double _calculateResistance(double resistivity, double length, double area) {
    return (resistivity * length * 2) / (area * 1e-6);
  }

  void _generateChartData(
    double maxLength,
    double voltage,
    Map<String, dynamic> material,
    Map<String, dynamic> cable,
  ) {
    _voltageDropPoints = [];
    final resistivity = _calculateResistivity(
      material,
      double.tryParse(_tempController.text) ?? 20.0,
    );
    final current = double.tryParse(_currentController.text) ?? 0.0;

    for (double l = 0; l <= maxLength; l += maxLength / 10) {
      final r = _calculateResistance(resistivity, l, cable['area'] as double);
      final vDrop = current * r;
      _voltageDropPoints.add(FlSpot(l, vDrop));
    }
  }

  void _showWarnings(double current, double maxCurrent) {
    if (current > maxCurrent) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '¡Peligro! El cable AWG $_selectedAWG soporta máximo $maxCurrent A',
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }

    if (_percentageDrop > 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '¡Advertencia! Caída de voltaje alta (${_percentageDrop.toStringAsFixed(2)}%)',
          ),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _resetValues() {
    _voltageDrop = 0.0;
    _percentageDrop = 0.0;
    _powerLoss = 0.0;
    _cost = 0.0;
    _voltageDropPoints = [];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora de Caída de Voltaje'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => setState(() => _showAdvanced = !_showAdvanced),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInputCard(theme),
            const SizedBox(height: 20),
            _buildMaterialCard(),
            const SizedBox(height: 20),
            _buildResultsCard(colors),
            if (_showAdvanced) _buildAdvancedCard(theme),
            if (_showChart && _voltageDropPoints.isNotEmpty)
              _buildChartCard(theme),
            const SizedBox(height: 20),
            _buildActionButtons(colors),
          ],
        ),
      ),
    );
  }

  Widget _buildInputCard(ThemeData theme) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _currentController,
              keyboardType: TextInputType.number,
              decoration: _inputDecoration('Corriente (A)', 'A'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _lengthController,
              keyboardType: TextInputType.number,
              decoration: _inputDecoration('Longitud del cable (m)', 'metros'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _voltageController,
              keyboardType: TextInputType.number,
              decoration: _inputDecoration('Tensión de alimentación (V)', 'V'),
            ),
            if (_showAdvanced) ...[
              const SizedBox(height: 12),
              TextField(
                controller: _tempController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration('Temperatura ambiente (°C)', '°C'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, String? suffix) {
    return InputDecoration(
      labelText: label,
      suffixText: suffix,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  Widget _buildMaterialCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              initialValue: _selectedMaterial,
              items: _materialDB.keys
                  .map(
                    (material) => DropdownMenuItem(
                      value: material,
                      child: Text(material),
                    ),
                  )
                  .toList(),
              onChanged: (value) => setState(() => _selectedMaterial = value!),
              decoration: _inputDecoration('Material del conductor', null),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _selectedAWG,
                    items: _cableDB.keys
                        .map(
                          (awg) => DropdownMenuItem(
                            value: awg,
                            child: Text(
                              'AWG $awg (${_cableDB[awg]?['current']}A)',
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) => setState(() => _selectedAWG = value!),
                    decoration: _inputDecoration('Calibre del cable', null),
                  ),
                ),
                if (_showAdvanced) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _selectedCableType,
                      items: _cableTypes
                          .map(
                            (type) => DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            ),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setState(() => _selectedCableType = value!),
                      decoration: _inputDecoration('Tipo de cable', null),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsCard(ColorScheme colors) {
    return Card(
      elevation: 4,
      color: colors.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resultados Principales:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildResultRow(
              'Caída de voltaje:',
              '${_voltageDrop.toStringAsFixed(2)} V',
            ),
            _buildResultRow(
              'Porcentaje de caída:',
              '${_percentageDrop.toStringAsFixed(2)} %',
            ),
            _buildResultRow(
              'Pérdida de potencia:',
              '${_powerLoss.toStringAsFixed(2)} W',
            ),
            if (_showAdvanced)
              _buildResultRow(
                'Costo estimado:',
                '\$${_cost.toStringAsFixed(2)}',
              ),
            if (_percentageDrop > 5) ...[
              const SizedBox(height: 8),
              Text(
                '¡Advertencia! Caída de voltaje > 5%',
                style: TextStyle(
                  color: colors.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedCard(ThemeData theme) {
    final material = _materialDB[_selectedMaterial] ?? _materialDB['Cobre']!;
    final cable = _cableDB[_selectedAWG] ?? _cableDB['14']!;

    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Información Técnica:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildInfoRow('Material:', _selectedMaterial),
            _buildInfoRow(
              'Resistividad (20°C):',
              '${((material['resistivity20'] as double) * 1e8).toStringAsFixed(2)} Ω·cm',
            ),
            _buildInfoRow('Coef. temperatura:', '${material['tempCoeff']} /°C'),
            const Divider(),
            _buildInfoRow('Calibre:', 'AWG $_selectedAWG'),
            _buildInfoRow('Área transversal:', '${cable['area']} mm²'),
            _buildInfoRow('Hilos:', '${cable['strands']}'),
            _buildInfoRow('Precio/m:', '\$${cable['pricePerMeter']}'),
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard(ThemeData theme) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Gráfico de Caída de Voltaje',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 250,
              child: LineChart(
                LineChartData(
                  minX: 0,
                  maxX: _voltageDropPoints.last.x,
                  minY: 0,
                  maxY: _voltageDropPoints.last.y * 1.1,
                  lineBarsData: [
                    LineChartBarData(
                      spots: _voltageDropPoints,
                      isCurved: true,
                      color: theme.colorScheme.primary,
                      barWidth: 4,
                      belowBarData: BarAreaData(
                        show: true,
                        color: theme.colorScheme.primary.withAlpha(50),
                      ),
                    ),
                  ],
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, _) =>
                            Text('${value.toStringAsFixed(0)} m'),
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, _) =>
                            Text('${value.toStringAsFixed(1)} V'),
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(ColorScheme colors) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: _calculate,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: colors.primary,
              foregroundColor: colors.onPrimary,
            ),
            child: const Text('CALCULAR', style: TextStyle(fontSize: 18)),
          ),
        ),
        const SizedBox(width: 12),
        IconButton(
          icon: Icon(_showChart ? Icons.visibility_off : Icons.visibility),
          onPressed: () => setState(() => _showChart = !_showChart),
          style: IconButton.styleFrom(
            backgroundColor: colors.secondaryContainer,
            padding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value, style: const TextStyle(fontFamily: 'RobotoMono')),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
