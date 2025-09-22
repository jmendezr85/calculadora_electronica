import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class ServoBleScreen extends StatefulWidget {
  const ServoBleScreen({super.key});

  @override
  State<ServoBleScreen> createState() => _ServoBleScreenState();
}

class _ServoBleScreenState extends State<ServoBleScreen> {
  // UUIDs NUS
  static final Guid nusService = Guid('6e400001-b5a3-f393-e0a9-e50e24dcca9e');
  static final Guid nusRx = Guid(
    '6e400002-b5a3-f393-e0a9-e50e24dcca9e',
  ); // write
  static final Guid nusTx = Guid(
    '6e400003-b5a3-f393-e0a9-e50e24dcca9e',
  ); // notify

  BluetoothDevice? _device;
  BluetoothCharacteristic? _rxChar;
  BluetoothCharacteristic? _txChar;
  StreamSubscription<List<int>>? _txSubscription;

  bool _scanning = false;
  bool _connecting = false;
  bool _discovering = false;

  double _angle = 90;
  String _log = '';

  @override
  void initState() {
    super.initState();
    _ensurePermissions();
  }

  Future<void> _ensurePermissions() async {
    // Android 12+: los permisos de Bluetooth son de runtime
    if (Platform.isAndroid) {
      await [
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
        // Para compatibilidad con escaneo BLE en APIs antiguas
        Permission.locationWhenInUse,
      ].request();
    }
  }

  void _appendLog(String message) {
    _log = _log.isEmpty ? message : '$_log\n$message';
  }

  Future<void> _startScan() async {
    setState(() {
      _scanning = true;
      _appendLog('Escaneando dispositivos BLE...');
    });

    try {
      await FlutterBluePlus.stopScan();
      await FlutterBluePlus.startScan(
        withServices: [nusService],
        timeout: const Duration(seconds: 8),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _scanning = false;
        _appendLog('Error al iniciar el escaneo: $e');
      });
      return;
    }

