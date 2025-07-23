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
  ];

  // Prefijos comunes para capacitancia (más pequeños)
  static const List<UnitPrefix> capacitancePrefixes = [
    UnitPrefix('Pico', 'p', 1e-12),
    UnitPrefix('Nano', 'n', 1e-9),
    UnitPrefix('Micro', 'µ', 1e-6),
    UnitPrefix('Mili', 'm', 1e-3), // Aunque menos común, se incluye
    UnitPrefix('Ninguno', '', 1.0),
  ];

  @override
  String toString() => '$name ($symbol)'; // Para mostrar en el Dropdown
}
