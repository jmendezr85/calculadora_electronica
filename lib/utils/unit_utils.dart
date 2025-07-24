// lib/utils/unit_utils.dart

/// Representa un prefijo de unidad electrónica (mili, micro, kilo, etc.).
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
    UnitPrefix('Tera', 'T', 1e12),
  ];

  // Prefijos comunes para capacitancia
  static const List<UnitPrefix> capacitancePrefixes = [
    UnitPrefix('Pico', 'p', 1e-12),
    UnitPrefix('Nano', 'n', 1e-9),
    UnitPrefix('Micro', 'µ', 1e-6),
    UnitPrefix(
      'Mili',
      'm',
      1e-3,
    ), // Aunque menos común para capacitancia, se incluye
    UnitPrefix('Ninguno', '', 1.0),
  ];

  // Prefijos comunes para inductancia
  static const List<UnitPrefix> inductancePrefixes = [
    UnitPrefix('Nano', 'n', 1e-9),
    UnitPrefix('Micro', 'µ', 1e-6),
    UnitPrefix('Mili', 'm', 1e-3),
    UnitPrefix('Ninguno', '', 1.0),
  ];
  static const UnitPrefix none = UnitPrefix('Ninguno', '', 1.0);
  // Prefijos comunes para voltaje y corriente, frecuencia, tiempo
  static const List<UnitPrefix> voltageCurrentPrefixes = [
    UnitPrefix(
      'Pico',
      'p',
      1e-12,
    ), // Añadido para mayor granularidad, ej. para frecuencia alta o tiempo muy corto
    UnitPrefix('Nano', 'n', 1e-9),
    UnitPrefix('Micro', 'µ', 1e-6),
    UnitPrefix('Mili', 'm', 1e-3),
    UnitPrefix('Ninguno', '', 1.0),
    UnitPrefix('Kilo', 'k', 1e3),
    UnitPrefix('Mega', 'M', 1e6),
    UnitPrefix('Giga', 'G', 1e9),
  ];
}

/// Enumeración para categorizar diferentes tipos de unidades.
/// Esto ayuda a seleccionar los prefijos adecuados para el formateo.
enum UnitType {
  resistance,
  capacitance,
  inductance,
  voltage,
  current,
  frequency,
  power,
  time, // Añadido para el simulador RC
  // Puedes añadir más tipos de unidades según sea necesario
}

/// Una clase de utilidad para formatear valores numéricos con los prefijos de unidad adecuados.
class UnitUtils {
  /// Formatea un valor numérico a una cadena con el prefijo de unidad más apropiado.
  ///
  /// [value]: El valor numérico a formatear.
  /// [type]: El tipo de unidad para determinar los prefijos aplicables.
  /// [decimalPlaces]: El número de decimales a redondear. Por defecto es 2.
  static String formatValue(
    double value,
    UnitType type, {
    int decimalPlaces = 2,
  }) {
    List<UnitPrefix> prefixes;

    switch (type) {
      case UnitType.resistance:
        prefixes = [...UnitPrefix.resistancePrefixes]; // <--- ¡Copia mutable!
        break;
      case UnitType.capacitance:
        prefixes = [...UnitPrefix.capacitancePrefixes]; // <--- ¡Copia mutable!
        break;
      case UnitType.inductance:
        prefixes = [...UnitPrefix.inductancePrefixes]; // <--- ¡Copia mutable!
        break;
      case UnitType.voltage:
      case UnitType.current:
      case UnitType.power:
      case UnitType.frequency:
      case UnitType.time:
        prefixes = [
          ...UnitPrefix.voltageCurrentPrefixes,
        ]; // <--- ¡Copia mutable!
        break;
      // Añade más casos si tienes listas de prefijos específicas para otros UnitType
    }

    // Ordenar los prefijos de menor a mayor multiplicador
    prefixes.sort((a, b) => a.multiplier.compareTo(b.multiplier));

    UnitPrefix selectedPrefix = prefixes.firstWhere(
      (prefix) => prefix.multiplier == 1.0,
      orElse: () => const UnitPrefix('Ninguno', '', 1.0),
    );

    double displayValue = value;

    // Buscar el prefijo más adecuado
    for (int i = 0; i < prefixes.length; i++) {
      final currentPrefix = prefixes[i];
      final nextPrefix = (i + 1 < prefixes.length) ? prefixes[i + 1] : null;

      // Si el valor es mayor o igual al prefijo actual, y menor que el siguiente (si existe)
      // o si es el último prefijo, seleccionamos este.
      if (value.abs() >= currentPrefix.multiplier &&
          (nextPrefix == null || value.abs() < nextPrefix.multiplier)) {
        selectedPrefix = currentPrefix;
        displayValue = value / currentPrefix.multiplier;
        break;
      }
    }

    // Caso especial para valores muy pequeños o muy grandes que no encajan perfectamente
    // con los rangos definidos por los prefijos en el bucle anterior.
    // Asegura que el valor se muestre con el prefijo más bajo o más alto si está fuera de los rangos intermedios.
    if (value.abs() > 0 &&
        selectedPrefix.multiplier == 1.0 &&
        prefixes.isNotEmpty) {
      // Si el valor es muy pequeño y no se seleccionó un prefijo más adecuado que "Ninguno"
      final smallestPrefix = prefixes.first;
      if (value.abs() < smallestPrefix.multiplier) {
        selectedPrefix = smallestPrefix;
        displayValue = value / smallestPrefix.multiplier;
      }
    }

    // Si después del bucle y el caso especial, el valor sigue siendo el original y no 0,
    // significa que es un valor muy grande que supera nuestro prefijo más grande.
    // En este caso, lo mostramos con el prefijo más grande disponible.
    if (value.abs() > 0 &&
        selectedPrefix.multiplier == 1.0 &&
        prefixes.isNotEmpty) {
      final largestPrefix = prefixes.last;
      if (value.abs() > largestPrefix.multiplier) {
        selectedPrefix = largestPrefix;
        displayValue = value / largestPrefix.multiplier;
      }
    }

    return '${displayValue.toStringAsFixed(decimalPlaces)} ${selectedPrefix.symbol}';
  }
}
