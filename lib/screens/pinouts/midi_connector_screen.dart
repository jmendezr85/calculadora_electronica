// lib/screens/pinouts/midi_connector_screen.dart
import 'package:flutter/material.dart';
import 'package:calculadora_electronica/screens/image_viewer_screen.dart';

const String _midiConnectorTitle =
    'Conector MIDI (Musical Instrument Digital Interface)';
const String _midiConnectorImagePath =
    'assets/images/pinouts/midi_connector.png';
const String _midiConnectorDescription =
    'El conector MIDI de 5 pines (DIN 41524) es un estándar de la industria para la comunicación entre una amplia variedad de instrumentos musicales electrónicos y equipos de audio. Es un protocolo digital que permite a dispositivos como teclados, secuenciadores y computadoras comunicarse entre sí, transmitiendo datos como notas musicales, velocidad, volumen y otros parámetros de control.\n\n'
    'Aunque el conector físicamente tiene 5 pines, el protocolo MIDI solo utiliza 3 para la comunicación de datos, creando un lazo de corriente ópticamente aislado. Los pines 1 y 3 no tienen una función definida en el estándar y no se utilizan en la mayoría de las implementaciones.';

// --- MODELOS DE DATOS ---
/// Clase para representar un pin del conector MIDI.
class MidiPin {
  final int number;
  final String description;
  final String notes;

  MidiPin({
    required this.number,
    required this.description,
    required this.notes,
  });
}

// --- DATOS CENTRALIZADOS ---
final List<MidiPin> _midiPins = [
  MidiPin(
    number: 1,
    description: 'Pin no utilizado',
    notes:
        'Reservado, no conectado internamente en la mayoría de los dispositivos.',
  ),
  MidiPin(
    number: 2,
    description: 'Tierra (GND)',
    notes: 'Conexión a tierra o blindaje del cable.',
  ),
  MidiPin(
    number: 3,
    description: 'Pin no utilizado',
    notes:
        'Reservado, no conectado internamente en la mayoría de los dispositivos.',
  ),
  MidiPin(
    number: 4,
    description: 'Corriente positiva (+5V)',
    notes:
        'Suministra 5V al circuito de entrada del dispositivo receptor. Se usa para transmitir datos.',
  ),
  MidiPin(
    number: 5,
    description: 'Corriente de datos',
    notes:
        'Transmisión de los datos MIDI. Es el pin principal de comunicación.',
  ),
];

