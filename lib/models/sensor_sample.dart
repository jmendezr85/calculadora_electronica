import 'package:intl/intl.dart';

class SensorSample {
  SensorSample({required this.ts, this.t, this.rh, this.lux});

  final DateTime ts;
  final double? t;
  final double? rh;
  final double? lux;

  static const String csvHeader = 'timestamp,t_C,rh_pct,lux';
  static final NumberFormat _formatter = NumberFormat('0.000');

  factory SensorSample.fromMap(Map<dynamic, dynamic> map) {
    double? parse(dynamic value) {
      if (value == null) {
        return null;
      }
      if (value is num) {
        return value.toDouble();
      }
      if (value is String) {
        return double.tryParse(value);
      }
      return null;
    }

    return SensorSample(
      ts: DateTime.now(),
      t: parse(map['t']),
      rh: parse(map['rh']),
      lux: parse(map['lux']),
    );
  }

  String toCsv() {
    return '${ts.toIso8601String()},${_format(t)},${_format(rh)},${_format(lux)}';
  }

  static String buildCsv(Iterable<SensorSample> samples) {
    final buffer = StringBuffer(csvHeader);
    for (final sample in samples) {
      buffer
        ..write('\n')
        ..write(sample.toCsv());
    }
    return buffer.toString();
  }

  static String _format(double? value) {
    if (value == null) {
      return '';
    }
    return _formatter.format(value);
  }
}
