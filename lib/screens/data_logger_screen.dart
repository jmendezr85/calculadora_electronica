import 'dart:async';
import 'dart:io' show Directory, File, Platform;
import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

class DataLoggerScreen extends StatefulWidget {
  const DataLoggerScreen({super.key});

  @override
  State<DataLoggerScreen> createState() => _DataLoggerScreenState();
}

class _DataLoggerScreenState extends State<DataLoggerScreen> {
  StreamSubscription<List<ScanResult>>? _scanSubscription;

  List<ScanResult> _scanResults = <ScanResult>[];
  BluetoothDevice? _selectedDevice;
  BluetoothDevice? _connectedDevice;

  bool _isScanning = false;
  bool _isConnecting = false;

  final List<Sample> _samples = <Sample>[];
  Sample? _latestSample;

  @override
  void initState() {
    super.initState();
    _ensurePermissions();
  }

  @override
  void dispose() {
    _scanSubscription?.cancel();
    super.dispose();
  }

  Future<void> _ensurePermissions() async {
    await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      if (Platform.isAndroid) Permission.location,
      if (Platform.isAndroid) Permission.manageExternalStorage,
      Permission.storage,
    ].request();
  }

  Future<void> _startScan() async {
    if (_isScanning) return;
    setState(() {
      _isScanning = true;
      _scanResults = <ScanResult>[];
    });

    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 6));
    _scanSubscription?.cancel();
    _scanSubscription = FlutterBluePlus.onScanResults.listen(
      (results) {
        final Map<String, ScanResult> deduped = <String, ScanResult>{};
        for (final r in results) {
          deduped[r.device.remoteId.str] = r;
        }
        if (!mounted) return;
        setState(() {
          _scanResults = deduped.values.toList()
            ..sort((a, b) => b.rssi.compareTo(a.rssi));
        });
      },
      onError: (Object e, StackTrace st) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al escanear: $e')));
      },
    );

    await Future<void>.delayed(const Duration(seconds: 6));
    if (mounted) {
      setState(() => _isScanning = false);
    }
    await FlutterBluePlus.stopScan();
  }

  Future<void> _connectSelected() async {
    final dev = _selectedDevice;
    if (dev == null) return;
    setState(() => _isConnecting = true);
    try {
      await dev.connect(timeout: const Duration(seconds: 8));
      if (!mounted) return;
      setState(() => _connectedDevice = dev);
    } on Object catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('No se pudo conectar: $e')));
    } finally {
      if (mounted) {
        setState(() => _isConnecting = false);
      }
    }
  }

  Future<void> _disconnect() async {
    final dev = _connectedDevice;
    if (dev == null) return;
    try {
      await dev.disconnect();
    } finally {
      if (mounted) {
        setState(() => _connectedDevice = null);
      }
    }
  }

  String _deviceName(ScanResult r) {
    final adv = r.advertisementData.advName;
    final plat = r.device.platformName;
    if (adv.isNotEmpty) return adv;
    if (plat.isNotEmpty) return plat;
    return r.device.remoteId.str;
  }

  List<FlSpot> _spotsForValue(double Function(Sample s) picker) {
    final List<FlSpot> spots = <FlSpot>[];
    for (int i = 0; i < _samples.length; i++) {
      final s = _samples[i];
      final y = picker(s);
      spots.add(FlSpot(i.toDouble(), y));
    }
    return spots;
  }

  LineChartData _buildChartData(List<FlSpot> spots) {
    final double minX = spots.isEmpty ? 0 : spots.first.x;
    final double maxX = spots.isEmpty ? 1 : spots.last.x;
    double minY = 0, maxY = 1;
    if (spots.isNotEmpty) {
      minY = spots.map((e) => e.y).reduce(math.min);
      maxY = spots.map((e) => e.y).reduce(math.max);
      if (minY == maxY) {
        minY -= 1;
        maxY += 1;
      }
    }
    return LineChartData(
      lineTouchData: const LineTouchData(enabled: false),
      minX: minX,
      maxX: maxX,
      minY: minY,
      maxY: maxY,
      lineBarsData: <LineChartBarData>[
        LineChartBarData(
          spots: spots,
          isCurved: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(show: false),
        ),
      ],
    );
  }

  Future<File> _exportCsv() async {
    final Directory dir = Platform.isAndroid
        ? (await getExternalStorageDirectory())!
        : await getApplicationDocumentsDirectory();
    final String path =
        '${dir.path}${Platform.pathSeparator}data_logger_${DateTime.now().millisecondsSinceEpoch}.csv';
    final File file = File(path);

    final StringBuffer buf = StringBuffer();
    buf.writeln('timestamp,t,rh,lux');
    for (final s in _samples) {
      buf.writeln('${s.ts.toIso8601String()},${s.t},${s.rh},${s.lux}');
    }
    await file.writeAsString(buf.toString(), flush: true);
    return file;
  }

  Future<void> _shareCsv() async {
    try {
      final file = await _exportCsv();
      final name = file.path.split(Platform.pathSeparator).last;
      // ignore: deprecated_member_use
      await Share.shareXFiles(
        [XFile(file.path, mimeType: 'text/csv', name: name)],
        text: 'Registro de datos',
        subject: 'Data Logger',
      );
    } on Object catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('No se pudo compartir: $e')));
    }
  }

  Widget _buildConnectionCard() {
    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Conexión', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _isScanning ? null : _startScan,
                  icon: _isScanning
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.search),
                  label: const Text('Escanear'),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: (_selectedDevice != null && !_isConnecting)
                      ? _connectSelected
                      : null,
                  icon: _isConnecting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.link),
                  label: const Text('Conectar'),
                ),
                const SizedBox(width: 8),
                if (_connectedDevice != null)
                  ElevatedButton.icon(
                    onPressed: _disconnect,
                    icon: const Icon(Icons.link_off),
                    label: const Text('Desconectar'),
                  ),
              ],
            ),
            if (_isConnecting) ...[
              const SizedBox(height: 16),
              const LinearProgressIndicator(),
            ],
            const SizedBox(height: 12),
            SizedBox(
              height: 160,
              child: _scanResults.isEmpty
                  ? const Center(child: Text('Sin resultados.'))
                  : ListView.separated(
                      itemCount: _scanResults.length,
                      separatorBuilder: (context, index) =>
                          const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final r = _scanResults[index];
                        final selected =
                            _selectedDevice?.remoteId == r.device.remoteId;
                        return ListTile(
                          title: Text(_deviceName(r)),
                          subtitle: Text(
                            'RSSI: ${r.rssi} • ${r.device.remoteId.str}',
                          ),
                          trailing: selected
                              ? const Icon(Icons.check_circle)
                              : null,
                          onTap: () {
                            setState(() => _selectedDevice = r.device);
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetrics() {
    final s = _latestSample;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: s == null
            ? const Text('Sin muestras aún.')
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _MetricCard(
                    key: const ValueKey('metric_t'),
                    icon: Icons.thermostat,
                    label: 'Temp (°C)',
                    value: s.t.toStringAsFixed(1),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  _MetricCard(
                    key: const ValueKey('metric_rh'),
                    icon: Icons.water_drop,
                    label: 'Humedad (%)',
                    value: s.rh.toStringAsFixed(1),
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  _MetricCard(
                    key: const ValueKey('metric_lux'),
                    icon: Icons.tungsten,
                    label: 'Lux',
                    value: s.lux.toStringAsFixed(0),
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildChartCard({
    required String title,
    required List<FlSpot> spots,
    Color? color,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            SizedBox(height: 220, child: LineChart(_buildChartData(spots))),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                spots.isEmpty ? '0' : spots.last.y.toStringAsFixed(2),
                style: TextStyle(color: color ?? scheme.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Logger'),
        actions: [
          IconButton(
            onPressed: _samples.isEmpty ? null : _shareCsv,
            icon: const Icon(Icons.share),
            tooltip: 'Exportar/Compartir CSV',
          ),
        ],
      ),
      body: ListView(
        children: [
          _buildConnectionCard(),
          _buildMetrics(),
          _buildChartCard(
            title: 'Temperatura (°C)',
            color: cs.primary,
            spots: _spotsForValue((s) => s.t),
          ),
          _buildChartCard(
            title: 'Humedad (%)',
            color: cs.tertiary,
            spots: _spotsForValue((s) => s.rh),
          ),
          _buildChartCard(
            title: 'Iluminancia (lux)',
            color: cs.secondary,
            spots: _spotsForValue((s) => s.lux),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class Sample {
  final double t;
  final double rh;
  final double lux;
  final DateTime ts;

  Sample({
    required this.t,
    required this.rh,
    required this.lux,
    required this.ts,
  });
}

class _MetricCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? color;

  const _MetricCard({
    required this.icon,
    required this.label,
    required this.value,
    this.color,
    super.key,
  });

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<IconData>('icon', icon))
      ..add(StringProperty('label', label))
      ..add(StringProperty('value', value))
      ..add(ColorProperty('color', color));
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final Color c = color ?? scheme.primary;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: scheme.surfaceContainerHighest,
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(icon, color: c),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: textTheme.labelMedium?.copyWith(color: c.withAlpha(200)),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: scheme.onSurface,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