final List<Map<String, dynamic>> _midiSections = [
  {
    'section_title': 'Pinout del Conector (DIN 5 pines)',
    'description':
        'Aunque el conector DIN 5 físicamente tiene 5 pines, el protocolo MIDI solo utiliza 3 para la comunicación de datos, creando un lazo de corriente ópticamente aislado.',
    'pin_details': _midiPins,
  },
  {
    'section_title': 'Protocolo y Mensajes MIDI',
    'description':
        'El protocolo MIDI es una serie de mensajes que se transmiten en serie a 31.25 kbaudios. Los mensajes se dividen en dos categorías principales:',
    'list_data': const [
      {
        'title': 'Mensajes de Canal (Channel Messages)',
        'details':
            'Estos mensajes se usan para enviar datos a un canal MIDI específico. Son los más comunes en la práctica musical y controlan la reproducción de notas, la presión del teclado (aftertouch), los controladores de cambio (CC) y los cambios de programa.\n\n'
            'Ejemplos:\n• **Note On:** Inicia una nota musical con una cierta velocidad.\n• **Note Off:** Detiene una nota.\n• **Program Change:** Cambia el sonido del instrumento (por ejemplo, de piano a guitarra).\n• **Control Change (CC):** Modifica parámetros como el volumen, la panorámica o la modulación.',
      },
      {
        'title': 'Mensajes del Sistema (System Messages)',
        'details':
            'Estos mensajes no están asociados a un canal específico y se dirigen a todos los dispositivos en la cadena. Se utilizan para funciones de sincronización y control de la sesión completa.\n\n'
            'Ejemplos:\n• **System Exclusive (SysEx):** Mensajes personalizados para un fabricante o modelo de instrumento específico.\n• **Timing Clock:** Sincroniza el tempo entre dispositivos.',
      },
    ],
  },
  {
    'section_title': 'MIDI Clásico (5 pines) vs. USB-MIDI',
    'description':
        'La interfaz MIDI original de 5 pines sigue siendo el estándar, pero la mayoría de los dispositivos modernos utilizan USB-MIDI, que ofrece varias ventajas:',
    'list_data': const [
      {
        'title': 'Velocidad y Ancho de Banda',
        'details':
            '**MIDI Clásico:** Velocidad fija de 31.25 kbaudios. Suficiente para la mayoría de los casos, pero puede tener latencia en cadenas largas.\n**USB-MIDI:** Mucho más rápido, aprovechando las velocidades de USB. Esto permite una transmisión masiva de datos y reduce la latencia.',
      },
      {
        'title': 'Alimentación (Power)',
        'details':
            '**MIDI Clásico:** No proporciona alimentación al dispositivo receptor.\n**USB-MIDI:** El puerto USB puede alimentar el dispositivo MIDI (bus-powered), eliminando la necesidad de una fuente de alimentación externa en muchos casos.',
      },
      {
        'title': 'Configuración (Plug and Play)',
        'details':
            '**MIDI Clásico:** Requiere interfaces MIDI dedicadas en la computadora.\n**USB-MIDI:** Es "plug-and-play". La mayoría de los sistemas operativos modernos reconocen y configuran automáticamente los dispositivos USB-MIDI.',
      },
    ],
  },
  {
    'section_title': 'Recomendaciones Prácticas',
    'description':
        'Aunque el conector MIDI es un estándar robusto, seguir estas recomendaciones puede ayudarte a evitar problemas y garantizar un funcionamiento óptimo en tu estudio:',
    'list_data': const [
      {
        'title': 'Usar Cables de Calidad',
        'details':
            'Utiliza cables MIDI apantallados de buena calidad. Los cables de baja calidad o demasiado largos pueden introducir ruido o causar una pérdida de señal, lo que se traduce en datos perdidos o un rendimiento inestable.',
      },
      {
        'title': 'Evitar Trazos de Cables Largos',
        'details':
            'Se recomienda mantener los cables MIDI por debajo de los 15 metros para evitar la degradación de la señal. Para distancias mayores, considera usar extensores o conversores de MIDI a Ethernet.',
      },
      {
        'title': 'Entender el Bucle MIDI',
        'details':
            'Cuando conectas múltiples dispositivos MIDI en cadena (OUT -> IN -> OUT -> IN), se puede crear un bucle de datos MIDI si el dispositivo final retransmite los datos al inicio. Para evitarlo, desconecta los cables MIDI innecesarios o utiliza la función de "MIDI Filter" si está disponible en tu equipo.',
      },
      {
        'title': 'Utilizar Dispositivos de Enrutamiento MIDI',
        'details':
            'Para estudios con muchos equipos, considera usar una "MIDI Thru box" o una "MIDI Merger". La Thru Box toma una entrada MIDI y la envía a múltiples salidas. El Merger toma varias entradas MIDI y las combina en una sola salida, evitando problemas de conexión en cadena.',
      },
    ],
  },
];

class MidiConnectorScreen extends StatelessWidget {
  const MidiConnectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(_midiConnectorTitle),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Sección de imagen principal y descripción
            _buildMainImage(context),
            const SizedBox(height: 24),
            _buildDescription(context),
            const SizedBox(height: 24),

            // Iterar sobre las secciones de información
            ..._midiSections.map((section) {
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
                      section['pin_details'] as List<MidiPin>,
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
      tag: _midiConnectorImagePath,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ImageViewerScreen(
                imagePath: _midiConnectorImagePath,
                title: _midiConnectorTitle,
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
          child: Image.asset(_midiConnectorImagePath, fit: BoxFit.contain),
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
          _midiConnectorDescription,
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurface,
            height: 1.5,
          ),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }

  Widget _buildPinoutTable(BuildContext context, List<MidiPin> pins) {
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
                'Descripción',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                'Notas',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
          rows: pins
              .map(
                (pin) => DataRow(
                  cells: [
                    DataCell(Text(pin.number.toString())),
                    DataCell(Text(pin.description)),
                    DataCell(Text(pin.notes)),
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
