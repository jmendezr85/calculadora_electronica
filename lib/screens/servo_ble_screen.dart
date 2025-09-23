import 'dart:async';
import 'dart:io' show Platform;

import 'package:calculadora_electronica/ble/nus_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class ServoBleScreen extends StatefulWidget {
  const ServoBleScreen({super.key});

  @override
  State<ServoBleScreen> createState() => _ServoBleScreenState();
}

class _ServoBleScreenState extends State<ServoBleScreen> {
  final NusClient _client = NusClient();
  StreamSubscription<List<ScanResult>>? _scanSubscription;
  StreamSubscription<String>? _lineSubscription;

  List<ScanResult> _scanResults = <ScanResult>[];
  BluetoothDevice? _selectedDevice;
  BluetoothDevice? _connectedDevice;

  bool _isScanning = false;
  bool _isConnecting = false;

  double _angle = 90;
  final List<String> _logs = <String>[];

  @override
  void initState() {
    super.initState();
    _ensurePermissions();
    _scanSubscription = FlutterBluePlus.scanResults.listen(_handleScanResults);
    _lineSubscription = _client.lines().listen(_handleIncomingLine);
  }

  @override
  void dispose() {
    _lineSubscription?.cancel();
    _scanSubscription?.cancel();
    unawaited(_client.disconnect());
    _client.dispose();
    super.dispose();
  }

  Future<void> _ensurePermissions() async {
    if (Platform.isAndroid) {
      await [
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
        Permission.locationWhenInUse,
      ].request();
    }
  }

