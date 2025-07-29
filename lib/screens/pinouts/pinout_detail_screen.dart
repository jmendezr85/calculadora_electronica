// lib/screens/pinouts/pinout_detail_screen.dart
import 'package:flutter/material.dart';

// Datos específicos del Puerto USB, definidos directamente en esta pantalla.
const String _usbTitle = 'Puerto USB';
const String _usbImagePath = 'assets/images/pinouts/usb_port.png';
const String _usbDescription =
    'El Universal Serial Bus (USB) es un estándar de la industria que establece especificaciones para la conectividad y las interfaces de alimentación entre los ordenadores y los dispositivos periféricos.';
const List<Map<String, dynamic>> _usbDetails = [
  {
    'section_title': 'USB 2.0 (Tipo-A / Tipo-B)',
    'table_data': [
      {
        'pin': '1',
        'name': 'VCC',
        'description': 'Voltaje de alimentación (+5V)',
        'color': 'Rojo',
      },
      {
        'pin': '2',
        'name': 'D-',
        'description': 'Datos Negativo',
        'color': 'Blanco',
      },
      {
        'pin': '3',
        'name': 'D+',
        'description': 'Datos Positivo',
        'color': 'Verde',
      },
      {'pin': '4', 'name': 'GND', 'description': 'Tierra', 'color': 'Negro'},
    ],
  },
  {
    'section_title': 'USB 3.0 / 3.1 (Tipo-A / Tipo-B SuperSpeed)',
    'table_data': [
      {
        'pin': '1',
        'name': 'VBUS',
        'description': 'Voltaje de alimentación (+5V)',
        'color': 'Rojo',
      },
      {
        'pin': '2',
        'name': 'D-',
        'description': 'Datos Negativo',
        'color': 'Blanco',
      },
      {
        'pin': '3',
        'name': 'D+',
        'description': 'Datos Positivo',
        'color': 'Verde',
      },
      {'pin': '4', 'name': 'GND', 'description': 'Tierra', 'color': 'Negro'},
      {
        'pin': '5',
        'name': 'SS_RX-',
        'description': 'SuperSpeed Datos Recepción Negativo',
        'color': 'Azul',
      },
      {
        'pin': '6',
        'name': 'SS_RX+',
        'description': 'SuperSpeed Datos Recepción Positivo',
        'color': 'Azul',
      },
      {
        'pin': '7',
        'name': 'GND_DRAIN',
        'description': 'Tierra para blindaje',
        'color': '--',
      },
      {
        'pin': '8',
        'name': 'SS_TX-',
        'description': 'SuperSpeed Datos Transmisión Negativo',
        'color': 'Amarillo',
      },
      {
        'pin': '9',
        'name': 'SS_TX+',
        'description': 'SuperSpeed Datos Transmisión Positivo',
        'color': 'Amarillo',
      },
    ],
  },
  {
    'section_title': 'USB Tipo-C (Full Featured)',
    'table_data': [
      {'pin': 'A1', 'name': 'GND', 'description': 'Tierra', 'color': '--'},
      {
        'pin': 'A2',
        'name': 'TX1+',
        'description': 'Lanes de transmisión diferencial SuperSpeed',
        'color': 'Azul/Amarillo',
      },
      {
        'pin': 'A3',
        'name': 'TX1-',
        'description': 'Lanes de transmisión diferencial SuperSpeed',
        'color': 'Azul/Amarillo',
      },
      {
        'pin': 'A4',
        'name': 'VBUS',
        'description': 'Voltaje de alimentación (+5V)',
        'color': 'Rojo',
      },
      {
        'pin': 'A5',
        'name': 'CC1',
        'description': 'Canal de configuración',
        'color': '--',
      },
      {
        'pin': 'A6',
        'name': 'D+',
        'description': 'USB 2.0 Datos Positivo',
        'color': 'Verde',
      },
      {
        'pin': 'A7',
        'name': 'D-',
        'description': 'USB 2.0 Datos Negativo',
        'color': 'Blanco',
      },
      {
        'pin': 'A8',
        'name': 'SBU1',
        'description': 'Uso de banda lateral',
        'color': '--',
      },
      {
        'pin': 'A9',
        'name': 'VBUS',
        'description': 'Voltaje de alimentación (+5V)',
        'color': 'Rojo',
      },
      {
        'pin': 'A10',
        'name': 'RX2-',
        'description': 'Lanes de recepción diferencial SuperSpeed',
        'color': 'Morado/Naranja',
      },
      {
        'pin': 'A11',
        'name': 'RX2+',
        'description': 'Lanes de recepción diferencial SuperSpeed',
        'color': 'Morado/Naranja',
      },
      {'pin': 'A12', 'name': 'GND', 'description': 'Tierra', 'color': '--'},
      {'pin': 'B1', 'name': 'GND', 'description': 'Tierra', 'color': '--'},
      {
        'pin': 'B2',
        'name': 'TX2+',
        'description': 'Lanes de transmisión diferencial SuperSpeed',
        'color': 'Azul/Amarillo',
      },
      {
        'pin': 'B3',
        'name': 'TX2-',
        'description': 'Lanes de transmisión diferencial SuperSpeed',
        'color': 'Azul/Amarillo',
      },
      {
        'pin': 'B4',
        'name': 'VBUS',
        'description': 'Voltaje de alimentación (+5V)',
        'color': 'Rojo',
      },
      {
        'pin': 'B5',
        'name': 'CC2',
        'description': 'Canal de configuración',
        'color': '--',
      },
      {
        'pin': 'B6',
        'name': 'D+',
        'description': 'USB 2.0 Datos Positivo',
        'color': 'Verde',
      },
      {
        'pin': 'B7',
        'name': 'D-',
        'description': 'USB 2.0 Datos Negativo',
        'color': 'Blanco',
      },
      {
        'pin': 'B8',
        'name': 'SBU2',
        'description': 'Uso de banda lateral',
        'color': '--',
      },
      {
        'pin': 'B9',
        'name': 'VBUS',
        'description': 'Voltaje de alimentación (+5V)',
        'color': 'Rojo',
      },
      {
        'pin': 'B10',
        'name': 'RX1-',
        'description': 'Lanes de recepción diferencial SuperSpeed',
        'color': 'Morado/Naranja',
      },
      {
        'pin': 'B11',
        'name': 'RX1+',
        'description': 'Lanes de recepción diferencial SuperSpeed',
        'color': 'Morado/Naranja',
      },
      {'pin': 'B12', 'name': 'GND', 'description': 'Tierra', 'color': '--'},
    ],
  },
];

