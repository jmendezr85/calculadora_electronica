// lib/screens/pinouts/obd_ii_connector_screen.dart
import 'package:calculadora_electronica/screens/image_viewer_screen.dart';
import 'package:flutter/material.dart';

const String _obdIititle = 'Conector OBD-II (On-Board Diagnostics II)';
const String _obdIiImagePath = 'assets/images/pinouts/obd_ii_connector.png';
const String _obdIiDescription =
    'El conector OBD-II es un puerto estandarizado que se encuentra en todos los vehículos fabricados a partir de 1996 en Estados Unidos, y en la mayoría de los vehículos a nivel global desde el año 2000. Su función principal es proporcionar un punto de acceso para diagnosticar y monitorear el sistema de control del motor y las emisiones del vehículo. Este conector de 16 pines permite a los técnicos y a los propietarios del vehículo acceder a información clave, como códigos de falla, datos del sensor en tiempo real y otros parámetros importantes.';

// --- MODELOS DE DATOS ---
/// Clase para representar un pin del conector OBD-II.
class ObdIiPin {
  final int number;
  final String function;
  final String description;

  ObdIiPin({
    required this.number,
    required this.function,
    required this.description,
  });
}

// --- DATOS CENTRALIZADOS ---
final List<ObdIiPin> _obdIiPins = [
  ObdIiPin(
    number: 1,
    function: 'Bus discreto J1850 / V-CAN+',
    description: 'Usado por el fabricante. Protocolo J1850 PWM (Ford) o CAN.',
  ),
  ObdIiPin(
    number: 2,
    function: 'Bus de línea J1850+',
    description: 'Usado en el protocolo J1850 VPW.',
  ),
  ObdIiPin(
    number: 3,
    function: 'Bus discreto J1850 / V-CAN-',
    description: 'Usado por el fabricante. Protocolo J1850 PWM (Ford) o CAN.',
  ),
  ObdIiPin(
    number: 4,
    function: 'Tierra del Chasis (GND)',
    description: 'Conexión a tierra del chasis del vehículo.',
  ),
  ObdIiPin(
    number: 5,
    function: 'Tierra de Señal (GND)',
    description: 'Tierra para las señales de comunicación.',
  ),
  ObdIiPin(
    number: 6,
    function: 'CAN High (J-2284)',
    description: 'Línea de datos CAN de alta velocidad.',
  ),
  ObdIiPin(
    number: 7,
    function: 'K-Line (ISO 9141-2 / ISO 14230)',
    description: 'Línea de comunicación bidireccional (KWP2000).',
  ),
  ObdIiPin(
    number: 8,
    function: 'Bus discreto',
    description: 'Usado por el fabricante.',
  ),
  ObdIiPin(
    number: 9,
    function: 'Bus discreto',
    description: 'Usado por el fabricante.',
  ),
  ObdIiPin(
    number: 10,
    function: 'Bus de línea J1850-',
    description: 'Usado en el protocolo J1850 VPW.',
  ),
  ObdIiPin(
    number: 11,
    function: 'Bus discreto',
    description: 'Usado por el fabricante.',
  ),
  ObdIiPin(
    number: 12,
    function: 'Bus discreto',
    description: 'Usado por el fabricante.',
  ),
  ObdIiPin(
    number: 13,
    function: 'Bus discreto',
    description: 'Usado por el fabricante.',
  ),
  ObdIiPin(
    number: 14,
    function: 'CAN Low (J-2284)',
    description: 'Línea de datos CAN de baja velocidad.',
  ),
  ObdIiPin(
    number: 15,
    function: 'L-Line (ISO 9141-2 / ISO 14230)',
    description: 'Línea opcional para inicialización o diagnóstico.',
  ),
  ObdIiPin(
    number: 16,
    function: 'Energía de la Batería (+12V)',
    description: 'Fuente de alimentación directa de la batería del vehículo.',
  ),
];