    Future<void>.delayed(const Duration(seconds: 8)).then((_) {
      if (!mounted) return;
      setState(() => _scanning = false);
    });
  }

  Future<void> _connect(BluetoothDevice device) async {
    await _txSubscription?.cancel();
    _txSubscription = null;

    final deviceName = device.platformName.isNotEmpty
        ? device.platformName
        : device.remoteId.str;

    setState(() {
      _connecting = true;
      _device = device;
      _appendLog('Conectando a $deviceName...');
    });

    await FlutterBluePlus.stopScan();
    if (mounted) {
      setState(() => _scanning = false);
    }

    try {
      await device.connect().timeout(
        const Duration(seconds: 10),
        onTimeout: () async {
          await device.disconnect();
          throw Exception('Tiempo de conexión agotado');
        },
      );
      if (!mounted) return;
      setState(() => _appendLog('Conexión establecida.'));
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _appendLog('Error de conexión: $e');
        if (_device?.remoteId == device.remoteId) {
          _device = null;
        }
      });
      return;
    }

    if (!mounted) return;
    setState(() => _connecting = false);

    if (!mounted || _device == null) return;

    await _discoverNus(device);
  }

  Future<void> _discoverNus(BluetoothDevice device) async {
    setState(() {
      _discovering = true;
      _rxChar = null;
      _txChar = null;
      _appendLog('Descubriendo servicios...');
    });

    String? message;
    var ready = false;

    try {
      final services = await device.discoverServices();
      var serviceFound = false;

      for (final service in services) {
        if (service.uuid == nusService) {
          serviceFound = true;
          for (final characteristic in service.characteristics) {
            if (characteristic.uuid == nusRx) {
              _rxChar = characteristic;
            } else if (characteristic.uuid == nusTx) {
              _txChar = characteristic;
            }
          }
        }
      }

      await _txSubscription?.cancel();
      _txSubscription = null;

      final tx = _txChar;
      if (tx != null) {
        await tx.setNotifyValue(true);
        _txSubscription = tx.onValueReceived.listen((data) {
          final text = utf8.decode(data, allowMalformed: true).trim();
          if (!mounted) return;
          setState(() {
            _appendLog(text.isEmpty ? '<< (mensaje vacío)' : '<< $text');
          });
        });
      }

      ready = _rxChar != null && _txChar != null;
      if (!serviceFound) {
        message = 'Servicio NUS no disponible en el dispositivo.';
      } else if (!ready) {
        message = 'No se encontraron las características NUS esperadas.';
      }
    } catch (e) {
      message = 'Error al descubrir servicios: $e';
    }

    if (!mounted) return;

    setState(() {
      _discovering = false;
      if (ready) {
        _appendLog('Servicio NUS listo.');
      } else if (message != null) {
        _appendLog(message);
      }
    });
  }

  Future<void> _sendAngle(int angle) async {
    final rx = _rxChar;
    if (rx == null) {
      if (!mounted) return;
      setState(() => _appendLog('No hay característica RX disponible.'));
      return;
    }

    final command = 'A:$angle\n';

    try {
      await rx.write(utf8.encode(command), withoutResponse: true);
      if (!mounted) return;
      setState(() => _appendLog('>> A:$angle'));
    } catch (e) {
      if (!mounted) return;
      setState(() => _appendLog('Error al enviar ángulo: $e'));
    }
  }

  Future<void> _setAngle(int angle) async {
    if (!mounted) return;
    setState(() => _angle = angle.toDouble());
    await _sendAngle(angle);
  }

  Future<void> _disconnect() async {
    final device = _device;
    if (device == null) return;

    await FlutterBluePlus.stopScan();
    await _txSubscription?.cancel();
    _txSubscription = null;

    final deviceName = device.platformName.isNotEmpty
        ? device.platformName
        : device.remoteId.str;

    setState(() {
      _connecting = false;
      _discovering = false;
      _appendLog('Desconectando de $deviceName...');
      _device = null;
      _rxChar = null;
      _txChar = null;
    });

    try {
      await device.disconnect();
      if (!mounted) return;
      setState(() => _appendLog('Dispositivo desconectado.'));
    } catch (e) {
      if (!mounted) return;
      setState(() => _appendLog('Error al desconectar: $e'));
    }
  }

  void _clearLog() {
    setState(() => _log = '');
  }

  bool get _isReady =>
      _device != null && _rxChar != null && !_connecting && !_discovering;

  @override
  void dispose() {
    _txSubscription?.cancel();
    _device?.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Control Servo BLE')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildHeader(context),
            const SizedBox(height: 16),
            _buildConnectionCard(context),
            const SizedBox(height: 16),
            _buildServoControlCard(context),
            const SizedBox(height: 16),
            _buildLogCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final onContainer = theme.colorScheme.onPrimaryContainer;

    return Card(
      color: theme.colorScheme.primaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16),
              child: Icon(
                Icons.settings_remote_rounded,
                size: 32,
                color: theme.colorScheme.onPrimary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Control de servo BLE',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: onContainer,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Escanea un dispositivo compatible, conéctate y ajusta el ángulo del servo con precisión directamente desde tu teléfono.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: onContainer.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectionCard(BuildContext context) {
    final theme = Theme.of(context);
    final connectedDevice = _device;
    final deviceName = connectedDevice != null
        ? (connectedDevice.platformName.isNotEmpty
              ? connectedDevice.platformName
              : connectedDevice.remoteId.str)
        : null;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: Color.alphaBlend(
                  theme.colorScheme.primary.withValues(alpha: 0.12),
                  theme.colorScheme.surface,
                ),
                child: Icon(
                  connectedDevice != null
                      ? Icons.bluetooth_connected_rounded
                      : Icons.bluetooth_searching_rounded,
                  color: theme.colorScheme.primary,
                ),
              ),
              title: Text(
                deviceName ?? 'Ningún dispositivo conectado',
                style: theme.textTheme.titleMedium,
              ),
              subtitle: Text(
                connectedDevice != null
                    ? 'ID: ${connectedDevice.remoteId.str}'
                    : 'Inicia un escaneo para encontrar módulos BLE compatibles.',
              ),
              trailing: connectedDevice != null
                  ? OutlinedButton.icon(
                      onPressed: _disconnect,
                      icon: const Icon(Icons.link_off_rounded, size: 18),
                      label: const Text('Desconectar'),
                    )
                  : null,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                ElevatedButton.icon(
                  onPressed: _scanning ? null : _startScan,
                  icon: const Icon(Icons.radar_rounded),
                  label: Text(_scanning ? 'Escaneando...' : 'Escanear'),
                ),
                if (connectedDevice != null)
                  OutlinedButton.icon(
                    onPressed: _discovering
                        ? null
                        : () => _discoverNus(connectedDevice),
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Redescubrir servicios'),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(
                  avatar: Icon(
                    connectedDevice != null
                        ? Icons.check_circle_rounded
                        : Icons.info_outline_rounded,
                    size: 18,
                    color: theme.colorScheme.primary,
                  ),
                  label: Text(
                    connectedDevice != null ? 'Conectado' : 'Sin conexión',
                  ),
                  backgroundColor: Color.alphaBlend(
                    theme.colorScheme.primary.withValues(alpha: 0.08),
                    theme.colorScheme.surface,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                if (_rxChar != null)
                  Chip(
                    avatar: Icon(
                      Icons.memory_rounded,
                      size: 18,
                      color: theme.colorScheme.secondary,
                    ),
                    label: const Text('Servicio NUS listo'),
                    backgroundColor: Color.alphaBlend(
                      theme.colorScheme.secondary.withValues(alpha: 0.1),
                      theme.colorScheme.surface,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
              ],
            ),
            if (_scanning || _connecting || _discovering) ...[
              const SizedBox(height: 16),
              const LinearProgressIndicator(),
              const SizedBox(height: 8),
              Text(
                _scanning
                    ? 'Buscando dispositivos cercanos...'
                    : _connecting
                    ? 'Estableciendo conexión...'
                    : 'Descubriendo servicios...',
              ),
            ],
            if (connectedDevice == null) ...[
              const SizedBox(height: 16),
              StreamBuilder<List<ScanResult>>(
                stream: FlutterBluePlus.scanResults,
                builder: (context, snapshot) {
                  final results = snapshot.data ?? [];
                  final seen = <String>{};
                  final devices = <BluetoothDevice>[];

                  for (final result in results) {
                    final id = result.device.remoteId.str;
                    if (seen.add(id)) {
                      devices.add(result.device);
                    }
                  }

                  if (devices.isEmpty) {
                    return Text(
                      _scanning
                          ? 'Esperando resultados del escaneo...'
                          : 'No se detectaron dispositivos recientes.',
                    );
                  }

                  return DropdownButtonFormField<BluetoothDevice>(
                    decoration: const InputDecoration(
                      labelText: 'Dispositivos disponibles',
                      border: OutlineInputBorder(),
                    ),
                    isExpanded: true,
                    items: devices
                        .map(
                          (device) => DropdownMenuItem(
                            value: device,
                            child: Text(
                              device.platformName.isNotEmpty
                                  ? device.platformName
                                  : device.remoteId.str,
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (device) {
                      if (device != null) {
                        _connect(device);
                      }
                    },
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildServoControlCard(BuildContext context) {
    final theme = Theme.of(context);
    final ready = _isReady;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Ángulo del servo',
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Color.alphaBlend(
                      theme.colorScheme.primary.withValues(alpha: 0.1),
                      theme.colorScheme.surface,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_angle.round()}°',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              ready
                  ? 'Arrastra el control para posicionar el servo con precisión.'
                  : 'Conéctate a un dispositivo compatible para habilitar el control.',
            ),
            const SizedBox(height: 16),
            Slider(
              value: _angle,
              max: 180,
              divisions: 180,
              label: '${_angle.round()}°',
              onChanged: ready
                  ? (value) => setState(() => _angle = value)
                  : null,
              onChangeEnd: ready ? (value) => _sendAngle(value.round()) : null,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton(
                  onPressed: ready ? () => _setAngle(0) : null,
                  child: const Text('0°'),
                ),
                OutlinedButton(
                  onPressed: ready ? () => _setAngle(90) : null,
                  child: const Text('90°'),
                ),
                OutlinedButton(
                  onPressed: ready ? () => _setAngle(180) : null,
                  child: const Text('180°'),
                ),
                if (ready)
                  OutlinedButton.icon(
                    onPressed: () => _setAngle(_angle.round()),
                    icon: const Icon(Icons.send_rounded, size: 18),
                    label: const Text('Enviar de nuevo'),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Consejo: utiliza los accesos rápidos para mover el servo a posiciones clave y después afina con el deslizador.',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogCard(BuildContext context) {
    final theme = Theme.of(context);
    final logs = _log.isEmpty ? 'Aún no hay mensajes.' : _log;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Registro de eventos',
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                if (_log.isNotEmpty)
                  TextButton.icon(
                    onPressed: _clearLog,
                    icon: const Icon(Icons.delete_sweep_rounded),
                    label: const Text('Limpiar'),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              constraints: const BoxConstraints(minHeight: 160, maxHeight: 240),
              decoration: BoxDecoration(
                color: Color.alphaBlend(
                  theme.colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.4,
                  ),
                  theme.colorScheme.surface,
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.dividerColor),
              ),
              padding: const EdgeInsets.all(12),
              child: Scrollbar(
                child: SingleChildScrollView(
                  child: SelectableText(
                    logs,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontFamily: 'monospace',
                      height: 1.4,
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
}
