// lib/screens/pinouts/iso_connector_screen.dart
import 'package:calculadora_electronica/screens/image_viewer_screen.dart';
import 'package:flutter/material.dart';

const String _isoConnectorTitle = 'Conector ISO para Estéreos de Automóvil';
const String _isoConnectorImagePath = 'assets/images/pinouts/iso_connector.png';
const String _isoConnectorDescription =
    'El conector ISO 10487 es un estándar de la industria para conectar las unidades principales (estéreos) de los automóviles. Se divide en dos conectores principales: un conector de alimentación (a menudo llamado ISO A) y un conector de altavoces (ISO B). Esto estandariza las conexiones de energía, tierra, antena y las 8 salidas de altavoces, simplificando la instalación y el reemplazo de estéreos de diferentes fabricantes sin necesidad de cortar o empalmar cables. Un tercer conector (ISO C) es opcional y se utiliza para funciones adicionales como cambiadores de CD, entradas auxiliares o amplificadores externos.';

// --- MODELOS DE DATOS ---
/// Clase para representar un pin del conector ISO.
class IsoPin {
  final String connector;
  final int pin;
  final String function;
  final String description;

  IsoPin({
    required this.connector,
    required this.pin,
    required this.function,
    required this.description,
  });
}

// --- DATOS CENTRALIZADOS ---
final List<IsoPin> _isoPins = [
  IsoPin(
    connector: 'ISO A (Alimentación)',
    pin: 1,
    function: 'Velocidad del Vehículo',
    description: 'Opcional. Señal de velocidad del vehículo (VSS).',
  ),
  IsoPin(
    connector: 'ISO A (Alimentación)',
    pin: 2,
    function: 'Teléfono Mute',
    description: 'Opcional. Silencia el audio cuando hay una llamada.',
  ),
  IsoPin(
    connector: 'ISO A (Alimentación)',
    pin: 3,
    function: 'Sin asignar',
    description: 'Reservado.',
  ),
  IsoPin(
    connector: 'ISO A (Alimentación)',
    pin: 4,
    function: 'Memoria (+12V)',
    description:
        'Energía constante de la batería para la memoria del estéreo (relojes, preajustes).',
  ),
  IsoPin(
    connector: 'ISO A (Alimentación)',
    pin: 5,
    function: 'Antena / AMP',
    description:
        'Salida de 12V para encender la antena eléctrica o un amplificador externo.',
  ),
  IsoPin(
    connector: 'ISO A (Alimentación)',
    pin: 6,
    function: 'Iluminación',
    description:
        'Señal para atenuar la pantalla del estéreo con las luces del auto.',
  ),
  IsoPin(
    connector: 'ISO A (Alimentación)',
    pin: 7,
    function: 'Ignición (+12V)',
    description:
        'Energía conmutada, se enciende y apaga con la llave de encendido.',
  ),
  IsoPin(
    connector: 'ISO A (Alimentación)',
    pin: 8,
    function: 'Tierra (GND)',
    description: 'Conexión a tierra del chasis del vehículo.',
  ),
  IsoPin(
    connector: 'ISO B (Altavoces)',
    pin: 1,
    function: 'Trasero Derecho +',
    description: 'Salida del altavoz trasero derecho, positiva.',
  ),
  IsoPin(
    connector: 'ISO B (Altavoces)',
    pin: 2,
    function: 'Trasero Derecho -',
    description: 'Salida del altavoz trasero derecho, negativa.',
  ),
  IsoPin(
    connector: 'ISO B (Altavoces)',
    pin: 3,
    function: 'Delantero Derecho +',
    description: 'Salida del altavoz delantero derecho, positiva.',
  ),
  IsoPin(
    connector: 'ISO B (Altavoces)',
    pin: 4,
    function: 'Delantero Derecho -',
    description: 'Salida del altavoz delantero derecho, negativa.',
  ),
  IsoPin(
    connector: 'ISO B (Altavoces)',
    pin: 5,
    function: 'Delantero Izquierdo +',
    description: 'Salida del altavoz delantero izquierdo, positiva.',
  ),
  IsoPin(
    connector: 'ISO B (Altavoces)',
    pin: 6,
    function: 'Delantero Izquierdo -',
    description: 'Salida del altavoz delantero izquierdo, negativa.',
  ),
  IsoPin(
    connector: 'ISO B (Altavoces)',
    pin: 7,
    function: 'Trasero Izquierdo +',
    description: 'Salida del altavoz trasero izquierdo, positiva.',
  ),
  IsoPin(
    connector: 'ISO B (Altavoces)',
    pin: 8,
    function: 'Trasero Izquierdo -',
    description: 'Salida del altavoz trasero izquierdo, negativa.',
  ),
];