final List<Map<String, dynamic>> _obdIiSections = [
  {
    'section_title': 'Pinout del Conector',
    'description':
        'El conector OBD-II tiene 16 pines, cada uno con una función específica para la comunicación y alimentación. La mayoría de los pines del 1, 3, 8, 9, 11, 12 y 13 están reservados para los fabricantes para usos específicos del vehículo, pero otros como el pin 16 (alimentación) y los pines 4 y 5 (tierra) son estándar.',
    'pin_details': _obdIiPins,
  },
  {
    'section_title': 'Protocolos de Comunicación',
    'description':
        'El estándar OBD-II soporta varios protocolos, aunque el conector físico es el mismo. Un escáner de diagnóstico debe ser capaz de identificar y comunicarse con el protocolo correcto del vehículo:',
    'list_data': const [
      {
        'title': 'SAE J1850 PWM (Pulse Width Modulation)',
        'details':
            'Protocolo de 41.6 kbaudios, usado comúnmente por Ford. Utiliza los pines 2 y 10. Se basa en la modulación del ancho de pulso para la transmisión de datos.',
      },
      {
        'title': 'SAE J1850 VPW (Variable Pulse Width)',
        'details':
            'Protocolo de 10.4 kbaudios, usado principalmente por General Motors. También utiliza el pin 2, pero sin el pin 10.',
      },
      {
        'title': 'ISO 9141-2',
        'details':
            'Protocolo común en vehículos europeos y asiáticos. Utiliza los pines 7 (K-Line) y 15 (L-Line, opcional). Es similar a una comunicación serial asincrónica.',
      },
      {
        'title': 'ISO 14230 KWP2000 (Keyword Protocol 2000)',
        'details':
            'Una mejora del ISO 9141-2, también usado en vehículos europeos y asiáticos. Se basa en el pin 7 (K-Line) y a menudo es más rápido que el estándar ISO 9141-2.',
      },
      {
        'title': 'ISO 15765 CAN (Controller Area Network)',
        'details':
            'El protocolo más moderno y rápido, estandarizado en todos los vehículos a partir de 2008. Usa los pines 6 (CAN High) y 14 (CAN Low), permitiendo una comunicación de alta velocidad y un sistema de diagnóstico muy eficiente.',
      },
    ],
  },
  {
    'section_title': 'Recomendaciones y Consejos',
    'description':
        'Al usar el conector OBD-II, ten en cuenta estas recomendaciones para evitar problemas y obtener diagnósticos precisos:',
    'list_data': const [
      {
        'title': 'Apagar el vehículo al conectar/desconectar',
        'details':
            'Aunque muchos dispositivos permiten la conexión en caliente, es una buena práctica apagar el motor y el encendido del vehículo antes de conectar o desconectar un escáner OBD-II para evitar picos de voltaje o errores de comunicación.',
      },
      {
        'title': 'Usar escáneres compatibles',
        'details':
            'Asegúrate de que tu herramienta de diagnóstico sea compatible con el protocolo OBD-II de tu vehículo. Los escáneres modernos suelen ser "multiprocolos" y se adaptan automáticamente, pero las herramientas más antiguas pueden requerir una configuración específica.',
      },
      {
        'title': 'Cuidado con la batería',
        'details':
            'Los adaptadores OBD-II (especialmente los Bluetooth o Wi-Fi) se alimentan directamente del pin 16. Si dejas uno conectado por mucho tiempo con el vehículo apagado, podría descargar la batería del auto.',
      },
      {
        'title': 'No usar el conector para carga de alta potencia',
        'details':
            'El conector OBD-II no está diseñado para suministrar alta potencia. Aunque el pin 16 da 12V, no uses el conector para cargar dispositivos de alta demanda, ya que podría dañar el cableado o el módulo de control del vehículo.',
      },
    ],
  },
];

class ObdIiConnectorScreen extends StatelessWidget {
  const ObdIiConnectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(_obdIititle),
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

            ..._obdIiSections.map((section) {
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
                      section['pin_details'] as List<ObdIiPin>,
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
      tag: _obdIiImagePath,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (context) => const ImageViewerScreen(
                imagePath: _obdIiImagePath,
                title: _obdIititle,
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
          child: Image.asset(_obdIiImagePath, fit: BoxFit.contain),
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
          _obdIiDescription,
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurface,
            height: 1.5,
          ),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }

  Widget _buildPinoutTable(BuildContext context, List<ObdIiPin> pins) {
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
                'Función',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                'Descripción',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
          rows: pins
              .map(
                (pin) => DataRow(
                  cells: [
                    DataCell(Text(pin.number.toString())),
                    DataCell(Text(pin.function)),
                    DataCell(Text(pin.description)),
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
