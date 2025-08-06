// lib/screens/pinouts/parallel_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:calculadora_electronica/screens/image_viewer_screen.dart'; // ¡NUEVO! Importa la pantalla de visualización de imagen

const String _parallelTitle = 'Puerto Paralelo (LPT)';
const String _parallelImagePath = 'assets/images/pinouts/parallel_port.png';
const String _parallelDescription =
    'El puerto paralelo (IEEE 1284) permite la transmisión de datos en paralelo (8 bits simultáneos). Se usaba principalmente para impresoras, escáneres y dispositivos de almacenamiento.';

const List<Map<String, dynamic>> _parallelDetails = [
  {
    'section_title': 'Conector DB25 (IEEE 1284) - Vista frontal',
    'table_data': [
      {
        'pin': '1',
        'name': 'STROBE',
        'description': 'Strobe (Activación)',
        'color': 'Rojo',
      },
      {
        'pin': '2',
        'name': 'D0',
        'description': 'Data Bit 0',
        'color': 'Amarillo',
      },
      {'pin': '3', 'name': 'D1', 'description': 'Data Bit 1', 'color': 'Verde'},
      {'pin': '4', 'name': 'D2', 'description': 'Data Bit 2', 'color': 'Azul'},
      {
        'pin': '5',
        'name': 'D3',
        'description': 'Data Bit 3',
        'color': 'Morado',
      },
      {
        'pin': '6',
        'name': 'D4',
        'description': 'Data Bit 4',
        'color': 'Naranja',
      },
      {
        'pin': '7',
        'name': 'D5',
        'description': 'Data Bit 5',
        'color': 'Marrón',
      },
      {'pin': '8', 'name': 'D6', 'description': 'Data Bit 6', 'color': 'Negro'},
      {
        'pin': '9',
        'name': 'D7',
        'description': 'Data Bit 7',
        'color': 'Blanco',
      },
      {
        'pin': '10',
        'name': 'ACK',
        'description': 'Acknowledge (Confirmación)',
        'color': 'Gris',
      },
      {
        'pin': '11',
        'name': 'BUSY',
        'description': 'Busy (Ocupado)',
        'color': 'Rosado',
      },
      {
        'pin': '12',
        'name': 'PE',
        'description': 'Paper End (Fin de papel)',
        'color': 'Turquesa',
      },
      {
        'pin': '13',
        'name': 'SLCT',
        'description': 'Select (Selección)',
        'color': 'Verde oscuro',
      },
      {
        'pin': '14',
        'name': 'AUTOFD',
        'description': 'Auto Feed (Alimentación automática)',
        'color': 'Azul claro',
      },
      {
        'pin': '15',
        'name': 'ERROR',
        'description': 'Error',
        'color': 'Rojo oscuro',
      },
      {
        'pin': '16',
        'name': 'INIT',
        'description': 'Initialize (Inicialización)',
        'color': 'Amarillo oscuro',
      },
      {
        'pin': '17',
        'name': 'SLCTIN',
        'description': 'Select In (Selección entrada)',
        'color': 'Violeta',
      },
      {
        'pin': '18-25',
        'name': 'GND',
        'description': 'Ground (Tierra)',
        'color': 'Negro',
      },
    ],
  },
];

class ParallelDetailScreen extends StatelessWidget {
  const ParallelDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(_parallelTitle),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // MODIFICACIÓN: Imagen principal con GestureDetector y Hero
            Hero(
              tag: _parallelImagePath, // El tag debe ser único
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImageViewerScreen(
                        imagePath: _parallelImagePath,
                        title:
                            _parallelTitle, // Pasa el título para la pantalla de zoom
                      ),
                    ),
                  );
                },
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.asset(_parallelImagePath, fit: BoxFit.contain),
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
              _parallelDescription,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface,
                height: 1.5,
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 24),
            Text(
              'Detalles de Pines:',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ..._parallelDetails.map((section) {
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
                    (section['table_data'] as List<dynamic>)
                        .cast<Map<String, String>>(),
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

  Widget _buildPinoutTable(
    List<Map<String, String>> data,
    BuildContext context,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return DataTable(
      decoration: BoxDecoration(border: Border.all(color: colorScheme.outline)),
      headingRowColor: WidgetStateProperty.all(colorScheme.primaryContainer),
      columns: const [
        DataColumn(label: Text('Pin')),
        DataColumn(label: Text('Nombre')),
        DataColumn(label: Text('Descripción')),
        DataColumn(label: Text('Color')),
      ],
      rows: data
          .map(
            (pin) => DataRow(
              color: WidgetStateProperty.resolveWith<Color?>(
                (Set<WidgetState> states) =>
                    states.contains(WidgetState.hovered)
                    ? colorScheme.primary.withValues(alpha: 0.1)
                    : null,
              ),
              cells: [
                DataCell(Text(pin['pin']!)),
                DataCell(Text(pin['name']!)),
                DataCell(Text(pin['description']!)),
                DataCell(Text(pin['color']!)),
              ],
            ),
          )
          .toList(),
    );
  }
}
