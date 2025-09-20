import 'package:calculadora_electronica/main.dart'; // Asegúrate de que esta ruta sea correcta
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FrequencyConverter extends StatefulWidget {
  const FrequencyConverter({super.key});

  @override
  State<FrequencyConverter> createState() => _FrequencyConverterState();
}

class _FrequencyConverterState extends State<FrequencyConverter> {
  final TextEditingController _frequencyController = TextEditingController();
  final TextEditingController _energyController = TextEditingController();
  final TextEditingController _harmonicController = TextEditingController(
    text: '1',
  );

  String _fromUnit = 'Hz';
  String _toUnit = 'kHz';
  String _medium = 'Vacío';
  double _convertedValue = 0.0;
  double _period = 0.0;
  double _wavelength = 0.0;
  double _energy = 0.0;
  List<double> _harmonics = [];

  // Constantes físicas
  final double _speedOfLight = 299792458.0; // m/s
  final double _planckConstant = 6.62607015e-34; // J·s
  final double _electronVolt = 1.602176634e-19; // J

  // Bases de datos
  final List<String> _units = ['Hz', 'kHz', 'MHz', 'GHz', 'THz', 'PHz'];
  final Map<String, double> _unitFactors = const {
    'Hz': 1,
    'kHz': 1e3,
    'MHz': 1e6,
    'GHz': 1e9,
    'THz': 1e12,
    'PHz': 1e15,
  };

  final Map<String, double> _mediumSpeeds = {
    'Vacío': 299792458.0,
    'Aire': 299702547.0,
    'Agua': 225000000.0,
    'Vidrio': 200000000.0,
    'Cobre': 280000000.0,
  };

  final Map<String, List<String>> _frequencyBands = {
    'ELF': ['3 Hz', '30 Hz'],
    'SLF': ['30 Hz', '300 Hz'],
    'RF': ['3 kHz', '300 GHz'],
    'Microondas': ['1 GHz', '300 GHz'],
    'IR': ['300 GHz', '430 THz'],
    'Visible': ['430 THz', '750 THz'],
    'UV': ['750 THz', '30 PHz'],
    'Rayos X': ['30 PHz', '300 EHz'],
  };

  @override
  void dispose() {
    _frequencyController.dispose();
    _energyController.dispose();
    _harmonicController.dispose();
    super.dispose();
  }

  void _convertFrequency() {
    final inputValue = double.tryParse(_frequencyController.text) ?? 0.0;
    if (inputValue <= 0) return;

    final fromFactor = _unitFactors[_fromUnit]!;
    final toFactor = _unitFactors[_toUnit]!;
    final speed = _medium == 'Vacío' ? _speedOfLight : _mediumSpeeds[_medium]!;

    setState(() {
      // Conversión básica
      _convertedValue = inputValue * fromFactor / toFactor;

      // Cálculos derivados
      _period = 1 / (inputValue * fromFactor);
      _wavelength = speed / (inputValue * fromFactor);
      _energy = _planckConstant * inputValue * fromFactor;

      // Cálculo de armónicos
      _calculateHarmonics(inputValue * fromFactor);
    });
  }

  void _convertEnergy() {
    final inputValue = double.tryParse(_energyController.text) ?? 0.0;
    if (inputValue <= 0) return;

    setState(() {
      final baseFreq = inputValue / _planckConstant;
      _frequencyController.text = (baseFreq / _unitFactors[_fromUnit]!)
          .toString();
      _convertFrequency();
    });
  }

  void _calculateHarmonics(double baseFreq) {
    final harmonicCount = int.tryParse(_harmonicController.text) ?? 1;
    _harmonics = List.generate(harmonicCount, (i) => baseFreq * (i + 1));
  }

