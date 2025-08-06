import 'package:flutter/material.dart';

class UnitsAndPrefixesScreen extends StatelessWidget {
  const UnitsAndPrefixesScreen({super.key});

  final List<Map<String, dynamic>> _fundamentalUnits = const [
    {
      'Magnitud': 'Tensión / Voltaje',
      'Unidad': 'Voltio (V)',
      'Concepto': 'Diferencia de potencial eléctrico entre dos puntos.',
      'Definición': '1 V = 1 J/C (Julio por Culombio)',
      'Aplicación':
          'Medición de baterías, fuentes de alimentación, señales analógicas/digitales',
      'Símbolo': 'V',
    },
    {
      'Magnitud': 'Corriente',
      'Unidad': 'Amperio (A)',
      'Concepto': 'Flujo de carga eléctrica por unidad de tiempo.',
      'Definición': '1 A = 1 C/s (Culombio por segundo)',
      'Aplicación': 'Capacidad de circuitos, fusibles, consumo de dispositivos',
      'Símbolo': 'I',
    },
    {
      'Magnitud': 'Resistencia',
      'Unidad': 'Ohmio (Ω)',
      'Concepto': 'Oposición al flujo de corriente en un material.',
      'Definición': '1 Ω = 1 V/A (Voltio por Amperio)',
      'Aplicación': 'Divisores de voltaje, limitación de corriente, filtros',
      'Símbolo': 'R',
    },
    {
      'Magnitud': 'Potencia',
      'Unidad': 'Vatio (W)',
      'Concepto': 'Tasa de transferencia de energía por unidad de tiempo.',
      'Definición': '1 W = 1 J/s (Julio por segundo) = 1 V·A',
      'Aplicación':
          'Consumo de dispositivos, disipación de calor, diseño de fuentes',
      'Símbolo': 'P',
    },
    {
      'Magnitud': 'Capacitancia',
      'Unidad': 'Faradio (F)',
      'Concepto':
          'Capacidad de almacenar carga eléctrica bajo un voltaje dado.',
      'Definición': '1 F = 1 C/V (Culombio por Voltio)',
      'Aplicación': 'Filtros, temporizadores, almacenamiento de energía',
      'Símbolo': 'C',
    },
    {
      'Magnitud': 'Inductancia',
      'Unidad': 'Henrio (H)',
      'Concepto':
          'Oposición a cambios en la corriente que fluye a través de un conductor.',
      'Definición': '1 H = 1 Wb/A (Weber por Amperio)',
      'Aplicación': 'Filtros, convertidores DC-DC, supresión de ruido',
      'Símbolo': 'L',
    },
    {
      'Magnitud': 'Frecuencia',
      'Unidad': 'Hertz (Hz)',
      'Concepto':
          'Número de ciclos completos por segundo en una señal periódica.',
      'Definición': '1 Hz = 1 ciclo/segundo',
      'Aplicación': 'Señales de reloj, comunicaciones, filtrado',
      'Símbolo': 'f',
    },
    {
      'Magnitud': 'Carga Eléctrica',
      'Unidad': 'Culombio (C)',
      'Concepto':
          'Cantidad fundamental de electricidad transportada por una corriente.',
      'Definición': '1 C = 6.241×10¹⁸ electrones',
      'Aplicación': 'Capacitores, leyes fundamentales de circuitos',
      'Símbolo': 'Q',
    },
    {
      'Magnitud': 'Conductancia',
      'Unidad': 'Siemens (S)',
      'Concepto':
          'Facilidad con la que un material permite el flujo de corriente.',
      'Definición': '1 S = 1/Ω (Inverso del Ohmio)',
      'Aplicación': 'Análisis de circuitos paralelos, materiales conductores',
      'Símbolo': 'G',
    },
    {
      'Magnitud': 'Flujo Magnético',
      'Unidad': 'Weber (Wb)',
      'Concepto':
          'Cantidad total de campo magnético que pasa a través de un área.',
      'Definición': '1 Wb = 1 V·s (Voltio-segundo)',
      'Aplicación': 'Transformadores, inductores, motores eléctricos',
      'Símbolo': 'Φ',
    },
    {
      'Magnitud': 'Densidad de Flujo Magnético',
      'Unidad': 'Tesla (T)',
      'Concepto': 'Fuerza del campo magnético por unidad de área.',
      'Definición': '1 T = 1 Wb/m² (Weber por metro cuadrado)',
      'Aplicación': 'Sensores de efecto Hall, diseño de motores',
      'Símbolo': 'B',
    },
  ];

