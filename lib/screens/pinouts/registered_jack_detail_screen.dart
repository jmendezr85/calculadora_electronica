// lib/screens/pinouts/registered_jack_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:calculadora_electronica/screens/image_viewer_screen.dart'; // ¡NUEVO! Importa la pantalla de visualización de imagen

// Datos específicos del Jack Registrado, definidos directamente en esta pantalla.
const String _rjTitle = 'Jack Registrado (RJ)';
const String _rjImagePath = 'assets/images/pinouts/registered_jack.png';
const String _rjDescription =
    'Los Jacks Registrados (RJ) son un tipo de conector estandarizado utilizado para la interconexión de equipos de telecomunicaciones. Los más comunes son el RJ-11 (para líneas telefónicas) y el RJ-45 (para redes Ethernet). Aunque visualmente similares, difieren en tamaño, número de pines y sus aplicaciones. Son cruciales para la infraestructura de comunicación de voz y datos.';

const List<Map<String, dynamic>> _rjDetails = [
  {
    'section_title': 'Conector RJ-45 (8P8C)',
    'table_data': [
      {'pin': '1', 'function': 'Transmisión (+)', 'color': 'Blanco/Naranja'},
      {'pin': '2', 'function': 'Transmisión (-)', 'color': 'Naranja'},
      {'pin': '3', 'function': 'Recepción (+)', 'color': 'Blanco/Verde'},
      {'pin': '4', 'function': 'Sin Uso', 'color': 'Azul'},
      {'pin': '5', 'function': 'Sin Uso', 'color': 'Blanco/Azul'},
      {'pin': '6', 'function': 'Recepción (-)', 'color': 'Verde'},
      {'pin': '7', 'function': 'Sin Uso', 'color': 'Blanco/Marrón'},
      {'pin': '8', 'function': 'Sin Uso', 'color': 'Marrón'},
    ],
  },
  {
    'section_title': 'Conector RJ-11 (6P4C)',
    'table_data': [
      {'pin': '1', 'function': 'Sin Uso', 'color': 'Blanco'},
      {'pin': '2', 'function': 'Tip (-)', 'color': 'Negro'},
      {'pin': '3', 'function': 'Ring (+)', 'color': 'Rojo'},
      {'pin': '4', 'function': 'Tip (-)', 'color': 'Verde'},
      {'pin': '5', 'function': 'Sin Uso', 'color': 'Amarillo'},
      {'pin': '6', 'function': 'Sin Uso', 'color': 'Azul'},
    ],
  },
];

// Función auxiliar para obtener el objeto Color o lista de Colores a partir de un nombre de color.
// El primer color será el base, el segundo (si existe) será la franja.
List<Color> _getColorsForCable(String colorName) {
  switch (colorName.toLowerCase()) {
    case 'negro':
      return [Colors.black];
    case 'rojo':
      return [Colors.red];
    case 'verde':
      return [Colors.green];
    case 'amarillo':
      return [Colors.yellow];
    case 'blanco/naranja':
      return [Colors.white, Colors.orange];
    case 'naranja':
      return [Colors.orange];
    case 'blanco/verde':
      return [Colors.white, Colors.green];
    case 'azul':
      return [Colors.blue];
    case 'blanco/azul':
      return [Colors.white, Colors.blue];
    case 'blanco/marrón':
      return [Colors.white, Colors.brown];
    case 'marrón':
      return [Colors.brown];
    case 'blanco':
      return [Colors.white];
    default:
      return [Colors.grey.shade400];
  }
}

class RegisteredJackDetailScreen extends StatelessWidget {
  const RegisteredJackDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(_rjTitle),
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
              tag: _rjImagePath,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImageViewerScreen(
                        imagePath: _rjImagePath,
                        title: _rjTitle,
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
                  child: Image.asset(_rjImagePath, fit: BoxFit.contain),
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
              _rjDescription,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface,
                height: 1.5,
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 24),
            ..._rjDetails.map((section) {
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
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
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
            label: Text('Pin', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          DataColumn(
            label: Text(
              'Función',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text('Color', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
        rows: data.map((pin) {
          final colors = _getColorsForCable(pin['color']!);
          final baseColor = colors.first;
          final stripeColor = colors.length > 1 ? colors[1] : null;

          Color textColor = baseColor.computeLuminance() > 0.5
              ? Colors.black
              : Colors.white;

          return DataRow(
            cells: <DataCell>[
              DataCell(Text(pin['pin']!)),
              DataCell(
                ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 80),
                  child: Text(
                    pin['function']!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodyMedium,
                  ),
                ),
              ),
              DataCell(
                Container(
                  width: 80,
                  height: 40,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(
                    vertical: 4.0,
                    horizontal: 4.0,
                  ),
                  decoration: BoxDecoration(
                    color: baseColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade400, width: 0.5),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (stripeColor != null)
                        Container(
                          width: 8,
                          decoration: BoxDecoration(
                            color: stripeColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      Text(
                        pin['color']!,
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