class PinoutDetailScreen extends StatelessWidget {
  // El constructor ya no necesita parámetros, ya que los datos están definidos arriba.
  const PinoutDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(_usbTitle), // Usa el título hardcodeado
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        centerTitle: true,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.asset(
                _usbImagePath, // Usa la ruta de imagen hardcodeada
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Descripción General:',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _usbDescription, // Usa la descripción hardcodeada
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface,
                height: 1.5,
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 24),

            // Siempre muestra los detalles de pines para USB
            Text(
              'Detalles de Pines:',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ..._usbDetails.map((section) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    section['section_title']!,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildPinoutTable(
                    section['table_data'] as List<Map<String, String>>,
                    context,
                  ),
                  const SizedBox(height: 24),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  // Método auxiliar para construir la tabla de pines (sin cambios)
  Widget _buildPinoutTable(
    List<Map<String, String>> data,
    BuildContext context,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return DataTable(
      columnSpacing: 16,
      dataRowMinHeight: 40,
      dataRowMaxHeight: 60,
      headingRowColor: WidgetStateProperty.all(colorScheme.primaryContainer),
      border: TableBorder.all(
        color: colorScheme.outlineVariant,
        width: 1,
        borderRadius: BorderRadius.circular(8),
      ),
      columns: const <DataColumn>[
        DataColumn(
          label: Expanded(
            child: Text('Pin', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Nombre',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Descripción',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text('Color', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      ],
      rows: data.map((pin) {
        return DataRow(
          cells: <DataCell>[
            DataCell(Text(pin['pin']!)),
            DataCell(Text(pin['name']!)),
            DataCell(
              Text(
                pin['description']!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            DataCell(Text(pin['color']!)),
          ],
        );
      }).toList(),
    );
  }
}
