import 'package:flutter/material.dart';

class UnitsAndPrefixesScreen extends StatelessWidget {
  const UnitsAndPrefixesScreen({super.key});

  final List<Map<String, String>> _fundamentalUnits = const [
    {
      'Magnitud': 'Tensión / Voltaje',
      'Unidad': 'Voltio (V)',
      'Concepto': 'Fuerza que impulsa a los electrones.',
    },
    {
      'Magnitud': 'Corriente',
      'Unidad': 'Amperio (A)',
      'Concepto': 'Flujo de carga eléctrica.',
    },
    {
      'Magnitud': 'Resistencia',
      'Unidad': 'Ohmio (Ω)',
      'Concepto': 'Oposición al flujo de corriente.',
    },
    {
      'Magnitud': 'Potencia',
      'Unidad': 'Vatio (W)',
      'Concepto': 'Velocidad a la que se realiza el trabajo.',
    },
    {
      'Magnitud': 'Capacitancia',
      'Unidad': 'Faradio (F)',
      'Concepto': 'Capacidad de almacenar carga eléctrica.',
    },
    {
      'Magnitud': 'Inductancia',
      'Unidad': 'Henrio (H)',
      'Concepto': 'Oposición a cambios en la corriente.',
    },
    {
      'Magnitud': 'Frecuencia',
      'Unidad': 'Hertz (Hz)',
      'Concepto': 'Número de ciclos por segundo.',
    },
    {
      'Magnitud': 'Carga Eléctrica',
      'Unidad': 'Culombio (C)',
      'Concepto': 'Cantidad fundamental de electricidad.',
    },
  ];

  final List<Map<String, String>> _siPrefixes = const [
    {
      'Prefijo': 'Tera (T)',
      'Multiplicador': '1,000,000,000,000',
      'Potencia de 10': '10¹²',
    },
    {
      'Prefijo': 'Giga (G)',
      'Multiplicador': '1,000,000,000',
      'Potencia de 10': '10⁹',
    },
    {
      'Prefijo': 'Mega (M)',
      'Multiplicador': '1,000,000',
      'Potencia de 10': '10⁶',
    },
    {'Prefijo': 'Kilo (k)', 'Multiplicador': '1,000', 'Potencia de 10': '10³'},
    {'Prefijo': 'Hecto (h)', 'Multiplicador': '100', 'Potencia de 10': '10²'},
    {'Prefijo': 'Deca (da)', 'Multiplicador': '10', 'Potencia de 10': '10¹'},
    {'Prefijo': 'Deci (d)', 'Multiplicador': '0.1', 'Potencia de 10': '10⁻¹'},
    {'Prefijo': 'Centi (c)', 'Multiplicador': '0.01', 'Potencia de 10': '10⁻²'},
    {'Prefijo': 'Mili (m)', 'Multiplicador': '0.001', 'Potencia de 10': '10⁻³'},
    {
      'Prefijo': 'Micro (µ)',
      'Multiplicador': '0.000001',
      'Potencia de 10': '10⁻⁶',
    },
    {
      'Prefijo': 'Nano (n)',
      'Multiplicador': '0.000000001',
      'Potencia de 10': '10⁻⁹',
    },
    {
      'Prefijo': 'Pico (p)',
      'Multiplicador': '0.000000000001',
      'Potencia de 10': '10⁻¹²',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Unidades y Prefijos'),
        centerTitle: true,
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Unidades Fundamentales en Electrónica',
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: DataTable(
                  columnSpacing: 12,
                  dataRowMinHeight: 50,
                  dataRowMaxHeight: 60,
                  headingRowColor: WidgetStateProperty.resolveWith<Color?>(
                    (Set<WidgetState> states) =>
                        colorScheme.surfaceContainerHighest,
                  ),
                  columns: [
                    DataColumn(
                      label: Text(
                        'Magnitud',
                        style: textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Unidad',
                        style: textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Concepto',
                        style: textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                  rows: _fundamentalUnits.map((item) {
                    return DataRow(
                      cells: [
                        DataCell(
                          Text(
                            item['Magnitud']!,
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            item['Unidad']!,
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            item['Concepto']!,
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'Prefijos del Sistema Internacional (SI)',
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: DataTable(
                  columnSpacing: 12,
                  dataRowMinHeight: 40,
                  dataRowMaxHeight: 50,
                  headingRowColor: WidgetStateProperty.resolveWith<Color?>(
                    (Set<WidgetState> states) =>
                        colorScheme.surfaceContainerHighest,
                  ),
                  columns: [
                    DataColumn(
                      label: Text(
                        'Prefijo',
                        style: textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Multiplicador',
                        style: textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Potencia de 10',
                        style: textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                  rows: _siPrefixes.map((item) {
                    return DataRow(
                      cells: [
                        DataCell(
                          Text(
                            item['Prefijo']!,
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            item['Multiplicador']!,
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            item['Potencia de 10']!,
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Estos prefijos se utilizan con las unidades para indicar múltiplos o submúltiplos de la unidad base, por ejemplo, mV (milivoltios), µF (microfaradios), kΩ (kiloohmios).',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
