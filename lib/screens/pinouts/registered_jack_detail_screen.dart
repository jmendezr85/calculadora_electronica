// lib/screens/pinouts/registered_jack_detail_screen.dart
import 'package:flutter/material.dart';

// Datos específicos del Jack Registrado, definidos directamente en esta pantalla.
const String _rjTitle = 'Jack Registrado (RJ)';
const String _rjImagePath = 'assets/images/pinouts/registered_jack.png';
const String _rjDescription =
    'Los Jacks Registrados (RJ) son un tipo de conector estandarizado utilizado para la interconexión de equipos de telecomunicaciones. Los más comunes son el RJ-11 (para líneas telefónicas) y el RJ-45 (para redes Ethernet). Aunque visualmente similares, difieren en tamaño, número de pines y sus aplicaciones. Son cruciales para la infraestructura de comunicación de voz y datos.';

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
      return [Colors.white, Colors.orange]; // Base: Blanco, Franja: Naranja
    case 'naranja':
      return [Colors.orange];
    case 'blanco/verde':
      return [Colors.white, Colors.green]; // Base: Blanco, Franja: Verde
    case 'azul':
      return [Colors.blue];
    case 'blanco/azul':
      return [Colors.white, Colors.blue]; // Base: Blanco, Franja: Azul
    case 'blanco/marrón':
      return [Colors.white, Colors.brown]; // Base: Blanco, Franja: Marrón
    case 'marrón':
      return [Colors.brown];
    default:
      return [
        Colors.grey.shade300,
      ]; // Color por defecto para "No Conectado" o desconocido
  }
}

const List<Map<String, dynamic>> _rjDetails = [
  {
    'section_title': 'Conector RJ-11 (6P2C/6P4C) - Vista frontal',
    'table_data': [
      {
        'pin': '1',
        'name': 'NC',
        'description': 'No Conectado',
        'color': '--', // Se usará gris por defecto
      },
      {
        'pin': '2',
        'name': 'Tip (R-)',
        'description': 'Anillo - Línea 1',
        'color': 'Negro',
      },
      {
        'pin': '3',
        'name': 'Ring (T+)',
        'description': 'Punta - Línea 1',
        'color': 'Rojo',
      },
      {
        'pin': '4',
        'name': 'Tip (R-)',
        'description': 'Anillo - Línea 2',
        'color': 'Verde',
      },
      {
        'pin': '5',
        'name': 'Ring (T+)',
        'description': 'Punta - Línea 2',
        'color': 'Amarillo',
      },
      {
        'pin': '6',
        'name': 'NC',
        'description': 'No Conectado',
        'color': '--', // Se usará gris por defecto
      },
    ],
  },
  {
    'section_title': 'Conector RJ-45 (8P8C) - Estándar T568B (más común)',
    'table_data': [
      {
        'pin': '1',
        'name': 'TX+',
        'description': 'Transmisión de Datos Positivo',
        'color': 'Blanco/Naranja',
      },
      {
        'pin': '2',
        'name': 'TX-',
        'description': 'Transmisión de Datos Negativo',
        'color': 'Naranja',
      },
      {
        'pin': '3',
        'name': 'RX+',
        'description': 'Recepción de Datos Positivo',
        'color': 'Blanco/Verde',
      },
      {
        'pin': '4',
        'name': 'NC',
        'description': 'No Conectado (para Gigabit Ethernet es BI_D+)',
        'color': 'Azul',
      },
      {
        'pin': '5',
        'name': 'NC',
        'description': 'No Conectado (para Gigabit Ethernet es BI_D-)',
        'color': 'Blanco/Azul',
      },
      {
        'pin': '6',
        'name': 'RX-',
        'description': 'Recepción de Datos Negativo',
        'color': 'Verde',
      },
      {
        'pin': '7',
        'name': 'NC',
        'description': 'No Conectado (para Gigabit Ethernet es BI_C+)',
        'color': 'Blanco/Marrón',
      },
      {
        'pin': '8',
        'name': 'NC',
        'description': 'No Conectado (para Gigabit Ethernet es BI_C-)',
        'color': 'Marrón',
      },
    ],
  },
  {
    'section_title': 'Conector RJ-45 (8P8C) - Estándar T568A',
    'table_data': [
      {
        'pin': '1',
        'name': 'TX+',
        'description': 'Transmisión de Datos Positivo',
        'color': 'Blanco/Verde',
      },
      {
        'pin': '2',
        'name': 'TX-',
        'description': 'Transmisión de Datos Negativo',
        'color': 'Verde',
      },
      {
        'pin': '3',
        'name': 'RX+',
        'description': 'Recepción de Datos Positivo',
        'color': 'Blanco/Naranja',
      },
      {
        'pin': '4',
        'name': 'NC',
        'description': 'No Conectado (para Gigabit Ethernet es BI_D+)',
        'color': 'Azul',
      },
      {
        'pin': '5',
        'name': 'NC',
        'description': 'No Conectado (para Gigabit Ethernet es BI_D-)',
        'color': 'Blanco/Azul',
      },
      {
        'pin': '6',
        'name': 'RX-',
        'description': 'Recepción de Datos Negativo',
        'color': 'Naranja',
      },
      {
        'pin': '7',
        'name': 'NC',
        'description': 'No Conectado (para Gigabit Ethernet es BI_C+)',
        'color': 'Blanco/Marrón',
      },
      {
        'pin': '8',
        'name': 'NC',
        'description': 'No Conectado (para Gigabit Ethernet es BI_C-)',
        'color': 'Marrón',
      },
    ],
  },
];

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
              child: Image.asset(_rjImagePath, fit: BoxFit.contain),
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

            // Detalles de pines para los conectores RJ
            Text(
              'Detalles de Pines:',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
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

  // Método auxiliar para construir la tabla de pines con aspecto de cable
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
        final pinColors = _getColorsForCable(pin['color']!);
        final baseColor = pinColors[0];
        final stripeColor = pinColors.length > 1 ? pinColors[1] : null;

        // Determina el color del texto basado en la luminancia del color base.
        final textColor = baseColor.computeLuminance() > 0.5
            ? Colors.black
            : Colors.white;

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
            DataCell(
              Container(
                // Fondo para el 'cable' con bordes redondeados
                decoration: BoxDecoration(
                  color: baseColor, // Color base del cable
                  borderRadius: BorderRadius.circular(
                    8,
                  ), // Bordes más redondeados para "cable"
                  border: Border.all(color: Colors.grey.shade400, width: 0.5),
                ),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(
                  horizontal: 4.0,
                ), // Padding para el texto
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Franja del cable (si existe)
                    if (stripeColor != null)
                      Container(
                        width: 8, // Ancho de la franja
                        decoration: BoxDecoration(
                          color: stripeColor, // Color de la franja
                          borderRadius: BorderRadius.circular(
                            4,
                          ), // Bordes redondeados para la franja
                        ),
                      ),
                    // Texto del nombre del color, superpuesto
                    Text(
                      pin['color']!,
                      style: TextStyle(
                        color: textColor, // Color del texto (negro o blanco)
                        fontWeight: FontWeight.bold,
                        fontSize:
                            10, // Tamaño de fuente más pequeño para que quepa bien
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1, // Evitar que el texto se salga
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