  void _handleScanResults(List<ScanResult> results) {
    final Map<String, ScanResult> deduped = <String, ScanResult>{};
    for (final ScanResult result in results) {
      deduped[result.device.remoteId.str] = result;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _scanResults = deduped.values.toList()
        ..sort(
          (ScanResult a, ScanResult b) =>
              _deviceName(a.device).compareTo(_deviceName(b.device)),
        );
      if (_selectedDevice != null &&
          !_scanResults.any(
            (ScanResult r) => r.device.remoteId == _selectedDevice!.remoteId,
          )) {
        _selectedDevice = null;
      }
    });
  }

  void _handleIncomingLine(String line) {
    if (!mounted) {
      return;
    }
    setState(() {
      _appendLog('<< $line');
    });
  }

  Future<void> _startScan() async {
    await _ensurePermissions();
    await FlutterBluePlus.stopScan();

    if (!mounted) {
      return;
    }

    setState(() {
      _isScanning = true;
      _scanResults = <ScanResult>[];
      _appendLog('Escaneo iniciado.');
    });

    try {
      await FlutterBluePlus.startScan(
        withServices: <Guid>[NusClient.nusService],
        timeout: const Duration(seconds: 6),
      );
    } catch (error) {
      // Corregido: quitado 'Object'
      if (!mounted) {
        return;
      }
      setState(() {
        _appendLog('Error de escaneo: $error');
      });
    } finally {
      if (mounted) {
        // Corregido: quitado el return del finally
        setState(() {
          _isScanning = false;
        });
      }
    }
  }

  Future<void> _connect(BluetoothDevice device) async {
    await FlutterBluePlus.stopScan();

    if (!mounted) {
      return;
    }

    setState(() {
      _isScanning = false;
      _isConnecting = true;
      _selectedDevice = device;
      _appendLog('Conectando a ${_deviceName(device)}...');
    });

    try {
      await _client.connect(device);
      if (!mounted) {
        return;
      }
      setState(() {
        _connectedDevice = device;
        _appendLog('Conexión establecida.');
      });
    } catch (error) {
      // Corregido: quitado 'Object'
      if (!mounted) {
        return;
      }
      setState(() {
        _connectedDevice = null;
        _appendLog('Error al conectar: $error');
      });
    } finally {
      if (mounted) {
        // Corregido: quitado el return del finally
        setState(() {
          _isConnecting = false;
        });
      }
    }
  }

  Future<void> _disconnect() async {
    setState(() {
      _isConnecting = true;
      _appendLog('Desconectando...');
    });
    await _client.disconnect();
    if (!mounted) {
      return;
    }
    setState(() {
      _isConnecting = false;
      _connectedDevice = null;
      _appendLog('Dispositivo desconectado.');
    });
  }

  Future<void> _setAngle(double value) async {
    final int angle = value.round().clamp(0, 180);
    if (!mounted) {
      return;
    }
    setState(() {
      _angle = angle.toDouble();
    });
    if (!_client.isReady) {
      setState(() {
        _appendLog('Servicio NUS no disponible.');
      });
      return;
    }
    try {
      await _client.writeString('A:$angle\n');
      if (!mounted) {
        return;
      }
      setState(() {
        _appendLog('>> A:$angle');
      });
    } catch (error) {
      // Corregido: quitado 'Object'
      if (!mounted) {
        return;
      }
      setState(() {
        _appendLog('Error al enviar ángulo: $error');
      });
    }
  }

  void _appendLog(String message) {
    _logs.add(message);
    const int maxEntries = 120;
    if (_logs.length > maxEntries) {
      _logs.removeRange(0, _logs.length - maxEntries);
    }
  }

  String _deviceName(BluetoothDevice device) {
    return device.platformName.isNotEmpty
        ? device.platformName
        : device.remoteId.str;
  }

  @override
  Widget build(BuildContext context) {
    final bool isReady = _connectedDevice != null && _client.isReady;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Servos (BLE)')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildConnectionCard(isReady),
            const SizedBox(height: 16),
            _buildServoCard(isReady),
            const SizedBox(height: 16),
            _buildLogCard(colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectionCard(bool isReady) {
    final String status = isReady
        ? 'Conectado a ${_deviceName(_connectedDevice!)}'
        : 'Sin conexión activa';

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dispositivo', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(status),
            const SizedBox(height: 16),
            DropdownButton<BluetoothDevice>(
              value: _selectedDevice,
              isExpanded: true,
              hint: const Text('Selecciona un dispositivo'),
              items: _scanResults
                  .map(
                    (ScanResult result) => DropdownMenuItem<BluetoothDevice>(
                      value: result.device,
                      child: Text(_deviceName(result.device)),
                    ),
                  )
                  .toList(),
              onChanged: _isConnecting
                  ? null
                  : (BluetoothDevice? device) {
                      if (device != null) {
                        _connect(device);
                      }
                    },
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                ElevatedButton.icon(
                  onPressed: _isScanning ? null : _startScan,
                  icon: const Icon(Icons.search),
                  label: Text(_isScanning ? 'Escaneando…' : 'Escanear'),
                ),
                if (isReady)
                  OutlinedButton.icon(
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
          ],
        ),
      ),
    );
  }

  Widget _buildServoCard(bool isReady) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ángulo del servo',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text('${_angle.round()}°'),
              ],
            ),
            const SizedBox(height: 16),
            Slider(
              value: _angle,
              max: 180,
              divisions: 180,
              label: '${_angle.round()}°',
              onChanged: isReady && !_isConnecting ? _setAngle : null,
            ),
            if (!isReady)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Conéctate a un dispositivo NUS para habilitar el control.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogCard(ColorScheme colorScheme) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Actividad',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _logs.clear();
                    });
                  },
                  icon: const Icon(Icons.delete_outline),
                  tooltip: 'Limpiar historial',
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              constraints: const BoxConstraints(minHeight: 120, maxHeight: 200),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: colorScheme
                    .surfaceContainerHighest, // Corregido: surfaceVariant -> surfaceContainerHighest
              ),
              child: SingleChildScrollView(
                child: Text(
                  _logs.isEmpty
                      ? 'Sin actividad registrada.'
                      : _logs.join('\n'),
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(fontFamily: 'monospace'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