  final List<Map<String, String>> _siPrefixes = const [
    {
      'Prefijo': 'Yotta (Y)',
      'Símbolo': 'Y',
      'Multiplicador': '1,000,000,000,000,000,000,000,000',
      'Potencia de 10': '10²⁴',
      'Ejemplo': 'Yottabyte (YB) - Almacenamiento de datos a gran escala',
    },
    {
      'Prefijo': 'Zetta (Z)',
      'Símbolo': 'Z',
      'Multiplicador': '1,000,000,000,000,000,000,000',
      'Potencia de 10': '10²¹',
      'Ejemplo': 'Zettaohm (ZΩ) - Resistencia extremadamente alta',
    },
    {
      'Prefijo': 'Exa (E)',
      'Símbolo': 'E',
      'Multiplicador': '1,000,000,000,000,000,000',
      'Potencia de 10': '10¹⁸',
      'Ejemplo':
          'Exaflops (EFLOPS) - Cálculos por segundo en supercomputadoras',
    },
    {
      'Prefijo': 'Peta (P)',
      'Símbolo': 'P',
      'Multiplicador': '1,000,000,000,000,000',
      'Potencia de 10': '10¹⁵',
      'Ejemplo': 'Petavatio (PW) - Potencia de pulsos láser intensos',
    },
    {
      'Prefijo': 'Tera (T)',
      'Símbolo': 'T',
      'Multiplicador': '1,000,000,000,000',
      'Potencia de 10': '10¹²',
      'Ejemplo': 'Terabyte (TB) - Almacenamiento en discos duros',
    },
    {
      'Prefijo': 'Giga (G)',
      'Símbolo': 'G',
      'Multiplicador': '1,000,000,000',
      'Potencia de 10': '10⁹',
      'Ejemplo': 'Gigahertz (GHz) - Frecuencias de CPU',
    },
    {
      'Prefijo': 'Mega (M)',
      'Símbolo': 'M',
      'Multiplicador': '1,000,000',
      'Potencia de 10': '10⁶',
      'Ejemplo': 'Megavoltio (MV) - Transmisión de energía eléctrica',
    },
    {
      'Prefijo': 'Kilo (k)',
      'Símbolo': 'k',
      'Multiplicador': '1,000',
      'Potencia de 10': '10³',
      'Ejemplo': 'Kilohmio (kΩ) - Resistencia en circuitos electrónicos',
    },
    {
      'Prefijo': 'Hecto (h)',
      'Símbolo': 'h',
      'Multiplicador': '100',
      'Potencia de 10': '10²',
      'Ejemplo':
          'Hectopascal (hPa) - Presión atmosférica (menos común en electrónica)',
    },
    {
      'Prefijo': 'Deca (da)',
      'Símbolo': 'da',
      'Multiplicador': '10',
      'Potencia de 10': '10¹',
      'Ejemplo':
          'Decámetro (dam) - Medición de longitudes (poco usado en electrónica)',
    },
    {
      'Prefijo': 'Deci (d)',
      'Símbolo': 'd',
      'Multiplicador': '0.1',
      'Potencia de 10': '10⁻¹',
      'Ejemplo': 'Decibel (dB) - Relación logarítmica entre cantidades',
    },
    {
      'Prefijo': 'Centi (c)',
      'Símbolo': 'c',
      'Multiplicador': '0.01',
      'Potencia de 10': '10⁻²',
      'Ejemplo': 'Centímetro (cm) - Medición de componentes electrónicos',
    },
    {
      'Prefijo': 'Mili (m)',
      'Símbolo': 'm',
      'Multiplicador': '0.001',
      'Potencia de 10': '10⁻³',
      'Ejemplo': 'Milivoltio (mV) - Señales de sensores',
    },
    {
      'Prefijo': 'Micro (µ)',
      'Símbolo': 'µ',
      'Multiplicador': '0.000001',
      'Potencia de 10': '10⁻⁶',
      'Ejemplo': 'Microfaradio (µF) - Capacitores de filtrado',
    },
    {
      'Prefijo': 'Nano (n)',
      'Símbolo': 'n',
      'Multiplicador': '0.000000001',
      'Potencia de 10': '10⁻⁹',
      'Ejemplo': 'Nanosegundo (ns) - Tiempos de conmutación en transistores',
    },
    {
      'Prefijo': 'Pico (p)',
      'Símbolo': 'p',
      'Multiplicador': '0.000000000001',
      'Potencia de 10': '10⁻¹²',
      'Ejemplo': 'Picofaradio (pF) - Capacitancia parásita',
    },
    {
      'Prefijo': 'Femto (f)',
      'Símbolo': 'f',
      'Multiplicador': '0.000000000000001',
      'Potencia de 10': '10⁻¹⁵',
      'Ejemplo': 'Femtosegundo (fs) - Pulsos láser ultracortos',
    },
    {
      'Prefijo': 'Atto (a)',
      'Símbolo': 'a',
      'Multiplicador': '0.000000000000000001',
      'Potencia de 10': '10⁻¹⁸',
      'Ejemplo': 'Attómetro (am) - Escalas subatómicas',
    },
    {
      'Prefijo': 'Zepto (z)',
      'Símbolo': 'z',
      'Multiplicador': '0.000000000000000000001',
      'Potencia de 10': '10⁻²¹',
      'Ejemplo': 'Zeptosegundo (zs) - Tiempos en física cuántica',
    },
    {
      'Prefijo': 'Yocto (y)',
      'Símbolo': 'y',
      'Multiplicador': '0.000000000000000000000001',
      'Potencia de 10': '10⁻²⁴',
      'Ejemplo': 'Yoctómetro (ym) - Escalas en teoría de cuerdas',
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
            _buildUnitsTable(context),
            const SizedBox(height: 30),
            Text(
              'Prefijos del Sistema Internacional (SI)',
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            _buildPrefixesTable(context),
            const SizedBox(height: 20),
            _buildAdditionalInfo(context),
          ],
        ),
      ),
    );
  }

  Widget _buildUnitsTable(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: ExpansionTile(
          title: Text(
            'Tabla de Unidades Electrónicas',
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 16,
                dataRowMinHeight: 60,
                dataRowMaxHeight: 80,
                headingRowColor: WidgetStateProperty.resolveWith<Color?>(
                  (Set<WidgetState> states) =>
                      colorScheme.surfaceContainerHighest,
                ),
                columns: [
                  DataColumn(
                    label: Text('Magnitud', style: _headerTextStyle(context)),
                    tooltip: 'Cantidad física medida',
                  ),
                  DataColumn(
                    label: Text('Símbolo', style: _headerTextStyle(context)),
                    tooltip: 'Símbolo matemático de la magnitud',
                  ),
                  DataColumn(
                    label: Text('Unidad', style: _headerTextStyle(context)),
                    tooltip: 'Unidad de medida estándar',
                  ),
                  DataColumn(
                    label: Text('Definición', style: _headerTextStyle(context)),
                    tooltip: 'Definición formal de la unidad',
                  ),
                  DataColumn(
                    label: Text('Aplicación', style: _headerTextStyle(context)),
                    tooltip: 'Usos comunes en electrónica',
                  ),
                ],
                rows: _fundamentalUnits.map((item) {
                  return DataRow(
                    cells: [
                      DataCell(
                        Text(
                          item['Magnitud']!,
                          style: _boldCellTextStyle(context),
                        ),
                      ),
                      DataCell(
                        Text(
                          item['Símbolo']!,
                          style: _symbolCellTextStyle(context),
                        ),
                      ),
                      DataCell(
                        Text(
                          item['Unidad']!,
                          style: _boldCellTextStyle(context),
                        ),
                      ),
                      DataCell(
                        Text(
                          item['Definición']!,
                          style: _cellTextStyle(context),
                        ),
                      ),
                      DataCell(
                        Text(
                          item['Aplicación']!,
                          style: _cellTextStyle(context),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrefixesTable(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: ExpansionTile(
          initiallyExpanded: true,
          title: Text(
            'Tabla de Prefijos SI',
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 16,
                dataRowMinHeight: 50,
                dataRowMaxHeight: 70,
                headingRowColor: WidgetStateProperty.resolveWith<Color?>(
                  (Set<WidgetState> states) =>
                      colorScheme.surfaceContainerHighest,
                ),
                columns: [
                  DataColumn(
                    label: Text('Prefijo', style: _headerTextStyle(context)),
                    tooltip: 'Nombre del prefijo',
                  ),
                  DataColumn(
                    label: Text('Símbolo', style: _headerTextStyle(context)),
                    tooltip: 'Símbolo del prefijo',
                  ),
                  DataColumn(
                    label: Text('Factor', style: _headerTextStyle(context)),
                    tooltip: 'Multiplicador numérico',
                  ),
                  DataColumn(
                    label: Text('Notación', style: _headerTextStyle(context)),
                    tooltip: 'Potencia de 10 equivalente',
                  ),
                  DataColumn(
                    label: Text('Ejemplo', style: _headerTextStyle(context)),
                    tooltip: 'Uso típico en electrónica',
                  ),
                ],
                rows: _siPrefixes.map((item) {
                  return DataRow(
                    cells: [
                      DataCell(
                        Text(
                          item['Prefijo']!,
                          style: _boldCellTextStyle(context),
                        ),
                      ),
                      DataCell(
                        Text(
                          item['Símbolo']!,
                          style: _symbolCellTextStyle(context),
                        ),
                      ),
                      DataCell(
                        Text(
                          item['Multiplicador']!,
                          style: _cellTextStyle(context),
                        ),
                      ),
                      DataCell(
                        Text(
                          item['Potencia de 10']!,
                          style: _cellTextStyle(context),
                        ),
                      ),
                      DataCell(
                        Text(
                          item['Ejemplo']!,
                          style: _cellTextStyle(context),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalInfo(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 2,
      color: colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Información Técnica Adicional',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Los prefijos SI son esenciales en electrónica para expresar valores en escalas adecuadas. Por ejemplo:',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBulletPoint(
                    '1 mA = 0.001 A (Corriente en circuitos de baja potencia)',
                  ),
                  _buildBulletPoint(
                    '1 kΩ = 1000 Ω (Resistencias comunes en circuitos)',
                  ),
                  _buildBulletPoint(
                    '1 µF = 0.000001 F (Capacitores de filtrado)',
                  ),
                  _buildBulletPoint(
                    '1 GHz = 1,000,000,000 Hz (Frecuencias de procesadores)',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Nota: En electrónica, los prefijos más utilizados son pico (p), nano (n), micro (µ), mili (m), kilo (k), mega (M), giga (G) y tera (T).',
              style: textTheme.bodySmall?.copyWith(
                fontStyle: FontStyle.italic,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• '),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  TextStyle _headerTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ) ??
        const TextStyle();
  }

  TextStyle _boldCellTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSurface,
        ) ??
        const TextStyle();
  }

  TextStyle _symbolCellTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
          fontFamily: 'RobotoMono',
        ) ??
        const TextStyle();
  }

  TextStyle _cellTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
        ) ??
        const TextStyle();
  }
}
