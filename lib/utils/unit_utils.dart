// lib/utils/unit_utils.dart

/// Representa un prefijo de unidad electrónica (mili, micro, kilo, etc.)
class UnitPrefix {
  final String name;
  final String symbol;
  final double multiplier;

  const UnitPrefix(this.name, this.symbol, this.multiplier);

  // Prefijos comunes utilizados en electrónica
  static const List<UnitPrefix> all = [
    UnitPrefix('Pico', 'p', 1e-12),
    UnitPrefix('Nano', 'n', 1e-9),
    UnitPrefix('Micro', 'µ', 1e-6),
    UnitPrefix('Mili', 'm', 1e-3),
    UnitPrefix('Ninguno', '', 1.0), // Unidad base (ej. Ohmios, Faradios)
    UnitPrefix('Kilo', 'k', 1e3),
    UnitPrefix('Mega', 'M', 1e6),
    UnitPrefix('Giga', 'G', 1e9),
    UnitPrefix('Tera', 'T', 1e12),
  ];

  // Prefijos comunes para resistencia
  static const List<UnitPrefix> resistancePrefixes = [
    UnitPrefix('Mili', 'm', 1e-3),
    UnitPrefix('Ninguno', '', 1.0),
    UnitPrefix('Kilo', 'k', 1e3),
    UnitPrefix('Mega', 'M', 1e6),
    UnitPrefix('Giga', 'G', 1e9),
  ];

  // Prefijos comunes para capacitancia
  static const List<UnitPrefix> capacitancePrefixes = [
    UnitPrefix('Pico', 'p', 1e-12),
    UnitPrefix('Nano', 'n', 1e-9),
    UnitPrefix('Micro', 'µ', 1e-6),
    UnitPrefix('Mili', 'm', 1e-3),
    UnitPrefix('Ninguno', '', 1.0),
  ];

  // Prefijos comunes para voltaje
  static const List<UnitPrefix> voltagePrefixes = [
    UnitPrefix('Mili', 'm', 1e-3),
    UnitPrefix('Ninguno', '', 1.0),
    UnitPrefix('Kilo', 'k', 1e3),
  ];

  // Prefijos comunes para tiempo
  static const List<UnitPrefix> timePrefixes = [
    UnitPrefix('Pico', 'p', 1e-12),
    UnitPrefix('Nano', 'n', 1e-9),
    UnitPrefix('Micro', 'µ', 1e-6),
    UnitPrefix('Mili', 'm', 1e-3),
    UnitPrefix('Ninguno', '', 1.0),
    UnitPrefix('Kilo', 'k', 1e3),
  ];

  // Prefijos comunes para frecuencia
  static const List<UnitPrefix> frequencyPrefixes = [
    UnitPrefix('Ninguno', '', 1.0),
    UnitPrefix('Kilo', 'k', 1e3),
    UnitPrefix('Mega', 'M', 1e6),
    UnitPrefix('Giga', 'G', 1e9),
  ];

  // Prefijos comunes para inductancia
  static const List<UnitPrefix> inductancePrefixes = [
    UnitPrefix('Nano', 'n', 1e-9),
    UnitPrefix('Micro', 'µ', 1e-6),
    UnitPrefix('Mili', 'm', 1e-3),
    UnitPrefix('Ninguno', '', 1.0),
  ];
}

/// Categorías de unidades para facilitar la gestión
enum UnitCategory {
  resistance,
  capacitance,
  inductance,
  voltage,
  current,
  power,
  frequency,
  time,
  temperature,
  charge,
}

/// Clase de utilidad para manejar la conversión y el formato de unidades
class UnitUtils {
  static double convertToBase(
    double value,
    String unitWithPrefix,
    UnitCategory category,
  ) {
    if (value == 0) return 0;

    String prefixSymbol = '';

    if (unitWithPrefix.length > 1) {
      prefixSymbol = unitWithPrefix[0];
    }

    UnitPrefix? prefix;
    for (var p in UnitPrefix.all) {
      if (p.symbol == prefixSymbol) {
        prefix = p;
        break;
      }
    }

    prefix ??= const UnitPrefix('Ninguno', '', 1.0);
    return value * prefix.multiplier;
  }

  static String formatResult(double value, UnitCategory category) {
    List<UnitPrefix> prefixes = [];

    switch (category) {
      case UnitCategory.resistance:
        prefixes = UnitPrefix.resistancePrefixes;
        break;
      case UnitCategory.capacitance:
        prefixes = UnitPrefix.capacitancePrefixes;
        break;
      case UnitCategory.voltage:
        prefixes = UnitPrefix.voltagePrefixes;
        break;
      case UnitCategory.time:
        prefixes = UnitPrefix.timePrefixes;
        break;
      case UnitCategory.frequency:
        prefixes = UnitPrefix.frequencyPrefixes;
        break;
      case UnitCategory.inductance:
        prefixes = UnitPrefix.inductancePrefixes;
        break;
      default:
        prefixes = UnitPrefix.all;
    }

    return _formatValueWithPrefixes(value, prefixes);
  }

  static String _formatValueWithPrefixes(
    double value,
    List<UnitPrefix> prefixes,
  ) {
    if (value == 0) return '0';

    UnitPrefix selectedPrefix = const UnitPrefix('Ninguno', '', 1.0);
    double displayValue = value;

    // Crear una copia mutable de la lista antes de ordenar
    final sortedPrefixes = prefixes.toList()
      ..sort((a, b) => a.multiplier.compareTo(b.multiplier));

    for (var i = 0; i < sortedPrefixes.length; i++) {
      final currentPrefix = sortedPrefixes[i];
      final bool isLastPrefix = i == sortedPrefixes.length - 1;
      if (value.abs() >= currentPrefix.multiplier &&
          (isLastPrefix || value.abs() < sortedPrefixes[i + 1].multiplier)) {
        selectedPrefix = currentPrefix;
        displayValue = value / currentPrefix.multiplier;
        break;
      }
    }

    if (value.abs() > 0 &&
        selectedPrefix.multiplier == 1.0 &&
        sortedPrefixes.isNotEmpty) {
      final smallestPrefix = sortedPrefixes.first;
      if (value.abs() < smallestPrefix.multiplier) {
        selectedPrefix = smallestPrefix;
        displayValue = value / smallestPrefix.multiplier;
      } else {
        final largestPrefix = sortedPrefixes.last;
        if (value.abs() > largestPrefix.multiplier) {
          selectedPrefix = largestPrefix;
          displayValue = value / largestPrefix.multiplier;
        }
      }
    }

    String formattedValue = displayValue.toStringAsFixed(3);
    formattedValue = formattedValue.replaceAll(RegExp(r'\.?0*$'), '');

    return '$formattedValue${selectedPrefix.symbol}';
  }
}
