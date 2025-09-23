import 'dart:async';
import 'dart:convert';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class NusClient {
  NusClient();

  static final Guid nusService = Guid('6e400001-b5a3-f393-e0a9-e50e24dcca9e');
  static final Guid nusRx = Guid('6e400002-b5a3-f393-e0a9-e50e24dcca9e');
  static final Guid nusTx = Guid('6e400003-b5a3-f393-e0a9-e50e24dcca9e');

  final StreamController<String> _linesController =
      StreamController<String>.broadcast();

  final StringBuffer _buffer = StringBuffer();

  BluetoothDevice? _device;
  BluetoothCharacteristic? _rxCharacteristic;
  BluetoothCharacteristic? _txCharacteristic;
  StreamSubscription<List<int>>? _txSubscription;

  Stream<String> lines() => _linesController.stream;

  BluetoothDevice? get device => _device;

  bool get isReady => _rxCharacteristic != null && _txCharacteristic != null;

  Future<void> connect(BluetoothDevice device) async {
    await disconnect();

    _device = device;

    try {
      await device.connect(timeout: const Duration(seconds: 10));

      final services = await device.discoverServices();

      BluetoothCharacteristic? rx;
      BluetoothCharacteristic? tx;

      for (final service in services) {
        if (service.uuid != nusService) continue;
        for (final characteristic in service.characteristics) {
          if (characteristic.uuid == nusRx) {
            rx = characteristic;
          } else if (characteristic.uuid == nusTx) {
            tx = characteristic;
          }
        }
      }

      if (rx == null || tx == null) {
        throw Exception('Servicio NUS incompleto en el dispositivo.');
      }

      _rxCharacteristic = rx;
      _txCharacteristic = tx;

      await tx.setNotifyValue(true);

      await _txSubscription?.cancel();
      _txSubscription = tx.onValueReceived.listen(_handleIncomingData);
    } catch (e) {
      await disconnect();
      rethrow;
    }
  }

  Future<void> writeString(String text) async {
    final rx = _rxCharacteristic;
    if (rx == null) {
      throw Exception('No existe característica RX para enviar datos.');
    }
    final data = utf8.encode(text);
    await rx.write(data, withoutResponse: true);
  }

  Future<void> disconnect() async {
    await _txSubscription?.cancel();
    _txSubscription = null;

    final tx = _txCharacteristic;
    if (tx != null) {
      try {
        await tx.setNotifyValue(false);
      } catch (_) {
        // Ignoramos errores al deshabilitar notificaciones.
      }
    }

    _rxCharacteristic = null;
    _txCharacteristic = null;
    _buffer.clear();

    final device = _device;
    _device = null;

    if (device != null) {
      try {
        await device.disconnect();
      } catch (_) {
        // Ignoramos errores de desconexión.
      }
    }
  }

  void dispose() {
    _linesController.close();
  }

  void _handleIncomingData(List<int> payload) {
    final chunk = utf8.decode(payload, allowMalformed: true);
    if (chunk.isEmpty) {
      return;
    }

    _buffer.write(chunk);
    final text = _buffer.toString();

    final parts = text.split('\n');
    for (var i = 0; i < parts.length - 1; i++) {
      final line = parts[i].replaceAll('\r', '').trim();
      if (line.isNotEmpty) {
        _linesController.add(line);
      }
    }

    final last = parts.last;
    _buffer
      ..clear()
      ..write(last);

    if (text.endsWith('\n')) {
      final line = last.replaceAll('\r', '').trim();
      if (line.isNotEmpty) {
        _linesController.add(line);
      }
      _buffer.clear();
    }
  }
}