final List<Map<String, dynamic>> _isoConnectorSections = [
  {
    'section_title': 'Pinout del Conector ISO A (Alimentación y Control)',
    'description':
        'Este conector de 8 pines es el más importante para la instalación. Suministra energía (constante y conmutada), tierra y algunas señales de control para el estéreo.',
    'pin_details': _isoPins
        .where((pin) => pin.connector == 'ISO A (Alimentación)')
        .toList(),
  },
  {
    'section_title': 'Pinout del Conector ISO B (Altavoces)',
    'description':
        'Este conector maneja las 8 salidas para los altavoces, divididas en 4 pares estéreo (delantero izquierdo/derecho y trasero izquierdo/derecho). Es crucial para la calidad de sonido y la correcta polaridad.',
    'pin_details': _isoPins
        .where((pin) => pin.connector == 'ISO B (Altavoces)')
        .toList(),
  },
  {
    'section_title': 'Recomendaciones de Instalación',
    'description':
        'Aunque el estándar ISO simplifica la instalación, es importante seguir algunas prácticas para evitar daños al estéreo o al vehículo:',
    'list_data': const [
      {
        'title': 'Verificar Voltajes',
        'details':
            'Antes de conectar un nuevo estéreo, usa un multímetro para verificar que el pin de **Memoria (+12V)** tiene energía constante y que el pin de **Ignición (+12V)** solo tiene energía cuando la llave está encendida. Esto previene que la batería se descargue.',
      },
      {
        'title': 'Cuidado con la Polaridad de los Altavoces',
        'details':
            'Asegúrate de conectar las terminales positivas (+) y negativas (-) de los altavoces correctamente. Conectar la polaridad invertida en un altavoz hará que se mueva en dirección opuesta, lo que puede afectar la calidad del sonido y la imagen estéreo, además de causar una posible cancelación de fase en graves.',
      },
      {
        'title': 'Adaptadores para Marcas Específicas',
        'details':
            'Algunos vehículos utilizan un arnés de cables propietario que no coincide con el estándar ISO. En estos casos, se necesita un adaptador de arnés específico para la marca y modelo del vehículo. Esto permite usar el estéreo ISO sin cortar el cableado original del auto.',
      },
      {
        'title': 'Fusibles de Protección',
        'details':
            'Asegúrate de que el fusible de tu estéreo y el del vehículo estén correctamente instalados y con el amperaje adecuado para evitar sobrecargas o cortocircuitos que puedan dañar el sistema eléctrico del auto.',
      },
    ],
  },
];

class IsoConnectorScreen extends StatelessWidget {
  const IsoConnectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(_isoConnectorTitle),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildMainImage(context),
            const SizedBox(height: 24),
            _buildDescription(context),
            const SizedBox(height: 24),

            ..._isoConnectorSections.map((section) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    section['section_title']!,
                    style: textTheme.headlineSmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (section.containsKey('description'))
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Text(
                        section['description']!,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  const SizedBox(height: 12),
                  if (section.containsKey('pin_details'))
                    _buildPinoutTable(
                      context,
                      section['pin_details'] as List<IsoPin>,
                    ),
                  if (section.containsKey('list_data'))
                    _buildExpandableList(
                      context,
                      section['list_data'] as List<Map<String, String>>,
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

  // --- MÉTODOS PRIVADOS PARA CONSTRUIR WIDGETS ---

  Widget _buildMainImage(BuildContext context) {
    return Hero(
      tag: _isoConnectorImagePath,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (context) => const ImageViewerScreen(
                imagePath: _isoConnectorImagePath,
                title: _isoConnectorTitle,
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
          child: Image.asset(_isoConnectorImagePath, fit: BoxFit.contain),
        ),
      ),
    );
  }

  Widget _buildDescription(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Descripción General:',
          style: textTheme.headlineSmall?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _isoConnectorDescription,
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurface,
            height: 1.5,
          ),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }

  Widget _buildPinoutTable(BuildContext context, List<IsoPin> pins) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DataTable(
          columnSpacing: 10,
          dataRowMinHeight: 40,
          dataRowMaxHeight: 60,
          headingRowColor: WidgetStateProperty.all(
            colorScheme.tertiaryContainer,
          ),
          border: TableBorder.all(
            color: colorScheme.outlineVariant,
            width: 0.5,
            borderRadius: BorderRadius.circular(8),
          ),
          columns: const [
            DataColumn(
              label: Text('Pin', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            DataColumn(
              label: Text(
                'Conector',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                'Función',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
          rows: pins
              .map(
                (pin) => DataRow(
                  cells: [
                    DataCell(Text(pin.pin.toString())),
                    DataCell(Text(pin.connector)),
                    DataCell(Text(pin.function)),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildExpandableList(
    BuildContext context,
    List<Map<String, String>> data,
  ) {
    return Column(
      children: data.map((item) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6.0),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ExpansionTile(
            title: Text(
              item['title']!,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            childrenPadding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            children: [
              Text(
                item['details']!,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
