// lib/screens/servo_ble_screen.dart
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
    // Android 12+: permisos de BT son de runtime
    if (Platform.isAndroid) {
      await [
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
        // Para compatibilidad en APIs viejas con escaneo BLE
        Permission.locationWhenInUse,
      ].request();
    }
  }

  Future<void> _startScan() async {
    setState(() => _log = 'Escaneando dispositivos BLE...\n');

    // IMPORTANTE: en flutter_blue_plus, start/stop/scanResults son ESTÁTICOS
    await FlutterBluePlus.stopScan();
    await FlutterBluePlus.startScan(
      withServices: [nusService],
      timeout: const Duration(seconds: 8), // detiene el scan automáticamente
    );

    // No es necesario un Future.delayed ni stopScan manual aquí:
    // el timeout de startScan ya corta el escaneo.
  }

  Future<void> _connect(BluetoothDevice device) async {
    setState(() {
      _connecting = true;
      _log += 'Conectando a ${device.platformName}...\n';
    });

    _device = device;

    // connect() ya devuelve Future<void>; no uses autoConnect si el valor por defecto te sirve
    await device.connect().timeout(
      const Duration(seconds: 10),
      onTimeout: () async {
        await device.disconnect();
        throw Exception('Tiempo de conexión agotado');
      },
    );

    setState(() {
      _log += 'Conectado.\n';
      _connecting = false;
    });

    await _discoverNus(device);
  }

  Future<void> _discoverNus(BluetoothDevice device) async {
    setState(() {
      _discovering = true;
      _log += 'Descubriendo servicios...\n';
    });

    final services = await device.discoverServices();
    for (final s in services) {
      if (s.uuid == nusService) {
        for (final c in s.characteristics) {
          if (c.uuid == nusRx) _rxChar = c;
          if (c.uuid == nusTx) _txChar = c;
        }
      }
    }

    if (_txChar != null) {
      // Habilitar notificaciones del periférico (TX)
      await _txChar!.setNotifyValue(true);
      _txChar!.onValueReceived.listen((data) {
        final text = utf8.decode(data, allowMalformed: true);
        setState(() => _log += '<< $text');
      });
    }

    setState(() {
      _discovering = false;
      _log += 'Servicio NUS listo.\n';
    });
  }

  Future<void> _sendAngle(int angle) async {
    if (_rxChar == null) {
      setState(() => _log += 'No hay característica RX disponible.\n');
      return;
    }
    final cmd = 'A:$angle\n'; // Protocolo simple
    await _rxChar!.write(utf8.encode(cmd), withoutResponse: true);
    setState(() => _log += '>> $cmd');
  }

  @override
  void dispose() {
    _device?.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Servos (BLE)')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                ElevatedButton(
                  onPressed: _startScan,
                  child: const Text('Escanear'),
                ),
                const SizedBox(width: 8),
                if (_device == null)
                  StreamBuilder<List<ScanResult>>(
                    // scanResults es ESTÁTICO
                    stream: FlutterBluePlus.scanResults,
                    builder: (context, snap) {
                      final results = snap.data ?? [];
                      return DropdownButton<BluetoothDevice>(
                        hint: const Text('Selecciona dispositivo'),
                        items: results
                            .map(
                              (r) => DropdownMenuItem(
                                value: r.device,
                                child: Text(
                                  r.advertisementData.advName.isNotEmpty
                                      ? r.advertisementData.advName
                                      : r.device.remoteId.str,
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (dev) {
                          if (dev != null) _connect(dev);
                        },
                      );
                    },
                  )
                else
                  Text('Conectado a: ${_device!.platformName}'),
              ],
            ),
            const SizedBox(height: 16),
            if (_connecting || _discovering) const LinearProgressIndicator(),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('Ángulo'),
                Expanded(
                  child: Slider(
                    value: _angle,
                    // min: 0,  // ← quítalo (el default ya es 0.0)
                    max: 180,
                    divisions: 180,
                    label: _angle.round().toString(),
                    onChanged: (v) async {
                      setState(() => _angle = v);
                      await _sendAngle(v.round());
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(child: Text(_log)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