  Widget _buildInputSection() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _frequencyController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Frecuencia',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _fromUnit,
                    items: _units
                        .map(
                          (unit) =>
                              DropdownMenuItem(value: unit, child: Text(unit)),
                        )
                        .toList(),
                    onChanged: (value) => setState(() => _fromUnit = value!),
                    decoration: const InputDecoration(
                      labelText: 'De',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _toUnit,
                    items: _units
                        .map(
                          (unit) =>
                              DropdownMenuItem(value: unit, child: Text(unit)),
                        )
                        .toList(),
                    onChanged: (value) => setState(() => _toUnit = value!),
                    decoration: const InputDecoration(
                      labelText: 'A',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    return Card(
      elevation: 4,
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Resultado: ${_convertedValue.toStringAsPrecision(6)} $_toUnit',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Table(
              columnWidths: const {
                0: FixedColumnWidth(120),
                1: FlexColumnWidth(),
              },
              children: [
                _buildTableRow(
                  'Período (T):',
                  '${_period.toStringAsExponential(3)} s',
                ),
                _buildTableRow(
                  'Longitud de onda:',
                  '${_wavelength.toStringAsExponential(3)} m',
                ),
                _buildTableRow(
                  'Energía:',
                  '${(_energy / _electronVolt).toStringAsPrecision(4)} eV',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(value),
        ),
      ],
    );
  }

  Widget _buildProfessionalModeSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Opciones de Modo Profesional',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Icon(
                  Icons.precision_manufacturing,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            _buildAdvancedOptions(),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedOptions() {
    return Column(
      children: [
        TextField(
          controller: _energyController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Energía (eV)',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (_) => _convertEnergy(),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          initialValue: _medium,
          items: _mediumSpeeds.keys
              .map(
                (medium) =>
                    DropdownMenuItem(value: medium, child: Text(medium)),
              )
              .toList(),
          onChanged: (value) {
            setState(() => _medium = value!);
            _convertFrequency();
          },
          decoration: const InputDecoration(
            labelText: 'Medio de propagación',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        _buildHarmonicsCard(),
        const SizedBox(height: 20),
        _buildSpectrumChart(),
        const SizedBox(height: 20),
        _buildBandTable(),
      ],
    );
  }

  Widget _buildHarmonicsCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Armónicos:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Número de armónicos:'),
                const SizedBox(width: 8),
                SizedBox(
                  width: 60,
                  child: TextField(
                    controller: _harmonicController,
                    keyboardType: TextInputType.number,
                    onSubmitted: (_) => _convertFrequency(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _harmonics.asMap().entries.map((entry) {
                final idx = entry.key + 1;
                final freq = entry.value;
                return Chip(
                  label: Text(
                    'Armónico $idx: ${freq.toStringAsExponential(3)} Hz',
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpectrumChart() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Espectro Electromagnético',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (group) => Colors.black87,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final band = _frequencyBands.keys.toList()[groupIndex];
                        return BarTooltipItem(
                          band,
                          const TextStyle(color: Colors.white),
                          children: [
                            TextSpan(
                              text: '\n${_frequencyBands[band]!.join(' - ')}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final bands = _frequencyBands.keys.toList();
                          return Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              bands[value.toInt()],
                              style: const TextStyle(fontSize: 10),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: const AxisTitles(),
                  ),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: _frequencyBands.keys.map((band) {
                    final index = _frequencyBands.keys.toList().indexOf(band);
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: (index + 1) * 2.0,
                          color: _getBandColor(band),
                          width: 16,
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getBandColor(String band) {
    const colors = {
      'ELF': Colors.indigo,
      'SLF': Colors.blue,
      'RF': Colors.green,
      'Microondas': Colors.lightGreen,
      'IR': Colors.red,
      'Visible': Colors.orange,
      'UV': Colors.purple,
      'Rayos X': Colors.deepPurple,
    };
    return colors[band] ?? Colors.grey;
  }

  Widget _buildBandTable() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Bandas de Frecuencia',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 16,
                columns: const [
                  DataColumn(label: Text('Banda')),
                  DataColumn(label: Text('Rango')),
                  DataColumn(label: Text('Aplicaciones')),
                ],
                rows: _frequencyBands.keys.map((band) {
                  return DataRow(
                    cells: [
                      DataCell(Text(band)),
                      DataCell(Text(_frequencyBands[band]!.join(' - '))),
                      DataCell(Text(_getBandApplications(band))),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getBandApplications(String band) {
    const applications = {
      'ELF': 'Comunicación submarina',
      'SLF': 'Comunicación minera',
      'RF': 'Radio, TV, telefonía',
      'Microondas': 'WiFi, radar, satélites',
      'IR': 'Control remoto, visión nocturna',
      'Visible': 'Iluminación, fotografía',
      'UV': 'Esterilización, medicina',
      'Rayos X': 'Radiografía, astronomía',
    };
    return applications[band] ?? 'Varios usos';
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettings>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversor de Frecuencias'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInputSection(),
            const SizedBox(height: 20),
            _buildResultCard(),
            if (settings.professionalMode) ...[
              const SizedBox(height: 20),
              _buildProfessionalModeSection(),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _convertFrequency,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('CALCULAR', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
