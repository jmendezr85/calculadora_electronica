// lib/screens/pinouts/serial_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

// Datos específicos del Puerto Serie, definidos directamente en esta pantalla.
const String _serialTitle = 'Puerto Serie';
const String _serialImagePath = 'assets/images/pinouts/serial_port.png';
const String _serialDescription =
    'El puerto serie (RS-232) es una interfaz de comunicación que transmite datos un bit a la vez, secuencialmente. Se utilizaba comúnmente para conectar periféricos como módems, ratones y equipos de red en computadoras antiguas.';
const List<Map<String, dynamic>> _serialDetails = [
  {
    'section_title': 'Conector DB-9 (DE-9) Macho (vista frontal)',
    'table_data': [
      {
        'pin': '1',
        'name': 'DCD',
        'description': 'Data Carrier Detect',
        'color': '--',
      },
      {'pin': '2', 'name': 'RXD', 'description': 'Receive Data', 'color': '--'},
      {
        'pin': '3',
        'name': 'TXD',
        'description': 'Transmit Data',
        'color': '--',
      },
      {
        'pin': '4',
        'name': 'DTR',
        'description': 'Data Terminal Ready',
        'color': '--',
      },
      {'pin': '5', 'name': 'GND', 'description': 'Ground', 'color': '--'},
      {
        'pin': '6',
        'name': 'DSR',
        'description': 'Data Set Ready',
        'color': '--',
      },
      {
        'pin': '7',
        'name': 'RTS',
        'description': 'Request To Send',
        'color': '--',
      },
      {
        'pin': '8',
        'name': 'CTS',
        'description': 'Clear To Send',
        'color': '--',
      },
      {
        'pin': '9',
        'name': 'RI',
        'description': 'Ring Indicator',
        'color': '--',
      },
    ],
  },
  {
    'section_title': 'Conector DB-25 (RS-232) - Vista frontal',
    'table_data': [
      {
        'pin': '1',
        'name': 'PG',
        'description': 'Protective Ground (Tierra de protección)',
        'color': '--',
      },
      {
        'pin': '2',
        'name': 'TXD',
        'description': 'Transmit Data (Datos de transmisión)',
        'color': 'Amarillo',
      },
      {
        'pin': '3',
        'name': 'RXD',
        'description': 'Receive Data (Datos de recepción)',
        'color': 'Rojo',
      },
      {
        'pin': '4',
        'name': 'RTS',
        'description': 'Request To Send (Solicitud de envío)',
        'color': 'Verde',
      },
      {
        'pin': '5',
        'name': 'CTS',
        'description': 'Clear To Send (Listo para enviar)',
        'color': 'Azul',
      },
      {
        'pin': '6',
        'name': 'DSR',
        'description': 'Data Set Ready (Equipo listo)',
        'color': 'Morado',
      },
      {
        'pin': '7',
        'name': 'GND',
        'description': 'Signal Ground (Tierra de señal)',
        'color': 'Negro',
      },
      {
        'pin': '8',
        'name': 'DCD',
        'description': 'Data Carrier Detect (Detección de portadora)',
        'color': 'Blanco',
      },
      {
        'pin': '9',
        'name': '--',
        'description': 'Reservado (+Voltaje)',
        'color': '--',
      },
      {
        'pin': '10',
        'name': '--',
        'description': 'Reservado (-Voltaje)',
        'color': '--',
      },
      {
        'pin': '12',
        'name': 'SDCD',
        'description': 'Secondary DCD (Detección secundaria)',
        'color': '--',
      },
      {
        'pin': '13',
        'name': 'SCTS',
        'description': 'Secondary CTS (Listo secundario)',
        'color': '--',
      },
      {
        'pin': '14',
        'name': 'STXD',
        'description': 'Secondary TXD (Transmisión secundaria)',
        'color': '--',
      },
      {
        'pin': '15',
        'name': 'TCK',
        'description': 'Transmit Clock (Reloj de transmisión)',
        'color': '--',
      },
      {
        'pin': '16',
        'name': 'SRXD',
        'description': 'Secondary RXD (Recepción secundaria)',
        'color': '--',
      },
      {
        'pin': '17',
        'name': 'RCK',
        'description': 'Receive Clock (Reloj de recepción)',
        'color': '--',
      },
      {'pin': '18', 'name': '--', 'description': 'Reservado', 'color': '--'},
      {
        'pin': '19',
        'name': 'SRTS',
        'description': 'Secondary RTS (Solicitud secundaria)',
        'color': '--',
      },
      {
        'pin': '20',
        'name': 'DTR',
        'description': 'Data Terminal Ready (Terminal listo)',
        'color': 'Naranja',
      },
      {
        'pin': '21',
        'name': 'SQD',
        'description': 'Signal Quality Detect (Calidad de señal)',
        'color': '--',
      },
      {
        'pin': '22',
        'name': 'RI',
        'description': 'Ring Indicator (Indicador de llamada)',
        'color': 'Gris',
      },
      {
        'pin': '23',
        'name': 'DRS',
        'description': 'Data Rate Select (Selección de velocidad)',
        'color': '--',
      },
      {
        'pin': '24',
        'name': 'XTCK',
        'description': 'External Clock (Reloj externo)',
        'color': '--',
      },
      {'pin': '25', 'name': '--', 'description': 'Reservado', 'color': '--'},
    ],
  },
];

class FullScreenImageView extends StatelessWidget {
  final String imagePath;

  const FullScreenImageView({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Imagen en pantalla completa')),
      body: PhotoView(
        imageProvider: AssetImage(imagePath),
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.covered * 2,
        initialScale: PhotoViewComputedScale.contained,
        backgroundDecoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
      ),
    );
  }
}

class SerialDetailScreen extends StatelessWidget {
  const SerialDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(_serialTitle),
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
            Hero(
              tag: 'serial-image',
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          FullScreenImageView(imagePath: _serialImagePath),
                    ),
                  );
                },
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.asset(_serialImagePath, fit: BoxFit.contain),
                ),
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
              _serialDescription,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface,
                height: 1.5,
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 24),

            // Detalles de pines para el puerto serie
            Text(
              'Detalles de Pines:',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ..._serialDetails.map((section) {
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

  // Método auxiliar para construir la tabla de pines (igual que en USB)
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
